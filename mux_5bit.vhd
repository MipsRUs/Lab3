-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: mux.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a mux/ 2-bit selecter. Two muxes are being used in this 
--		processor implementation
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/20/2016		Created						TH, NS, LV, SC
--	1/27/2016		Updating to With/Select		LV
--
-------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_5bit is
	port( 
		in0: in std_logic_vector(4 downto 0);
		in1: in std_logic_vector(4 downto 0);
		sel: in std_logic;
		outb: out std_logic_vector(4 downto 0)
	);
end mux_5bit;

architecture behavior of mux is
begin
	with sel select outb <=
		in0 when '0',
		in1 when OTHERS;
--process(in0, in1, sel)
--begin
	--if(sel = '0') then
		--outb<= in0;
	--else
		--outb<= in1;
	--end if;
--end process;
end behavior;
	
