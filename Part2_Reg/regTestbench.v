module reg_file_tb;

    reg [7:0] IN;
    wire [7:0] OUT1, OUT2;
    reg [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
    reg WRITE, CLK, RESET;

    // Instantiate the register file
    reg_file uut (
        .IN(IN),
        .OUT1(OUT1),
        .OUT2(OUT2),
        .INADDRESS(INADDRESS),
        .OUT1ADDRESS(OUT1ADDRESS),
        .OUT2ADDRESS(OUT2ADDRESS),
        .WRITE(WRITE),
        .CLK(CLK),
        .RESET(RESET)
    );

    // Clock generation: 10ns period
    initial CLK = 0;
    always #5 CLK = ~CLK;

    initial begin
        // Initialize inputs
        IN = 8'b0;
        INADDRESS = 3'b0;
        OUT1ADDRESS = 3'b0;
        OUT2ADDRESS = 3'b0;
        WRITE = 0;
        RESET = 0;

        // Dump waves for GTKWave
        $dumpfile("reg_file_tb.vcd");
        $dumpvars(0, reg_file_tb);

        // Reset the register file
        @(negedge CLK);
        RESET = 1;
        @(posedge CLK);
        RESET = 0;

        // Wait a few cycles for reset to complete
        repeat (3) @(posedge CLK);

        // Write some values
        IN = 8'hAA; INADDRESS = 3'd1; WRITE = 1;
        @(posedge CLK);
        WRITE = 0;
        @(posedge CLK);

        IN = 8'h55; INADDRESS = 3'd3; WRITE = 1;
        @(posedge CLK);
        WRITE = 0;
        @(posedge CLK);

        IN = 8'hFF; INADDRESS = 3'd5; WRITE = 1;
        @(posedge CLK);
        WRITE = 0;
        @(posedge CLK);

        // Read back values asynchronously by setting OUT addresses
        OUT1ADDRESS = 3'd1;
        OUT2ADDRESS = 3'd3;
        #10;  // Wait to observe delayed asynchronous read

        $display("OUT1 (reg 1) = %h, OUT2 (reg 3) = %h", OUT1, OUT2);


        OUT1ADDRESS = 3'd5;
        OUT2ADDRESS = 3'd0;
        #10;

        $display("OUT1 (reg 5) = %h, OUT2 (reg 0) = %h", OUT1, OUT2);

        // Test reset again
        @(negedge CLK);
        RESET = 1;
        @(posedge CLK);
        RESET = 0;
        #10;

        $display("After reset: OUT1 (reg 1) = %h, OUT2 (reg 3) = %h", OUT1, OUT2);

        $finish;
    end

endmodule
