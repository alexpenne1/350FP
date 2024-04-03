module div_tb;

	// declare wires
	wire [31:0] data_operandA, data_operandB;
	wire clock;
	wire [31:0] data_result;
	wire data_exception, data_resultRDY;
	wire reset = 1'b0;
	// instaniate module
	div divtb(data_operandA, data_operandB, clock, data_result, data_exception, data_resultRDY, reset);
	
	// make integers
	integer i, j, k;
	assign data_operandA = i;
	assign data_operandB = j;
	assign clock = k[0:0];
	
	// initiate
	initial begin
		i = 21;
		j = 3;
		k = 0;
		#600;
		$finish;
	end
	
	// flip clock and print every cycle
	always
		#5 k = ~k;
	always
		#10 $display("A:%d, B:%d, Out:%d, Ready:%d", data_operandA, data_operandB, data_result, data_resultRDY);
		
	// output to gtkwave
	initial begin
		$dumpfile("Wave_mult.vcd");
		$dumpvars(0, div_tb);
	end
	
	

endmodule