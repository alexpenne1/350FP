module tff(t, clk, q, en, clr);

	input t, clk, en, clr;
	output q;
	wire d;
	
	dffe_ref dff(q, d, clk, en, clr);
	
	xor xor1(d, q, t);
	

endmodule