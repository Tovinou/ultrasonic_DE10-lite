-- trigger_generator.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trigger_generator is
    generic (
        CLK_FREQ_MHZ : integer := 100;  -- Clock frequency in MHz
        TRIGGER_US   : integer := 10;   -- Trigger pulse width in microseconds
        CYCLE_MS     : integer := 60    -- Measurement cycle in milliseconds
    );
    port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        trigger_out : out std_logic
    );
end trigger_generator;

architecture Behavioral of trigger_generator is
    -- Constants for timing
    constant TRIGGER_CYCLES : integer := CLK_FREQ_MHZ * TRIGGER_US;
    constant CYCLE_CYCLES   : integer := CLK_FREQ_MHZ * 1000 * CYCLE_MS;
    
    -- State machine states
    type state_type is (IDLE, TRIGGER_ACTIVE, WAIT_CYCLE);
    signal state : state_type := IDLE;
    
    -- Counter for timing
    signal counter : integer range 0 to CYCLE_CYCLES := 0;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            counter <= 0;
            trigger_out <= '0';
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    trigger_out <= '1';  -- Start trigger pulse
                    counter <= 0;
                    state <= TRIGGER_ACTIVE;
                    
                when TRIGGER_ACTIVE =>
                    if counter < TRIGGER_CYCLES then
                        counter <= counter + 1;
                    else
                        trigger_out <= '0';  -- End trigger pulse
                        counter <= 0;
                        state <= WAIT_CYCLE;
                    end if;
                    
                when WAIT_CYCLE =>
                    if counter < CYCLE_CYCLES - TRIGGER_CYCLES then
                        counter <= counter + 1;
                    else
                        state <= IDLE;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;