	watchdog_cpu_sys u0 (
		.button_export       (<connected-to-button_export>),       //     button.export
		.clk_clk             (<connected-to-clk_clk>),             //        clk.clk
		.hex_export          (<connected-to-hex_export>),          //        hex.export
		.ledr_export         (<connected-to-ledr_export>),         //       ledr.export
		.pll_clk_clk         (<connected-to-pll_clk_clk>),         //    pll_clk.clk
		.reset_reset_n       (<connected-to-reset_reset_n>),       //      reset.reset_n
		.reset_out_reset_out (<connected-to-reset_out_reset_out>), //  reset_out.reset_out
		.sdram_wire_addr     (<connected-to-sdram_wire_addr>),     // sdram_wire.addr
		.sdram_wire_ba       (<connected-to-sdram_wire_ba>),       //           .ba
		.sdram_wire_cas_n    (<connected-to-sdram_wire_cas_n>),    //           .cas_n
		.sdram_wire_cke      (<connected-to-sdram_wire_cke>),      //           .cke
		.sdram_wire_cs_n     (<connected-to-sdram_wire_cs_n>),     //           .cs_n
		.sdram_wire_dq       (<connected-to-sdram_wire_dq>),       //           .dq
		.sdram_wire_dqm      (<connected-to-sdram_wire_dqm>),      //           .dqm
		.sdram_wire_ras_n    (<connected-to-sdram_wire_ras_n>),    //           .ras_n
		.sdram_wire_we_n     (<connected-to-sdram_wire_we_n>),     //           .we_n
		.sw_export           (<connected-to-sw_export>),           //         sw.export
		.wdt_enable_export   (<connected-to-wdt_enable_export>)    // wdt_enable.export
	);

