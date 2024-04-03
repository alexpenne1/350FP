module register(in, out, clk, en, clr);

	input [31:0] in;
	input clk, en, clr;
	output [31:0] out;
	
	// Need 32 dffes
	
	
	
	genvar c;
	generate
		for (c=0; c < 32; c = c + 1) begin: loop1
			
			dffe_ref a_dffe(out[c], in[c], clk, en, clr);
			
		end
	endgenerate
	
	

endmodule 