library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rom2_TB is
end rom2_TB;

architecture test of rom2_TB is
component rom2 is
    Port ( addr : in  STD_LOGIC_VECTOR (31 downto 0);
           dataOut : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

signal addr: std_logic_vector (31 downto 0);
signal dataOut: std_logic_vector (31 downto 0);
begin
	rom: rom2 port map(addr, instruction);
tb: process
begin
	addr <= "00000000000000000000000000000000";
	wait for 10 ns;
	addr <= "00000000000000000000000000000100";
	wait for 10 ns;
	addr <= "00000000000000000000000000001000";
	wait for 10 ns;
	addr <= "00000000000000000000000000001100";
	wait for 10 ns;
	addr <= "00000000000000000000000000010000";
	wait for 10 ns;
	addr <= "00000000000000000000000000010100";
	wait for 10 ns;
	addr <= "00000000000000000000000000011000";
	wait for 10 ns;
	addr <= "00000000000000000000000000011100";
	wait for 10 ns;
	addr <= "00000000000000000000000000100000";
	wait for 10 ns;
	addr <= "00000000000000000000000000100100";
	wait for 10 ns;
assert false report "finish" severity failure;
end process;

end test;

