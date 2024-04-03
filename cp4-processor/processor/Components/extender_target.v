module extender_target(in, out);

	input [26:0] in;
	output [31:0] out;
	
	assign out[26:0] = in;
	
	wire [4:0] leftbits = in[26] ? 5'b11111 : 5'b0;
	
	assign out[31:27] = leftbits;
	

endmodule