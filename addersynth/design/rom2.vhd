library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use ieee.numeric_std.all;
entity rom2 is -- instruction memory
	port(
		addr: IN STD_LOGIC_VECTOR(31 downto 0); 
		dataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end rom2;
architecture behavior of rom2 is

type ramtype is array (0 to 63) of STD_LOGIC_VECTOR(7 downto 0);
variable mem: ramtype; 
begin

dataOut<= mem(to_integer(addr(7 downto 0))) & mem(to_integer(addr(7 DOWNTO 0)) + 1) & mem(to_integer(addr(7 DOWNTO 0)) +2) & mem(to_integer(addr(7 DOWNTO 0)) + 3);

end;
