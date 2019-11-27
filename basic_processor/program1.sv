import definitions::*;	 

module program1(

  input [7:0] regA, [7:0] regB,
  output [4:0] parityBits
);

logic [7:0] andOutput1, andOutput2, andOutput3;
logic [7:0] xorOutput1, xorOutput2; 

logic evenBit1, evenBit2, evenBit3, evenBit4, evenBit5, evenBit6, evenBit7, evenBit8; 

logic b11, b10, b9, b8, b7, b6, b5, b4, b3, b2, b1; 
logic p8, p4, p2, p1, p16; 

assign [7:0] zerob4tob1 = {b'11110000}; //0 out b4 to b1

// CALCULATE p8

//zero out lower 4 bits of mem[0]
ALU ANDB4TOB1  (
	  .INPUTA  (regB),
	  .INPUTB  (zerob4tob1), 
	  .OP      (kAND),
	  .OUT     (andOutput1), //regWriteValue),
	  .SC_IN   , 1'b0),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN(evenBit1)
	  );

num_ones_for finOnesForP8(
    .A(regA),
    .ones(evenBit2)     //0 if even 1 if odd
    );
 
 assign p8 = evenBit1 ^ evenBit2;
 
 
//CALCULATE p4

assign [7:0] zerob7tob5b1 = {b'10001110}; //0 out b7 to b5 and b1

ALU ANDNOTB5  (
	  .INPUTA  (regB),
	  .INPUTB  (zerob7tob5b1), 
	  .OP      (kAND),
	  .OUT     (andOutput2), //regWriteValue),
	  .SC_IN   , 1'b0),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN(evenBit3)
	  );
  
 assign p4 = evenBit2 ^ eveBit3;
 
 //CALCULAE P2
 assign [7:0] zerob9 = {8'b11111110}; //0 out b9
 assign [7:0] zerob8b5 = {8'b01101101} //0 out b8,b5,b2
 
 //operation on mem[1] to zero b9 
 ALU ANDB9 (
	  .INPUTA  (regA),
	  .INPUTB  (zerob9), 
	  .OP      (kAND),
	  .OUT     (andOutput3), //regWriteValue),
	  .SC_IN   , 1'b0),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN(evenBit4)
	  );
    
  //operation to 
  ALU ANDB8TOB5 (
	  .INPUTA  (regB),
	  .INPUTB  (zerob8b5), 
	  .OP      (kAND),
	  .OUT     (andOutput4), //regWriteValue),
	  .SC_IN   , 1'b0),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN(evenBit5)
	  );
   
  assign p2 = evenBit4 ^ evenBit5;
  
  //CALCULATE P1 
  
  assign [7:0] zerob10 = {8'b11111101}; //0 out b10
  assign [7:0] zerob8b5b3 = {8'b01011011} //0 out B8, B6  B3
 
  //operation on mem[1] to zero b9 
  ALU ANDB9 (
	  .INPUTA  (regA),
	  .INPUTB  (zerob10), 
	  .OP      (kAND),
	  .OUT     (andOutput5), //regWriteValue),
	  .SC_IN   , 1'b0),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN(evenBit6)
	  );
    
  //operation to 
  ALU ANDB8TOB5 (
	  .INPUTA  (regB),
	  .INPUTB  (zerob8b5b3), 
	  .OP      (kAND),
	  .OUT     (andOutput6), //regWriteValue),
	  .SC_IN   , 1'b0),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN(evenBit7)
	  );
    
    assign p1 = evenBit6 ^ evenBit7; 
    
    
   //CALCULATE P16 
   ALU xorb11tob1 (
	  .INPUTA  (regA),
	  .INPUTB  (regB), 
	  .OP      (kXOR),
	  .OUT     (andOutput7), //regWriteValue),
	  .SC_IN   , 1'b0),
	  .SC_OUT  ,
	  .ZERO ,
	  .BEVEN(evenBit8)
	  );
    
    assign p16 = evenBit8 ^ p8 ^ p4 ^ p2 ^ p1; 
    
    assign output[1] = p1; 
    assign output[2] = p2; 
    assign output[3] = p4; 
    assign output[4] = p8; 
    assign output[5] = p16; 
