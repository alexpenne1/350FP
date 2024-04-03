module cla_32_tb;
	
	wire [31:0] A, B;
	wire Cout;
	wire [31:0] S;
	wire enable;
	integer i, j, l;
	assign {A} = i[31:0];
	assign {B} = j[31:0];
	assign {enable} = l[31:0];
	
	cla_32 tb_cla_32(A, B, Cout, S, enable);
	
	initial begin
		l=0;
		i = 10;
		j = 10;
		#160;
		$display("A:%d + B:%d = S:%d, Carry out:%b", A, B, S, Cout);
		
	end
	

endmodule