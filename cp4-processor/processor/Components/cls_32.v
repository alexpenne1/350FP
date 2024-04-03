module cls_32(A, B, Cout, S, enable);

	

	input [31:0] A, B;
	output Cout;
	output [31:0] S;
	input enable;
	
	// flip B
	wire [31:0] flipped_B;
	not_32 flip_B(B, flipped_B);
	// add 1 to B
	wire [31:0] negative_B;
	wire ignore_out;
	cla_32 make_b_neg(flipped_B, 1, ignore_out, negative_B, enable);
	// add A and B
	wire not_cout;
	cla_32 sum(A, negative_B, not_cout, S, enable);
	
	wire a_not, b_not, s_not;
	not nota(a_not, A[31]);
	not notb(b_not, B[31]);
	not nots(s_not, S[31]);
	
	wire and0, and1;
	and and_0(and0, A[31], b_not, s_not);
	and and_1(and1, a_not, B[31], S[31]);
	
	or or0(Cout, and0, and1);
	// have cout here.
endmodule