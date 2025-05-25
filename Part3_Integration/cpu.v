`include "alu.v"
`include "reg.v"

module cpu(PC, INSTRUCTION, CLK, RESET);

    // Input Port Declaration
    input [31:0] INSTRUCTION;
    input CLK, RESET;

    // Output Port Declaration
    output reg [31:0] PC;

    // Connections for Register File
    wire [2:0] READREG1, READREG2, WRITEREG;
    wire [7:0] REGOUT1, REGOUT2;
    reg WRITEENABLE;

    // Connections for ALU
    wire [7:0] OPERAND1, OPERAND2, ALURESULT;
    reg [2:0] ALUOP;

    // Connections for negation MUX
    wire [7:0] negatedOp;
    wire [7:0] registerOp;
    reg signSelect;

    // Connections for immediate value MUX
    wire [7:0] IMMEDIATE;
    reg immSelect;

    // PC value stored inside CPU
    reg [31:0] PCreg;

    // Current OPCODE stored in CPU
    reg [7:0] OPCODE;

    // Instantiation of CPU modules
    reg_file my_reg(ALURESULT, REGOUT1, REGOUT2, WRITEREG, READREG1, READREG2, WRITEENABLE, CLK, RESET);

    alu my_alu(REGOUT1, OPERAND2, ALURESULT, ALUOP);

    twosComp my_twosComp(REGOUT2, negatedOp);

    mux negationMUX(REGOUT2, negatedOp, signSelect, registerOp);

    mux immediateMUX(registerOp, IMMEDIATE, immSelect, OPERAND2);

    //PC - Program counter

    always @ ( posedge CLK)
	begin
		if (RESET == 1'b1) 
		begin
			#1
			PC = 0;		//If RESET signal is HIGH, set PC to zero
			PCreg = 0;
		end
		else #1 PC = PCreg;		//Else, write new PC value
	end
	
	
	//PC+4 Adder
	always @ (PC)
	begin
		#1 PCreg = PCreg + 4;
	end

    	//Relevant portions of INSTRUCTION are mapped to the respective units
	
	///////////////////////////////////////////////////////////////////
	/*    OP-CODE    /      RD       /       RT      /     RS/IMM    */
	/*    [31:24]    /    [23:16]    /     [15:8]    /      [7:0]    */
	///////////////////////////////////////////////////////////////////
	/*       |       /        |      /        |      /       |       */
	/*    OPCODE     /    WRITEREG   /    READREG1   /    READREG2   */
	/*               /               /               /   IMMEDIATE   */
	/*****************************************************************/
	assign READREG1 = INSTRUCTION[15:8];
	assign IMMEDIATE = INSTRUCTION[7:0];
	assign READREG2 = INSTRUCTION[7:0];
	assign WRITEREG = INSTRUCTION[23:16];

    	//Decoding the instruction
	always @ (INSTRUCTION)
	begin
	
		OPCODE = INSTRUCTION[31:24];	//Mapping the OP-CODE section of the instruction to OPCODE
		
		#1			//1 Time Unit Delay for Decoding process
		
		case (OPCODE)
		
			//loadi instruction
			8'b00000000:	begin
								ALUOP = 3'b000;			//Set ALU to forward
								immSelect = 1'b1;		//Set MUX to select immediate value
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
		
			//mov instruction
			8'b00000001:	begin
								ALUOP = 3'b000;			//Set ALU to FORWARD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
			
			//add instruction
			8'b00000010:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end	
		
			//sub instruction
			8'b00000011:	begin
								ALUOP = 3'b001;			//Set ALU to ADD
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b1;		//Set sign select MUX to negative sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end

			//and instruction
			8'b00000100:	begin
								ALUOP = 3'b010;			//Set ALU to AND
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end
							
			//or operation
			8'b00000101:	begin
								ALUOP = 3'b011;			//Set ALU to OR
								immSelect = 1'b0;		//Set MUX to select register input
								signSelect = 1'b0;		//Set sign select MUX to positive sign
								WRITEENABLE = 1'b1;		//Enable writing to register
							end

		endcase
		
	end

endmodule



//modules 

module twosComp(IN, OUT);
    input [7:0] IN;
    output [7:0] OUT;

    // Combinational logic to assign two's complement value of input to output
    assign #1 OUT = ~IN + 1;
endmodule

module mux(IN1, IN2, SELECT, OUT);
    input [7:0] IN1, IN2;
    input SELECT;
    output reg [7:0] OUT;

    // MUX should update output value upon change of any of the inputs
    always @ (IN1, IN2, SELECT) begin
        if (SELECT == 1'b1) begin  // If SELECT is HIGH, switch to 2nd input
            OUT = IN2;
        end else begin              // If SELECT is LOW, switch to 1st input
            OUT = IN1;
        end
    end
endmodule