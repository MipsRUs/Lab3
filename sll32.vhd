-- shifter that takes in 32 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY shiftll IS
	PORT (
		A_in : IN std_logic_vector (32 DOWNTO 0);
		O_out: OUT std_logic_vector (32 DOWNTO 0)
	);
END shiftll ;

architecture behavior of shiftll is


begin
	funct: process(A_in)
	
	
	begin
	
		O_out <= A_in sll 2;
		
		
	end process;
	
end behavior;