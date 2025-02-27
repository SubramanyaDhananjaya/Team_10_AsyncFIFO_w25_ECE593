import uvm_pkg::*;
import fifo_pkg::*;
`include "uvm_macros.svh"
`include "async_fifo_env.sv"

class fifo_base_test extends uvm_test;
    `uvm_component_utils(fifo_base_test) //Factory Registration

    fifo_env env;  // Environment that includes agents, monitors, and scoreboard
    write_sequence w_seq; // Sequence to generate write transactions
    read_sequence r_seq; // Sequence to generate read transactions
    virtual intf vif;

    function new(string name = "fifo_base_test", uvm_component parent = null);  //Constructor
        super.new(name, parent); 
    endfunction

//Build Phase
    function void build_phase(uvm_phase phase); 
        super.build_phase(phase);
        env = fifo_env::type_id::create("env", this);
        if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
            `uvm_fatal("FIFO/DRV/NOVIF", "No virtual interface specified for this test instance")
        end 
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    endfunction 

//Print the UVM testbench hierarchy
    function void end_of_elaboration();
        super.end_of_elaboration();
        uvm_root::get().print_topology();
    endfunction

// Executes the main test procedure
    task run_phase(uvm_phase phase);
        env.wa.wd.trans_count_write=1024;  // Write driver transaction count
        env.ra.rd.trans_count_read=1024;   // Read driver transaction count

        env.wa.wm.trans_count_write=1024;  // Write monitor transaction count
        env.ra.rm.trans_count_read=1024;   // Read monitor transaction count

        phase.raise_objection(this, "Starting fifo_write_seq in main phase");  //Raise objection to prevent premature test completion

// Start write and read sequences in parallel using fork-join
        fork
            begin
                $display("/t Starting sequence w_seq run_phase");
                w_seq = write_sequence::type_id::create("w_seq", this);  // Create write sequence               
                w_seq.start(env.wa.ws);  // Start write sequence on the write sequencer
            end
            begin
                $display("/t Starting sequence r_seq run_phase");  
                r_seq = read_sequence::type_id::create("r_seq", this); // Create read sequence 
                r_seq.start(env.ra.rs); // Start read sequence on the read sequencer
            end
        join // Wait for both sequences to complete
      
        #100ns;
 		
      	env.scb.compare_flags(); // Invoke the scoreboard for result comparison
        phase.drop_objection(this , "Finished fifo_seq in main phase"); // Drop objection after sequences have completed execution


        #2000;
        $finish;
    endtask

endclass
