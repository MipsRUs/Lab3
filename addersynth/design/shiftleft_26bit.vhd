library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftleft_26bit is
	PORT(
		shamt : IN std_logic_vector(4 DOWNTO 0);
		sign_extension_out : OUT std_logic_vector(31 DOWNTO 0)
	);
end shiftleft_26bit;

architecture Behavioral of shiftleft_26bit is

begin

	sign_extension_out <= std_logic_vector(resize(signed(shamt), 32));

end Behavioral;

