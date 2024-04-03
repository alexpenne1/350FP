module decode_tb;

	wire en;
	wire [4:0] in;
	wire [31:0] out;
	
	integer i, j;
	
	assign in = i[4:0];
	assign en = 1'b1;
	
	decode decodetb(in, out, en);
	initial begin
		
		for (i = 0; i < 32; i++) begin
			
			#20;
			$display("In:%d, Out:%b", in, out);
		
		end
		
	
	end

endmodule