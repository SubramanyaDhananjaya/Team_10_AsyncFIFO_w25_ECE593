onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/DUT/winc
add wave -noupdate /tb_top/DUT/wclk
add wave -noupdate /tb_top/DUT/wrst
add wave -noupdate /tb_top/DUT/rinc
add wave -noupdate /tb_top/DUT/rclk
add wave -noupdate /tb_top/DUT/rrst
add wave -noupdate /tb_top/DUT/wData
add wave -noupdate /tb_top/DUT/rData
add wave -noupdate /tb_top/DUT/wFull
add wave -noupdate /tb_top/DUT/rEmpty
add wave -noupdate /tb_top/DUT/wHalfFull
add wave -noupdate /tb_top/DUT/rHalfEmpty
add wave -noupdate /tb_top/DUT/waddr
add wave -noupdate /tb_top/DUT/raddr
add wave -noupdate /tb_top/DUT/g_wptr
add wave -noupdate /tb_top/DUT/g_rptr
add wave -noupdate /tb_top/DUT/g_wptr_sync
add wave -noupdate /tb_top/DUT/g_rptr_sync
add wave -noupdate /tb_top/DUT/wptr
add wave -noupdate /tb_top/DUT/rptr
add wave -noupdate /tb_top/DUT/wptr_s
add wave -noupdate /tb_top/DUT/rptr_s
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {129 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ns} {1 us}
