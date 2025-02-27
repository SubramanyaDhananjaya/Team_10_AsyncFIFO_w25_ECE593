import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

// Write Driver Class
class write_driver extends uvm_driver#(transaction_write);
	`uvm_component_utils(write_driver)

	virtual intf intf_vi;
	transaction_write txw;
	int trans_count_write;

//Constructor 
function new (string name = "write_driver", uvm_component parent);
	super.new(name, parent);
	`uvm_info("WRITE_DRIVER_CLASS", "Inside constructor",UVM_LOW)
endfunction


// Build phase
function void build_phase (uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("WRITE_DRIVER_CLASS", "Build Phase",UVM_LOW)
		if(!(uvm_config_db #(virtual intf)::get (this, "*", "vif", intf_vi))) 
			`uvm_error("WRITE_DRIVER_CLASS", "FAILED to get intf_vi from config DB")
endfunction


 // Connect phase
function void connect_phase (uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("WRITE_DRIVER_CLASS", "Connect Phase",UVM_LOW)
endfunction


// Task to drive a write transaction to the DUT
task drive_write(transaction_write txw);
	@(posedge intf_vi.wclk);
  	this.intf_vi.winc = txw.winc;
        this.intf_vi.wData = txw.wData;	
endtask


// Run phase
task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("DRIVER_CLASS", "Inside Run Phase",UVM_LOW)

	// Initialize signals
	this.intf_vi.wData <=0;
	this.intf_vi.winc <=0;

	repeat(10) @(posedge intf_vi.wclk);
  		
// Loop through the number of write transactions
  for (integer i = 0; i < trans_count_write ; i++) begin
	txw=transaction_write::type_id::create("txw");
	seq_item_port.get_next_item(txw);
           wait(intf_vi.wFull ==0);
            drive_write(txw);
               seq_item_port.item_done();
	end
		
// Ensure the write enable signal is cleared after all transactions
	@(posedge intf_vi.wclk);
	   this.intf_vi.winc =0;   	
endtask


endclass






// Read driver class 
class read_driver extends uvm_driver#(transaction_read);
`uvm_component_utils(read_driver)

	virtual intf intf_vi;	 // Virtual interface for driving read transactions
	transaction_read txr;	 // Transaction variable to hold the read transaction
	int trans_count_read;	// Counter for the number of read transactions


// Constructor
function new (string name = "read_driver", uvm_component parent);
	super.new(name, parent);
	`uvm_info("READ_DRIVER_CLASS", "Inside constructor",UVM_LOW)
endfunction


  // Build phase
function void build_phase (uvm_phase phase);
	super.build_phase(phase);
	`uvm_info("READ_DRIVER_CLASS", "Build Phase",UVM_LOW)
		if(!(uvm_config_db #(virtual intf)::get (this, "*", "vif", intf_vi)))     //Geting the virtual interface from the UVM config database
		`uvm_error("READ_DRIVER_CLASS", "FAILED to get intf_vi from config DB")
endfunction


// Connect phase
function void connect_phase (uvm_phase phase);
	super.connect_phase(phase);
	`uvm_info("READ_DRIVER_CLASS", "Connect Phase",UVM_LOW)
endfunction


 // Task to drive a read transaction to the DUT
task drive_read(transaction_read txr);
 	 @(posedge intf_vi.rclk);
  	this.intf_vi.rinc = txr.rinc;     // Set read enable signal from transaction
endtask


 // Run phase
task run_phase (uvm_phase phase);
	super.run_phase(phase);
	`uvm_info("DRIVER_CLASS", "Inside Run Phase",UVM_LOW)
 	// Initialize signals
	this.intf_vi.rinc <=0;

         repeat(10) @(posedge intf_vi.rclk);
	  // Loop through the number of read transactions		
       	for (integer j = 0; j < trans_count_read; j++) begin
	txr=transaction_read::type_id::create("txr");   // Create a new read transaction
						
	seq_item_port.get_next_item(txr);     // Get the next item from the sequencer
			
        wait(intf_vi.rEmpty==0);     // Wait for FIFO to not be empty

      	drive_read(txr);      // Drive the read transaction to the DUT
            
   	seq_item_port.item_done();     // Mark the transaction as done
			
    	end
			
	 // Ensure the read enable signal is cleared after all transactions
	@(posedge intf_vi.rclk);
	this.intf_vi.rinc =0;
    	
endtask


endclass
