module fifo2 (rdata, wfull, rempty, wdata, winc, wclk, wrst_n, rinc, rclk, rrst_n);
    parameter DSIZE = 8;
    parameter ASIZE = 6;

    output [DSIZE-1:0] rdata;
    output wfull;
    output rempty;
    input [DSIZE-1:0] wdata;
    input winc, wclk, wrst_n;
    input rinc, rclk, rrst_n;
    wire [ASIZE-1:0] wptr, rptr;  
    wire [ASIZE-1:0] waddr, raddr; 

    async_cmp #(ASIZE) async_cmp(.aempty_n(aempty_n), .afull_n(afull_n), .wptr(wptr), .rptr(rptr), .wrst_n(wrst_n));
    fifomem #(DSIZE, ASIZE) fifomem(.rdata(rdata), .wdata(wdata), .waddr(wptr), .raddr(rptr), .wclken(winc), .wclk(wclk));
    rptr_empty #(ASIZE) rptr_empty(.rempty(rempty), .rptr(rptr), .aempty_n(aempty_n), .rinc(rinc),.rclk(rclk), .rrst_n(rrst_n));
    wptr_full #(ASIZE) wptr_full (.wfull(wfull), .wptr(wptr), .afull_n(afull_n), .winc(winc), .wclk(wclk), .wrst_n(wrst_n));

endmodule

module fifomem (rdata, wdata, waddr, raddr, wclken, wclk);
    parameter DATASIZE = 8; // data width
    parameter ADDRSIZE = 6; // memory address bits
    parameter DEPTH = 1<<ADDRSIZE; // DEPTH = 2**ADDRSIZE

    output [DATASIZE-1:0] rdata;
    input [DATASIZE-1:0] wdata;
    input [ADDRSIZE-1:0] waddr, raddr;
    input wclken, wclk;
/////////// memory array//////////////
    reg [DATASIZE-1:0] MEM [0:DEPTH-1];
  assign rdata = MEM[raddr]; ////////reading from FIFO
    always @(posedge wclk)
      if (wclken) MEM[waddr] <= wdata; ///writing to the FIFO

endmodule

module async_cmp (aempty_n, afull_n, wptr, rptr, wrst_n);
    parameter ADDRSIZE = 6;
    parameter N = ADDRSIZE-1;

    output aempty_n, afull_n;
    input [N:0] wptr, rptr;
    input wrst_n;
    reg direction;
    wire high = 1'b1;
  ///////////////// Direction setting logic/////////////////////
    wire dirset_n = ~( (wptr[N]^rptr[N-1]) & ~(wptr[N-1]^rptr[N]));
    wire dirclr_n = ~((~(wptr[N]^rptr[N-1]) & (wptr[N-1]^rptr[N])) | ~wrst_n);
    always @(posedge high or negedge dirset_n or negedge dirclr_n)
        if (!dirclr_n) direction <= 1'b0;
        else if (!dirset_n) direction <= 1'b1;
        else direction <= high;
  
   /////////// FIFO full and empty conditions//////////
    assign aempty_n = ~((wptr == rptr) && !direction);
    assign afull_n = ~((wptr == rptr) && direction);

endmodule
///////////// Read Pointer Management
module rptr_empty (rempty, rptr, aempty_n, rinc, rclk, rrst_n);
    parameter ADDRSIZE = 6;

    output rempty;
    output [ADDRSIZE-1:0] rptr;
    input aempty_n;
    input rinc, rclk, rrst_n;
    reg [ADDRSIZE-1:0] rptr, rbin;
    reg rempty, rempty2;
    wire [ADDRSIZE-1:0] rgnext, rbnext;
///////// Update read pointer in binary and Gray code
    always @(posedge rclk or negedge rrst_n)
        if (!rrst_n) begin
        rbin <= 0;
        rptr <= 0;
        end
        else begin
        rbin <= rbnext;
        rptr <= rgnext;
        end
  ////// Increment binary counter if FIFO is not empty
    assign rbnext = !rempty ? rbin + rinc : rbin;
  assign rgnext = (rbnext>>1) ^ rbnext; //// binary-to-gray conversion
    always @(posedge rclk or negedge aempty_n)
        if (!aempty_n) {rempty,rempty2} <= 2'b11;
        else {rempty,rempty2} <= {rempty2,~aempty_n};

endmodule
//////////// Write Pointer Management
module wptr_full (wfull, wptr, afull_n, winc, wclk, wrst_n);
    parameter ADDRSIZE = 6;
    
    output wfull;
    output [ADDRSIZE-1:0] wptr;
    input afull_n;
    input winc, wclk, wrst_n;
    reg [ADDRSIZE-1:0] wptr, wbin;
    reg wfull, wfull2;
    wire [ADDRSIZE-1:0] wgnext, wbnext;
// Update write pointer in binary and Gray code
    always @(posedge wclk or negedge wrst_n)
        if (!wrst_n) begin
        wbin <= 0;
        wptr <= 0;
        end
        else begin
        wbin <= wbnext;
        wptr <= wgnext;
        end
// Increment binary counter if FIFO is not full
    assign wbnext = !wfull ? wbin + winc : wbin;
    assign wgnext = (wbnext>>1) ^ wbnext; // binary-to-gray conversion
  // Update full flag
    always @(posedge wclk or negedge wrst_n or negedge afull_n)
        if (!wrst_n ) {wfull,wfull2} <= 2'b00;
        else if (!afull_n) {wfull,wfull2} <= 2'b11;
        else {wfull,wfull2} <= {wfull2,~afull_n};

endmodule