module cls_32_tb;

	

	wire [31:0] A, B;
	wire Cout, enable;
	wire [31:0] S;
	
	integer i, j, l;
	assign {A} = i[31:0];
	assign {B} = j[31:0];
	assign {enable} = l[0:0];
	
	cls_32 tb_cls_32(A, B, Cout, S, enable);
	
	initial begin
		l = 0;
		i = 10;
		j = 4;
		#160;
		$display("A:%d + B:%d = S:%d, Carry out:%b", A, B, S, Cout);
		
	end
	

endmodule