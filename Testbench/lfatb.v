`timescale 1ns / 1ps

module tb_ksa4_bit();

    // Inputs to the UUT (Unit Under Test)
    reg [7:0] A, B;
    reg Cin;

    // Outputs from the UUT
    wire [7:0] Sum;
    wire Cout;

    // Expected result for self-checking
    reg [8:0] expected;
    integer i, j, k;
    integer errors = 0;

    // Instantiate the Kogge-Stone Adder
    lfa8_bit uut (
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout)
    );

    initial begin
        $display("Starting Exhaustive Test for 4-bit KSA...");
        $display("---------------------------------------");

        // Loop through all possible combinations of A, B, and Cin
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin
                    
                    // Assign inputs
                    A = i;
                    B = j;
                    Cin = k;

                    // Calculate what the answer SHOULD be
                    expected = A + B + Cin;

                    // Wait for combinational logic to settle
                    #10;

                    // Check the result {Cout, Sum} joins the bits into a 5-bit number
                    if ({Cout, Sum} !== expected) begin
                        $display("ERROR: A=%d B=%d Cin=%b | Expected=%d Got=%d", 
                                  A, B, Cin, expected, {Cout, Sum});
                        errors = errors + 1;
                    end
                end
            end
        end

        // Final Report
        if (errors == 0) begin
            $display("---------------------------------------");
            $display("TEST PASSED! All 131072 combinations correct.");
            $display("---------------------------------------");
        end else begin
            $display("---------------------------------------");
            $display("TEST FAILED with %d errors.", errors);
            $display("---------------------------------------");
        end
        
        $finish;
    end

endmodule