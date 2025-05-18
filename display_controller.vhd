-- display_controller.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity display_controller is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        bcd_in    : in  std_logic_vector(15 downto 0);  -- BCD input (4 digits, 4 bits each)
        seg_out   : out std_logic_vector(6 downto 0);   -- 7-segment display segments
        digit_sel : out std_logic_vector(3 downto 0)    -- Digit select signals
    );
end display_controller;

architecture Behavioral of display_controller is
    -- 7-segment display encoding (0 to 9)
    type segment_array is array (0 to 9) of std_logic_vector(6 downto 0);
    constant SEGMENTS : segment_array := (
        "1000000",  -- 0
        "1111001",  -- 1
        "0100100",  -- 2
        "0110000",  -- 3
        "0011001",  -- 4
        "0010010",  -- 5
        "0000010",  -- 6
        "1111000",  -- 7
        "0000000",  -- 8
        "0010000"   -- 9
    );
    
    -- Counter for digit multiplexing
    signal digit_counter : unsigned(1 downto 0) := (others => '0');
    signal digit_value : unsigned(3 downto 0);
    
    -- Clock divider for display refresh
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal refresh_clk : std_logic := '0';
begin
    -- Clock divider for display refresh (around 1kHz)
    process(clk, reset)
    begin
        if reset = '1' then
            refresh_counter <= (others => '0');
            refresh_clk <= '0';
        elsif rising_edge(clk) then
            refresh_counter <= refresh_counter + 1;
            if refresh_counter = 50000 then  -- Adjust for desired refresh rate
                refresh_counter <= (others => '0');
                refresh_clk <= not refresh_clk;
            end if;
        end if;
    end process;
    
    -- Digit multiplexing
    process(refresh_clk, reset)
    begin
        if reset = '1' then
            digit_counter <= (others => '0');
        elsif rising_edge(refresh_clk) then
            digit_counter <= digit_counter + 1;
        end if;
    end process;
    
    -- Digit selection
    process(digit_counter, bcd_in)
    begin
        case digit_counter is
            when "00" =>
                digit_sel <= "1110";  -- Enable digit 0 (rightmost)
                digit_value <= unsigned(bcd_in(3 downto 0));
            when "01" =>
                digit_sel <= "1101";  -- Enable digit 1
                digit_value <= unsigned(bcd_in(7 downto 4));
            when "10" =>
                digit_sel <= "1011";  -- Enable digit 2
                digit_value <= unsigned(bcd_in(11 downto 8));
            when "11" =>
                digit_sel <= "0111";  -- Enable digit 3 (leftmost)
                digit_value <= unsigned(bcd_in(15 downto 12));
            when others =>
                digit_sel <= "1111";  -- All digits off
                digit_value <= (others => '0');
        end case;
    end process;
    
    -- 7-segment encoding
    process(digit_value)
    begin
        if digit_value < 10 then
            seg_out <= SEGMENTS(to_integer(digit_value));
        else
            seg_out <= "1111111";  -- All segments off for invalid values
        end if;
    end process;
end Behavioral;