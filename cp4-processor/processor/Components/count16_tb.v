module count16_tb;

	
	wire done;
	wire clock;
	wire [31:0] count;
	wire reset;
	wire [31:0] timer;
	wire enable;
	
	integer i, k, l;
	assign clock = k[0:0];
	assign reset = l[0:0];
	assign timer = i[31:0];
	count16 ctb(done, clock, reset, enable);
	
	initial begin
		i = 0;
		k = 0;
		l = 0;
		#400;
		$finish;
	end
	
	always 
		#5 k = ~k;
	always
		#200 l = 1;
	always
		#3 l = 0;
	
	always @(clock) begin
		#1;
		if (clock == 1'b1) begin
			i = i + 1;
			$display("Count:%d, Ready:%d, Enable:%b", timer, done, enable);
		end
	end
	initial begin
		$dumpfile("Wave_count16.vcd");
		$dumpvars(0, count16_tb);
	end
	

endmodule