interface intf(input logic wclk,rclk,wrst,rrst);   // Define the interface with input signals for clocks and resets

parameter DATA_SIZE = 8;    // Define the parameter for data size (8 bits)
//Inputs
logic [DATA_SIZE-1:0] wData;    // Write data bus of size DATA_SIZE
logic winc;    // Write enable signal
logic rinc;    // Read enable signal

//outputs
logic [DATA_SIZE-1:0] rData;    // Read data bus of size DATA_SIZE
logic rEmpty;     // Read empty flag
logic wFull;       // Write full flag

logic rHalfEmpty;     // Read half-empty flag
logic wHalfFull;       // Write half-full flag

// Clocking for driver domain
clocking driver_cb @(posedge wclk);     // Trigger on the positive edge of the write clock
        output wData;                   // Output write data
      	output winc, rinc;              // Output write enable and read enable signals
        input wFull, rEmpty;            // Input write full and read empty flags
        input wHalfFull, rHalfEmpty;    // Input write half-full and read half-empty flags
endclocking

// Clocking for read domain
clocking monitor_cb @(posedge rclk);         // Trigger on the positive edge of the read clock
      	input winc, rinc;                    // Input write enable and read enable signals
        input rData;                         // Input read data
        input wFull, rEmpty;                 // Input write full and read empty flags
        input wHalfFull, rHalfEmpty;         // Input write half-full and read half-empty flags
endclocking
      
//modport DRIVER (clocking driver_cb, input wclk, rclk, rrst,wrst);
modport DRIVER(clocking driver_cb, input wclk,wrst);         // Modport for the driver with write clock and reset
modport MONITOR(clocking monitor_cb, input rclk,rrst);        // Modport for the monitor with read clock and reset
     
endinterface: intf
