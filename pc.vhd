-------------------------------------------------------------------
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
--
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY pc IS
	
	-- program counter is set to 32 for this 32-bit ALU
	GENERIC (NBIT: INTEGER := 32;
				STEP: INTEGER := 1);
	PORT (clk: in STD_LOGIC;
      		rst: in STD_LOGIC;
      		-- this is set to '1' if there is a branch
      		isBranch: in STD_LOGIC;  
			addr_in: in STD_LOGIC_VECTOR(31 DOWNTO 0);
			addr_out: out STD_LOGIC_VECtOR(31 DOWNTO 0)
	);
end pc;
      
architecture logic of pc is
begin

	-- SC 2016-01-15: Added the following code 
	PROCESS (clk)

		--defining variable temp (used as temporary storage)
		VARIABLE temp : std_logic_vector (0 to NBIT-1);		
	BEGIN
		if(clk'event and clk='1') THEN

			-- synchronous reset
			if (rst='1') THEN										
				L1: for i in addr_in'RANGE LOOP
					temp(i):='0';
				end loop;

			-- load values from addr_in to temp
			elsif (isBranch='1') THEN								
				temp := addr_in;
			else										
				temp := std_logic_vector(unsigned(temp)+STEP);
			end if;
		end if;
		
	-- output the values
	addr_out <= temp;														
	end process;

end logic;





