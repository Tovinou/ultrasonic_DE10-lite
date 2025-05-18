-- distance_calculator.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.MATH_REAL.ALL;

entity distance_calculator is
    generic (
        CLK_FREQ_MHZ : integer := 100  -- Clock frequency in MHz
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        pulse_width : in  std_logic_vector(15 downto 0);  -- Echo pulse width in clock cycles
        data_valid  : in  std_logic;                      -- Indicates valid measurement
        distance_cm : out std_logic_vector(15 downto 0);  -- Distance in centimeters
        dist_valid  : out std_logic                       -- Indicates valid distance
    );
end distance_calculator;

architecture Behavioral of distance_calculator is
    -- Constants for calculation
    -- Speed of sound = 34300 cm/s = 0.0343 cm/μs
    -- Distance = (pulse_width * 0.0343) / 2 cm
    -- For fixed-point calculation: multiply by 1000, then divide by 1000 at the end
    constant FACTOR : integer := 17150;  -- 0.0343 * 1000000 / 2 = 17150
    
    signal distance_temp : unsigned(31 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            distance_cm <= (others => '0');
            dist_valid <= '0';
        elsif rising_edge(clk) then
            dist_valid <= '0';
            
            if data_valid = '1' then
                -- Calculate distance: (pulse_width * FACTOR) / CLK_FREQ_MHZ
                distance_temp <= unsigned(pulse_width) * to_unsigned(FACTOR, 16) / to_unsigned(CLK_FREQ_MHZ, 16);
                
                -- Limit to 16 bits
                if distance_temp > 65535 then
                    distance_cm <= (others => '1');  -- Saturate at max value
                else
                    distance_cm <= std_logic_vector(distance_temp(15 downto 0));
                end if;
                
                dist_valid <= '1';
            end if;
        end if;
    end process;
end Behavioral;