module control(in, out, reset, done, clock, en, q);


	input [2:0] in;
	output [31:0] out;
	input reset;
	output done;
	input clock;
	input en; 
	
	
	// start counter
	//count16 counter(done, clock, reset, counter_on);
	
	output [3:0] q;
	tff16 counter(clock, en, reset, q);
	assign done = q[3] & q[2] & q[1] & q[0];
	
	/// mux 8
	wire [31:0] code;
	mux_8 select_code(code, in, 32'b0, 32'b1, 32'b1, 32'b10, 32'b100, 32'b11, 32'b11, 32'b0);
	
	mux_2 select_enable(out, ~done, 32'b0, code);
	
	
	

endmodule