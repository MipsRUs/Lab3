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

entity adder32_tb is
end adder32_tb;

architecture behavior of adder32_tb is
COMPONENT adder32
port(a_32    : in  std_logic_vector(31 downto 0);
        b_32    : in  std_logic_vector(31 downto 0);
	cin	: in std_logic;
	sub	: in std_logic;
	sum_32	: out std_logic_vector(31 downto 0);
	cout	: inout std_logic;
	ov	: out std_logic);

end component;
for add: adder32 use entity work.adder32(logic);
-----SIGNALS-----
signal a32_tb:  std_logic_vector (31 DOWNTO 0);
signal b32_tb:  std_logic_vector (31 DOWNTO 0);
signal sum32_tb:  std_logic_vector (31 DOWNTO 0);
signal cout32_t :std_logic :='0';
signal cin_sub,ov_t :std_logic:='0';

begin
add: adder32 port map (a_32=>a32_tb,b_32=>b32_tb,cin=>cin_sub,sub=>cin_sub, sum_32=>sum32_tb, cout=>cout32_t, ov=>ov_t);

tb: process
begin

	--testing for pc adder
	wait for 10 ns;
	a32_tb <="00000000000000000000000000000001"; --assume pc address
	b32_tb <="00000000000000000000000000000100"; --adding 4
	cin_sub <='0';
	--should outout "00000000000000000000000000000101" which is 5

	--testing for jump adder
	wait for 10 ns;
	a32_tb <="00000000000000000000000000000101"; --assume the result (which is 5) coming from pc adder 
	b32_tb <="00000000000000000000000000000001"; --assume the result from sign extension (1)
	cin_sub <='0';
	--should output "00000000000000000000000000000110" which is 6

end process;
end behavior;

