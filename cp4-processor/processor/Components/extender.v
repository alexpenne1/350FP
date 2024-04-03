module extender(in, out);

	input [16:0] in;
	output [31:0] out;
	
	assign out[16:0] = in;
	
	wire [14:0] leftbits = in[16] ? 15'b111111111111111 : 15'b0;
	
	assign out[31:17] = leftbits;
	

endmodule