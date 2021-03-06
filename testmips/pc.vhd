---------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: pc.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		Program Counter for ALU_32_Bit
--		adder is incorporated with this program counter
--		features:
--			rst: resets to all the bits to 0's
--			isBranch: when set to '1', will read the addr_in and
--				output it
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/13/2016		Created						TH, NS, LV, SC
--	1/29/2016		Changed pc implementation	SC
--						+ changed to "when-else"
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY pc IS
	
	-- program counter is set to 32 for this 32-bit ALU
	GENERIC (NBIT: INTEGER := 32);
			
	PORT (
		ref_clk: in STD_LOGIC;
      	rst: in STD_LOGIC;  
		addr_in: in STD_LOGIC_VECTOR(NBIT-1 DOWNTO 0);
		addr_out: out STD_LOGIC_VECtOR(NBIT-1 DOWNTO 0)
	);
end pc;
      
architecture logic of pc is
begin
	
	-- if reset is '1' set the values to 0's else output the addr_in
	addr_out <= (others=>'0') when (ref_clk'event AND ref_clk='1' AND rst='1') else 
				addr_in when (ref_clk'event AND ref_clk='1' AND rst='0');														
	
end logic;





