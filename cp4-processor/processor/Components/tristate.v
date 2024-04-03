module tristate(in, oe, out);
	
	input oe;
	input [31:0] in;
	output out;
	
	assign out = oe ? in : 32'bz;

endmodule