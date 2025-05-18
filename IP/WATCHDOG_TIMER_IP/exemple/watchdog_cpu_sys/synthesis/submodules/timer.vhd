LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- connects to the registers
ENTITY timer IS
   PORT (
        clk            : IN std_logic;
        reset_n        : IN std_logic;
        Control_timer  : IN std_logic_vector(1 downto 0);
        timer_data     : OUT std_logic_vector(31 DOWNTO 0)
        );
END timer;

-- HW_function_process handles the function in timer component
ARCHITECTURE timer_rtl OF timer IS
   -- Internal signal to hold the timer value
   SIGNAL timer_value : unsigned(31 downto 0) := (others => '0');

BEGIN

   HW_function_process: process(clk, reset_n)
   BEGIN
      if reset_n = '0' then
         timer_value <= (others => '0');
      elsif rising_edge(clk) then
         case Control_timer is
   ---------------------------------------------------------------------			
            -- Timer start
            when "10" =>
               timer_value <= timer_value + 1;

            -- timer stop
            when "00" =>
               -- No action required; maintain current value
               timer_value <= timer_value;

            -- timer reset
            when "01" =>
               timer_value <= (others => '0');

            -- Handle unexpected values
            when others =>
               timer_value <= timer_value;
	-----------------------------------------------------------------------				
         end case;
      end if;
   end process HW_function_process;

	timer_data <= std_logic_vector(timer_value);
	
END timer_rtl;
