library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shiftleft_26bit is
	PORT(
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (27 DOWNTO 0)
	);
end shiftleft_26bit;

architecture Behavioral of shiftleft_26bit is

begin

	O_out <= A_in & "00";

end Behavioral;

