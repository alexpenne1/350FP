module op_decode_tb;

	wire [4:0] ctrl_ALUopcode;
	wire [5:0] enable_wires;
	
	op_decode tb_op_decode(ctrl_ALUopcode, enable_wires);
	integer i;
	assign {ctrl_ALUopcode} = i[4:0];
	
	initial begin
		for (i=0; i<32; i++) begin
			#20;
			$display("Opcode: %b", ctrl_ALUopcode);
			$display("Add: %d, Sub: %d, And: %d, Or: %d, SLL: %d, SRA: %d", enable_wires[0], enable_wires[1], enable_wires[2], enable_wires[3], enable_wires[4], enable_wires[5]);
		end
		$finish;
	end
endmodule
	