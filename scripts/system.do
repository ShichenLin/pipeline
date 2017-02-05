onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/dpifhalt
add wave -noupdate /system_tb/DUT/CPU/DP/PC_0
add wave -noupdate /system_tb/DUT/CPU/DP/PC_1
add wave -noupdate /system_tb/DUT/CPU/DP/PC_2
add wave -noupdate /system_tb/DUT/CPU/DP/PC_3
add wave -noupdate /system_tb/DUT/CPU/DP/PC_4
add wave -noupdate /system_tb/DUT/CPU/DP/PC_5
add wave -noupdate /system_tb/DUT/CPU/DP/PC_6
add wave -noupdate {/system_tb/DUT/RAM/\ramif.ramREN }
add wave -noupdate /system_tb/DUT/CPU/CC/ruifdREN_r
add wave -noupdate /system_tb/DUT/CPU/CC/ruifdWEN_r
add wave -noupdate /system_tb/DUT/CPU/DP/dcifimemload_31
add wave -noupdate /system_tb/DUT/CPU/DP/dcifimemload_30
add wave -noupdate /system_tb/DUT/CPU/DP/dcifimemload_29
add wave -noupdate /system_tb/DUT/CPU/DP/dcifimemload_28
add wave -noupdate /system_tb/DUT/CPU/DP/dcifimemload_27
add wave -noupdate /system_tb/DUT/CPU/DP/dcifimemload_26
add wave -noupdate /system_tb/DUT/CPU/CM/ramiframload_26
add wave -noupdate /system_tb/DUT/CPU/CM/ramiframload_27
add wave -noupdate /system_tb/DUT/CPU/CM/ramiframload_28
add wave -noupdate /system_tb/DUT/CPU/CM/ramiframload_29
add wave -noupdate /system_tb/DUT/CPU/CM/ramiframload_30
add wave -noupdate /system_tb/DUT/CPU/CM/ramiframload_31
add wave -noupdate -expand /system_tb/DUT/CPU/CM/instr
add wave -noupdate /system_tb/DUT/CPU/CM/dcifihit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1311396339 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {1311005 ns} {1313105 ns}
