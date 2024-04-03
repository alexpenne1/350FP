module cla_4_tb;

	wire [3:0] A, B;
	wire Cin;
	wire P, G, Cout;
	wire [3:0] S;
	
	cla_4 tb_cla_4(A, B, Cin, P, G, Cout, S);
	
	integer i, j, k;
	assign {A} = i[3:0];
	assign {B} = j[3:0];
	assign {Cin} = k[0:0];
	
	
	initial begin
		k = 1;
		i = 5;
		j = 15;
	
		#160;
		$display("A:%d + B:%d = S:%d, Carry In:%b, Carry Out:%b, P:%b, G:%b", A, B, S, Cin, Cout, P, G);
	end
endmodule
