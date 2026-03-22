


module full_adder(
    input a,b,cin,
    output sum,carry);

assign sum = a ^ b ^ cin;
assign carry = (a & b)|(b & cin)|(cin & a);
                
endmodule
module mux(D0, D1, S, Y);

output Y;
input D0, D1, S;

assign Y=(S)?D1:D0;

endmodule
module CSELA(input [7:0] A,input [7:0] B,input Cin,output [7:0] Sum,output Cout);

wire[7:0] innersum1,innersum2;
wire [7:0] innercarry1,innercarry2;
full_adder A0(A[0],B[0],1'b0,innersum1[0],innercarry1[0]);
full_adder B0(A[0],B[0],1'b1,innersum2[0],innercarry2[0]);
mux C1(innersum1[0],innersum2[0],Cin,Sum[0]); 
genvar i;
generate
    for( i=1;i<8;i=i+1)
    begin: gen_adds
    full_adder A1(A[i],B[i],innercarry1[i-1],innersum1[i],innercarry1[i]);
    full_adder B1(A[i],B[i],innercarry2[i-1],innersum2[i],innercarry2[i]);
    mux C1(innersum1[i],innersum2[i],Cin,Sum[i]);
    end

endgenerate
mux Carry(innercarry1[7],innercarry2[7],Cin,Cout);
endmodule
