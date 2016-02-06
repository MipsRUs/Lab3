-- shifter that takes in 32 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY shiftll32 IS
	PORT (
		A_in : IN std_logic_vector (31 DOWNTO 0);
		O_out: OUT std_logic_vector (31 DOWNTO 0)
	);
END shiftll32 ;

architecture behavior of shiftll32 is


begin
	funct: process(A_in)
	
	
	begin
	
		O_out <= A_in sll 2;
		
		
	end process;
	
end behavior;