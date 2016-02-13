-- shifter that takes in 26 bits

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY sll IS
	PORT (
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (27 DOWNTO 0)
	);
END sll ;

architecture behavior of sll is


begin
		O_out <= std_logic_vector(resize(signed(A_in), 28));

	
end behavior;