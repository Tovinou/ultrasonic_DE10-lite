
module watchdog_cpu_sys (
	button_export,
	clk_clk,
	hex_export,
	ledr_export,
	pll_clk_clk,
	reset_reset_n,
	reset_out_reset_out,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	sw_export,
	wdt_enable_export);	

	input		button_export;
	input		clk_clk;
	output	[6:0]	hex_export;
	output	[7:0]	ledr_export;
	output		pll_clk_clk;
	input		reset_reset_n;
	output		reset_out_reset_out;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	input	[7:0]	sw_export;
	input		wdt_enable_export;
endmodule
