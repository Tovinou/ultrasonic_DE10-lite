library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity WATCHDOG_TIMER_HW_IP is
   port
      (
      clk       : in std_logic;
      reset_n   : in std_logic;
      cs_n      : in std_logic;                     --IP component address
      addr      : in std_logic_vector(1 downto 0);  --offset address
      --need one address, two be sure we add one extra bit (4 addresses a 4 bytes)
      write_n   : in std_logic;
      read_n    : in std_logic;
      din       : in std_logic_vector(31 downto 0);  -- data in
      --need only two bits, but the wrapper require same number of bits for din and dout
      dout      : out std_logic_vector(31 downto 0); -- data out
      reset_out : out std_logic
      );
end entity WATCHDOG_TIMER_HW_IP;

architecture rtl of WATCHDOG_TIMER_HW_IP is

   signal data_reg    : std_logic_vector(31 downto 0); -- Data Register (32 bits)
   signal control_reg : std_logic_vector(1 downto 0);  -- Control Register (2 bits)
	
-----------------------------------------------------------------------  
   ---timer components declarations --
   component watchdog_timer IS
   PORT (
        clk            : IN std_logic;
        reset_n        : IN std_logic;
        Control_timer  : IN std_logic_vector(1 downto 0);
        timer_data     : OUT std_logic_vector(31 DOWNTO 0);
        cpu_restart    : OUT std_logic -- Signal to reset the system
        );
   end component watchdog_timer;
-----------------------------------------------------------------------
	
begin
----------------------------------------------------------------
   -- data read process--
   Bus_register_read_process :
   process(cs_n, read_n, addr, data_reg)
   begin
      if (cs_n = '0' and read_n = '0' and addr = "00") then
         dout <= data_reg;                 -- timer read
      else
         dout <= (others => '0');
      end if;
   end process Bus_register_read_process;
---------------------------------------------------------------
    -- data write process--
   Bus_register_write_process :
   process(clk, reset_n)
   begin
      if reset_n = '0' then
         control_reg <= (others => '0');
         elsif rising_edge(clk) then
            if (cs_n = '0' and write_n = '0' and addr = "01") then
               control_reg(1 downto 0) <= din(31 downto 30);
            end if;
      end if;
   end process bus_register_write_process;
----------------------------------------------------------------
	
   ---------Instantiation of components-------------------
	
   -- Instantiation of timer component
   b2v_inst_watchdog_timer : watchdog_timer 
   port map
      (
      clk           => clk,
      reset_n       => reset_n,
      Control_timer => control_reg,
      timer_data    => data_reg,
		cpu_restart   => reset_out
      );
----------------------------------------------------------------

end rtl;
