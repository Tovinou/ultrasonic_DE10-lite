# Primary system clock
create_clock -period 20.000 -name MAX10_CLK1_50 [get_ports MAX10_CLK1_50]

# Automatically calculate clock uncertainty
derive_clock_uncertainty

# Optional: If you want to manually specify uncertainty for specific clocks
# set_clock_uncertainty -setup 0.1 -hold 0.05 [get_clocks MAX10_CLK1_50]

# Generated clocks
create_generated_clock -name clk_25MHz -source [get_ports MAX10_CLK1_50] -divide_by 2 [get_pins VGA_CLK_DIV|clk_out]
create_generated_clock -name clk_1MHz -source [get_ports MAX10_CLK1_50] -divide_by 50 [get_pins CLK_DIV_1MHZ|clk_out]

# Input and output delays
set_input_delay -clock MAX10_CLK1_50 -max 5 [get_ports GPIO*]
set_input_delay -clock MAX10_CLK1_50 -min 1 [get_ports GPIO*]
set_input_delay -clock MAX10_CLK1_50 -max 5 [get_ports SW*]
set_input_delay -clock MAX10_CLK1_50 -min 1 [get_ports SW*]

set_output_delay -clock MAX10_CLK1_50 -max 5 [get_ports HEX*]
set_output_delay -clock MAX10_CLK1_50 -min 1 [get_ports HEX*]
set_output_delay -clock MAX10_CLK1_50 -max 5 [get_ports LEDR*]
set_output_delay -clock MAX10_CLK1_50 -min 1 [get_ports LEDR*]

# VGA timing constraints
set_output_delay -clock clk_25MHz -max 5 [get_ports VGA_*]
set_output_delay -clock clk_25MHz -min 1 [get_ports VGA_*]

# False paths
set_false_path -from [get_clocks MAX10_CLK1_50] -to [get_clocks clk_25MHz]
set_false_path -from [get_clocks clk_25MHz] -to [get_clocks MAX10_CLK1_50]
set_false_path -from [get_clocks MAX10_CLK1_50] -to [get_clocks clk_1MHz]
set_false_path -from [get_clocks clk_1MHz] -to [get_clocks MAX10_CLK1_50]