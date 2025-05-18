transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/_definitions.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/_internals.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/_simulation_global_signals.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/_simulation_test_cases.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/blockram.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/tmq_top_tmq.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/sierra_top.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/sem_top_sem.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/sch_top_struct1.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/modules_top_struct.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/mod2rdy_rtl.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/irq_top_struct.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/hdl/bif_top_struct.vhd}
vcom -93 -work work {C:/altera_trn/Sierra_VHDL_verifiering_run/9_ver_sierra_VHDL/sierra_top/simulation/modelsim/sierra_top.vht}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  sierra_top_vhd_tst

add wave -position insertpoint  \
sim:/simulation_global_signals/reset_n \
sim:/simulation_global_signals/addr \
sim:/simulation_global_signals/clk \
sim:/simulation_global_signals/cs_n \
sim:/simulation_global_signals/din \
sim:/simulation_global_signals/dout \
sim:/simulation_global_signals/irq_n \
sim:/simulation_global_signals/write_n \
sim:/simulation_global_signals/external_data_modules_bif_taskid \
sim:/simulation_global_signals/extirq_n

view structure
view signals
run 1 us
