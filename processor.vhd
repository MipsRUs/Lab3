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
		imm: OUT std_logic_vector(15 DOWNTO 0);

		-- jump shift left
		jumpshiftleft: OUT std_logic_vector(25 DOWNTO 0)
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

-- mux 5 bit
component mux_5bit
	port( 
		in0: in std_logic_vector(4 downto 0);
		in1: in std_logic_vector(4 downto 0);
		sel: in std_logic;
		outb: out std_logic_vector(4 downto 0)
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
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (31 DOWNTO 0)
	);
end component;

----------------------------------------------------------TAKE A LOOOKK THIS HAS NOT BEEN DONE WHEN I CREATED THE PROCRESSOR ------------------------
component shiftll2
	PORT (
		A_in: IN std_logic_vector(31 DOWNTO 0);
		O_out: OUT std_logic_vector(31 DOWNTO 0)
	)
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

-- adder1x_out: PORT_OUT->sum_32(adder1x)
signal adder1x_out: std_logic_vector (31 DOWNTO 0);

-- adder_cout: PORT_INOUT->cout(adder1x)
signal adder_cout: std_logic;

-- adder_ov: PORT_OUT->ov(adderx)
signal adder_ov: std_logic;
---------------------------------------------------

------------------ rom signal ---------------------
-- rom_out: PORT_OUT->dataOut(romx), PORT_IN->instructio(controlx)
signal rom_out: std_logic_vector(31 DOWNTO 0);
---------------------------------------------------

------------------ shiftleft1x signal ---------------------
-- jumpshiftleft_out: PORT_OUT->jumpshiftleft(controlx), PORT_IN->A_in(shiftleft1x)
signal jumpshiftleft_out: std_logic_vector(25 DOWNTO 0);

-- shiftleft1x_out: PORT_OUT->O_out(shiftleft1x), PORT_IN->A_in(concatinationx)
signal shiftleft1x_out: std_logic_vector(31 DOWNTO 0);
-----------------------------------------------------------

------------------ concatination signal ---------------------
-- concatination_out: PORT_OUT->O_out(concatinationx), PORT_IN->in0(JRControlMuxx)
signal concatination_out: std_logic_vector(31 DOWNTO 0);
-------------------------------------------------------------

------------------ control signal ---------------------

signal RegWrite_out: std_logic;
signal ALUSrc_out: std_logic;
signal MemWrite_out: std_logic;
signal MemToReg_out: std_logic;
signal RegDst_out: std_logic;
signal Branch_out: std_logic;
signal Jump_out: std_logic;
signal JRControl_out: std_logic;
signal JALAddr_out: std_logic;
signal JALData_out: std_logic_vector(1 DOWNTO 0);
signal ShiftControl_out: std_logic;
signal LoadControl_out: std_logic_vector(2 DOWNTO 0);
signal ALUControl_out: std_logic_vector(5 DOWNTO 0);
signal rs_out: std_logic_vector(4 DOWNTO 0);
signal rt_out: std_logic_vector(4 DOWNTO 0);
signal rd_out: std_logic_vector(4 DOWNTO 0);
signal imm_out: std_logic_vector(15 DOWNTO 0);
---------------------------------------------------------

------------------ RegDstMux signal ---------------------
signal RegDst2JALaddr: std_logic_vector;


------------------- begin --------------------- 
begin

	pcx:			pc PORT MAP(clk=>ref_clk, rst=>resest, addr_in=>JumpMux2PC, addr_out=>PCOut);	
	
	adder1x:		adder32 PORT MAP(a_32=>PCOut, b_32=>adder_b_32, cin=>adder_cin, sub=>adder_sub, 
								sum_32=>adder_out, cout=>adder_cout, ov=>adder_ov);

	romx: 			rom PORT MAP(addr=>PCOut, dataOut=>rom_out);

	shiftleft1x: 	shiftll PORT MAP(A_in=>jumpshiftleft_out, O_out=>shiftleft1x_out);

	concatinationx:	concatination PORT MAP(A_in=>shiftleft1x_out, B_in=>adder1x_out, O_out=>concatination_out);

	RegDstMuxx:		mux PORT MAP(in0=>rt_out, in1=>rd_out, sel=>RegDst_out, outb=>);

	JalAddrMuxx:	mux PORT MAP();

	JalDataMuxx: 	mux4 PORT MAP();

	controlx:		control PORT MAP();

	regfilex:		regfile PORT MAP();

	SignExtensionImmx: sign_extension_16bit PORT MAP();

	SignExtensionShamtx: sign_extension_5bit PORT MAP();

	shiftleft2x: 	shiftll2 PORT MAP();

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



	
end behavior;

