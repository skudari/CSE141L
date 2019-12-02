// Create Date:    2017.01.25
// Design Name:    CSE141L
// Module Name:    reg_file 
//
// Additional Comments: 					  $clog2

module reg_file #(parameter W=8, D=3)(		 // W = data path width; D = pointer width
  input           CLK,
                  write_en,
                  start,
  input  [ D-1:0] raddrA,
                  raddrB,
                  waddrA,
  input  [ W-1:0] memAddress,
  input  [ W-1:0] data_inA,
  input  [ W-1:0] data_inB,
  
  output [ W-1:0] data_outA,
  output logic [W-1:0] data_outB
  );
  
// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] registers[2**D];	  // or just registers[16] if we know D=4 always

// combinational reads w/ blanking of address 0
always_comb data_outA = registers[raddrA];   
always_comb data_outB = registers[raddrB];               // can read from addr 0, just like ARM

// sequential (clocked) writes 
always_ff @ (posedge CLK)
begin
  // if (write_en) if want to be able to write to address 0, as well
  if (write_en && waddr)	// && waddr requires nonzero pointer address
  begin 
    registers[waddr] <= data_inA;
    registers[waddr + 3'b001] <= data_inB;
  end
end

endmodule
