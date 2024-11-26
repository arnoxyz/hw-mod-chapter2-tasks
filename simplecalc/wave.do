onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider Constants
add wave -noupdate /simplecalc_tb/clk_period
add wave -noupdate /simplecalc_tb/DATA_WIDTH
add wave -noupdate -divider clk
add wave -noupdate /simplecalc_tb/clk
add wave -noupdate /simplecalc_tb/clk_stop
add wave -noupdate /simplecalc_tb/res_n
add wave -noupdate -divider Inputs
add wave -noupdate /simplecalc_tb/operand_data_in
add wave -noupdate /simplecalc_tb/store_operand1
add wave -noupdate /simplecalc_tb/store_operand2
add wave -noupdate /simplecalc_tb/sub
add wave -noupdate -divider Outputs
add wave -noupdate /simplecalc_tb/operand1
add wave -noupdate /simplecalc_tb/operand2
add wave -noupdate /simplecalc_tb/result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 4} {74319 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {69300 ps}
