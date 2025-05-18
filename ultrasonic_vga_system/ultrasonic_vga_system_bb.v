
module ultrasonic_vga_system (
	clk_clk,
	reset_reset_n,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	sdram_clk_clk,
	vga_b_vga_b,
	vga_g_vga_g,
	vga_hs_vga_hs,
	vga_r_vga_r,
	vga_vs_vga_vs);	

	input		clk_clk;
	input		reset_reset_n;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[15:0]	sdram_dq;
	output	[1:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		sdram_clk_clk;
	output	[3:0]	vga_b_vga_b;
	output	[3:0]	vga_g_vga_g;
	output		vga_hs_vga_hs;
	output	[3:0]	vga_r_vga_r;
	output		vga_vs_vga_vs;
endmodule
