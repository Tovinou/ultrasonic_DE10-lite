-- vga_display_module.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vga_display_module is
    port (
        clk         : in  std_logic;                      -- System clock
        reset       : in  std_logic;                      -- Reset signal
        distance_cm : in  std_logic_vector(15 downto 0);  -- Distance in cm
        dist_valid  : in  std_logic;                      -- Valid distance flag
        
        -- Avalon MM interface to VGA IP
        vga_addr    : out std_logic_vector(16 downto 0);  -- Address to VGA memory
        vga_data    : out std_logic_vector(31 downto 0);  -- Data to VGA memory
        vga_write   : out std_logic;                      -- Write enable
        vga_cs_n    : out std_logic;                      -- Chip select (active low)
        vga_read_n  : out std_logic                       -- Read enable (active low)
    );
end vga_display_module;

architecture Behavioral of vga_display_module is
    -- Constants for display layout
    constant DISPLAY_WIDTH  : integer := 640;
    constant DISPLAY_HEIGHT : integer := 480;
    
    -- Signals for display generation
    signal pixel_x : integer range 0 to DISPLAY_WIDTH-1 := 0;
    signal pixel_y : integer range 0 to DISPLAY_HEIGHT-1 := 0;
    signal distance_value : unsigned(15 downto 0) := (others => '0');
    signal prev_distance : unsigned(15 downto 0) := (others => '0');
    
    -- State machine for display update
    type state_type is (IDLE, CLEAR_SCREEN, DRAW_SCALE, DRAW_VALUE, DRAW_BAR);
    signal state : state_type := IDLE;
    
    -- Signals for drawing text
    signal char_addr : integer range 0 to 255 := 0;
    signal char_x : integer range 0 to 7 := 0;
    signal char_y : integer range 0 to 15 := 0;
    
    -- Constants for display positions
    constant BAR_X_START : integer := 100;
    constant BAR_WIDTH   : integer := 100;
    constant BAR_Y_END   : integer := 400;
    
    -- Function to convert distance to ASCII digits
    function to_bcd(bin : unsigned(15 downto 0)) return unsigned is
        variable i : integer := 0;
        variable bcd : unsigned(19 downto 0) := (others => '0');
        variable bin_reg : unsigned(15 downto 0) := bin;
    begin
        for i in 0 to 15 loop
            -- Add 3 to columns >= 5
            if bcd(3 downto 0) >= 5 then
                bcd(3 downto 0) := bcd(3 downto 0) + 3;
            end if;
            if bcd(7 downto 4) >= 5 then
                bcd(7 downto 4) := bcd(7 downto 4) + 3;
            end if;
            if bcd(11 downto 8) >= 5 then
                bcd(11 downto 8) := bcd(11 downto 8) + 3;
            end if;
            if bcd(15 downto 12) >= 5 then
                bcd(15 downto 12) := bcd(15 downto 12) + 3;
            end if;
            if bcd(19 downto 16) >= 5 then
                bcd(19 downto 16) := bcd(19 downto 16) + 3;
            end if;
            
            -- Shift left one
            bcd := bcd(18 downto 0) & bin_reg(15);
            bin_reg := bin_reg(14 downto 0) & '0';
        end loop;
        
        return bcd;
    end function;
    
begin
    -- Default values for Avalon MM interface
    vga_read_n <= '1';  -- We're not reading from the VGA IP
    
    -- Process to update the display when new distance data is available
    process(clk, reset)
        variable bar_height : integer;
        variable bcd_distance : unsigned(19 downto 0);
        variable digit : integer range 0 to 9;
        variable digit_pos : integer range 0 to 4;
    begin
        if reset = '1' then
            state <= IDLE;
            vga_write <= '0';
            vga_cs_n <= '1';
            distance_value <= (others => '0');
            prev_distance <= (others => '0');
            pixel_x <= 0;
            pixel_y <= 0;
        elsif rising_edge(clk) then
            vga_write <= '0';  -- Default
            vga_cs_n <= '1';   -- Default
            
            case state is
                when IDLE =>
                    if dist_valid = '1' and distance_value /= unsigned(distance_cm) then
                        -- New valid distance that's different from current
                        prev_distance <= distance_value;
                        distance_value <= unsigned(distance_cm);
                        state <= CLEAR_SCREEN;
                        pixel_x <= 0;
                        pixel_y <= 0;
                    end if;
                
                when CLEAR_SCREEN =>
                    -- Clear the screen with black background
                    vga_addr <= std_logic_vector(to_unsigned(pixel_y * DISPLAY_WIDTH + pixel_x, 17));
                    vga_data <= x"00000000";  -- Black background
                    vga_write <= '1';
                    vga_cs_n <= '0';
                    
                    -- Move to next pixel
                    if pixel_x < DISPLAY_WIDTH-1 then
                        pixel_x <= pixel_x + 1;
                    else
                        pixel_x <= 0;
                        if pixel_y < DISPLAY_HEIGHT-1 then
                            pixel_y <= pixel_y + 1;
                        else
                            pixel_x <= 0;
                            pixel_y <= 0;
                            state <= DRAW_SCALE;
                        end if;
                    end if;
                
                when DRAW_SCALE =>
                    -- Draw horizontal scale line at the bottom
                    if pixel_y = BAR_Y_END then
                        vga_addr <= std_logic_vector(to_unsigned(pixel_y * DISPLAY_WIDTH + pixel_x, 17));
                        vga_data <= x"00FFFFFF";  -- White line
                        vga_write <= '1';
                        vga_cs_n <= '0';
                    end if;
                    
                    -- Draw vertical tick marks every 10cm
                    if pixel_x >= BAR_X_START and pixel_x < BAR_X_START + BAR_WIDTH then
                        if (pixel_x - BAR_X_START) mod 10 = 0 and pixel_y >= BAR_Y_END - 5 and pixel_y <= BAR_Y_END + 5 then
                            vga_addr <= std_logic_vector(to_unsigned(pixel_y * DISPLAY_WIDTH + pixel_x, 17));
                            vga_data <= x"00FFFFFF";  -- White tick mark
                            vga_write <= '1';
                            vga_cs_n <= '0';
                        end if;
                    end if;
                    
                    -- Move to next pixel
                    if pixel_x < DISPLAY_WIDTH-1 then
                        pixel_x <= pixel_x + 1;
                    else
                        pixel_x <= 0;
                        if pixel_y < DISPLAY_HEIGHT-1 then
                            pixel_y <= pixel_y + 1;
                        else
                            pixel_x <= 300;  -- Center position for text
                            pixel_y <= 200;  -- Center position for text
                            state <= DRAW_VALUE;
                            digit_pos := 0;
                            bcd_distance := to_bcd(distance_value);
                        end if;
                    end if;
                
                when DRAW_VALUE =>
                    -- Draw the numeric value (simplified)
                    -- In a real implementation, you would use a character generator
                    -- to draw the actual digits
                    
                    -- This is a placeholder for drawing text
                    -- You would need to implement a proper character generator
                    -- or use the one provided with the VGA IP
                    
                    -- Move to next digit position
                    if digit_pos < 4 then
                        digit_pos := digit_pos + 1;
                    else
                        state <= DRAW_BAR;
                        pixel_x <= 0;
                        pixel_y <= 0;
                    end if;
                
                when DRAW_BAR =>
                    -- Draw a bar representing the distance
                    bar_height := to_integer(distance_value);
                    if bar_height > 300 then bar_height := 300; end if;  -- Limit height
                    
                    if pixel_x >= BAR_X_START and pixel_x < BAR_X_START + BAR_WIDTH and 
                       pixel_y >= (BAR_Y_END - bar_height) and pixel_y < BAR_Y_END then
                        vga_addr <= std_logic_vector(to_unsigned(pixel_y * DISPLAY_WIDTH + pixel_x, 17));
                        
                        -- Color based on distance (green for close, yellow for medium, red for far)
                        if distance_value < 50 then
                            vga_data <= x"0000FF00";  -- Green
                        elsif distance_value < 150 then
                            vga_data <= x"00FFFF00";  -- Yellow
                        else
                            vga_data <= x"00FF0000";  -- Red
                        end if;
                        
                        vga_write <= '1';
                        vga_cs_n <= '0';
                    end if;
                    
                    -- Move to next pixel
                    if pixel_x < DISPLAY_WIDTH-1 then
                        pixel_x <= pixel_x + 1;
                    else
                        pixel_x <= 0;
                        if pixel_y < DISPLAY_HEIGHT-1 then
                            pixel_y <= pixel_y + 1;
                        else
                            state <= IDLE;  -- Done updating display
                        end if;
                    end if;
            end case;
        end if;
    end process;
end Behavioral;