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

architecture behavior of concatination is

begin
	O_out(31 downto 28) <= B_in(31 downto 28);
	O_out(27 downto 0 ) <= A_in(27 downto 0);
	
end behavior;