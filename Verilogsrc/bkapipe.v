module bka_pipe (input clk,input rst,
    input  [7:0] A, B,
    input        Cin,
    output reg [7:0] Sum,
    output    reg   Cout
);
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

wire [7:0] P1, G1, P2, G2, P3, G3,P4,G4,P5,G5,C_comb;
   
    assign G1[1] = G0_r1[1] | (P0_r1[1] & G0_r1[0]);
    assign P1[1] = P0_r1[1] & P0_r1[0];

    assign G1[3] = G0_r1[3] | (P0_r1[3] & G0_r1[2]);
    assign P1[3] = P0_r1[3] & P0_r1[2];

    assign G1[5] = G0_r1[5] | (P0_r1[5] & G0_r1[4]);
    assign P1[5] = P0_r1[5] & P0_r1[4];

    assign G1[7] = G0_r1[7] | (P0_r1[7] & G0_r1[6]);
    assign P1[7] = P0_r1[7] & P0_r1[6];

    // the two edge   cases for this one here.
    
  

    assign G2[3] = G1[3] | (P1[3] & G1[1]); 
    assign P2[3] = P1[3] & P1[1];

   
    assign G2[7] = G1[7] | (P1[7] & G1[5]); 
    assign P2[7] = P1[7] & P1[5];

    // --- STAGE 3: Octets (Distance 4) ---
    // HIGHLIGHT 3 (HIGH FAN-OUT): Look at the right side of the OR gate!
    // Every single bit in the top half (4, 5, 6, 7) reuses the EXACT SAME 
    // wire (G2[3]) from the bottom half. In KSA, these were all different!
    
    assign G3[7] = G2[7] | (P2[7] & G2[3]); // Group 7:0 is complete!
    assign P3[7] = P2[7] & P2[3];

    

    assign G4[5]=G1[5] | (P1[5] & G2[3]); 
    assign P4[5]=P1[5] & P2[3];

    assign G5[2]=G0_r1[2]|(P0_r1[2]&G1[1]);
    assign P5[2]=P0_r1[2]&P1[1];
    assign G5[4]=G0_r1[4]|(P0_r1[4]&G2[3]);
    assign P5[4]=P0_r1[4]&P2[3];
    assign G5[6]=G0_r1[6]|(P0_r1[6]&G4[5]);
    assign P5[6]=P0_r1[6]&P4[5];
    //depth 4 BKA adder.
    assign C_comb[0] = G0_r1[0] | (P0_r1[0] & Cin_r1);
    assign C_comb[1] = G1[1] | (P1[1] & Cin_r1); 
    assign C_comb[2] = G5[2] | (P5[2] & Cin_r1);
    assign C_comb[3] = G2[3] | (P2[3] & Cin_r1);
    assign C_comb[4] = G5[4] | (P5[4] & Cin_r1);
    assign C_comb[5] = G4[5] | (P4[5] & Cin_r1); 
    assign C_comb[6] = G5[6] | (P5[6] & Cin_r1);
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