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

subtype byte is std_logic_vector(7 DOWNTO 0);

-- change this depending of the size of the RAM
-- the ram is supposed to be 32 by 2**9, but because of instructions giving
--              overflow, we changed it to 2**14 to not deal with this complications
type memory is array (0 to (2**11)-1) of byte;  --size: 8 x 2048

begin

rom_process: process (addr)
        
        variable mem_var:memory;
      
        begin
        	dataOut <= mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))) &  mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))+1)
                        & mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))+2) & mem_var(to_integer(unsigned(addr(7 DOWNTO 0)))+3);

        end process;
end behavior;