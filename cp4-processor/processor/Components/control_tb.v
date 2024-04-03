module control_tb;
	
	wire [2:0] in;
	wire [31:0] out;
	wire  reset;
	wire done;
	wire clock;
	
	integer i, l, k;
	assign in = i[2:0];
	assign clock = l[0:0];
	assign reset = k[0:0];
	
	control controller(in, out, reset, done, clock);
	initial begin
		k = 0;
		i = 0;
		l = 0;
		#300;
		$finish;
	end 
	
	always
		#5 l = ~l;
	
	always
		#200 k = 1'b1;
	
	always
		#3 k = 1'b0;
	
	always @(clock) begin
		#1;
		if (clock == 1'b1) begin
			i = i + 1;
			$display("In:%b, Out:%d", in, out);
		end
	end

endmodule