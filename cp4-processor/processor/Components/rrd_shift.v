module rrd_shift(reg1in, reg0in, reg1out, reg0out, dffout);

	input signed [31:0] reg1in, reg0in;
	output [31:0] reg1out, reg0out;
	output dffout;
	
	assign dffout = reg0in[1];
	
	assign reg0out[29:0] = reg0in[31:2];
	assign reg0out[31:30] = reg1in[1:0];
	
	assign reg1out = reg1in >>> 2;

endmodule