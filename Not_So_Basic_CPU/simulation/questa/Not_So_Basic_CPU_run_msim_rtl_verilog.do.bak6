transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/harve/Documents/Not_So_Basic_CPU {C:/Users/harve/Documents/Not_So_Basic_CPU/system_agent.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Not_So_Basic_CPU {C:/Users/harve/Documents/Not_So_Basic_CPU/memory.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Not_So_Basic_CPU {C:/Users/harve/Documents/Not_So_Basic_CPU/fifo_shift_reg.sv}
vlog -sv -work work +incdir+C:/Users/harve/Documents/Not_So_Basic_CPU {C:/Users/harve/Documents/Not_So_Basic_CPU/system.sv}

vlog -sv -work work +incdir+C:/Users/harve/Documents/Not_So_Basic_CPU {C:/Users/harve/Documents/Not_So_Basic_CPU/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run -all
