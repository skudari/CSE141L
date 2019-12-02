// Create Date:    2017.01.25
// Design Name:
// Module Name:    DataRAM
// single address pointer for both read and write
// CSE141L
module data_mem(
  input              CLK,
  input              reset,
  input [7:0]        DataAddress,
  input              ReadMem,
  input              WriteMem,
  input [7:0]        DataInA, //from registers
  input [7:0]       DataInB,
  output logic[7:0]  DataOutA, 
  output logic[7:0] DataOutB
);

  logic [7:0] core[256];
  logic [7:0] writeDataAddress; 
   
//    $readmemh("dataram_init.list", my_memory);
  always_comb                     // reads are combinational
    if(ReadMem) begin
      DataOutB = core[DataAddress]; 
      DataOutA = corew[DataAddress + 8'b00000001];
// optional diagnostic print
	    $display("Memory read M[%d] = %d ",DataAddress,DataOutB);
	    $display("Memory read M[%d] = %d ",DataAddress + 8'b00000001,DataOutA);
    end else begin 
      DataOutA = 'bZ;           // tristate, undriven
      DataOutB = 'bZ;
    end
  always_ff @ (posedge CLK)		 // writes are sequential
    if(reset) begin
// you may initialize your memory w/ constants, if you wish
      for(int i=0;i<256;i++)
	    core[i] <= 0;
      core[ 16] <= 254;   // overrides the 0
      core[244] <= 5;
	end
    else if(WriteMem) begin
	    assign writeDataAddress = DataAddress + 8'b00011110;
	    core[writeDataAddress] <= DataIn;
// optional diagnostic print statement
	  $display("Memory write M[%d] = %d",DataAddress,DataIn);
    end

    assign newDataAddress = DataAddress + 8'b00000010; 
endmodule
