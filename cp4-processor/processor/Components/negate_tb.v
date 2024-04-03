module negate_tb;

	wire signed [31:0] in;
	wire signed [31:0] out;
	
	integer i;
	assign in = i;
	
	negate tb(in, out);
	
	initial begin
	
		for (i = 0; i < 100; i++) begin
		
			#5;
			$display("In:%d, Out:%d", in, out);
		
		end
	
	$finish;
	end

endmodule