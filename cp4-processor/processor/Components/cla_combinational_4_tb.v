module cla_combinational_4_tb;

	wire [3:0] A, B;
	wire c0;
	wire [3:0] cout;
	wire P, G;
	
	cla_combinational_4 cla_combinational_t(A, B, c0, cout, P, G);
	
	integer i, j, k;
	assign {A} = i[3:0];
	assign {B} = j[3:0];
	assign {c0} = k[0:0];
	
	
	initial begin
		k = 0;
		i = 15;
		j = 15;
		#160;
		$display("A:%b + B:%b, Carry: %b, P:%b, G:%b", A, B, cout, P, G);
		
		
	end
	
endmodule