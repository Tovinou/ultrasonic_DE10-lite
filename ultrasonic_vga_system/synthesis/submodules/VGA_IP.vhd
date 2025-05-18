--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity VGA_IP is
	port
		(
			clk			:	in std_logic;
			reset_n		:	in std_logic;
			addr			:	in std_logic_vector(16 downto 0);
         --Avalon
			cs_n			:	in std_logic;
			read_n		:	in std_logic;
			write_n		:	in std_logic;
			din			:	in std_logic_vector(31 downto 0);
			dout			:	out std_logic_vector(31 downto 0);
			--VGA--
			clock_25		:	in std_logic;
			vga_r			:	out std_logic_vector(3 downto 0);
			vga_g			:	out std_logic_vector(3 downto 0);
			vga_b			:	out std_logic_vector(3 downto 0);
			vga_hs		:	out std_logic;
			vga_vs		:	out std_logic
		);
end VGA_IP;

architecture rtl of VGA_IP is

	--Ram-Signal--
	signal address 	:	std_logic_vector(16 downto 0);
	signal we		   :	std_logic;	
	--Register--
	signal data_reg : std_logic_vector(2 downto 0);
	signal data     : std_logic_vector(2 downto 0);

	
	----VGA-RAM----
	component DP_RAM
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
	end component;
	
	
	----VGA Sync----
	component VGA_Controller
	 PORT
   (
      clk 	  :  IN std_logic;
      resetn  :  IN std_logic;
      data_in :  IN std_logic_vector (2 downto 0);

      VGA_HS  :  OUT   std_logic;
      VGA_VS  :  OUT   std_logic;
      VGA_BL  :  OUT   std_logic;    
      VGA_R   :  OUT   std_logic_vector(3 downto 0);
      VGA_G   :  OUT   std_logic_vector(3 downto 0);
      VGA_B   :  OUT   std_logic_vector(3 downto 0);
      ADDRESS :  OUT   std_logic_vector(16 downto 0)
   );
	end component;


begin

	 
	 --write process
	bus_register_write_process: Process(clk, reset_n)
	Begin
	if reset_n = '0' then
		data_reg <= (others => '0');
	elsif rising_edge(clk) then
		if (cs_n = '0' and write_n = '0') then
		   we <= '1';
			data_reg(2 downto 0) <= din(2 downto 0);
		else
			we <= '0';
		end if;
	else
		NULL;
	end if;
	End Process bus_register_write_process;
		
	--read process
	bus_register_read_process: Process(cs_n, read_n)
	Begin
		if (cs_n = '0' and read_n = '0') then
			dout(31 downto 3) <= (others => '0');
			dout(2 downto 0) <= data;
		else
			dout <= (others => 'X');
		End if;
	End Process bus_register_read_process;
	 
	----VGA-RAM----
	inst_DPRAM : DP_RAM
		port map
		(
			clk_a		=> clock_25,
			clk_b		=> clk,
			addr_a	=> address,
			addr_b	=> addr,
			data_b	=> data_reg,
			we_b		=> we,
			q_a		=> data
		);
		
		----VGA Sync----
	inst_controller : VGA_Controller
		port map
		(
			clk 	  => clock_25, 
			resetn  => reset_n,
			data_in => data,
			VGA_HS  => vga_hs,
			VGA_VS  => vga_vs,
			VGA_R	  => vga_r,
			VGA_G   => vga_g,
			VGA_B   => vga_b,
			ADDRESS => address
		);
		
		dout(2 downto 0) <= data;
		
end rtl;