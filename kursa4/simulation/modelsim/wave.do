onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk_tb
add wave -noupdate /top_tb/rst_tb
add wave -noupdate /top_tb/wr_tb
add wave -noupdate /top_tb/rd_tb
add wave -noupdate /top_tb/SCL_tb
add wave -noupdate /top_tb/SDA_tb
add wave -noupdate /top_tb/write_data_tb
add wave -noupdate /top_tb/read_data_tb
add wave -noupdate /top_tb/pointer_tb
add wave -noupdate /top_tb/pointer
add wave -noupdate /top_tb/read_process_start
add wave -noupdate /top_tb/CR0
add wave -noupdate /top_tb/CR1
add wave -noupdate /top_tb/CR2
add wave -noupdate /top_tb/data_for_CR0
add wave -noupdate /top_tb/data_for_CR1
add wave -noupdate /top_tb/data_for_CR2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {860000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 201
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {1186214 ps}
