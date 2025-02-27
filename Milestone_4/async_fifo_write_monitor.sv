import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

class write_monitor extends uvm_monitor;
`uvm_component_utils(write_monitor) 
 
virtual intf vif;
transaction_write txw;

uvm_analysis_port#(transaction_write) port_write;     // Declare an analysis port for transaction_write object

int trans_count_write;    // Declare a counter for the number of write transactions
int w_count;      // Declare a counter for the write actions


// Constructor 
function new (string name = "write_monitor", uvm_component parent);
super.new(name, parent);
`uvm_info("WRITE_MONITOR_CLASS", "Inside constructor",UVM_LOW)
endfunction


 // Build phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
port_write = new("port_write", this);    // Create the analysis port 'port_write'
 
 // Check if the virtual interface is available in the configuration database
     if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
       `uvm_error("build_phase", "No virtual interface specified for this write_monitor instance")
     end
endfunction


// Connect phase
function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
endfunction 
 

// Run phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);

    	 fork
        	begin : write_monitor          // Monitor writes task
            		forever @(negedge vif.wclk)
			 begin
                	mon_write();    // Call the mon_write function to monitor the write transaction
            		end 
        	end

        	begin : write_completion    // Monitor write completion task
                wait (w_count == trans_count_write);     // Wait until all transactions are counted
        	end
    	join

endtask
        

// Monitor write task
task mon_write;
     
 	 transaction_write txw;   // Declare a transaction_write object

   	if (vif.winc==1) begin
 	txw=transaction_write::type_id::create("txw");  // Create a new transaction_write object
 	txw.winc = vif.winc;    // Set the write enable signal
  	txw.wData = vif.wData;    // Set the write data value
	$display ("\t Monitor winc = %0h \t wData = %0h \t w_count=%0d", txw.winc, txw.wData, w_count+1);
   	port_write.write(txw);    // Write the transaction to the analysis port
	w_count=w_count +1;        // Increment the write count	 
	end
endtask


endclass
