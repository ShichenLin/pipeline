onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/pc/PC
add wave -noupdate /system_tb/DUT/CPU/DP/deif/instr
add wave -noupdate /system_tb/DUT/CPU/DP/de/rf/regs
add wave -noupdate /system_tb/DUT/CPU/DP/instru_me_next
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/hu/R_PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/huif/equal
add wave -noupdate /system_tb/DUT/CPU/DP/huif/PCSel
add wave -noupdate /system_tb/DUT/CPU/DP/huif/PCSrc
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/br
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/br_result
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/PC
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/brPC
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/braddr
add wave -noupdate /system_tb/DUT/CPU/DP/bp/buffer
add wave -noupdate /system_tb/DUT/CPU/DP/bp/state
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/nxtPC
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/select
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/psel
add wave -noupdate /system_tb/DUT/CPU/DP/pcif/pPC
add wave -noupdate /system_tb/DUT/CPU/DP/pc/nxtPC
add wave -noupdate /system_tb/DUT/CPU/DP/huif/nPC
add wave -noupdate /system_tb/DUT/CPU/DP/huif/braddr
add wave -noupdate /system_tb/DUT/CPU/DP/hu/br_taken
add wave -noupdate /system_tb/DUT/CPU/DP/bpif/taken
add wave -noupdate /system_tb/DUT/CPU/DP/huif/exREN
add wave -noupdate /system_tb/DUT/CPU/DP/huif/exWEN
add wave -noupdate /system_tb/DUT/CPU/DP/huif/exrdst
add wave -noupdate /system_tb/DUT/CPU/DP/huif/meldst
add wave -noupdate /system_tb/DUT/CPU/DP/huif/merdst
add wave -noupdate /system_tb/DUT/CPU/DP/huif/rs
add wave -noupdate /system_tb/DUT/CPU/DP/huif/rt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5184475 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 261
configure wave -valuecolwidth 88
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
WaveRestoreZoom {5033628 ps} {5469013 ps}
