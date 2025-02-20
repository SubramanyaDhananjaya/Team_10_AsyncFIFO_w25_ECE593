import async_fifo_pkg::*;
/*class scoreboard;

	parameter DATA_SIZE = 8;
	parameter ADDR_SIZE = 6;
	parameter DEPTH = 64;
	int no_trans; 
	logic [DATA_SIZE-1 : 0] fifo_mem [DEPTH-1 : 0];
	bit [ADDR_SIZE : 0] wr_count;
	bit [ADDR_SIZE : 0] rd_count;
	mailbox mon2scb;

	function new(mailbox mon2scb);
	this.mon2scb = mon2scb;
	foreach(fifo_mem[i])
	begin
		fifo_mem[i] = '0;
	end
	endfunction 

	virtual task main();
	begin   
	transaction trans_sb;
	mon2scb.get(trans_sb);
		
	if(trans_sb.winc)
	begin
		fifo_mem[wr_count] = trans_sb.wData;
		wr_count = wr_count + 1;
	end

	if(trans_sb.rinc)
	begin
		if(trans_sb.rData == fifo_mem[rd_count])
		begin
		//	$display("MATCH at address %0h - trans_sb.Data = %0h - Saved Data = %0h",rd_count, trans_sb.rData, fifo_mem[rd_count]);
			$display("Data match at address %0h | Transaction Received: %0h | Transaction Expected: %0h", rd_count, trans_sb.rData, fifo_mem[rd_count]);
			rd_count = rd_count + 1;   
		end 
		else 
		begin
			//$display("ERROR at address %0h - trans_sb.Data = %0h - Saved Data = %0h",rd_count, trans_sb.rData, fifo_mem[rd_count]);
			$display("Data mismatch at address %0h | Transaction Received: %0h | Transaction Expected: %0h", rd_count, trans_sb.rData, fifo_mem[rd_count]);
		end
	end

	// Half Full & Half Empty checks
	if(trans_sb.wHalfFull)
	begin
		$display("FIFO IS HALF FULL");
	end
	if(trans_sb.rHalfEmpty)
	begin
		$display("FIFO IS HALF EMPTY");
	end

	// Full & Empty checks
	if(trans_sb.wFull)
	begin
		$display("FIFO IS FULL");
	end
	if(trans_sb.rEmpty)
	begin
		$display("FIFO IS EMPTY");
	end
	no_trans++;

	end
	endtask

endclass  */


class scoreboard;

 parameter DEPTH = 2048;
 int no_trans;
 logic [11:0] fifo_mem [DEPTH-1 : 0];
 bit [11:0] wr_count;
 bit [11:0] rd_count = '0;
 mailbox mon2scb;
  
function new(mailbox mon2scb);
	this.mon2scb = mon2scb;
   	foreach(fifo_mem[i])
	begin
     		fifo_mem[i] = 12'h0;
   	end
endfunction 
 
virtual task main();
begin   
	transaction trans_sb;
    	trans_sb = new();
    	mon2scb.get(trans_sb);
     
        if(trans_sb.winc)
	begin
        	fifo_mem[wr_count] = trans_sb.wData;
        	wr_count = wr_count + 1;
        end
        //$display("%0h,%0h,%0h,%0h,%0h,%0h,%0h,%0h",fifo_mem[0],fifo_mem[1],fifo_mem[2],fifo_mem[3],fifo_mem[4],fifo_mem[5],fifo_mem[6],fifo_mem[7]);

	if(trans_sb.rinc)
	begin
        	if(trans_sb.rData == fifo_mem[rd_count])
		begin
          		$display("\n\n ********Data Matched and PASSED at address %0h - trans_sb.Data = %0h - Saved Data = %0h**********************",rd_count, trans_sb.rData,fifo_mem[]);
                   	rd_count = rd_count + 1;
      		end 
		else 
		begin
         		$display("\n\n ERROR at address %0h - trans_sb.Data = %0h - Saved Data = %0h",rd_count,trans_sb.rData,fifo_mem[rd_count]);
      		end
    	end

      // Full & Empty checks
       if(trans_sb.wFull)
       begin
       		$display("\n\n FIFO is full");
       end
       if(trans_sb.rEmpty)
       begin
      		$display("\nFIFO is empty");
       end
       $display(" \n ***************************No_of_transaction_completed =%0d *******************************************************\n\n ", no_trans);
       no_trans++;

end
endtask


endclass

/*
class scoreboard;

  parameter DEPTH = 2048;
  mailbox mon2scb; // Mailbox for communication
  
  logic [11:0] fifo_mem[DEPTH-1:0]; // FIFO memory array
  bit [11:0] wr_count = '0; // Write count
  bit [11:0] rd_count = '0; // Read count
  int no_trans = 0; // Transaction count
  int err = 0; // Error count
  
  // Constructor
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb;
    foreach (fifo_mem[i]) begin
      fifo_mem[i] = 12'h0;
    end
  endfunction
  
  // Task to run the scoreboard logic
  virtual task main();
    transaction trans_sb; // Declare transaction object
    forever begin
      // Fetch transaction from the mailbox
      if (!mon2scb.try_get(trans_sb)) begin
        $display("[SCO] : NO TRANSACTION AVAILABLE IN MAILBOX");
        #10; // Add a small delay to avoid a tight loop
        continue;
      end

      $display("[SCO] : TRANSACTION RECEIVED");

      // Write transaction
      if (trans_sb.winc) begin
        if (wr_count < DEPTH) begin
          fifo_mem[wr_count] = trans_sb.wData;
          $display("[SCO] : DATA WRITTEN TO FIFO AT ADDR %0d : %0h", wr_count, trans_sb.wData);
          wr_count++;
        end else begin
          $display("[SCO] : FIFO IS FULL");
        end
      end
      
      // Read transaction
      if (trans_sb.rinc) begin
        if (rd_count < wr_count) begin
          if (trans_sb.rData == fifo_mem[rd_count]) begin
            $display("[SCO] : DATA MATCHED AT ADDR %0d : %0h", rd_count, trans_sb.rData);
          end else begin
            $error("[SCO] : DATA MISMATCH AT ADDR %0d - Expected: %0h, Found: %0h", rd_count, fifo_mem[rd_count], trans_sb.rData);
            err++;
          end
          rd_count++;
        end else begin
          $display("[SCO] : FIFO IS EMPTY");
        end
      end

      // Transaction completion
      no_trans++; // Increment the transaction count
      $display("[SCO] : TRANSACTION COMPLETED - COUNT: %0d", no_trans);
    end
  endtask

endclass
*/

