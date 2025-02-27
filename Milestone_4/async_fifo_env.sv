 import uvm_pkg::*;
`include "uvm_macros.svh"
import fifo_pkg::*;

class fifo_env extends uvm_env;
`uvm_component_utils(fifo_env)

virtual intf vif;

write_agent wa;
read_agent ra;
fifo_scoreboard scb;

//constructor 
function new(string name, uvm_component parent);
      super.new(name, parent);
endfunction

//build phase 
function void build_phase(uvm_phase phase);
super.build_phase(phase);
     wa = write_agent::type_id::create("wa", this); // create write agent 
     ra = read_agent::type_id::create("ra", this);  // create read agent 
     scb = fifo_scoreboard::type_id::create("scb", this); // create scoreboard 
  
     if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin 	
       `uvm_fatal("build phase", "No virtual interface specified for this env instance")
     end

endfunction
  
  //connect phase 
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
   
     wa.wm.port_write.connect(scb.write_port); //port_write is TLM port name , we are connecting it with write_port in scb
     ra.rm.port_read.connect(scb.read_port);
    
endfunction


// run phase 
task run_phase (uvm_phase phase);
super.run_phase(phase);
endtask
endclass


