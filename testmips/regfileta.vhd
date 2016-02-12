library IEEE; 
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std_unsigned.all;
use IEEE.std_logic_signed.all;
--use IEEE.std_logic_arith.all;

entity regfile is 
	 port(
		ref_clk: in STD_LOGIC;
	 	we3: in STD_LOGIC;
	 	ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
	 	wd3: in STD_LOGIC_VECTOR(31 downto 0);
	 	rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0)
	);
end;

architecture behave of regfile is
	type ramtype is array (31 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	signal mem: ramtype;
begin

	process(ref_clk) begin
		if rising_edge(ref_clk) then
			if we3 = '1' then 
				mem(conv_integer(wa3)) <= wd3;
			end if;
		end if;
	end process;
	
	process(all) begin
		if (conv_integer(ra1) = 0) then 
			rd1 <= X"00000000";
		else 
			rd1 <= mem(conv_integer(ra1));
		end if;
		if (conv_integer(ra2) = 0) then 
			rd2 <= X"00000000";
		else 
			rd2 <= mem(conv_integer(ra2));
		end if;
	end process;
end;

