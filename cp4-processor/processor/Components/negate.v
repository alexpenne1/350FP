module negate(in, out);

	input [31:0] in;
	output [31:0] out; 
	
	wire [31:0] flipped;
	assign flipped = ~in;
	
	alu adder(.data_operandA(flipped), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0), .data_result(out));
	
endmodule