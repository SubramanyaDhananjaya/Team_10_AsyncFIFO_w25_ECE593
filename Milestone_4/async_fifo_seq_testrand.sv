import uvm_pkg::*;
`include "uvm_macros.svh"
 import fifo_pkg::*;



// Write sequence random class 
class write_sequence_random extends uvm_sequence#(transaction_write);
  `uvm_object_utils(write_sequence_random)

// Define the count for the number of transactions to generate
int tx_count_write=1024;
transaction_write txw;


 // Constructor
function new(string name = "write_sequence_full");
       super.new(name);
       `uvm_info("WRITE_SEQUENCE_CLASS", "Inside constructor",UVM_LOW)
endfunction


// Body task
task body();
        `uvm_info("WRITE_SEQUENCE_CLASS", "Inside body task",UVM_LOW)
// Loop through the number of transactions to generate
  	for (int i = 0; i < tx_count_write; i++) 
	begin
		txw = transaction_write::type_id::create("txw");  // Create a new transaction_write object
		start_item(txw);      // Start the transaction by passing it to the sequencer
    		if (!(txw.randomize()));      // Randomize the transaction
			//`uvm_error("TX_GENERATION_FAILED", "Failed to randomize transaction_write")
		finish_item(txw);       // Finish the transaction and return it to the sequencer
    	end
	
endtask

endclass:write_sequence_random






// Read sequence random class 
class read_sequence_random extends uvm_sequence#(transaction_read);
  
`uvm_object_utils(read_sequence_random)

int tx_count_read=1024;
transaction_read txr;    // Defining the transaction object for reading
    
 // Constructor 
function new(string name = "read_sequence_random");
	super.new(name);
       `uvm_info("READ_SEQUENCE_CLASS", "Inside constructor",UVM_LOW)
endfunction


 // Body task 
task body();

        `uvm_info("READ_SEQUENCE_CLASS", "Inside body task",UVM_LOW)
	// Loop through the number of transactions to generate
	for (int i = 0; i < tx_count_read; i++) 
	begin
		txr = transaction_read::type_id::create("txr");  // Create a new transaction_read object
		start_item(txr);    // Start the transaction by passing it to the sequencer
          	if(!(txr.randomize()));	    // Randomize the transaction
			//`uvm_fatal("TX_GENERATION_FAILED", "Failed to randomize transaction_read")
		finish_item(txr);        // Finish the transaction and return it to the sequencer
	end	
endtask

endclass
