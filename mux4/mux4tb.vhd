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
--		This is a mux or a 4 to 1 selector testbench.
--History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/29/2016		Created						TH, NS, LV, SC
--	
--
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4_tb is
end mux4_tb;

architecture behavior of mux4_tb is
component mux4
port(	in0: in std_logic_vector(31 downto 0);
	in1: in std_logic_vector(31 downto 0);
	in2: in std_logic_vector(31 downto 0);
	in3: in std_logic_vector(31 downto 0);		
	sel: in std_logic_vector(1 downto 0);
	mux4out: out std_logic_vector(31 downto 0)
);
end component;

for mux: mux4 use entity work.mux4(logic);

----signals----
signal in0tb: std_logic_vector(31 downto 0);
signal in1tb: std_logic_vector(31 downto 0);
signal in2tb: std_logic_vector(31 downto 0);
signal in3tb: std_logic_vector(31 downto 0);
signal seltb: std_logic_vector(1 downto 0);
signal mux4outtb:  std_logic_vector(31 downto 0);

begin
	mux: mux4 port map (in0=>in0tb, in1=>in1tb,in2=>in2tb,in3=>in3tb,sel=>seltb,mux4out=>mux4outtb);
tb: process
begin

	wait for 10 ns;
	seltb <= "00";
	in0tb <= "00000000000000000000000000000000";
	in1tb <= "00000000000000000000000000000001";
	in2tb <= "00000000000000000000000000000010";
	in3tb <= "00000000000000000000000000000011";
	--should get 0

	wait for 10 ns;
	seltb <= "01";
	in0tb <= "00000000000000000000000000000000";
	in1tb <= "00000000000000000000000000000001";
	in2tb <= "00000000000000000000000000000010";
	in3tb <= "00000000000000000000000000000011";
	--should get 1

	wait for 10 ns;
	seltb <= "10";
	in0tb <= "00000000000000000000000000000000";
	in1tb <= "00000000000000000000000000000001";
	in2tb <= "00000000000000000000000000000010";
	in3tb <= "00000000000000000000000000000011";
	--should get 2

	wait for 10 ns;
	seltb <= "11";
	in0tb <= "00000000000000000000000000000000";
	in1tb <= "00000000000000000000000000000001";
	in2tb <= "00000000000000000000000000000010";
	in3tb <= "00000000000000000000000000000011";
	--should get 4
end process;
end behavior;

