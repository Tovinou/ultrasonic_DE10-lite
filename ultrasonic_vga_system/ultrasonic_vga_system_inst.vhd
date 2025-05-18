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

	u0 : component ultrasonic_vga_system
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --       clk.clk
			reset_reset_n => CONNECTED_TO_reset_reset_n, --     reset.reset_n
			sdram_addr    => CONNECTED_TO_sdram_addr,    --     sdram.addr
			sdram_ba      => CONNECTED_TO_sdram_ba,      --          .ba
			sdram_cas_n   => CONNECTED_TO_sdram_cas_n,   --          .cas_n
			sdram_cke     => CONNECTED_TO_sdram_cke,     --          .cke
			sdram_cs_n    => CONNECTED_TO_sdram_cs_n,    --          .cs_n
			sdram_dq      => CONNECTED_TO_sdram_dq,      --          .dq
			sdram_dqm     => CONNECTED_TO_sdram_dqm,     --          .dqm
			sdram_ras_n   => CONNECTED_TO_sdram_ras_n,   --          .ras_n
			sdram_we_n    => CONNECTED_TO_sdram_we_n,    --          .we_n
			sdram_clk_clk => CONNECTED_TO_sdram_clk_clk, -- sdram_clk.clk
			vga_b_vga_b   => CONNECTED_TO_vga_b_vga_b,   --     vga_b.vga_b
			vga_g_vga_g   => CONNECTED_TO_vga_g_vga_g,   --     vga_g.vga_g
			vga_hs_vga_hs => CONNECTED_TO_vga_hs_vga_hs, --    vga_hs.vga_hs
			vga_r_vga_r   => CONNECTED_TO_vga_r_vga_r,   --     vga_r.vga_r
			vga_vs_vga_vs => CONNECTED_TO_vga_vs_vga_vs  --    vga_vs.vga_vs
		);

