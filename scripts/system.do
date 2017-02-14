onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/pc/PC
add wave -noupdate /system_tb/DUT/CPU/DP/deif/instr
add wave -noupdate /system_tb/DUT/CPU/DP/de/rf/regs
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/imm
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/imemaddr
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/DP/pcif/nPC
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/DP/pcif/jPC
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/brPC
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/jraddr
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pcen
add wave -noupdate /system_tb/DUT/CPU/DP/pc/nxtPC
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/jaddr
add wave -noupdate /system_tb/DUT/CPU/DP/de/deif/rdat1_next
add wave -noupdate /system_tb/DUT/CPU/DP/de/rfif/rsel1
add wave -noupdate /system_tb/DUT/CPU/DP/de/rfif/rsel2
add wave -noupdate /system_tb/DUT/CPU/DP/de/rfif/rdat1
add wave -noupdate /system_tb/DUT/CPU/DP/de/rfif/rdat2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {948922 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 286
configure wave -valuecolwidth 200
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
WaveRestoreZoom {0 ps} {448487 ps}
