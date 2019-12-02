// Create Date:    2018.04.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module TopLevel(		   // you will have the same 3 ports
    input     start,	   // init/reset, active high
    input     CLK,		   // clock -- posedge used inside design
    output    halt		   // done flag from DUT
    );

wire [ 9:0] PC;            // program count
wire [ 8:0] Instruction;   // our 9-bit opcode
wire [ 7:0] ReadA, ReadB;  // reg_file outputs
wire [ 7:0] InA, InB, 	   // ALU operand inputs
            ALU_out;       // ALU result
wire [ 7:0] regWriteValue, // data in to reg file
            memWriteValue, // data in to data_memory
	    Mem_Out;	   // data out from data_memory
wire        MEM_READ,	   // data_memory read enable
	    MEM_WRITE,	   // data_memory write enable
	    reg_wr_en,	   // reg_file write enable
	    sc_clr,        // carry reg clear
	    sc_en,	       // carry reg enable
	    SC_OUT,	       // to carry register
	    ZERO,		   // ALU output = 0 flag
	    BEVEN,		   // ALU input B is even flag
            jump_en,	   // to program counter: jump enable
            branch_en;	   // to program counter: branch enable
logic[15:0] cycle_ct;	   // standalone; NOT PC!
logic       SC_IN;         // carry register (loop with ALU)
	
	
	
	const logic [2:0]load  = 3'b100;
	const logic [2:0]store  = 3'b101;	
	
	
	logic [7:0] regA; 
	logic [7:0] regB; 
	wire [7:0] MSW; 
	wire [7:0] LSW; 

	program1 callProg1(
		.regA(data_outA),
		.regB(data_outB), 
		.MSW(MSW), 
		.LSW(LSW)
	);
	//if instruction is store: pass in MSW and LSW into regFile 	
	//if instruction is load: pass in DataOutA and DataOutB into regFile
	
	//load from data mem into register
	reg_file load(		
		.CLK(CLK),
		.write_en(1'b1),
		.raddrA({1'b0, 3'b100}),
		.raddrB({1'b0, 3'b101}),
		.waddr({1'b0, 3'b100}),
		.data_inA(DataOutA),
		.data_inB(DataOutB),
		.data_outA(regA),
		.data_outB(regB)
		);

	data_mem data_mem1(
		.CLK(CLK),
		.reset (start), 
		.DataAddressIn  (newDataAddress)    , //HOW TO DERTERMINE ADDRESS INCREMENT?
		.ReadMem      (1'b1),          //(MEM_READ) ,   always enabled 
		.WriteMem     (MEM_WRITE), 
		.DataInA       (), 
		.DataInB       (),
		.DataOutA      (DataOutA), //A is mem[1] 
		.DataOutB      (DataOutB), 	//B is mem[0] 
	);	
	
	
// count number of instructions executed
always_ff @(posedge CLK)
  if (start == 1)	   // if(start)
  	cycle_ct <= 0;
  else if(halt == 0)   // if(!halt)
  	cycle_ct <= cycle_ct+16'b1;

always_ff @(posedge CLK)    // carry/shift in/out register
  if(sc_clr)				// tie sc_clr low if this function not needed
    SC_IN <= 0;             // clear/reset the carry (optional)
  else if(sc_en)			// tie sc_en high if carry always updates on every clock cycle (no holdovers)
    SC_IN <= SC_OUT;        // update the carry  

endmodule
