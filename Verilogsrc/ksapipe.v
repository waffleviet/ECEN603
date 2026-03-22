module ksa_pipe(input clk, input rst,input [7:0] A , input [7:0]B, input Cin,output reg [7:0] Sum, output reg Cout);
reg [7:0] P0_r1,G0_r1;
reg Cin_r1;

always @(posedge clk)
begin
    if(rst)begin
        P0_r1  <= 8'd0;
        G0_r1  <= 8'd0;
        Cin_r1 <= 1'b0;


    end
 else begin
    P0_r1  <= A ^ B;
    G0_r1  <= A & B;
    Cin_r1 <= Cin;





end


end

wire [7:0] P1, G1, P2, G2, P3, G3, C_comb;

assign G1[0] = G0_r1[0];
assign P1[0] = P0_r1[0];
assign G1[1] = G0_r1[1] | (P0_r1[1] & G0_r1[0]);
assign P1[1] = P0_r1[1]&P0_r1[0];
assign G1[2] = G0_r1[2] | (P0_r1[2] & G0_r1[1]);
assign P1[2] = P0_r1[2]&P0_r1[1];
assign G1[3] = G0_r1[3] | (P0_r1[3] & G0_r1[2]);
assign P1[3] = P0_r1[3]&P0_r1[2];
assign G1[4] = G0_r1[4] | (P0_r1[4] & G0_r1[3]);
assign P1[4] = P0_r1[4]&P0_r1[3];
assign G1[5] = G0_r1[5] | (P0_r1[5] & G0_r1[4]);
assign P1[5] = P0_r1[5]&P0_r1[4];
assign G1[6] = G0_r1[6] | (P0_r1[6] & G0_r1[5]);
assign P1[6] = P0_r1[6]&P0_r1[5];
assign G1[7] = G0_r1[7] | (P0_r1[7] & G0_r1[6]);
assign P1[7] = P0_r1[7]&P0_r1[6];




assign G2[0] = G1[0]; 
assign G2[1] = G1[1]; 
assign G2[2] = G1[2] | (P1[2] & G1[0]);
assign G2[3] = G1[3] | (P1[3] & G1[1]);
assign G2[4] = G1[4] | (P1[4] & G1[2]);
assign G2[5] = G1[5] | (P1[5] & G1[3]);
assign G2[6] = G1[6] | (P1[6] & G1[4]);
assign G2[7] = G1[7] | (P1[7] & G1[5]);
assign P2[0] = P1[0];
assign P2[1] = P1[1];
assign P2[2] = P1[2] & P1[0];
assign P2[3] = P1[3] & P1[1];
assign P2[4] = P1[4] & P1[2];
assign P2[5] = P1[5] & P1[3];
assign P2[6] = P1[6] & P1[4];
assign P2[7] = P1[7] & P1[5];


assign G3[0] = G2[0]; 
assign G3[1] = G2[1]; 
assign G3[2] = G2[2]; 
assign G3[3] = G2[3]; 
assign G3[4] = G2[4] | (P2[4] & G2[0]);
assign G3[5] = G2[5] | (P2[5] & G2[1]);
assign G3[6] = G2[6] | (P2[6] & G2[2]);
assign G3[7] = G2[7] | (P2[7] & G2[3]);
assign P3[0] = P2[0];
assign P3[1] = P2[1];
assign P3[2] = P2[2]; 
assign P3[3] = P2[3];
assign P3[4] = P2[4] & P2[0];
assign P3[5] = P2[5] & P2[1];
assign P3[6] = P2[6] & P2[2];
assign P3[7] = P2[7] & P2[3];




assign C_comb[0] = G3[0] | (P3[0] & Cin_r1);
assign C_comb[1] = G3[1] | (P3[1] & Cin_r1); 
assign C_comb[2] = G3[2] | (P3[2] & Cin_r1);
assign C_comb[3] = G3[3] | (P3[3] & Cin_r1);
assign C_comb[4] = G3[4] | (P3[4] & Cin_r1);
assign C_comb[5] = G3[5] | (P3[5] & Cin_r1); 
assign C_comb[6] = G3[6] | (P3[6] & Cin_r1);
assign C_comb[7] = G3[7] | (P3[7] & Cin_r1);



reg [7:0] C_r2;
reg [7:0] P0_r2;
reg       Cin_r2;

    always @(posedge clk) begin
        if (rst) begin
            C_r2  <= 8'd0;
            P0_r2 <= 8'd0;
            Cin_r2<=1'b0;
        end else begin
            C_r2  <= C_comb;
            P0_r2 <= P0_r1; 
            Cin_r2<=Cin_r1;
        end
    end
always @(posedge clk) begin
if(rst)begin
    Sum<=8'd0;
    Cout<=1'b0;
end else
begin
 Sum[0] <= P0_r2[0] ^ Cin_r2;
 Sum[1] <= P0_r2[1] ^ C_r2[0];
 Sum[2] <= P0_r2[2] ^ C_r2[1];
 Sum[3] <= P0_r2[3] ^ C_r2[2];
 Sum[4] <= P0_r2[4] ^ C_r2[3];
 Sum[5] <= P0_r2[5] ^ C_r2[4];
 Sum[6] <= P0_r2[6] ^ C_r2[5];
 Sum[7] <= P0_r2[7] ^ C_r2[6];
 Cout<=C_r2[7];
end
end 






endmodule