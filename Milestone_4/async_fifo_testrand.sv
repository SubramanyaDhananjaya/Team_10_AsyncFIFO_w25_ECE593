import uvm_pkg::*;
import fifo_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo_env.sv"

// Random FIFO testing
class fifo_random_test extends uvm_test;
  
`uvm_component_utils(fifo_random_test)

fifo_env env;
write_sequence_random w_seq;
read_sequence_random r_seq;
virtual intf vif;


// Constructor
function new(string name = "fifo_random_test", uvm_component parent = null);
	super.new(name, parent);
endfunction


// Build Phase 
function void build_phase(uvm_phase phase); 

	super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif))  // Retrieving virtual interface 
            begin
                `uvm_fatal("FIFO/DRV/NOVIF", "No virtual interface specified for this test instance")
            end 
endfunction


// Connect Phase 
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction 


// End of Elaboration 
function void end_of_elaboration();
	super.end_of_elaboration();
        uvm_root::get().print_topology(); // Printing topology 
endfunction


// Run Phase 
task run_phase(uvm_phase phase );

	env.wa.wd.trans_count_write=1024;    // Write sequence transaction count
        env.ra.rd.trans_count_read=1024;     // Read sequence transaction count

        env.wa.wm.trans_count_write=1024;    // Another write sequence transaction count
        env.ra.rm.trans_count_read=1024;     // Another read sequence transaction count

        phase.raise_objection(this, "Starting fifo_write_seq in main phase");   //Raising objection 

        fork
        	begin
                	$display("/t Starting sequence w_seq run_phase");
                	w_seq = write_sequence_random::type_id::create("w_seq", this);  // Creating write sequence 
              		w_seq.start(env.wa.ws);   // Starting the write sequence using the write sequencer
            	end
            	begin
                	$display("/t Starting sequence r_seq run_phase");
                	r_seq = read_sequence_random::type_id::create("r_seq", this);  	// Create read sequence
                	r_seq.start(env.ra.rs);		// Start the read sequence using the read sequencer
            	end
        join
      
        #100ns;
 		
      	env.scb.compare_flags();	// Comparing flags for FIFO full and FIFO empty conditions 

        phase.drop_objection(this , "Finished the fifo_seq in Main_Phase");		// Droping sequence 


        #1000;
        $finish;

endtask

endclass

