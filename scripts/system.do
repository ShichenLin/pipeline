onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/pc/PC
add wave -noupdate /system_tb/DUT/CPU/DP/deif/instr
add wave -noupdate /system_tb/DUT/CPU/DP/de/rf/regs
add wave -noupdate /system_tb/DUT/CPU/DP/instru_me_next
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/hu/R_PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/huif/PCSel
add wave -noupdate /system_tb/DUT/CPU/DP/huif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/huif/equal
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate /system_tb/DUT/CPU/dcif/dhit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {116321 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 141
configure wave -valuecolwidth 88
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
WaveRestoreZoom {0 ps} {1386 ns}
