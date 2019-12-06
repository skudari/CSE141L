module count_ones(
    input [7:0] A,
    output ones     //0 if even 1 if odd
    );

integer i;

always@(A)
begin
    ones = 0;  //initialize count variable.
    for(i=0;i<8;i=i+1)   //check for all the bits.
        if(A[i] == 1'b1)    //check if the bit is '1'
            ones = ones + 1;    //if its one, increment the count.
end

always@(A)
begin
if(ones % 2 == 0 ) 
  ones = 1'b0; 
else 
  ones = 1'b1;
end

endmodule
