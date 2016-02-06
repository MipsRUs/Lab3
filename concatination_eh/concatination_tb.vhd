library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity concatination_tb is
end concatination_tb;
architecture tb of concatination_tb is
component concatination
PORT (
		A_in : IN std_logic_vector (27 DOWNTO 0);
		B_in : IN std_logic_vector (31 DOWNTO 0);
		O_out : OUT std_logic_vector (31 DOWNTO 0)
	);
end component;
signal a28tb: std_logic_vector (27 downto 0);
signal b32tb,out32tb: std_logic_vector (31 downto 0);
begin
tb: concatination port map (A_in=> a28tb, B_in=>b32tb, O_out=>out32tb);
tb2: process
begin
wait for 10 ns;
	a28tb <= "1111000000000000000000000000";
	b32tb <= "01010000000000000000000000000000";
	--should produce"01011111000000000000000000000000"
wait for 10 ns;
	a28tb <= "0001100000000000000000000000";
	b32tb <= "11111000000000000000000000000000";
--should produce"11110001100000000000000000000000"
end process;
end;
