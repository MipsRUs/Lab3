library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity andgate is
Port (IN1 : in STD_LOGIC; -- and gate input
      IN2 : in STD_LOGIC; -- and gate input
     OUT1 : out STD_LOGIC
); -- OR gate output
end andgate;

architecture Behavioral of andgate is
begin
OUT1 <= IN1 and IN2; -- 2 input AND gate
end Behavioral;
