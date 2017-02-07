onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/wbif/WEN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/pc/PC
add wave -noupdate /system_tb/DUT/CPU/DP/de/instr
add wave -noupdate /system_tb/DUT/CPU/DP/wbif/wdat
add wave -noupdate /system_tb/DUT/CPU/DP/deif/regDst_next
add wave -noupdate /system_tb/DUT/CPU/DP/exif/regDst_next
add wave -noupdate /system_tb/DUT/CPU/DP/meif/regDst
add wave -noupdate /system_tb/DUT/CPU/DP/deif/imm_next
add wave -noupdate -expand /system_tb/DUT/CPU/DP/de/rf/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {148358 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 279
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {1050 ns}
