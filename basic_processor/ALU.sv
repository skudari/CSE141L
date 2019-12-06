// Create Date:    2016.10.15
// Module Name:    ALU 
// Project Name:   CSE141L
//
// Revision 2018.01.27
// Additional Comments: 
//   combinational (unclocked) ALU
import definitions::*;			  // includes package "definitions"
//`include "count_ones.sv"

module co(
    input [7:0] A,
    output ones     //0 if even 1 if odd
    );

integer i, o;

always@(A)
begin
    o = 0;  //initialize count variable.
    for(i=0;i<8;i=i+1)   //check for all the bits.
        if(A[i] == 1'b1)    //check if the bit is '1'
            o = o + 1;    //if its one, increment the count.
end

always@(A)
begin
if(o % 2 == 0 ) 
  ones = 1'b0; 
else 
  ones = 1'b1;
end

endmodule

module ALU(
  input [ 7:0] INPUTA,      	  // data inputs
               INPUTB,
  input [ 2:0] OP,				  // ALU opcode, part of microcode
  output logic [7:0] OUT,		  // or:  output reg [7:0] OUT,
  input        SC_IN,             // shift in/carry in 
  output logic SC_OUT,			  // shift out/carry out
  output logic ZERO,              // zero out flag
  output logic BEVEN              // tells you if you have an even number of ones -- 0 for even, 1 for odd
    );
	 
  op_mne op_mnemonic;			  // type enum: used for convenient waveform viewing
  	
  always_comb begin
    {SC_OUT, OUT} = 0;            // default -- clear carry out and result out
// single instruction for both LSW & MSW
  case(OP)
    kAND : begin                                           // bitwise AND
     	OUT    = INPUTA & INPUTB;
	SC_OUT = 0;
    end
	 
    kLSH : {SC_OUT, OUT} = {INPUTA, SC_IN};  	            // shift left 
    kRSH : {OUT, SC_OUT} = {SC_IN, INPUTA};			        // shift right
    
    kXOR : begin
	OUT    = INPUTA^INPUTB;					// exclusive OR
	SC_OUT = 0;					   		       // clear carry out -- possible convenience
    end
    
    default: {SC_OUT,OUT} = 0;						       // no-op, zero out
  endcase

  co c (
	.A(OUT), 
	.ones(BEVEN)
	);
	end
endmodule


