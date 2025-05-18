-- ultrasonic_top.vhd
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ultrasonic_top is
    port (
        MAX10_CLK1_50  : in  std_logic;
        SW             : in  std_logic_vector(9 downto 9);  -- reset_n and pio
        GPIO           : in  std_logic_vector(0 downto 0);  -- Echo signal from ultrasonic sensor(used as echo_in)
        HEX0           : out std_logic_vector(6 downto 0);  -- 7-segment display segments
        HEX1           : out std_logic_vector(3 downto 0);  -- Digit select signals (digit_sel)
        LEDR           : out std_logic_vector(1 downto 0); -- [1] trigger, [0] dist_valid  
        -- VGA ports
        VGA_R          : out std_logic_vector(3 downto 0);  -- VGA Red channel
        VGA_G          : out std_logic_vector(3 downto 0);  -- VGA Green channel
        VGA_B          : out std_logic_vector(3 downto 0);  -- VGA Blue channel
        VGA_HS         : out std_logic;                     -- VGA Horizontal Sync
        VGA_VS         : out std_logic;                     -- VGA Vertical Sync
        -------SDRAM----------------------------------------------
        DRAM_CLK       : out   std_logic; -- connect to pll C1 clock
        DRAM_ADDR      : out   std_logic_vector(12 downto 0);
        DRAM_BA        : out   std_logic_vector(1 downto 0);
        DRAM_CAS_N     : out   std_logic;
        DRAM_CKE       : out   std_logic;
        DRAM_CS_N      : out   std_logic;
        DRAM_DQ        : inout std_logic_vector(15 downto 0) := (others => '0');
        DRAM_LDQM      : out   std_logic;
        DRAM_UDQM      : out   std_logic;
        DRAM_RAS_N     : out   std_logic; 
        DRAM_WE_N      : out   std_logic
    );
end ultrasonic_top;

architecture Behavioral of ultrasonic_top is

    -- Constants
    constant CLK_FREQ_MHZ : integer := 50;  -- Clock frequency in MHz
    -- Clock signals
    signal clk_1MHz : std_logic;  -- 1 MHz clock for precise timing
    
    -- Internal signals
    signal pulse_width  : std_logic_vector(15 downto 0);
    signal data_valid   : std_logic;
    signal distance_cm  : std_logic_vector(15 downto 0);
    signal dist_valid   : std_logic;
    signal bcd_distance : std_logic_vector(15 downto 0);
    signal trigger_out  : std_logic;
    
    -- New signals for VGA
    signal clk_25MHz : std_logic;  -- 25 MHz clock for VGA
    signal distance_latched : std_logic_vector(15 downto 0);
    
    -- Signals for VGA IP interface
    signal vga_addr  : std_logic_vector(16 downto 0);
    signal vga_data  : std_logic_vector(31 downto 0);
    signal vga_write : std_logic;
    signal vga_cs_n  : std_logic;
    signal vga_read_n : std_logic;
    
    -- sdram signal
    signal S_DQM : std_logic_vector(1 downto 0);
-------------------------------------------------------------------------    
    -- Component declarations
    component clock_divider is
        generic (
            DIVISOR : integer
        );
        port (
            clk_in  : in  std_logic;
            reset   : in  std_logic;
            clk_out : out std_logic
        );
    end component;
    
    component trigger_generator is
        generic (
            CLK_FREQ_MHZ : integer;
            TRIGGER_US   : integer;
            CYCLE_MS     : integer
        );
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            trigger_out : out std_logic
        );
    end component;
    
    component echo_handler is
        generic (
            CLK_FREQ_MHZ : integer;
            TIMEOUT_MS   : integer
        );
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            echo_in     : in  std_logic;
            pulse_width : out std_logic_vector(15 downto 0);
            data_valid  : out std_logic
        );
    end component;
    
    component distance_calculator is
        generic (
            CLK_FREQ_MHZ : integer
        );
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            pulse_width : in  std_logic_vector(15 downto 0);
            data_valid  : in  std_logic;
            distance_cm : out std_logic_vector(15 downto 0);
            dist_valid  : out std_logic
        );
    end component;
    
    component binary_to_bcd is
        port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            binary_in : in  std_logic_vector(15 downto 0);
            bcd_out   : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component display_controller is
        port (
            clk       : in  std_logic;
            reset     : in  std_logic;
            bcd_in    : in  std_logic_vector(15 downto 0);
            seg_out   : out std_logic_vector(6 downto 0);
            digit_sel : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- VGA Display Module component declaration
    component vga_display_module is
        port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            distance_cm : in  std_logic_vector(15 downto 0);
            dist_valid  : in  std_logic;
            vga_addr    : out std_logic_vector(16 downto 0);
            vga_data    : out std_logic_vector(31 downto 0);
            vga_write   : out std_logic;
            vga_cs_n    : out std_logic;
            vga_read_n  : out std_logic
        );
    end component;
    
    -- VGA component declaration 
    component ultrasonic_vga_system is
      port (
         clk_clk       : in    std_logic                     := 'X';             -- clk
         reset_reset_n : in    std_logic                     := 'X';             -- reset_n
         sdram_addr    : out   std_logic_vector(12 downto 0);                    -- addr
         sdram_ba      : out   std_logic_vector(1 downto 0);                     -- ba
         sdram_cas_n   : out   std_logic;                                        -- cas_n
         sdram_cke     : out   std_logic;                                        -- cke
         sdram_cs_n    : out   std_logic;                                        -- cs_n
         sdram_dq      : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
         sdram_dqm     : out   std_logic_vector(1 downto 0);                     -- dqm
         sdram_ras_n   : out   std_logic;                                        -- ras_n
         sdram_we_n    : out   std_logic;                                        -- we_n
         sdram_clk_clk : out   std_logic;                                        -- clk
         vga_b_vga_b   : out   std_logic_vector(3 downto 0);                     -- vga_b
         vga_g_vga_g   : out   std_logic_vector(3 downto 0);                     -- vga_g
         vga_hs_vga_hs : out   std_logic;                                        -- vga_hs
         vga_r_vga_r   : out   std_logic_vector(3 downto 0);                     -- vga_r
         vga_vs_vga_vs : out   std_logic                                         -- vga_vs
      );
   end component ultrasonic_vga_system;
--------------------------------------------------------------------------------------------------------------------------- 
 
begin
    -- Clock divider for 25 MHz VGA clock (from 50 MHz system clock)
    VGA_CLK_DIV: clock_divider
        generic map (
            DIVISOR => 2  -- Divide by 2 to get 25 MHz from 50 MHz
        )
        port map (
            clk_in  => MAX10_CLK1_50,
            reset   => SW(9),
            clk_out => clk_25MHz
        );
    
    -- Latch the distance value when valid
    process(MAX10_CLK1_50, SW(9))
    begin
        if SW(9) = '1' then
            distance_latched <= (others => '0');
        elsif rising_edge(MAX10_CLK1_50) then
            if dist_valid = '1' then
               distance_latched <= distance_cm;
            end if;
        end if;
    end process;

------------------------------------------------------------------------------------------------------------------------------------    
    -- Instantiate clock divider to generate 1 MHz clock from system clock
    -- For a 50 MHz input clock, divide by 50 to get 1 MHz
    CLK_DIV_1MHZ: clock_divider
        generic map (
            DIVISOR => CLK_FREQ_MHZ           -- Divide by 50 to get 1 MHz from 50 MHz
        )
        port map (
            clk_in  => MAX10_CLK1_50,
            reset   => SW(9),
            clk_out => clk_1MHz
        );
    
    -- Instantiate trigger generator
    TRIG_GEN: trigger_generator
        generic map (
            CLK_FREQ_MHZ => 1,                -- Using 1 MHz clock for timing
            TRIGGER_US   => 10,               -- 10 μs trigger pulse
            CYCLE_MS     => 60                -- 60 ms measurement cycle
        )
        port map (
            clk          => clk_1MHz,         -- Use 1 MHz clock for precise timing
            reset        => SW(9),
            trigger_out  => trigger_out
        );
    
    -- Instantiate echo handler
    ECHO_HANDLER_INST: echo_handler
        generic map (
            CLK_FREQ_MHZ => 1,                -- Using 1 MHz clock for timing
            TIMEOUT_MS   => 30                -- 30 ms timeout
        )
        port map (
            clk          => clk_1MHz,         -- Use 1 MHz clock for precise timing
            reset        => SW(9),
            echo_in      => GPIO(0),          -- Connect to GPIO input
            pulse_width  => pulse_width,
            data_valid   => data_valid
        );
    
    -- Instantiate distance calculator
    DIST_CALC: distance_calculator
        generic map (
            CLK_FREQ_MHZ => 1                 -- Using 1 MHz clock for timing
        )
        port map (
            clk          => clk_1MHz,         -- Use 1 MHz clock for calculations
            reset        => SW(9),
            pulse_width  => pulse_width,
            data_valid   => data_valid,
            distance_cm  => distance_cm,
            dist_valid   => dist_valid
        );
    
    -- Instantiate binary to BCD converter
    BIN_TO_BCD_INST: binary_to_bcd
        port map (
            clk       => MAX10_CLK1_50,       -- Use system clock for display processing
            reset     => SW(9),
            binary_in => distance_cm,
            bcd_out   => bcd_distance
        );
    
    -- Instantiate display controller
    DISP_CTRL: display_controller
        port map (
            clk       => MAX10_CLK1_50,       -- Use system clock for display
            reset     => SW(9),
            bcd_in    => bcd_distance,
            seg_out   => HEX0,
            digit_sel => HEX1                 -- Connect directly to HEX1 output
        );
        
    -- Instantiate VGA Display Module
    VGA_DISPLAY: vga_display_module
        port map (
            clk         => MAX10_CLK1_50,
            reset       => SW(9),
            distance_cm => distance_latched,
            dist_valid  => dist_valid,
            vga_addr    => vga_addr,
            vga_data    => vga_data,
            vga_write   => vga_write,
            vga_cs_n    => vga_cs_n,
            vga_read_n  => vga_read_n
        );
        
    -- Instantiate VGA controller
    ULTRA_VGA_SYS: ultrasonic_vga_system
        port map (
            clk_clk       => MAX10_CLK1_50,       
            reset_reset_n => not SW(9), 
            sdram_addr    => DRAM_ADDR,    
            sdram_ba      => DRAM_BA,      
            sdram_cas_n   => DRAM_CAS_N,   
            sdram_cke     => DRAM_CKE,     
            sdram_cs_n    => DRAM_CS_N,    
            sdram_dq      => DRAM_DQ,      
            sdram_dqm     => S_DQM,     
            sdram_ras_n   => DRAM_RAS_N,   
            sdram_we_n    => DRAM_WE_N,    
            sdram_clk_clk => DRAM_CLK, 
            vga_b_vga_b   => VGA_B,   
            vga_g_vga_g   => VGA_G,   
            vga_hs_vga_hs => VGA_HS, 
            vga_r_vga_r   => VGA_R,   
            vga_vs_vga_vs => VGA_VS  
      );
      
    -- Connect trigger and valid signals to LEDs
    LEDR(1) <= trigger_out;
    LEDR(0) <= dist_valid;
    
    -- Output signal for sdram_dqm
    DRAM_LDQM <= S_DQM(0);
    DRAM_UDQM <= S_DQM(1);
    
end Behavioral;