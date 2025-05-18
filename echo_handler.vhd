-- echo_handler.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity echo_handler is
    generic (
        CLK_FREQ_MHZ : integer := 100;  -- Clock frequency in MHz
        TIMEOUT_MS   : integer := 30    -- Timeout in milliseconds
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        echo_in     : in  std_logic;
        pulse_width : out std_logic_vector(15 downto 0);  -- Echo pulse width in clock cycles
        data_valid  : out std_logic                       -- Indicates valid measurement
    );
end echo_handler;

architecture Behavioral of echo_handler is
    -- Constants
    constant TIMEOUT_CYCLES : integer := CLK_FREQ_MHZ * 1000 * TIMEOUT_MS;
    
    -- State machine states
    type state_type is (IDLE, COUNTING, DATA_READY);
    signal state : state_type := IDLE;
    
    -- Counter for pulse width
    signal counter : unsigned(15 downto 0) := (others => '0');
    signal timeout_counter : integer range 0 to TIMEOUT_CYCLES := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            counter <= (others => '0');
            timeout_counter <= 0;
            data_valid <= '0';
            pulse_width <= (others => '0');
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    data_valid <= '0';
                    if echo_in = '1' then
                        counter <= (others => '0');
                        timeout_counter <= 0;
                        state <= COUNTING;
                    end if;
                    
                when COUNTING =>
                    if echo_in = '1' then
                        if counter < 65535 then  -- Prevent overflow
                            counter <= counter + 1;
                        end if;
                        
                        -- Check for timeout
                        if timeout_counter < TIMEOUT_CYCLES then
                            timeout_counter <= timeout_counter + 1;
                        else
                            state <= IDLE;  -- Timeout occurred, return to IDLE
                        end if;
                    else
                        -- Echo pulse ended
                        pulse_width <= std_logic_vector(counter);
                        state <= DATA_READY;
                    end if;
                    
                when DATA_READY =>
                    data_valid <= '1';
                    state <= IDLE;
            end case;
        end if;
    end process;
end Behavioral;