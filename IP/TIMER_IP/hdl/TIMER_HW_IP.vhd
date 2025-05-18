library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity TIMER_HW_IP is
   port
      (
      clk     : in std_logic;
      reset_n : in std_logic;
      cs_n    : in std_logic;                     --IP component address
      addr    : in std_logic_vector(1 downto 0);  --offset address
      --need one address, two be sure we add one extra bit (4 addresses a 4 bytes)
      write_n : in std_logic;
      read_n  : in std_logic;
      din     : in std_logic_vector(31 downto 0);  -- data in
      --need only two bits, but the wrapper require same number of bits for din and dout
      dout    : out std_logic_vector(31 downto 0) -- data out
      --ledr    : out std_logic_vector(7 downto 0)
      );
end entity TIMER_HW_IP;

architecture rtl of TIMER_HW_IP is

   signal data_reg    : std_logic_vector(31 downto 0); -- Data Register (32 bits)
   signal control_reg : std_logic_vector(1 downto 0);  -- Control Register (2 bits)

   ---timer components declarations --
   component timer is
      port
         (
         clk           : in std_logic;
         reset_n       : in std_logic;
         Control_timer : in std_logic_vector(1 downto 0);
         timer_data    : out std_logic_vector(31 downto 0)
         );
   end component;
	
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
            else
               null;
            end if;
         else
            null;
      end if;
   end process bus_register_write_process;
----------------------------------------------------------------
	
   ---------Instantiation of components-------------------
   -- Instantiation of timer component
   b2v_inst_timer : timer 
   port map
      (
      clk           => clk,
      reset_n       => reset_n,
      Control_timer => control_reg,
      timer_data    => data_reg
      );

   --ledr <= data_reg(31 downto 24);

end rtl;
