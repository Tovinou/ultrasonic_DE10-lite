transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/AGSTU/HWSW/VGA_IP/VGA_IP.vhd}
vcom -93 -work work {D:/AGSTU/HWSW/VGA_IP/dpram.vhd}
vcom -93 -work work {D:/AGSTU/HWSW/VGA_IP/vga_sync.vhd}

vcom -93 -work work {D:/AGSTU/HWSW/VGA_IP/simulation/modelsim/vga_ip.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  vga_ip_vhd_tst

add wave *
view structure
view signals
run 100 ns
