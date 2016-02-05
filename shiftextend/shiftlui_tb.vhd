library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftlui_tb is
end shiftlui_tb;
architecture tb of shiftlui_tb is
component shiftlui
port(
in32: IN std_logic_vector (31 downto 0);
out32: OUT std_logic_vector (31 downto 0)
);
end component;

signal in32tb, out32tb : std_logic_vector(31 downto 0);

begin
tb: shiftlui port map (in32=>in32tb, out32=>out32tb);
tb2: process
begin

wait for 10 ns;
in32tb <= "10111111111111101000000000000000";
wait for 10 ns;
end process;
end tb;          