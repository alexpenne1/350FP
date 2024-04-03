module my_alu_tb;

	wire signed [31:0] data_operandA, data_operandB;
    wire [4:0] ctrl_ALUopcode, ctrl_shiftamt;
	
    wire signed [31:0] data_result;
    wire isNotEqual, isLessThan, overflow;
	
	wire [5:0] enable_wires;
	
	alu tb_alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
	
	integer i, j, k, l;
	assign {data_operandA} = i[31:0];
	assign {data_operandB} = j[31:0];
	assign {ctrl_ALUopcode} = k[4:0];
	assign {ctrl_shiftamt} = l[4:0];
	
	initial begin
		i = 34;
		j = 32'b10000;
		k = 1;
		l = 5;
		#160;
		$display("A:%d, B:%d, Opcode:%b, Out:%b, isNotEqual:%b, isLessThan:%b, Overflow:%b", data_operandA, data_operandB, ctrl_ALUopcode, data_result, isNotEqual, isLessThan,  overflow);
	end
	
	
endmodule
		