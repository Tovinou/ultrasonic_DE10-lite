LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY watchdog_timer IS
    PORT (
        clk           : IN std_logic;
        reset_n       : IN std_logic;
        Control_timer : IN std_logic_vector(1 downto 0);
        timer_data    : OUT std_logic_vector(31 DOWNTO 0);
        cpu_restart   : OUT std_logic
    );
END watchdog_timer;

ARCHITECTURE rtl OF watchdog_timer IS
    -- Internal signal to hold the timer value
    SIGNAL timer_value : unsigned(31 downto 0) := (others => '0');

    -- Maximum limit for the timer
    CONSTANT TIMER_LIMIT      : unsigned(31 downto 0) := to_unsigned(2147483647, 32);  -- 2^31 - 1
    -- Delay before triggering the system reset
    CONSTANT CPU_RESET_DELAY  : NATURAL := 2;
    -- Internal signal to hold the reset delay counter
    SIGNAL reset_delay_counter : unsigned(31 downto 0) := (others => '0');
BEGIN

    HW_function_process: process(clk, reset_n)
    BEGIN
        if reset_n = '0' then
            timer_value <= (others => '0');
            reset_delay_counter <= (others => '0');
            cpu_restart <= '1';  -- Set to default value

        elsif rising_edge(clk) then
            case Control_timer is
                ----------------------------------------------------------------------------------
                -- Timer start
                when "10" =>
                    if timer_value < TIMER_LIMIT then
                        timer_value <= timer_value + 1;
                        cpu_restart <= '1';  -- Timer running, no reset
                    else
                        if reset_delay_counter < to_unsigned(CPU_RESET_DELAY, 32) then
                            reset_delay_counter <= reset_delay_counter + 1;
                            cpu_restart <= '0';  -- Signal a reset during the delay period
                        else
                            cpu_restart <= '1';  -- Reset done, set back to default
                        end if;
                    end if;
                ----------------------------------------------------------------------------------
                -- Timer stop
                when "00" =>
                    -- No action required; maintain current value
                    timer_value <= timer_value;
                    cpu_restart <= '1';  -- Ensure no reset is signaled
                ----------------------------------------------------------------------------------
                -- Timer reset
                when "01" =>
                    timer_value <= (others => '0');
                    reset_delay_counter <= (others => '0');
                    cpu_restart <= '1';  -- Ensure no reset is signaled
                ----------------------------------------------------------------------------------
                -- Handle unexpected values
                when others =>
                    timer_value <= timer_value;
                    cpu_restart <= '1';  -- Ensure no reset is signaled
            end case;
        end if;
    end process HW_function_process;

    timer_data <= std_logic_vector(timer_value);

END rtl;
