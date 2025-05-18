`include "alu.v"

module aluTestBench;
    reg [7:0] DATA1, DATA2; // 8-bit inputs
    reg [2:0] SELECT_TEST; // 3-bit select input
    wire [7:0] RESULT_TEST; // 8-bit output

    // Instantiate the ALU module
    alu aluTest (
        .DATA1(DATA1),
        .DATA2(DATA2),
        .RESULT(RESULT_TEST),
        .SELECT(SELECT_TEST)
    );

    initial begin
        // Test case 1: Forward operation
        DATA1 = 8'b00001111;
        DATA2 = 8'b11110001;
        #2
        SELECT_TEST = 3'b000; // Forward
        #10; // Wait for 10 time units
        $display("Forward Result: %b", RESULT_TEST);

        // Test case 2: Add operation
        SELECT_TEST = 3'b001; // Add
        #10; // Wait for 10 time units
        $display("Add Result: %b", RESULT_TEST);

        // Test case 3: AND operation
        SELECT_TEST = 3'b010; // AND
        #10; // Wait for 10 time units

        $display("AND Result: %b", RESULT_TEST);
        // Test case 4: OR operation
        SELECT_TEST = 3'b011; // OR
        #10; // Wait for 10 time units
        $display("OR Result: %b", RESULT_TEST);
        // End the simulation
        $finish;
    end
endmodule