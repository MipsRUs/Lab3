--concat
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY concatination IS
	PORT (
		A_in : IN std_logic_vector (27 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0)
	);
END concatination ;

architecture behavior of alu is

begin
	funct: process(A_in, B_in)
	
	
	begin
	
	O_out <= A_in & B_in;
	
	end process;
	
end behavior;