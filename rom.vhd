-------------------------------------------------------------------
-- Copyright MIPS_R_US 2016 - All Rights Reserved 
--
-- File: rom.vhd
-- Team: MIPS_R_US
-- Members:
-- 		Stefan Cao (ID# 79267250)
--		Ting-Yi Huang (ID# 58106363)
--		Nehme Saikali (ID# 89201494)
--		Linda Vang (ID# 71434490)
--
-- Description:
--		This is a rom used as an instruction memory
--
-- History:
-- 		Date		Update Description			Developer
--	-----------   ----------------------   	  -------------
--	1/19/2016		Created						TH, NS, LV, SC
--
-------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all; 
use STD.TEXTIO.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;

entity rom is -- instruction memory
	port(
		addr: IN STD_LOGIC_VECTOR(31 downto 0); 
		dataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end rom;

architecture behavior of rom is
begin
process is
file mem_file: TEXT;
variable L: line;
variable ch: character;
variable i, index, result: integer;

type ramtype is array (2**16 downto 0) of STD_LOGIC_VECTOR(31 downto 0);

variable mem: ramtype;
begin
for i in 0 to 63 loop 
mem(i) := (others => '0');
end loop;

index := 0;
FILE_OPEN (mem_file, "imem.h", READ_MODE);
while not endfile(mem_file) loop
readline(mem_file, L);
result := 0;

	for i in 1 to 8 loop
	read (L, ch);
		if '0' <= ch and ch <= '9' then
			result := character'pos(ch) - character'pos('0');
		elsif 'a' <= ch and ch <= 'f' then
			result := character'pos(ch) - character'pos('a') + 10;
		else report "Format error on line" & integer'
			image(index) severity error;
		end if;
	mem(index)(35-i*4 DOWNTO 32-i*4) := to_std_logic_vector(result,4);
	end loop; -- end for loop
index := index + 1;
end loop; -- end while
------------------------new loop-----------------------------
loop
dataOut<= mem(to_integer(addr));
wait on addr;
end loop;
end process;
end;




	