//8bit cla adder
module CLA1bit(Cin, A, B, S, P, G);
input Cin, A, B;
output S, P, G;
xor(S, Cin, P);
xor(P, A, B);
and(G, A, B);
endmodule
module CLA( C, A, B, S, P, G);
input [3:0]C;
input [3:0]A;
input [3:0]B;
output [3:0]S;
output [3:0]P;
output [3:0]G;
CLA1bit c1(C[0], A[0], B[0], S[0], P[0], G[0]);
CLA1bit c2(C[1], A[1], B[1], S[1], P[1], G[1]);
CLA1bit c3(C[2], A[2], B[2], S[2], P[2], G[2]);
CLA1bit c4(C[3], A[3], B[3], S[3], P[3], G[3]);
endmodule
module carryGenerationUnit(C, P, G, Cin);
input [3:0]P;
input [3:0]G;
input Cin;
output [3:0]C;
assign C[0] = P[0]&Cin|G[0];
assign C[1] = P[1]&P[0]&Cin|P[1]&G[0]|G[1];
assign C[2] = P[2]&P[1]&P[0]&Cin|P[2]&P[1]&G[0]|P[2]&G[1]|G[2];
assign C[3] =
P[3]&P[2]&P[1]&P[0]&Cin|P[3]&P[2]&P[1]&G[0]|P[3]&P[2]&G[1]|P[3]&G[2]|G[3];
endmodule
module adder8bit(Cout, S, A, B, Cin);
input [7:0] A;
input [7:0] B;
input Cin;
wire [7:0] P;
wire [7:0] G;
output [7:0] S;
output Cout;
wire C[7:1];
CLA cla1 ({C[3], C[2], C[1], Cin}, A[3:0], B[3:0], S[3:0], P[3:0],
G[3:0]);
carryGenerationUnit cgu1 ({C[4], C[3], C[2], C[1]}, P[3:0], G[3:0], Cin);
CLA cla2 ({C[7], C[6], C[5], C[4]}, A[7:4], B[7:4], S[7:4], P[7:4],
G[7:4]);
carryGenerationUnit cgu2({Cout, C[7], C[6],C[5]}, P[7:4], G[7:4], C[4]);
endmodule







module CSA1bit
( input a,b,c,
output sum,carry
);
assign sum = a ^ b ^ c;
assign carry = (a & b) | (c & b) | (a & c);
endmodule


module CSA8bit(
output [7:0] sum,
output [7:0] carry,
input [7:0] x,
input [7:0] y,
input [7:0] z
);
// created with 8 1-bit CSA blocks
CSA1bit csa0 (x[0], y[0], z[0], sum[0], carry[0]);
CSA1bit csa1 (x[1], y[1], z[1], sum[1], carry[1]);
CSA1bit csa2 (x[2], y[2], z[2], sum[2], carry[2]);
CSA1bit csa3 (x[3], y[3], z[3], sum[3], carry[3]);
CSA1bit csa4 (x[4], y[4], z[4], sum[4], carry[4]);
CSA1bit csa5 (x[5], y[5], z[5], sum[5], carry[5]);
CSA1bit csa6 (x[6], y[6], z[6], sum[6], carry[6]);
CSA1bit csa7 (x[7], y[7], z[7], sum[7], carry[7]);
endmodule

module carrySaveAdder(
output [7:0] sum,
output carry,
input [7:0] x, y, z
);
wire [7:0] s, c;
// 8-bit carry-save adder
CSA8bit csa8(s, c, x, y, z);
// 8-bit carry-lookaheadadder
adder8bit cla(carry, sum, s, {c[6:0], 1'b0}, 1'b0);
endmodule
