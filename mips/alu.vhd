-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: alu.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is an ALU
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

ENTITY alu IS
	PORT (
		Func_in : IN std_logic_vector (5 DOWNTO 0);
		A_in : IN std_logic_vector (31 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0);
		Branch_out : OUT std_logic
	);
END alu ;

architecture behavior of alu is


begin
	funct: process(Func_in, A_in, B_in)

	variable one : std_logic_vector (31 DOWNTO 0) := "00000000000000000000000000000001";
	variable zero : std_logic_vector (31 DOWNTO 0) := "00000000000000000000000000000000";

	
	begin
	
		case Func_in is
		
			-- ADD
			when "100000" =>
				O_out <= std_logic_vector(signed(A_in) + signed(B_in));
				Branch_out <= '0';
				
				
			--ADDU
			when "100001" => 
				O_out <= std_logic_vector(unsigned(A_in) + unsigned(B_in));
				Branch_out <= '0';

			-- SUB
			when "100010" =>
				O_out <= std_logic_vector(signed(A_in) - signed(B_in));
				Branch_out <= '0';
			

			-- SUBU
			when "100011" =>
				O_out <= std_logic_vector(unsigned(A_in) - unsigned(B_in));
				Branch_out <= '0';
				

			-- AND
			when "100100" =>
				O_out <= A_in AND B_in;
				Branch_out <= '0';

			-- OR
			when "100101" =>
				O_out <= A_in OR B_in;
				Branch_out <= '0';

			-- XOR
			when "100110" =>
				O_out <= A_in XOR B_in;
				Branch_out <= '0';

			-- NOR
			when "100111" =>
				O_out <= A_in NOR B_in;
				Branch_out <= '0';

			-- SLT (signed)
			when "101010" =>
				if (signed(A_in) < signed(B_in)) then
					O_out <= one;
				else 
					O_out <= zero;
				end if;
				Branch_out <= '0';
				
			-- SLT(unsigned)
			when "101011" =>
				if(unsigned(A_in) < unsigned(B_in)) then
					O_out <= one;
				else 
					O_out <= zero;
				end if;
				Branch_out <= '0';
				
			-- LUI
			when "XXXXXX" =>
				O_out <= B_in sll 16;
				
			--shift instr
			--SLL
			when "000000" =>
				O_out <= B_in sll A_in;
				Branch_out <= '0';
				
			--SRL
			when "000010" =>
				O_out <= B_in srl A_in;
				Branch_out <= '0';
				
			--SRA
			when "000011" =>
				O_out <= B_in sra A_in;
				Branch_out <= '0';

			--SLLV
			when "000100" =>
				O_out <= B_in sll A_in;
				Branch_out <= '0';
				
			--SRLV
			when "000110" =>
				O_out <= B_in srl A_in;
				Branch_out <= '0';
				Jump_out <= '0';
				
			--SRAV
			when "000111" =>
				O_out <= B_in sra A_in;
				Branch_out <= '0';
				Jump_out <= '0';
				
			--branch
			--BLTZ
			when "111000" =>
				O_out <= A_in;
				Branch_out <= A_in < zero;
				
			--BGEZ
			when "111001" =>
				O_out <= A_in;
				Branch_out <= A_in >= zero;
				
			--BEQ
			when "111100" =>
				O_out <= A_in;
				Branch_out <= A_in == B_in;
				
			--BNE
			when "111101" =>
				O_out <= A_in;
				Branch_out <= A_in != B_in;
				
			--BLEZ
			when "111110" =>
				O_out <= A_in;
				Branch_out <= A_in <= zero;
			
			--BGTZ
			when "111111" =>
				O_out <= A_in;
				Branch_out <= A_in > zero;
			
			when others =>
				O_out <= zero;
				Branch_out <= '0';


		end case;
	end process;

end behavior;
