vdel -all
vlog -source -lint *.sv
vsim  work.top
run -all
