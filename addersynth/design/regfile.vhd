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
use IEEE.std_logic_signed.all;

ENTITY regfile IS

	PORT (
		ref_clk : IN std_logic ;
		rst_s : IN std_logic ; 
		we : IN std_logic ; -- write enable
		raddr_1 : IN std_logic_vector (4 DOWNTO 0); -- read address 1
		raddr_2 : IN std_logic_vector (4 DOWNTO 0); -- read address 2
		waddr : IN std_logic_vector (4 DOWNTO 0); -- write address
		rdata_1 : OUT std_logic_vector (31 DOWNTO 0); -- read data 1
		rdata_2 : OUT std_logic_vector (31 DOWNTO 0); -- read data 2
		wdata : IN std_logic_vector (31 DOWNTO 0) -- write data 1
	);
END regfile ;

architecture behavior of regfile is

subtype word is std_logic_vector(31 downto 0);
type memory is array(0 to 2**4) of word;
signal mem: ramtype;

begin
    process(ref_clk) begin
		if rising_edge(ref_clk) then
			if we = '1' then 
				mem(conv_integer(waddr)) <= wdata;
			end if;
		end if;
	end process;
	
	process(all) begin
		if (conv_integer(raddr_1) = 0) then 
			rdata_1 <= X"00000000";
		else 
			rdata_1 <= mem(conv_integer(raddr_1));
		end if;
		if (conv_integer(raddr_2) = 0) then 
			rdata_2 <= X"00000000";
		else 
			rdata_2 <= mem(conv_integer(raddr_2));
		end if;
	end process;
end behavior;