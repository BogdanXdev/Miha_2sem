transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/code/miha/soc/1ps_5/circular_shifter_left.vhd}

vcom -2008 -work work {C:/code/miha/soc/1ps_5/circular_shifter_left.vhd}
vcom -2008 -work work {C:/code/miha/soc/1ps_5/circular_shifter_left_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L rtl_work -L work -voptargs="+acc"  circular_shifter_left_tb

add wave *
view structure
view signals
run 1 ms
