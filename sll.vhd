-- shifter that takes in 26 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY shiftll IS
	PORT (
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (27 DOWNTO 0)
	);
END shiftll ;

architecture behavior of shiftll is


begin
	funct: process(A_in)
	
	
	begin
	
		O_out <= A_in & "00";
		
		
	end process;
	
end behavior;