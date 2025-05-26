module cpu_tb;

    reg CLK, RESET;
    wire [31:0] PC;
    wire [31:0] INSTRUCTION;

    //Initialize an array of registers (8x1024) named 'instr_mem' to be used as instruction memory
	reg [7:0] instr_mem [1023:0];
    
    //Create combinational logic to support CPU instruction fetching, given the Program Counter(PC) value 
    //       (make sure you include the delay for instruction fetching here)
	assign #2 INSTRUCTION = {instr_mem[PC+3], instr_mem[PC+2], instr_mem[PC+1], instr_mem[PC]};
    
    initial
    begin
        // Initialize instruction memory with the set of instructions you need execute on CPU
        
        // METHOD 1: manually loading instructions to instr_mem
        // loadi R4, 5
        {instr_mem[3], instr_mem[2], instr_mem[1], instr_mem[0]} = 32'b00000000_00000100_00000000_00000101;

        // loadi R2, 5
        {instr_mem[7], instr_mem[6], instr_mem[5], instr_mem[4]} = 32'b00000000_00000010_00000000_00000101;

        // add R6, R4, R2
        {instr_mem[11], instr_mem[10], instr_mem[9], instr_mem[8]} = 32'b00000010_00000110_00000100_00000010;

        // mov R1, R4
        {instr_mem[15], instr_mem[14], instr_mem[13], instr_mem[12]} = 32'b00000001_00000001_00000100_00000000;

        // sub R3, R6, R2
        {instr_mem[19], instr_mem[18], instr_mem[17], instr_mem[16]} = 32'b00000011_00000011_00000110_00000010;

        // and R7, R4, R2
        {instr_mem[23], instr_mem[22], instr_mem[21], instr_mem[20]} = 32'b00000100_00000111_00000100_00000010;

        // or R5, R4, R2
        {instr_mem[27], instr_mem[26], instr_mem[25], instr_mem[24]} = 32'b00000101_00000101_00000100_00000010;
        
        // METHOD 2: loading instr_mem content from instr_mem.mem file
        // $readmemb("instr_mem.mem", instr_mem);
    end
    
    cpu mycpu(PC, INSTRUCTION, CLK, RESET);

    initial
    begin
    
        // generate files needed to plot the waveform using GTKWave
        $dumpfile("cpu_wavedata.vcd");
		$dumpvars(0, cpu_tb);
        
        CLK = 1'b0;
        RESET = 1'b0;
        
        //Reset the CPU (by giving a pulse to RESET signal) to start the program execution
		RESET = 1'b1;
		#5
		RESET = 1'b0;
        
        // finish simulation after some time
        #500
        $finish;
        
    end
    
    // clock signal generation
    always
        #4 CLK = ~CLK;
        

endmodule