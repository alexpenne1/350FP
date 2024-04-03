module my_multdiv_tb;

	wire [31:0] data_operandA, data_operandB;
    wire ctrl_MULT, ctrl_DIV, clock;

    wire [31:0] data_result;
    wire data_exception, data_resultRDY;
	
	multdiv tb(data_operandA, data_operandB, ctrl_MULT, ctrl_DIV, clock, data_result, data_exception, data_resultRDY);
	
	integer i, j, k, l, m;
	assign data_operandA = i;
	assign data_operandB = j;
	assign clock = k[0:0];
	assign ctrl_MULT = l[0:0];
	assign ctrl_DIV = m [0:0];
	
	initial begin
		i = 21;
		j = 3;
		k = 0;
		l = 0;
		m = 1;
		#1200;
		$finish;
	end
	
	always
		#10 k = ~k;
	
	always
		#20 $display("A:%d, B:%d, Out:%d, Ready:%d", $signed(data_operandA), $signed(data_operandB), $signed(data_result), data_resultRDY);
		
	
	
	wire [4:0] q;
	tff32 counter(clock, 1'b1, 1'b0, q);
	
	always @(clock) begin
	
		if (q == 5'b0) begin
			m = 1;
		end else begin
			m = 0;
		end
	
	end
	
		
	
	
	initial begin
		$dumpfile("Wave_mult.vcd");
		$dumpvars(0, my_multdiv_tb);
	end
	
	

endmodule;