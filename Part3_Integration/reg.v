module reg_file (
    IN,OUT1,OUT2,INADDRESS,OUT1ADDRESS,OUT2ADDRESS, WRITE, CLK, RESET
);
    input [7:0] IN;
    input [2:0] INADDRESS, OUT1ADDRESS, OUT2ADDRESS;
    input WRITE, CLK, RESET;
    output [7:0] OUT1, OUT2;

    reg [7:0] registers [7:0]; // 8 registers of 8 bits each
    integer i;

    // Asynchronous read with artificial delay using continuous assignment
    assign #2 OUT1 = registers[OUT1ADDRESS];
    assign #2 OUT2 = registers[OUT2ADDRESS];

    // Synchronous Write and Reset with artificial delay
    always @(posedge CLK) begin
        if (RESET == 1'b1) begin
            #1 for (i = 0; i < 8; i = i + 1) begin
                 registers[i] = 8'b0;     // Clear all registers
            end
        end else if (WRITE == 1'b1) begin
            #1 registers[INADDRESS] = IN;   // Write data with delay
        end
    end

    initial 
    begin
        //$monitor($time, "\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d", REGISTERFILES[0], REGISTERFILES[1],REGISTERFILES[2],REGISTERFILES[3],REGISTERFILES[4],REGISTERFILES[5],REGISTERFILES[6],REGISTERFILES[7]);
		$monitor($time, "\t%d\t%d", OUT1,OUT2);
	end

endmodule
