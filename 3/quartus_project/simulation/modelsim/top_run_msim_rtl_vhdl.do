transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -2008 -work work {C:/Users/Bogdan/Desktop/MIHA_2SEM/Miha_2sem/3/quartus_project/top.vhd}

vcom -93 -work work {C:/Users/Bogdan/Desktop/MIHA_2SEM/Miha_2sem/3/quartus_project/util_pckg.vhd}
vcom -93 -work work {C:/Users/Bogdan/Desktop/MIHA_2SEM/Miha_2sem/3/quartus_project/qntr_tb.vhd}
vcom -93 -work work {C:/Users/Bogdan/Desktop/MIHA_2SEM/Miha_2sem/3/quartus_project/top.vhd}
vcom -93 -work work {C:/Users/Bogdan/Desktop/MIHA_2SEM/Miha_2sem/3/quartus_project/top_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  top_tb

add wave *
view structure
view signals
run 1 ms
