library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftextend_tb is
end shiftextend_tb;

architecture tb of shiftextend_tb is
component shiftextend
port(
loadcontrol:	IN std_logic_vector(2 downto 0);
in32:		IN std_logic_vector (31 downto 0);
out32:		OUT std_logic_vector(31 downto 0)
);
end component;
signal in32tb,out32tb : std_logic_vector(31 downto 0);
signal sel3: std_logic_vector(2 downto 0);

begin
tb: shiftextend port map (loadcontrol=> sel3, in32=>in32tb, out32=>out32tb);
tb2: process
begin
wait for 10 ns;
	--for lb signed "000"
	sel3 <= "000";
	in32tb <= "01000000000000000000000010011111"; --should get "11...1" and "1011111" 
	--sel3 <= "000";
	--in32tb <= "01000000000000000000000000111111"; -- should be "00...0" and "0111111"
wait for 10 ns;	
	--for lh signed "001"
	sel3 <= "001";
	in32tb <= "01000000000000000101111111111111"; --should get "1...1" and "101111111111111"
	--sel3 <= "001";
	--in32tb <= "01000000000000000011111111111111"; --should get "0...0" and "011111111111111"
wait for 10 ns;
	--for lbu "010"
	sel3 <= "010";
	in32tb <= "01000000000000000000000001011111"; --should get "00000000000000000000000001011111"
	--sel3 <= "010";
	--in32tb <= "01000000000000000000000000111111"; --should get "00000000000000000000000000111111"
wait for 10 ns;
	--for lhu "011"
	sel3 <= "011";
	in32tb <= "01000000000000000101111111111111"; --should get "00000000000000000101111111111111"
	--sel3 <= "011";
	--in32tb <= "01000000000000000011111111111111"; --should get "00000000000000000011111111111111"
wait for 10 ns;
	--for normal "100"
	sel3 <= "000";
	in32tb <= "00000000000000000000000000000001"; --should get "00000000000000000000000000000001"
end process;
end tb;


	