onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/uut/rdata
add wave -noupdate /top/uut/wfull
add wave -noupdate /top/uut/rempty
add wave -noupdate /top/uut/wdata
add wave -noupdate /top/uut/winc
add wave -noupdate /top/uut/wclk
add wave -noupdate /top/uut/wrst_n
add wave -noupdate /top/uut/rinc
add wave -noupdate /top/uut/rclk
add wave -noupdate /top/uut/rrst_n
add wave -noupdate /top/uut/wptr
add wave -noupdate /top/uut/rptr
add wave -noupdate /top/uut/waddr
add wave -noupdate /top/uut/raddr
add wave -noupdate /top/uut/aempty_n
add wave -noupdate /top/uut/afull_n
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 72
configure wave -valuecolwidth 40
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
WaveRestoreZoom {0 ns} {4421 ns}
