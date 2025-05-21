module regTestbench;

    // Inputs
    reg [7:0] IN;
    reg [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
    reg WRITE, CLK, RESET;

    // Outputs
    wire [7:0] OUT1, OUT2;

    // Instantiate the reg_file
    reg_file uut (
        .IN(IN),
        .INADDRESS(INADDRESS),
        .OUT1ADDRESS(OUT1ADDRESS),
        .OUT2ADDRESS(OUT2ADDRESS),
        .WRITE(WRITE),
        .CLK(CLK),
        .RESET(RESET),
        .OUT1(OUT1),
        .OUT2(OUT2)
    );

    // Clock Generation: 10ns period (100 MHz)
    initial CLK = 0;
    always #5 CLK = ~CLK;

    // Simulation
    initial begin
        $dumpfile("reg_file_tb.vcd"); // For GTKWave
        $dumpvars(0, regTestbench);

        // Initial values
        IN = 8'b0;
        INADDRESS = 3'b000;
        OUT1ADDRESS = 3'b000;
        OUT2ADDRESS = 3'b001;
        WRITE = 0;
        RESET = 0;

        // Wait a bit before starting
        #2;

        // --- Reset all registers ---
        RESET = 1;
        #10; // Wait for rising edge
        RESET = 0;
        #10;

        // --- Write 55h to register 3 ---
        IN = 8'h55;
        INADDRESS = 3'b011;
        WRITE = 1;
        #10; // Rising edge of CLK
        WRITE = 0;
        #10;

        // --- Write AAh to register 5 ---
        IN = 8'hAA;
        INADDRESS = 3'b101;
        WRITE = 1;
        #10;
        WRITE = 0;
        #10;

        // --- Read from registers 3 and 5 ---
        OUT1ADDRESS = 3'b011;
        OUT2ADDRESS = 3'b101;
        #5; // allow #2 delay for OUT1 and OUT2
        $display("OUT1 (Reg 3): %h | OUT2 (Reg 5): %h", OUT1, OUT2);

        // --- Change read addresses ---
        OUT1ADDRESS = 3'b000; // Should be 0 (after reset)
        OUT2ADDRESS = 3'b100; // Also 0
        #5;
        $display("OUT1 (Reg 0): %h | OUT2 (Reg 4): %h", OUT1, OUT2);

        // --- Reset again and check all are 0 ---
        RESET = 1;
        #10;
        RESET = 0;
        #10;
        OUT1ADDRESS = 3'b011; // Previously written
        OUT2ADDRESS = 3'b101; // Previously written
        #5;
        $display("After reset - OUT1: %h | OUT2: %h", OUT1, OUT2);

        // End simulation
        #20;
        $finish;
    end

endmodule
