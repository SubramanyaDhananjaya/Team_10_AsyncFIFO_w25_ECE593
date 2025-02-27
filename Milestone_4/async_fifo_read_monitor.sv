import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

// Read monitor class 
class read_monitor extends uvm_monitor;
`uvm_component_utils(read_monitor) 
 
virtual intf vif;
transaction_read txr;
bit write_complete_flag;

uvm_analysis_port#(transaction_read) port_read;   // Declare an analysis port for transaction_read object

int trans_count_read;    // Declare a counter for the number of read transactions
int r_count;            // Declare a counter for the read actions

// Constructor
function new (string name = "read_monitor", uvm_component parent);
	super.new(name, parent);
	`uvm_info("READ_MONITOR_CLASS", "Inside constructor",UVM_LOW)
endfunction

 // Build phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
port_read = new("port_read", this);    // Create the analysis port 'port_read'

 // Check if the virtual interface is available in the configuration database
     if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin     
       `uvm_error("build_phase", "No virtual interface specified for this read_monitor instance")
     end
endfunction


// Connect phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction 
 

// Run phase 
task run_phase(uvm_phase phase);
	super.run_phase(phase);
		 // Fork to run two concurrent tasks
			fork 
				begin : read_monitor    // Monitor reads task
	       				forever @(negedge vif.rclk)begin
        					mon_read();    // Call the mon_read function to monitor the read transaction
    					end
				end
				begin

                  wait (r_count == trans_count_read);    // Wait until all read transactions are counted
                  
				end
			join_any
        
		
endtask
 
       

 // Monitor read task
task mon_read;
     
// Declare a transaction_read object 
  transaction_read txr;

if (vif.rinc==1)begin
txr=transaction_read::type_id::create("txr");    // Create a new transaction_read object
		fork
			begin
				@(negedge vif.rclk);
				txr.rData = vif.rData;    // Capture the read data from the virtual interface
            			$display ("\t Monitor rinc = 1 \t rData = %0h \t \t rcount=%0d",  txr.rData, r_count+1);
				port_read.write(txr);    // Write the transaction to the analysis port
				r_count= r_count +1;     // Increment the read count
			end
		join_none	
  	end
endtask



endclass
