library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY regfile IS
GENERIC ( NBIT : INTEGER := 32;
NSEL : INTEGER := 5);
PORT (
clk : IN std_logic ;
rst_s : IN std_logic ; -- synchronous reset
we : IN std_logic ; -- write enable
raddr_1 : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 1
raddr_2 : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- read address 2
waddr : IN std_logic_vector ( NSEL -1 DOWNTO 0); -- write address
rdata_1 : OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 1
rdata_2 : OUT std_logic_vector ( NBIT -1 DOWNTO 0); -- read data 2
wdata : IN std_logic_vector ( NBIT -1 DOWNTO 0) -- write data 1
);
END regfile ;

architecture beh of regfile is
--type memory is array (natural range <>, natural range <>) of std_logic;
--signal mem1: memory(2**NSEL-1 downto 0, NBIT-1 downto 0);

subtype word is std_logic_vector(NBIT-1 downto 0);
type regFileTyp is array(0 to 2**NSEL-1) of word;
--signal reg: regFileType;



begin  -- beh
  funct: process(clk)
    variable mem1:regFileTyp;
    variable RDATA1_VAR, RDATA2_VAR : STD_LOGIC_VECTOR(NBIT-1 downto 0);
    variable zeros : std_logic_vector (NBIT-1 downto 0) := (others => '0');
    begin
    if(clk'event and clk='1' and rst_s='1') then
     all_zero: for i in 0 to 2**NSEL-1 loop
        mem1(i) := (others=>'0');
      end loop;  -- i
      rdata1_var := (others =>'0');
      rdata2_var := (others =>'0');
    elsif (clk'event and clk='1') then
	if(to_integer(unsigned(raddr_1)) = 0) then
		rdata1_var := zeros;
	else
		rdata1_var := mem1(to_integer(unsigned(raddr_1)));
	end if;
	if(to_integer(unsigned(raddr_2)) = 0) then
		rdata2_var := zeros;
	else
		rdata2_var := mem1(to_integer(unsigned(raddr_2)));
	end if;
      if (we='1') then
	if (to_integer(unsigned(waddr)) = 0) then
	
	else
		mem1(to_integer(unsigned(waddr))) := wdata;
	end if;
      end if;
    end if;
    rdata_1 <= rdata1_var;
    rdata_2 <=rdata2_var;
    end process;
end beh;
