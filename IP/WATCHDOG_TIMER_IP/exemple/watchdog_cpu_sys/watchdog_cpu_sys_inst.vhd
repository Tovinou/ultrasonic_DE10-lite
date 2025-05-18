	component watchdog_cpu_sys is
		port (
			button_export       : in    std_logic                     := 'X';             -- export
			clk_clk             : in    std_logic                     := 'X';             -- clk
			hex_export          : out   std_logic_vector(6 downto 0);                     -- export
			ledr_export         : out   std_logic_vector(7 downto 0);                     -- export
			pll_clk_clk         : out   std_logic;                                        -- clk
			reset_reset_n       : in    std_logic                     := 'X';             -- reset_n
			reset_out_reset_out : out   std_logic;                                        -- reset_out
			sdram_wire_addr     : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba       : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n    : out   std_logic;                                        -- cas_n
			sdram_wire_cke      : out   std_logic;                                        -- cke
			sdram_wire_cs_n     : out   std_logic;                                        -- cs_n
			sdram_wire_dq       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm      : out   std_logic_vector(1 downto 0);                     -- dqm
			sdram_wire_ras_n    : out   std_logic;                                        -- ras_n
			sdram_wire_we_n     : out   std_logic;                                        -- we_n
			sw_export           : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			wdt_enable_export   : in    std_logic                     := 'X'              -- export
		);
	end component watchdog_cpu_sys;

	u0 : component watchdog_cpu_sys
		port map (
			button_export       => CONNECTED_TO_button_export,       --     button.export
			clk_clk             => CONNECTED_TO_clk_clk,             --        clk.clk
			hex_export          => CONNECTED_TO_hex_export,          --        hex.export
			ledr_export         => CONNECTED_TO_ledr_export,         --       ledr.export
			pll_clk_clk         => CONNECTED_TO_pll_clk_clk,         --    pll_clk.clk
			reset_reset_n       => CONNECTED_TO_reset_reset_n,       --      reset.reset_n
			reset_out_reset_out => CONNECTED_TO_reset_out_reset_out, --  reset_out.reset_out
			sdram_wire_addr     => CONNECTED_TO_sdram_wire_addr,     -- sdram_wire.addr
			sdram_wire_ba       => CONNECTED_TO_sdram_wire_ba,       --           .ba
			sdram_wire_cas_n    => CONNECTED_TO_sdram_wire_cas_n,    --           .cas_n
			sdram_wire_cke      => CONNECTED_TO_sdram_wire_cke,      --           .cke
			sdram_wire_cs_n     => CONNECTED_TO_sdram_wire_cs_n,     --           .cs_n
			sdram_wire_dq       => CONNECTED_TO_sdram_wire_dq,       --           .dq
			sdram_wire_dqm      => CONNECTED_TO_sdram_wire_dqm,      --           .dqm
			sdram_wire_ras_n    => CONNECTED_TO_sdram_wire_ras_n,    --           .ras_n
			sdram_wire_we_n     => CONNECTED_TO_sdram_wire_we_n,     --           .we_n
			sw_export           => CONNECTED_TO_sw_export,           --         sw.export
			wdt_enable_export   => CONNECTED_TO_wdt_enable_export    -- wdt_enable.export
		);

