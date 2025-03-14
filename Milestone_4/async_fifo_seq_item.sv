import uvm_pkg::*;
`include "uvm_macros.svh"

// Write transaction class
class transaction_write extends uvm_sequence_item;
`uvm_object_utils(transaction_write)

parameter DATA_SIZE = 8;
rand bit [DATA_SIZE-1:0] wData;
rand bit winc;
bit wFull;

// Constructor 
function new(string name = "transaction_write");
        super.new(name);
endfunction
endclass


// Read transaction class
class transaction_read extends uvm_sequence_item;
`uvm_object_utils(transaction_read)

parameter DATA_SIZE = 8;
rand bit rinc;
logic [DATA_SIZE-1:0] rData;
bit rEmpty;


//Constructor
function new(string name = "transaction_read");
        super.new(name);
endfunction
endclass
