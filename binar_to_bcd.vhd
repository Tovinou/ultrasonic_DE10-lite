-- binary_to_bcd.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_to_bcd is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        binary_in : in  std_logic_vector(15 downto 0);  -- Binary input (up to 9999)
        bcd_out   : out std_logic_vector(15 downto 0)   -- BCD output (4 digits, 4 bits each)
    );
end binary_to_bcd;

architecture Behavioral of binary_to_bcd is
begin
    -- Double dabble algorithm
    process(clk, reset)
        variable temp : unsigned(31 downto 0);
        variable bcd : unsigned(15 downto 0) := (others => '0');
    begin
        if reset = '1' then
            bcd_out <= (others => '0');
        elsif rising_edge(clk) then
            -- Initialize with binary input in the lower bits
            temp := (others => '0');
            bcd := (others => '0');
            
            -- Properly initialize temp with binary_in in the lower 16 bits
            temp(15 downto 0) := unsigned(binary_in);
            
            -- Perform double dabble algorithm
            for i in 0 to 15 loop
                -- Check if any BCD digit is >= 5
                if bcd(3 downto 0) > 4 then
                    bcd(3 downto 0) := bcd(3 downto 0) + 3;
                end if;
                
                if bcd(7 downto 4) > 4 then
                    bcd(7 downto 4) := bcd(7 downto 4) + 3;
                end if;
                
                if bcd(11 downto 8) > 4 then
                    bcd(11 downto 8) := bcd(11 downto 8) + 3;
                end if;
                
                if bcd(15 downto 12) > 4 then
                    bcd(15 downto 12) := bcd(15 downto 12) + 3;
                end if;
                
                -- Shift left
                bcd := bcd(14 downto 0) & temp(15);
                temp := temp(30 downto 0) & '0';
            end loop;
            
            bcd_out <= std_logic_vector(bcd);
        end if;
    end process;
end Behavioral;