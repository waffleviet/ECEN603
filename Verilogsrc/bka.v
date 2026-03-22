module bka8_bit (
    input  [7:0] A, B,
    input        Cin,
    output [7:0] Sum,
    output       Cout
);

    wire [7:0] P0, G0;
    wire [7:0] P1, G1;
    wire [7:0] P2, G2;
    wire [7:0] P3, G3;
    wire [7:0] P4,G4;
    wire [7:0] P5,G5;
    wire [7:0] C;

    // --- PRE-PROCESSING (Same as KSA) ---
    assign P0 = A ^ B;
    assign G0 = A & B;

   
    assign G1[1] = G0[1] | (P0[1] & G0[0]);
    assign P1[1] = P0[1] & P0[0];

    assign G1[3] = G0[3] | (P0[3] & G0[2]);
    assign P1[3] = P0[3] & P0[2];

    assign G1[5] = G0[5] | (P0[5] & G0[4]);
    assign P1[5] = P0[5] & P0[4];

    assign G1[7] = G0[7] | (P0[7] & G0[6]);
    assign P1[7] = P0[7] & P0[6];

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

    assign G5[2]=G0[2]|(P0[2]&G1[1]);
    assign P5[2]=P0[2]&P1[1];
    assign G5[4]=G0[4]|(P0[4]&G2[3]);
    assign P5[4]=P0[4]&P2[3];
    assign G5[6]=G0[6]|(P0[6]&G4[5]);
    assign P5[6]=P0[6]&P4[5];
    //depth 4 BKA adder.
    assign C[0] = G0[0] | (P0[0] & Cin);
    assign C[1] = G1[1] | (P1[1] & Cin); 
    assign C[2] = G5[2] | (P5[2] & Cin);
    assign C[3] = G2[3] | (P2[3] & Cin);
    assign C[4] = G5[4] | (P5[4] & Cin);
    assign C[5] = G4[5] | (P4[5] & Cin); 
    assign C[6] = G5[6] | (P5[6] & Cin);
    assign C[7] = G3[7] | (P3[7] & Cin);

   
    assign Sum[0] = P0[0] ^ Cin;
    assign Sum[1] = P0[1] ^ C[0];
    assign Sum[2] = P0[2] ^ C[1];
    assign Sum[3] = P0[3] ^ C[2];
    assign Sum[4] = P0[4] ^ C[3];
    assign Sum[5] = P0[5] ^ C[4];
    assign Sum[6] = P0[6] ^ C[5];
    assign Sum[7] = P0[7] ^ C[6];
    
    assign Cout = C[7];

endmodule