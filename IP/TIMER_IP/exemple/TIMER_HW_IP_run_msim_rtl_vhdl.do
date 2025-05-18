transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/AGSTU/HWSW/TIMER_HW_IP/timer.vhd}
vcom -93 -work work {D:/AGSTU/HWSW/TIMER_HW_IP/timer_hw_ip.vhd}

vcom -93 -work work {D:/AGSTU/HWSW/TIMER_HW_IP/simulation/modelsim/TIMER_HW_IP.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  TIMER_HW_IP_vhd_tst

add wave *
view structure
view signals
run 100 ns
