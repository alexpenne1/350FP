module op_decode(ctrl_ALUopcode, enable_wires);

	input [4:0] ctrl_ALUopcode;
	output [5:0] enable_wires;
	
	wire [4:0] ctrl_ALUopcode_NOT;
	// replace nots with multiple not
	not ctrl_not_g1(ctrl_ALUopcode_NOT[0], ctrl_ALUopcode[0]);
	not ctrl_not_g2(ctrl_ALUopcode_NOT[1], ctrl_ALUopcode[1]);
	not ctrl_not_g3(ctrl_ALUopcode_NOT[2], ctrl_ALUopcode[2]);
	not ctrl_not_g4(ctrl_ALUopcode_NOT[3], ctrl_ALUopcode[3]);
	not ctrl_not_g5(ctrl_ALUopcode_NOT[4], ctrl_ALUopcode[4]);
	
	// add, sub
	and op_add(enable_wires[0], ctrl_ALUopcode_NOT[0], ctrl_ALUopcode_NOT[1], ctrl_ALUopcode_NOT[2], ctrl_ALUopcode_NOT[3], ctrl_ALUopcode_NOT[4]);
	and op_sub(enable_wires[1], ctrl_ALUopcode[0], ctrl_ALUopcode_NOT[1], ctrl_ALUopcode_NOT[2], ctrl_ALUopcode_NOT[3], ctrl_ALUopcode_NOT[4]);
	and op_and(enable_wires[2], ctrl_ALUopcode_NOT[0], ctrl_ALUopcode[1], ctrl_ALUopcode_NOT[2], ctrl_ALUopcode_NOT[3], ctrl_ALUopcode_NOT[4]);
	and op_or(enable_wires[3], ctrl_ALUopcode[0], ctrl_ALUopcode[1], ctrl_ALUopcode_NOT[2], ctrl_ALUopcode_NOT[3], ctrl_ALUopcode_NOT[4]);
	and op_sll(enable_wires[4], ctrl_ALUopcode_NOT[0], ctrl_ALUopcode_NOT[1], ctrl_ALUopcode[2], ctrl_ALUopcode_NOT[3], ctrl_ALUopcode_NOT[4]);
	and op_sra(enable_wires[5], ctrl_ALUopcode[0], ctrl_ALUopcode_NOT[1], ctrl_ALUopcode[2], ctrl_ALUopcode_NOT[3], ctrl_ALUopcode_NOT[4]);
	
endmodule