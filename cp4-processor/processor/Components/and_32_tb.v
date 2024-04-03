module and_32_tb;

	wire [31:0] data_operandA, data_operandB;
	wire and_enable;
	wire [31:0] and_output;
	
	and_32 tb_and_32(data_operandA, data_operandB, and_enable, and_output);
	
	integer a;
	integer b;
	integer and_enable_int;
	
	assign {data_operandA} = a[31:0];
	assign {data_operandB} = b[31:0];
	assign {and_enable} = and_enable_int[0:0];
	
	initial begin
		b = 1000;
		for (a = 0; a < 10000; a = a + 1000) begin
				
				and_enable_int = 0;
				#80;
				$display("AND:");
				$display("A: %b, B: %b, Enable: %b, Output: %b", data_operandA, data_operandB, and_enable, and_output);
				
				and_enable_int = 1;
				#80;
				$display("A: %b, B: %b, Enable: %b, Output: %b", data_operandA, data_operandB, and_enable, and_output);
		end
		$finish;
	end
	
endmodule
				