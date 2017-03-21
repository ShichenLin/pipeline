onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/pc/PC
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate /system_tb/DUT/CPU/CM/DCACHE/addr
add wave -noupdate /system_tb/DUT/CPU/DP/deif/instr
add wave -noupdate /system_tb/DUT/CPU/DP/de/rf/regs
add wave -noupdate /system_tb/DUT/CPU/DP/instru_me_next
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/PC
add wave -noupdate /system_tb/DUT/CPU/DP/huif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/huif/exREN
add wave -noupdate /system_tb/DUT/CPU/DP/huif/exWEN
add wave -noupdate /system_tb/DUT/CPU/DP/huif/exrdst
add wave -noupdate /system_tb/DUT/CPU/DP/huif/meldst
add wave -noupdate /system_tb/DUT/CPU/DP/huif/merdst
add wave -noupdate /system_tb/DUT/CPU/DP/huif/rs
add wave -noupdate /system_tb/DUT/CPU/DP/huif/rt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3799995 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 261
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
WaveRestoreZoom {3343558 ps} {4656058 ps}
