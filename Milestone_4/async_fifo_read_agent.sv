 import uvm_pkg::*;
`include "uvm_macros.svh"
 import fifo_pkg::*;
 
class read_agent extends uvm_agent;
`uvm_component_utils(read_agent)

// Decalring the components of agents 
	read_sequencer rs;
	read_driver rd;
	read_monitor rm;

// Constructor 
function new (string name = "read_agent", uvm_component parent);
	super.new(name, parent);
	`uvm_info("READ_AGENT_CLASS", "Inside constructor",UVM_LOW);
endfunction

//Build phase 
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
		rs = read_sequencer::type_id::create("rs", this); // Create a read sequencer
		rd = read_driver::type_id::create("rd", this);	   // Create a read driver
		rm = read_monitor::type_id::create("rm", this);    // Create a read monitor
endfunction


//Connect phase 
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	rd.seq_item_port.connect(rs.seq_item_export);    // Connect the sequencer to the driver's sequence item port
endfunction


// Run phase 
task run_phase(uvm_phase phase);
	super.run_phase(phase);
endtask


endclass
