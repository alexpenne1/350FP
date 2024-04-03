module register_custom(in, out, clk, en, clr, init);

	input [31:0] in;
	input clk, en, clr;
	input [31:0] init;
	output [31:0] out;
	
	// Need 32 dffes
	
	
	
	genvar c;
	generate
		for (c=0; c < 32; c = c + 1) begin: loop1
			
			dffe_custom a_dffe(out[c], in[c], clk, en, clr, init[c]);
			
		end
	endgenerate
	
	

endmodule 