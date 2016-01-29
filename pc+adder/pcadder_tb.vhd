-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: adder32tb.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is an adder32 testbench
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/27/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pcadder_tb is
end pcadder_tb;

architecture behavior of pcadder_tb is
COMPONENT pcadder

	port(
		rst    : in  std_logic;
		clk    : in  std_logic
	);

end component;


begin


tb: process
begin

	rst <= '1';
	wait for 10 ns;

	rst <= '0';
	wait for 100 ns;

end process;
end behavior;

