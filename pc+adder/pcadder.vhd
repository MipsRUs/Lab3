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

entity pcadder is
	port(
		rst    : in  std_logic;
		clk    : in  std_logic
	);
end; 

architecture behavior of pcadder is

component adder32
  	port(
  		a_32    : in  std_logic_vector(31 downto 0);
        b_32    : in  std_logic_vector(31 downto 0);
		cin	: in std_logic;
		sub	: in std_logic;
		sum_32	: out std_logic_vector(31 downto 0);
		cout	: inout std_logic;
		ov	: out std_logic);
end component;

component pc 
	PORT (clk: in STD_LOGIC;
      		rst: in STD_LOGIC;
      		-- this is set to '1' if there is a branch
      		--isBranch: in STD_LOGIC;  
			addr_in: in STD_LOGIC_VECTOR(31 DOWNTO 0);
			addr_out: out STD_LOGIC_VECtOR(31 DOWNTO 0)
	);
end component;


signal cin0 :std_logic := '0';
signal sub0 : std_logic := '0';
--signal a_32_ : std_logic_vector(31 downto 0);
signal b_320 : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";
signal clk0 : std_logic;
signal rst0 : std_logic;
signal addr_in0 : std_logic_vector(31 DOWNTO 0);
signal addr_out0 : std_logic_vector(31 DOWNTO 0);
signal cout0 : std_logic;
signal ov0: std_logic;


begin

	pcx : 	pc port map (clk=>clk0, rst=>rst0, addr_in=>addr_in0, addr_out=>addr_out0);
	adderx: adder32 port map(a_32=>addr_out0, b_32=>b_320, cin=>cin0, sub=>sub0
		sum_32=>addr_in0, cout=>cout0, ov=>ov0)

end architecture; --architecture logic