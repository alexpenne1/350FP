module or_32_tb;

	wire [31:0] data_operandA, data_operandB;
	wire or_enable;
	wire [31:0] or_output;
	
	or_32 tb_or_32(data_operandA, data_operandB, or_enable, or_output);
	
	integer a;
	integer b;
	integer or_enable_int;
	
	assign {data_operandA} = a[31:0];
	assign {data_operandB} = b[31:0];
	assign {or_enable} = or_enable_int[0:0];
	
	initial begin
		b = 1000;
		for (a = 0; a < 10000; a = a + 1000) begin
				
				or_enable_int = 0;
				#80;
				$display("OR:");
				$display("A: %b, B: %b, Enable: %b, Output: %b", data_operandA, data_operandB, or_enable, or_output);
				
				or_enable_int = 1;
				#80;
				$display("A: %b, B: %b, Enable: %b, Output: %b", data_operandA, data_operandB, or_enable, or_output);
		end
		$finish;
	end
	
endmodule