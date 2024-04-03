module cla_combinational_32_tb;

	wire [7:0] P, G; // Comes from 8 cla_4's.
	wire c0; // likely 0.
	wire [7:0] cout; // c4, c8, c12, c16, c20, c24, c28, c32. These go back to cla_4's.
	
	integer i, j, k;
	
	assign {P} = i[7:0];
	assign {G} = j[7:0];
	assign {c0} = k[0:0];
	
	cla_combinational_32 cla_comb(P, G, c0, cout);
	
	initial begin
		i =32;
		j =32;
		k = 0;
		#160;
		$display("P:%b, G:%b, Cout:%b", P, G, cout);
	
	end

endmodule