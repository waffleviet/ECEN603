`timescale 1ns / 1ps

module tb_lfa8_bit_pipelined();

    // 1. Declare clock and reset
    reg clk;
    reg rst;
    
    // Inputs to the UUT
    reg [7:0] A, B;
    reg Cin;

    // Outputs from the UUT
    wire [7:0] Sum;
    wire Cout;

    // Instantiate the Pipelined Adder
    bka_pipe uut (
        .clk(clk),
        .rst(rst),
        .A(A), 
        .B(B), 
        .Cin(Cin), 
        .Sum(Sum), 
        .Cout(Cout)
    );

    // ==========================================
    // 2. Generate the Clock (100MHz / 10ns period)
    // ==========================================
    initial begin
        clk = 0;
        forever #5 clk = ~clk; 
    end

    // ==========================================
    // 3. The "Shadow Pipeline" for expected results
    // ==========================================
    // We delay the expected answer by 3 clock cycles to match the hardware latency
    reg [8:0] expected_s1, expected_s2, expected_s3;
    reg       valid_s1, valid_s2, valid_s3; // To track when real data reaches the end

    always @(posedge clk) begin
        if (rst) begin
            expected_s1 <= 9'd0; expected_s2 <= 9'd0; expected_s3 <= 9'd0;
            valid_s1 <= 1'b0;    valid_s2 <= 1'b0;    valid_s3 <= 1'b0;
        end else begin
            // Shift the expected answer through the stages
            expected_s1 <= A + B + Cin; 
            expected_s2 <= expected_s1;
            expected_s3 <= expected_s2;

            // Track valid data so we don't check garbage during startup
            valid_s1 <= 1'b1; 
            valid_s2 <= valid_s1;
            valid_s3 <= valid_s2;
        end
    end

    // ==========================================
    // 4. Stimulus Generation (Pushing data in)
    // ==========================================
    integer i, j, k;
    integer errors = 0;

    initial begin
        $display("Starting Pipelined Test...");
        
        // Apply Reset
        rst = 1; A = 0; B = 0; Cin = 0;
        @(posedge clk); // Wait for a clock edge
        @(posedge clk);
        rst = 0;

        // Exhaustive Input Loop
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 256; j = j + 1) begin
                for (k = 0; k < 2; k = k + 1) begin
                    #1
                    A = i;
                    B = j;
                    Cin = k;
                    @(posedge clk); // Advance 1 clock cycle for EVERY new input
                end
            end
        end

        // Wait a few extra cycles for the final numbers to flush out of the pipeline
        repeat(5) @(posedge clk);

        // Final Report
        if (errors == 0)
            $display("TEST PASSED! All combinations correct.");
        else
            $display("TEST FAILED with %d errors.", errors);
            
        $finish;
    end

    // ==========================================
    // 5. Output Checking (Reading data out)
    // ==========================================
    // We check on the negative edge to ensure the outputs have fully settled
    always @(negedge clk) begin
        // Only check if valid data has made it all the way through the 3 stages
        if (valid_s3) begin
            if ({Cout, Sum} !== expected_s3) begin
                $display("ERROR! Expected=%d Got=%d", expected_s3, {Cout, Sum});
                errors = errors + 1;
            end
        end
    end

endmodule