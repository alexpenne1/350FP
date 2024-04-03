module or_32_input_tb;

	wire [31:0] in;
	wire out;
	or_32_input tb(in, out);
	integer i;
	assign {in} = i[31:0];
	
	initial begin
		i = 10;
		#80;
		$display("In:%b, Out:%b", in, out);
	end
endmodule