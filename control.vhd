-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: control.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a control unit of the processor
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/19/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY control IS
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
		-- '0' if rd, '1' if rt
		RegDst: OUT std_logic;

		-- '1' if branching, '0' if not branching
		Branch: OUT std_logic;

		-- '1' if jump instruction, else '0' 
		Jump: OUT std_logic;

		-- '1' if JR instruction, else '0'
		JRControl: OUT std_logic;

		-- '1' if JAL instruction else '0' save current address to register '31'
		JALAddr: OUT std_logic;

		-- "00" (LB/LH, and whatever comes out from memReg)
		-- "01" for LUI instruction,
		-- "10" for JAL, saves data of current instruction (or the next one)		 
		JALData: OUT std_logic_vector(1 DOWNTO 0);

		-- '1' if shift, else '0'
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
END control;

architecture behavior of control is

begin
	
	-- Operand A
	rs <= instruction(25 DOWNTO 21);

	-- Operand B
	rt <= instruction(20 DOWNTO 16);

	-- write destination
	rd <= instruction(15 DOWNTO 11);

	-- immediant, (rd+shamt+func)
	imm <= instruction(15 DOWNTO 0);

	-----------------------------------------------
	--------------- Control Enables ---------------
	-----------------------------------------------
	RegWrite <= '1' when ( 
					
						-- if not BEQ
						NOT(instruction(31 DOWNTO 26)="000100") AND

						-- if not BNE
						NOT(instruction(31 DOWNTO 26)="000101") AND

						-- if not BLTZ or BGEZ
						NOT(instruction(31 DOWNTO 26)="000001") AND

						-- if not BLEZ
						NOT(instruction(31 DOWNTO 26)="000110") AND

						-- if not BGTZ
						NOT(instruction(31 DOWNTO 26)="000111") AND

						-- if not JUMP
						NOT(instruction(31 DOWNTO 26)="000010") AND

						-- if not JR
						NOT((instruction(31 DOWNTO 26)="000000") AND
								(instruction(5 DOWNTO 0)="001000")) AND

						-- if not SB
						NOT(instruction(31 DOWNTO 26)="101000") AND
						
						-- if not SH
						NOT(instruction(31 DOWNTO 26)="101001")
					) 	else 
				'0';

	ALUSrc <= '1' when (	

						-- addi
						(instruction(31 DOWNTO 26) = "001000") OR

						-- ADDIU or JALR(can be anything)
						(instruction(31 DOWNTO 26) = "001001") OR

						-- SUBi and SubUi need to do...

						-- ANDI
						(instruction(31 DOWNTO 26) = "001100") OR

						-- ORI
						(instruction(31 DOWNTO 26) = "001101") OR

						-- XORI
						(instruction(31 DOWNTO 26) = "001110") OR

						-- SLTI
						(instruction(31 DOWNTO 26) = "001010") OR

						-- SLTUI
						(instruction(31 DOWNTO 26) = "001011") OR

						-- LUI
						(instruction(31 DOWNTO 26) = "001111") OR

						-- BLTZ or BGEZ
						(instruction(31 DOWNTO 26) = "000001") OR

						-- BLEZ
						(instruction(31 DOWNTO 26) = "000110") OR

						-- BGTZ
						(instruction(31 DOWNTO 26) = "000111") OR

						-- LB
						(instruction(31 DOWNTO 26) = "100000") OR

						-- LH
						(instruction(31 DOWNTO 26) = "100001") OR

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001") OR

						-- LBU
						(instruction(31 DOWNTO 26) = "100100") OR

						-- LHU
						(instruction(31 DOWNTO 26) = "100101") OR

						-- LW
						(instruction(31 DOWNTO 26) = "100011") OR

						-- SW
						(instruction(31 DOWNTO 26) = "101011") OR

						)	else 
				'0';

	MemWrite <= '1' when (

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001") OR

						-- SW
						(instruction(31 DOWNTO 26) = "101011")
					)	else 
				'0';

	MemToReg <= '0' when (

						-- LB
						(instruction(31 DOWNTO 26) = "100000") OR

						-- LH
						(instruction(31 DOWNTO 26) = "100001") OR

						-- SB
						(instruction(31 DOWNTO 26) = "101000") OR

						-- SH
						(instruction(31 DOWNTO 26) = "101001") OR

						-- LBU
						(instruction(31 DOWNTO 26) = "100100") OR

						-- LHU
						(instruction(31 DOWNTO 26) = "100101") OR

						-- LW
						(instruction(31 DOWNTO 26) = "100011") OR

						-- SW
						(instruction(31 DOWNTO 26) = "101011") OR
					)	else 
				'1';

		

						

		
	

end behavior;

