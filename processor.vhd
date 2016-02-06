-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: processor.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a a single cycle processor
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/19/2016		Created						TH, NS, LV, SC
--	2/5/2016		Updated to work with		SC 
--					assignment 31
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY processor IS
	PORT (
		ref_clk : IN std_logic ;
		reset : IN std_logic
	);
END processor;

architecture behavior of processor is

---------------------------------------
-------------- components -------------
---------------------------------------
-- ALU
component alu
	PORT (
		Func_in : IN std_logic_vector (5 DOWNTO 0);
		A_in : IN std_logic_vector (31 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0);
		Branch_out : OUT std_logic
	);
end component;

-- control
component control
	PORT (
		-- SC: i don't think we need clock 
		--clk : IN std_logic;
		instruction : IN std_logic_vector (31 DOWNTO 0);

		-----------------------------------------------
		--------------- Control Enables ---------------
		-----------------------------------------------
		-- write enable for regfile
		-- '0' if read, '1' if write
		RegWrite: OUT std_logic;

		-- selecting sign extend OR raddr_2
		-- '0' if raddr_2 result, '1' if sign extend result
		ALUSrc: OUT std_logic;

		-- write ebable for data memory
		-- '0' if not writing to mem, '1' if writing to mem
		MemWrite: OUT std_logic;

		-- selecting output data from memory OR ALU result
		-- '1' if ALU result, '0' if mem result
		MemToReg: OUT std_logic;

		-- selecting if 'rs' or 'rt' is selected to write destination (regfile)
		-- '1' if rd, '0' if rt
		RegDst: OUT std_logic;

		-- '1' if branching, '0' if not branching
		Branch: OUT std_logic;

		-- '1' if jump instruction, else '0' 
		Jump: OUT std_logic;

		-- '1' if JR instruction, else '0'
		JRControl: OUT std_logic;

		-- '1' if JAL instruction and saves current address to register '31' else '0' 
		JALAddr: OUT std_logic;

		-- "00" (LB/LH, and whatever comes out from memReg)
		-- "01" for LUI instruction,
		-- "10" for JAL, saves data of current instruction (or the next one)		 
		JALData: OUT std_logic_vector(1 DOWNTO 0);

		-- '1' if shift, else '0' (SLL, SRL, SRA ONLY)
		ShiftControl: OUT std_logic;

		-- "000" if LB; "001" if LH; "010" if LBU; "011" if LHU; 
		-- "100" if normal, (don't do any manipulation to input) 
		LoadControl: OUT std_logic_vector(2 DOWNTO 0);

		-- func for ALU
		ALUControl: OUT std_logic_vector(5 DOWNTO 0);


		-- to regfile
		-- operand A
		rs: OUT std_logic_vector(4 DOWNTO 0);

		-- operand B
		rt: OUT std_logic_vector(4 DOWNTO 0);

		-- write address
		rd: OUT std_logic_vector(4 DOWNTO 0);

		-- immediant, (rd+shamt+func)
		imm: OUT std_logic_vector(15 DOWNTO 0)
	);
end component;

-- rom: instruction memory
component rom
	port(
		addr: IN STD_LOGIC_VECTOR(31 downto 0); 
		dataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;

-- mux
component mux
	port( 
		in0: in std_logic_vector(31 downto 0);
		in1: in std_logic_vector(31 downto 0);
		sel: in std_logic;
		outb: out std_logic_vector(31 downto 0)
	);
end component;

-- pc
component pc
	PORT (
		PORT (clk: in STD_LOGIC;
  		rst: in STD_LOGIC;
  		-- this is set to '1' if there is a branch
  		--isBranch: in STD_LOGIC;  
		addr_in: in STD_LOGIC_VECTOR(31 DOWNTO 0);
		addr_out: out STD_LOGIC_VECtOR(31 DOWNTO 0)
	);
end component;

-- ram: data memory
component ram
	port (
		clk : IN std_logic;
		we : IN std_logic;
		addr : IN std_logic_vector(31 DOWNTO 0); 
		dataI : IN std_logic_vector(31 DOWNTO 0); 
		dataO : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- regfile
component regfile
	PORT (
		clk : IN std_logic ;
		rst_s : IN std_logic ; 
		we : IN std_logic ; -- write enable
		raddr_1 : IN std_logic_vector (4 DOWNTO 0); -- read address 1
		raddr_2 : IN std_logic_vector (4 DOWNTO 0); -- read address 2
		waddr : IN std_logic_vector (4 DOWNTO 0); -- write address
		rdata_1 : OUT std_logic_vector (31 DOWNTO 0); -- read data 1
		rdata_2 : OUT std_logic_vector (31 DOWNTO 0); -- read data 2
		wdata : IN std_logic_vector (31 DOWNTO 0) -- write data 1
	);
end component;

-- sign extension 16 bit to 32 bits
component sign_extension_16bit
	PORT(
		immediate : IN std_logic_vector(15 DOWNTO 0);
		sign_extension_out : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- sign extension 5 bits to 32 bits
component sign_extension_5bit
	PORT(
		shamt : IN std_logic_vector(4 DOWNTO 0);
		sign_extension_out : OUT std_logic_vector(31 DOWNTO 0)
	);
end component;

-- 32-bit adder
component adder32
	port(
		a_32    : in  std_logic_vector(31 downto 0);
        b_32    : in  std_logic_vector(31 downto 0);
		cin	: in std_logic;
		sub	: in std_logic;
		sum_32	: out std_logic_vector(31 downto 0);
		cout	: inout std_logic;
		ov	: out std_logic
	);
end component;

-- andgate
component andgate
	Port (
		IN1 : in STD_LOGIC; -- and gate input
    	IN2 : in STD_LOGIC; -- and gate input
		OUT1 : out STD_LOGIC
	); 
end component;

-- mux4
component mux4
	port(   
		in0: in std_logic_vector(31 downto 0);
		in1: in std_logic_vector(31 downto 0);
		in2: in std_logic_vector(31 downto 0);
		in3: in std_logic_vector(31 downto 0);		
		sel: in std_logic_vector(1 downto 0);
		mux4out: out std_logic_vector(31 downto 0)
	);
end component;

-- concatination
component concatination
	PORT (
		A_in : IN std_logic_vector (31 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0)
	);
end component;

-- shiftleft
component shiftll
	PORT (
		A_in : IN std_logic_vector (31 DOWNTO 0)
	);
end component;

-- shiftlui
component shiftlui
	port(
		in32: IN std_logic_vector (31 downto 0);
		out32: OUT std_logic_vector (31 downto 0)
	);
end component;

-- shiftextend
component shiftextend
	port(
		loadcontrol:	IN std_logic_vector(2 downto 0);
		in32:		IN std_logic_vector (31 downto 0);	
		out32:		OUT std_logic_vector(31 downto 0)
	);
end component;


-----------------------------------------------
-------------- signals ------------------------
-----------------------------------------------

------------------ pc signal ------------------
-- JumpMux2PC: PORT_IN->add_in(pcx), PORT_OUT->outb(JumpMuxx)
signal JumpMux2PC: std_logic_vector (31 DOWNTO 0);

-- PCOut: PORT_IN->a_32(adder1x) and PORT_IN->addr(romx)
signal PCOut: std_logic_vector (31 DOWNTO 0);
-----------------------------------------------

------------------ adder signal ------------------
-- adder_b_32: PORT_IN->b_32(adder1x) value '4'
signal adder_b_32: std_logic_vector (31 DOWNTO 0) := "00000000000000000000000000000100";

--	adder_cin: PORT_IN->cin(adder1x) value'0'
signal adder_cin: std_logic := '0';

-- adder_sub: PORT_IN->sub(adder1x) value '0'
signal adder_sub: std_logic := '0';

-- adder_out: PORT_OUT->sum_32(adder1x)
signal adder_out: std_logic_vector (31 DOWNTO 0);

-- adder_cout: PORT_INOUT->cout(adder1x)
signal adder_cout: std_logic;

-- adder_ov: PORT_OUT->ov(adderx)
signal adder_ov: std_logic;
---------------------------------------------------

------------------ rom signal ---------------------
-- rom_out: PORT_OUT->dataOut(romx), PORT_IN->
signal rom_out: std_logic_vector(31 DOWNTO 0);



-- pcbranch: Port_IN->isBranch(pcx) (set to 0 because no branch)
signal pcbranch:			std_logic := '0';	

-- pcadder: Port_IN->addr_in(pcx) (not using branch so set to 0's)
signal pcadder:				std_logic_vector (31 DOWNTO 0) := (others=>'0'); 

-- pcadderout: Port_OUT->addr_out(pcx), Port_IN->addr(romx)
signal pcadderout:			std_logic_vector (31 DOWNTO 0);
-----------------------------------------------


---------------- rom signal -------------------
-----------------------------------------------


--------------- control signals ---------------

-- cinstruction: Port_OUT->dataOut(romx), Port_In->instruction(controlx)
signal cinstruction:		std_logic_vector (31 DOWNTO 0);

-- cregwrite: Port_OUT-> RegWrite(romx), Port_In->we(regfilex)
signal cregwrite:			std_logic;

-- calucontrol: Port_OUT->ALUControl(controlx), Port_In->Func_in(alux)
signal calucontrol:			std_logic_vector (5 DOWNTO 0);

-- calusrc: Port_OUT->ALUSrc(controlx), Port_In->sel(mux1)
signal calusrc:				std_logic;

-- cmemwrite: Port_OUT->MemWrite(controlx), Port_In->we(ramx)
signal cmemwrite:			std_logic;

-- cmemtoreg: Port_OUT->MemToReg(controlx), Port_In->sel(mux2)
signal cmemtoreg:			std_logic;

-- crs: Port_OUT->rs(controlx), Port_In->raddr_1(regfilex)
-- crt: Port_OUT->rt(controlx), Port_In->raddr_2(regfilex)
-- crd: Port_OUT->rd(controlx), Port_In->waddr(regfilex)
signal crs, crt, crd:		std_logic_vector (4 DOWNTO 0);

-- cimm: Port_OUT->imm(controlx), Port_In->immediate(signextensionx)
signal cimm:				std_logic_vector (15 DOWNTO 0);
-----------------------------------------------


--------- sign_extension signals --------------

-- signextendout: Port_OUT->sign_extension_out(signextensionx), Port_In->in1(mux1)
signal signextendout:		std_logic_vector (31 DOWNTO 0);
-----------------------------------------------


----------------- mux1 signals ----------------

-- mux1ina: Port_OUT->rdata_2(regfile), Port_In->in0(mux1), Port_In->dataI(ramx)
signal mux1ina:	std_logic_vector (31 DOWNTO 0);
-----------------------------------------------


---------------- alu signals ------------------

-- operanda: Port_OUT->rdata_1(regfile), Port_In->A_in(alux)
-- operandb: Port_OUT->outb(mux1x), Port_In->B_in(alux)
signal operanda, operandb:	std_logic_vector (31 DOWNTO 0);

-- aluout: Port_OUT->, Port_In->
signal aluout:				std_logic_vector (31 DOWNTO 0);

-- aluresult: Port_OUT->O_out(alux), Port_In->addr(ramx), Port_IN->in1(mux2x)
signal aluresult:			std_logic_vector (31 DOWNTO 0);

-- alubranchout: Port_OUT->Branch_out, Port_In->
signal alubranchout:		std_logic;

-- alujumpout: Port_OUT->Jump_out, Port_In->  
signal alujumpout:			std_logic;
-----------------------------------------------


----------------- mux2 signals ----------------

-- mux2ina: Port_OUT->dataO(ramx), Port_In->in0(mux2x)
signal mux2ina:	std_logic_vector (31 DOWNTO 0);

-- mux2out: Port_OUT->outb(mux2x), Port_In->wdata(regfilex)
signal mux2out:				std_logic_vector (31 DOWNTO 0);
-----------------------------------------------



------------------- begin --------------------- 
begin

	pcx:			pc PORT MAP(clk=>ref_clk, rst=>resest, addr_in=>JumpMux2PC, addr_out=>PCOut);	
	
	adder1x:		adder32 PORT MAP(a_32=>PCOut, b_32=>adder_b_32, cin=>adder_cin, sub=>adder_sub, 
								sum_32=>adder_out, cout=>adder_cout, ov=>adder_ov);

	romx: 			rom PORT MAP(addr=>PCOut, dataOut=>);

	shiftleft1x: 	shiftll PORT MAP();

	concatinationx:	concatination PORT MAP();

	RegDstMuxx:		mux PORT MAP();

	JalAddrMuxx:	mux PORT MAP();

	JalDataMuxx: 	mux4 PORT MAP();

	controlx:		control PORT MAP();

	regfilex:		regfile PORT MAP();

	SignExtensionImmx: sign_extension_16bit PORT MAP();

	SignExtensionShamtx: sign_extension_5bit PORT MAP();

	shiftleft2x: 	shiftll PORT MAP();

	AluSrcMuxx:		mux PORT MAP();

	ShiftControlMuxx:	mux PORT MAP();

	ShiftandExtendLUI: 	shiftlui PORT MAP();

	adder2x:		adder32 PORT MAP();

	alux: 			alu PORT MAP();

	BranchMuxx:		mux PORT MAP();

	BranchAndx:		andgate PORT MAP();

	JumpMuxx:		mux PORT MAP();

	JRControlMuxx: 	mux PORT MAP();

	ramx:			ram PORT MAP();

	ShiftandExtendx: shiftextend PORT MAP();

	MemRegMuxx: 	mux PORT MAP();







	--pcx:			pc port map (clk=>ref_clk, rst=>reset, isBranch=>pcbranch,
	--					addr_in=>pcadder, addr_out=>pcadderout);

	--romx:			rom port map (addr=>pcadderout, dataOut=>cinstruction);

	--controlx:		control port map (clk=>ref_clk, instruction=>cinstruction,
	--					RegWrite=>cregwrite, ALUControl=>calucontrol, 
	--					ALUSrc=>calusrc, MemWrite=>cmemwrite, 
	--					MemToReg=>cmemtoreg, rs=>crs, rt=>crt, rd=>crd, 
	--					imm=>cimm);

	--signextensionx:	sign_extension port map (immediate=>cimm, 
	--					sign_extension_out=>signextendout);

	--regfilex:		regfile port map (clk=>ref_clk, rst_s=>reset, 
	--					we=>cregwrite, raddr_1=>crs, raddr_2=>crt, 
	--					waddr=>crd, rdata_1=>operanda, rdata_2=>mux1ina, 
	--					wdata=>mux2out);

	--mux1x:			mux port map (in0=>mux1ina, in1=>signextendout, 
	--					sel=>calusrc, outb=>operandb);

	--alux:			alu port map (Func_in=>calucontrol, A_in=>operanda, 
	--					B_in=>operandb, O_out=>aluresult, 
	--					Branch_out=>alubranchout, Jump_out=>alujumpout);

	--ramx:			ram port map (clk=>ref_clk, we=>cmemwrite, 
	--					addr=>aluresult, dataI=>mux1ina, dataO=>mux2ina);
	
	--mux2x:			mux port map (in0=>aluresult, in1=>mux2ina, 
	--					sel=>cmemtoreg, outb=>mux2out);	
	
end behavior;

