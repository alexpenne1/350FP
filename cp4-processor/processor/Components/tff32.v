module tff32(clk, en, clr, q);

	input clk, en, clr;
	output [4:0] q;
	
	
	
	tff tff0(1'b1, clk, q[0], en, clr);
	tff tff1(q[0], clk, q[1], en, clr);
	
	wire t2in;
	assign t2in = q[1] & q[0];
	
	tff tff2(t2in, clk, q[2], en, clr);
	
	wire t3in;
	assign t3in = q[2] & q[1] & q[0];
	
	tff tff3(t3in, clk, q[3], en, clr);
	
	wire t4in;
	assign t4in = q[3] & q[2] & q[1] & q[0];
	
	tff tff4(t4in, clk, q[4], en, clr);

endmodule