-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: adder32.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is an addeer with 32 bits
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/27/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity adder32 is
	port(
		a_32    : in  std_logic_vector(31 downto 0);
		b_32    : in  std_logic_vector(31 downto 0);
		cin	: in std_logic;
		sub	: in std_logic;
		sum_32	: out std_logic_vector(31 downto 0);
		cout	: inout std_logic;
		ov	: out std_logic
	);
end; 

architecture logic of adder32 is

component adder
	port(  
		a         : in  std_logic;
		b         : in  std_logic;
		cin       : in  std_logic;
		sum  	  : out std_logic;
		carry_borrow	: out std_logic
	);
end component;

for add1: adder use entity work.adder(logic);

signal carry_i :std_logic_vector(30 downto 0):=(others=>'0');
signal xor_out :std_logic_vector(31 downto 0):=(others=>'0');

begin


Exclusive_or:for i in  31 downto 0 generate
begin
xor_out(i)<=b_32(i) xor sub;
end generate;

add1: adder port map(a=>a_32(0),b=>xor_out(0),cin=>sub,sum=>sum_32(0),carry_borrow=>carry_i(0));	
add_2_31 : for i in 1 to 30 generate
add1 :adder port map(a=>a_32(i),b=>xor_out(i),cin=>carry_i(i-1),sum=>sum_32(i),carry_borrow=>carry_i(i)); 
end generate;
add32: adder port map(a=>a_32(31),b=>xor_out(31),cin=>carry_i(30),sum=>sum_32(31),carry_borrow=>cout);		

ov<=carry_i(30) xor cout;
end architecture; --architecture logic