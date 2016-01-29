library ieee;
use ieee.std_logic_1164.all;


entity adder is
   port(a       : in  std_logic;
        b       : in  std_logic;
	cin	: in  std_logic;
	carry_borrow	: out std_logic;	
	sum	: out std_logic
);
end adder;


architecture logic of adder is

begin


process(a,b,cin)
begin

sum <= a xor b xor cin;
carry_borrow <=(a and b) or (a and cin) or (b and cin);


end process;
end architecture; 


