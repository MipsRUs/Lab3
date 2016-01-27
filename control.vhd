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
		clk : IN std_logic;
		instruction : IN std_logic_vector (31 DOWNTO 0);

		-- selecting rs or rd
		--RegDst: OUT std_logic;

		-- Branch is not used in this single cycle processor
		--Branch: OUT std_logic;

		-- write enable for regfile
		-- '0' if read, '1' if write
		RegWrite: OUT std_logic;

		-- func
		ALUControl: OUT std_logic_vector(5 DOWNTO 0);

		-- selecting sign extend of raddr_2
		-- '0' if raddr_2 result, '1' if sign extend result
		ALUSrc: OUT std_logic;

		-- write ebable for data memory
		-- '0' if not writing to mem, '1' if writing to mem
		MemWrite: OUT std_logic;

		-- selecting output data from memory OR ALU result
		-- '0' if ALU result, '1' if mem result
		MemToReg: OUT std_logic;

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

	funct: process(clk, instruction)

	begin

		-- if clk='0' then read
		if(clk'event and clk='1') then

			imm <= instruction(15 DOWNTO 0);

			-- operand A
			rs <= instruction(25 DOWNTO 21);

			-- operand B
			rt <= instruction(20 DOWNTO 16);

			-- func
			ALUControl <= instruction(5 DOWNTO 0);

			-- write address
			rd <= instruction(15 DOWNTO 11);

			-- reading from register
			RegWrite <= '0';

			-- R-type, if opcode="000000"
			if(instruction(31 DOWNTO 26)= "000000") then

				-- R-Type, not reading anything from memory
				MemWrite <= '0';

				-- R-type, not selecting data from mem, but from ALU result
				MemToReg <= '0';

				-- I-type, addi and subi
				if((instruction(5 DOWNTO 0)="100001") OR 
						(instruction(5 DOWNTO 0)="100011")) then

					-- selecting result from sign extend
					ALUSrc <= '1';

				-- R-type,
				else

					-- selecting result from raddr_2
					ALUSrc <= '0'; 
				end if;

			-- Load instruction, if opcode="100011"
			elsif (instruction(31 DOWNTO 26)="100011") then 

				-- not writing to mem, only reading from it
				MemWrite <= '0';

				-- selecting result coming out from mem
				MemToReg <= '1';

				-- selecting from sign extend
				ALUSrc <= '1'; 

			-- Store instruction, if opcode="101011"
			elsif(instruction(31 DOWNTO 26)="101011") then

				-- writing to mem
				MemWrite <= '1';

				-- doesn't matter what comes out, will not write it to mem
				MemToReg <= '0';

				-- selecting from sign extend
				ALUSrc <= '1'; 
			end if; -- R-type, Load, store instruction


		-- if clk='1' then write to regfile (except for store instruction)
		elsif(clk'event and clk='0') then

			imm <= instruction(15 DOWNTO 0);

			-- operand A
			rs <= instruction(25 DOWNTO 21);

			-- operand B
			rt <= instruction(20 DOWNTO 16);

			-- func
			ALUControl <= instruction(5 DOWNTO 0);

			-- write address
			rd <= instruction(15 DOWNTO 11);

			-- R-type, if opcode="000000"
			if(instruction(31 DOWNTO 26)= "000000") then

				-- writing to register
				RegWrite <= '1';

				-- R-Type, not reading anything from memory
				MemWrite <= '0';

				-- R-type, not selecting data from mem, but from ALU result
				MemToReg <= '0';

				-- I-type, addi and subi
				if((instruction(5 DOWNTO 0)="100001") OR 
						(instruction(5 DOWNTO 0)="100011")) then

					-- selecting result from sign extend
					ALUSrc <= '1';

				-- R-type,
				else

					-- selecting result from raddr_2
					ALUSrc <= '0'; 
				end if;

			-- Load instruction, if opcode="100011"
			elsif (instruction(31 DOWNTO 26)="100011") then 

				-- writing to register
				RegWrite <= '1';

				-- not writing to mem, only reading from it
				MemWrite <= '0';

				-- selecting result coming out from mem
				MemToReg <= '1';

				-- selecting from sign extend
				ALUSrc <= '1'; 

			-- Store instruction, if opcode="101011"
			elsif(instruction(31 DOWNTO 26)="101011") then

				-- not writing to register so set it to '0'
				RegWrite <= '0';

				-- writing to mem
				MemWrite <= '1';

				-- doesn't matter what comes out, will not write it to mem
				MemToReg <= '0';

				-- selecting from sign extend
				ALUSrc <= '1'; 
			end if; -- R-type, Load, store instruction
		end if; -- if clk
	end process;

end behavior;

