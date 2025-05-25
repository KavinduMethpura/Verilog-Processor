module addModule ( DATA1, DATA2, addResult);
    input [7:0] DATA1,DATA2; // 8-bit inputs
    output reg [7:0] addResult; // 8-bit output

    always @(DATA1,DATA2) begin // trigger on changes to DATA1 or DATA2
        #2 addResult = DATA1 + DATA2;
    end

endmodule