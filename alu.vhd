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
		Branch_out : OUT std_logic;
		Jump_out : OUT std_logic
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
				Jump_out <= '0';
				
				
			--ADDi
			when "100001" => 
				O_out <= std_logic_vector(signed(A_in) + signed(B_in));
				Branch_out <= '0';
				Jump_out <= '0';

			-- SUB
			when "100010" =>
				--O_out <= std_logic_vector(signed(A_in) - signed(B_in));
				if (A_in >= B_in) then
					O_out <= std_logic_vector(unsigned(A_in) - unsigned(B_in));
					--overflow   <= '0';
					--equal <= '0';
						else
					O_out <= std_logic_vector(unsigned(B_in) - unsigned(A_in));
					--overflow   <= '1';
					--equal <= '0';
						end if;
				Branch_out <= '0';
				Jump_out <= '0';
			

			-- SUBi
			when "100011" =>
				--O_out <= std_logic_vector(signed(A_in) - signed(B_in));
				if (A_in >= B_in) then
					O_out <= std_logic_vector(unsigned(A_in) - unsigned(B_in));
					--overflow   <= '0';
					--equal <= '0';
						else
					O_out <= std_logic_vector(unsigned(B_in) - unsigned(A_in));
					--overflow   <= '1';
					--equal <= '0';
						end if;
				Branch_out <= '0';
				Jump_out <= '0';
				

			-- AND
			when "100100" =>
				O_out <= A_in AND B_in;
				Branch_out <= '0';
				Jump_out <= '0';

			-- OR
			when "100101" =>
				O_out <= A_in OR B_in;
				Branch_out <= '0';
				Jump_out <= '0';

			-- XOR
			when "100110" =>
				O_out <= A_in XOR B_in;
				Branch_out <= '0';
				Jump_out <= '0';

			-- NOR
			when "100111" =>
				O_out <= A_in NOR B_in;
				Branch_out <= '0';
				Jump_out <= '0';

			-- SLT (signed)
			when "101000" =>
				if (signed(A_in) < signed(B_in)) then
					O_out <= one;
				else 
					O_out <= zero;
				end if;
				Branch_out <= '0';
				Jump_out <= '0';
				
			-- SLT(unsigned)
			when "101001" =>
				if(unsigned(A_in) < unsigned(B_in)) then
					O_out <= one;
				else 
					O_out <= zero;
				end if;
				Branch_out <= '0';
				Jump_out <= '0';
			
			when others =>
				O_out <= zero;
				Branch_out <= '0';
				Jump_out <= '0';


		end case;
	end process;

end behavior;

