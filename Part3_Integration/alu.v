`include "add/add.v"
`include "and/and.v"
`include "or/or.v"
`include "forward/forward.v"

module alu(DATA1, DATA2, RESULT, SELECT);
    input [7:0] DATA1, DATA2; // 8-bit inputs
    input [2:0] SELECT; // 3-bit select input
    output reg [7:0] RESULT; // 8-bit output

    wire [7:0] addResult, andResult, orResult, forwardResult;

    // Instantiate the modules
    addModule addModuleAlu (
        .DATA1(DATA1),
        .DATA2(DATA2),
        .addResult(addResult)
    );
    andModule andModuleAlu (
        .DATA1(DATA1),
        .DATA2(DATA2),
        .andResult(andResult)
    );
    orModule orModuleAlu (
        .DATA1(DATA1),
        .DATA2(DATA2),
        .orResult(orResult)
    );
    forwardModule forwardModuleAlu (
        .DATA1(DATA1),
        .DATA2(DATA2),
        .forwardResult(forwardResult)
    );

    always @(DATA1, DATA2, SELECT) begin // trigger on changes to DATA1, DATA2 or SELECT
        case (SELECT)
            3'b000: RESULT = forwardResult; // Forward
            3'b001: RESULT = addResult; // Add
            3'b010: RESULT = andResult; // AND
            3'b011: RESULT = orResult; // OR
        endcase
    end
endmodule