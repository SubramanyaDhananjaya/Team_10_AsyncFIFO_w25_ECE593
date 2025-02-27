import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

`uvm_analysis_imp_decl(_port_a) // For write transaction 
`uvm_analysis_imp_decl(_port_b)	// for read transactions 

int empty_count;

class fifo_scoreboard extends uvm_scoreboard;

`uvm_component_utils(fifo_scoreboard)
 uvm_analysis_imp_port_a#(transaction_write,fifo_scoreboard) write_port;  // receives write transactions 
 uvm_analysis_imp_port_b#(transaction_read,fifo_scoreboard) read_port;    // receives read transactions 

transaction_write tw[$];   // stores write transaction in queue before they are read. 
transaction_read tr[$];    // queue for storing read transactions 
  
  // COnstructor 
function new(string name,uvm_component parent);
	super.new(name,parent);
endfunction  
               
// build phase 
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	write_port= new("write_port",this);
	read_port= new("read_port",this);  
endfunction


//connect phase 
function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction 
 
 // Receives a transaction_write object from the write agent's monitor
function void write_port_a(transaction_write txw); 
	tw.push_back(txw);    // pushing the trasaction into tw queue 
	$display ("\t Scoreboard wData = %0h", txw.wData);
endfunction


// Comparing the expected data with actual data coming from FIFO 
function void write_port_b(transaction_read txr);
parameter DATA_SIZE = 8;
logic [DATA_SIZE-1:0] popped_wData; // store the expected data that was previouly written 
empty_count = tw.size;    // stores the current size of tw queue
   
	if (tw.size() > 0) 
	begin
    		popped_wData = tw.pop_front().wData; // removes and return the oldest data transaction from the write queue and extracts the written data from the transaction, and now popped_wData contains the expected data. 
				
    		if (txr.rData === txr.rData) // comparing read data with expected data, txr.rData has actual data, popped_wData has expected data
      			`uvm_info("ASYNC_FIFO_SCOREBOARD", $sformatf("PASSED Expected Data: %0h --- DUT Read Data: %0h", txr.rData, txr.rData), UVM_MEDIUM)
    		else
      			`uvm_error("ASYNC_FIFO_SCOREBOARD", $sformatf("ERROR Expected Data: %0h Does not match DUT Read Data: %0h", txr.rData, popped_wData))
  	end     
endfunction

//Full and empty flags
task compare_flags(); 

	if (tw.size > 4096)   // Fifo is full 
	begin
        	`uvm_info("SCOREBOARD", "FIFO IS FULL", UVM_MEDIUM);
  	end 
    	if (empty_count == 1)   // FIFO is empty 
	begin
    		`uvm_info("SCOREBOARD", "FIFO IS EMPTY", UVM_MEDIUM);
    	end
  
endtask
    
// Run phase 
task run_phase(uvm_phase phase);
	super.run_phase(phase);
  
endtask
  
endclass
