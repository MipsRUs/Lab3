-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: ram.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a RAM
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/16/2016		Created						TH, NS, LV, SC
--	1/27/2016		Updating to With/Select		LV
--	1/31/2016		Modified to byte addressable	LV
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ram IS 
	port (
		clk : IN std_logic;
		we : IN std_logic;
		addr : IN std_logic_vector(31 DOWNTO 0); 
		dataI : IN std_logic_vector(31 DOWNTO 0); 
		dataO : OUT std_logic_vector(31 DOWNTO 0));
END ram;

architecture behavior of ram is

subtype byte is std_logic_vector(7 DOWNTO 0);

-- change this depending of the size of the RAM
-- the ram is supposed to be 32 by 2**9, but because of instructions giving
--              overflow, we changed it to 2**14 to not deal with this complications
type memory is array (0 to (2**11)-1) of byte;  --size: 8 x 2048

begin
        ram_process: process (clk, we, addr, dataI)
        variable mem_var:memory;
        begin

        -- SC (2016-02-06: changed clk='0')
        if(clk'event and clk='0') then

        		-- making sure that the address is not negative
                if(addr > 0) then 
					if(we='1') then
                        mem_var(to_integer(unsigned(addr))) := dataI(31 downto 24);
                        mem_var(to_integer(unsigned(addr))+1) := dataI(23 downto 16);
                        mem_var(to_integer(unsigned(addr))+2) := dataI(15 downto 8);
                        mem_var(to_integer(unsigned(addr))+3) := dataI(7 downto 0);

                	else
                        dataO <= mem_var(to_integer(unsigned(addr))) &  mem_var(to_integer(unsigned(addr))+1)
                                & mem_var(to_integer(unsigned(addr))+2) & mem_var(to_integer(unsigned(addr))+3);
                	end if;
                end if;
        end if;

        end process;
end behavior;






