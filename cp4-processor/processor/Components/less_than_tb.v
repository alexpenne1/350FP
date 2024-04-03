module less_than_tb;

	wire [31:0] A, B;
	wire out;
	
	less_than tb(A, B, out);
	
	integer i, j;
	assign {A} = i[31:0];
	assign {B} = j[31:0];
	
	initial begin
		i = 10;
		j = 8;
	end
		

endmodule