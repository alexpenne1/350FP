module not_32_tb;

	wire [31:0] A;
	wire [31:0] Out;
	
	not_32 not_tb(A, Out);
	
	integer i;
	assign {A} = i[31:0];
	
	initial begin
		i = 0;
		#160;
		$display("A:%b, Out:%b", A, Out);
	end

endmodule