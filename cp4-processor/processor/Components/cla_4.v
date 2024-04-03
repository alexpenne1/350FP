module cla_4(A, B, Cin, P, G, Cout, S);

	// Setup combinational unit
	// Use to inputs of full adder
	// Output answer and final carry
	
	input [3:0] A, B;
	input Cin;
	output P, G, Cout;
	output [3:0] S;
	wire [3:0] carries;
	wire zeroWire;
	
	
	cla_combinational_4 clacomb(A, B, Cin, carries, P, G);
	// First two bits add with 0 carry in.
	full_adder adder0(S[0], A[0], B[0], Cin);
	// Second two bits add with first carry already calculated.
	full_adder adder1(S[1], A[1], B[1], carries[0]);
	full_adder adder2(S[2], A[2], B[2], carries[1]);
	full_adder adder3(S[3], A[3], B[3], carries[2]);
	// ... we know carry out already.
	assign Cout = carries[3];
	

endmodule