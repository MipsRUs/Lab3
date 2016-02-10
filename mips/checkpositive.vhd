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
--		Check if number going into RAM is positive
--			if negative turn it into 0 otherwise ram will fail
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	2/9/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity checkpositive is
	port( 
		in0: in std_logic_vector(31 downto 0);
		outb: out std_logic_vector(31 downto 0)
	);
end checkpositive;

architecture behavior of checkpositive is
begin

	outb <= in0 when (in0 > "00000000000000000000000000000000") else 
			"00000000000000000000000000000000";

end behavior;
	
