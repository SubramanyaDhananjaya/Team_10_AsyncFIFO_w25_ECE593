 import uvm_pkg::*;
`include "uvm_macros.svh"
 import fifo_pkg::*;

class write_agent extends uvm_agent;
`uvm_component_utils(write_agent)

write_sequencer ws; //Generates writes transactions 
write_driver wd;    // Drives transactions to the DUT 
write_monitor wm;   // monitoring transactions for scoreboard analysis 

// 
function new (string name = "write_agent", uvm_component parent);
super.new(name, parent);
`uvm_info("WRITE_AGENT_CLASS", "Inside constructor",UVM_LOW);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
	
		ws = write_sequencer::type_id::create("ws", this);
		wd = write_driver::type_id::create("wd", this);
		wm = write_monitor::type_id::create("wm", this);

endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
wd.seq_item_port.connect(ws.seq_item_export);

endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
endtask

endclass