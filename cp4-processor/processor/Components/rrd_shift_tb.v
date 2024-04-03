module rrd_shift_tb;

	wire [31:0] reg1in, reg0in;
	wire [31:0] reg1out, reg0out;
	wire dffout;
	
	rrd_shift tb(reg1in, reg0in, reg1out, reg0out, dffout);
	
	integer i, j;
	assign reg1in = i;
	assign reg0in = j;
	initial begin
	
		i = 32'b11111;
		j = 32'b11101;
		#50;
		$display("In1:%b, In0:%b, Out1:%b, out0:%b, Dff:%b", reg1in, reg0in, reg1out, reg0out, dffout);
		
	
	end

endmodule