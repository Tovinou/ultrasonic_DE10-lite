-- clock_divider.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    generic (
        DIVISOR : integer := 100 -- Default divisor
    );
    port (
        clk_in  : in  std_logic;
        reset   : in  std_logic;
        clk_out : out std_logic
    );
end clock_divider;

architecture Behavioral of clock_divider is
    signal counter : integer range 0 to DIVISOR-1 := 0;
    signal temp    : std_logic := '0';
begin
    process(clk_in, reset)
    begin
        if reset = '1' then
            counter <= 0;
            temp <= '0';
        elsif rising_edge(clk_in) then
            if counter = DIVISOR-1 then
                temp <= not temp;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clk_out <= temp;
end Behavioral;