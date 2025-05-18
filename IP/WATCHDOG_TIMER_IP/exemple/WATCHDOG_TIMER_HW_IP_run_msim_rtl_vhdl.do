transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/AGSTU/HWSW/WATCHDOG_TIMER_HW_IP/watchdog_timer.vhd}
vcom -93 -work work {D:/AGSTU/HWSW/WATCHDOG_TIMER_HW_IP/WATCHDOG_TIMER_HW_IP.vhd}

vcom -93 -work work {D:/AGSTU/HWSW/WATCHDOG_TIMER_HW_IP/simulation/modelsim/WATCHDOG_TIMER_HW_IP.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L fiftyfivenm -L rtl_work -L work -voptargs="+acc"  WATCHDOG_TIMER_HW_IP_vhd_tst

add wave *

add wave -position insertpoint  \
sim:/watchdog_timer_hw_ip_vhd_tst/i1/b2v_inst_watchdog_timer/timer_data \
sim:/watchdog_timer_hw_ip_vhd_tst/i1/b2v_inst_watchdog_timer/cpu_restart \
sim:/watchdog_timer_hw_ip_vhd_tst/i1/b2v_inst_watchdog_timer/reset_delay_counter \
sim:/watchdog_timer_hw_ip_vhd_tst/i1/b2v_inst_watchdog_timer/timer_value \
sim:/watchdog_timer_hw_ip_vhd_tst/i1/b2v_inst_watchdog_timer/CPU_RESET_DELAY \
sim:/watchdog_timer_hw_ip_vhd_tst/i1/b2v_inst_watchdog_timer/TIMER_LIMIT \
sim:/watchdog_timer_hw_ip_vhd_tst/i1/b2v_inst_watchdog_timer/Control_timer

view structure
view signals
run 100 ns
