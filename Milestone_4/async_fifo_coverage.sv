parameter DATA_SIZE = 8;

covergroup FIFO_coverage;
 

// Coverpoint for write data, covering all possible values based on DATA_SIZE 
  coverpoint intf.wData {
    bins data_bin[] = {[0:(2**DATA_SIZE)-1]};
  }


// Coverpoint for read data, covering all possible values based on DATA_SIZE
  coverpoint intf.rData {
    bins data_bin[] = {[0:(2**DATA_SIZE)-1]};
  }
  

// Coverpoint for write full flag, covering both 0 and 1
  coverpoint intf.wFull {
    bins full_bin[] = {0, 1};
  }


 // Coverpoint for write half-full flag, covering both 0 and 1
  coverpoint intf.wHalfFull {
    bins half_full_bin[] = {0, 1};
  }



  // Coverpoint for read empty flag, covering both 0 and 1
  coverpoint intf.rEmpty {
    bins empty_bin[] = {0, 1};
  }

// Coverpoint for read half-empty flag, covering both 0 and 1
  coverpoint intf.rHalfEmpty {
    bins half_empty_bin[] = {0, 1};
  }

 // Cross coverage for write data and read data values
  cross intf.wData, intf.rData;
	
// Cross coverage for write data and write full flag
  cross intf.wData, intf.wFull;

// Cross coverage for read data and read empty flag
  cross intf.rData, intf.rEmpty;

endgroup
