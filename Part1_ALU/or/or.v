module orModule (
    DATA1, // 8-bit input
    DATA2, // 8-bit input
    orResult // 8-bit output
);
    input [7:0] DATA1, DATA2; // 8-bit inputs
    output reg [7:0] orResult; // 8-bit output

    always @(DATA1, DATA2) begin // trigger on changes to DATA1 or DATA2
        #1 orResult = DATA1 | DATA2; // perform bitwise OR operation
    end
endmodule
