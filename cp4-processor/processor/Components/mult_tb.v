module mult_tb;

	wire [31:0] data_operandA, data_operandB;
    wire clock;

    wire [31:0] data_result;
    wire data_exception, data_resultRDY;
	
	integer i, j, k;
	assign data_operandA = i;
	assign data_operandB = j;
	assign clock = k[0:0];
	
	mult multtb(data_operandA, data_operandB, clock, data_result, data_exception, data_resultRDY);
	
	initial begin
		i = 2147483647;
		j = 2147483647;
		k = 0;
		#600;
		$finish;
	end
	
	
	always
		#5 k = ~k;
	always
		#10 $display("A:%d, B:%d, Out:%d, Ready:%d", $signed(data_operandA), $signed(data_operandB), $signed(data_result), data_resultRDY);
		
	
	
	
	initial begin
		$dumpfile("Wave_mult.vcd");
		$dumpvars(0, mult_tb);
	end

endmodule