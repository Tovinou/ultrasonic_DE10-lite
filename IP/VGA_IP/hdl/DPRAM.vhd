
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.ALL;

entity DP_RAM is

--	generic 
--	(
--		DATA_WIDTH : natural := 8;
--		ADDR_WIDTH : natural := 6
--	);
	port 
	(
		clk_a		: in std_logic; -- 25 MHz
		clk_b		: in std_logic; -- 50 MHz
		addr_a	: in std_logic_vector(16 downto 0);
		addr_b	: in std_logic_vector(16 downto 0);
		data_b	: in std_logic_vector(2 downto 0);
		we_b		: in std_logic := '1';
		q_a		: out std_logic_vector(2 downto 0)
	);

end DP_RAM;

architecture rtl of DP_RAM is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(2 downto 0);
	type memory_t is array(76800-1 downto 0) of word_t;
	
	-- Declare the RAM 
	shared variable ram : memory_t;

	begin

		-- Port A, read data from RAM
		process(clk_a)
		begin
		   if(rising_edge(clk_a)) then 
			   q_a <= ram(conv_integer(addr_a));
		   end if;
		end process;

		-- Port B, write data to RAM
		process(clk_b)
		begin
		   if(rising_edge(clk_b)) then 
			   if(we_b = '1') then
				   ram(conv_integer(addr_b)) := data_b;
			   end if;
		   end if;
		end process;

end rtl;
