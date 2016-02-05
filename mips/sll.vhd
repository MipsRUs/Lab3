-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: sll.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		shifter that takes 26 bits input
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	02/05/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY shiftll IS
	PORT (
		A_in : IN std_logic_vector (25 DOWNTO 0);
		O_out: OUT std_logic_vector (27 DOWNTO 0)
	);
END shiftll ;

architecture behavior of shiftll is

begin
	funct: process(A_in)
	
	begin
	
		O_out <= A_in sll 2;
			
	end process;
	
end behavior;