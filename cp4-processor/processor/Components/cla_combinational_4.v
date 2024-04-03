module cla_combinational_4(A, B, c0, cout, P, G);

	// TODO: make testbench, add this with full adder to cla 4 bit, make cla 16 bit from this, then two of them for 32 bit.

	input [3:0] A, B;
	input c0;
	output [3:0] cout;
	output P, G;
	
	wire g0, g1, g2, g3;
	wire p0, p1, p2, p3;
	
	wire w00, w10, w11, w20, w21, w22, w30, w31, w32, w33;
	
	and g0and(g0, A[0], B[0]);
	and g1and(g1, A[1], B[1]);
	and g2and(g2, A[2], B[2]);
	and g3and(g3, A[3], B[3]);
	
	xor p0xor(p0, A[0], B[0]);
	xor p1xor(p1, A[1], B[1]);
	xor p2xor(p2, A[2], B[2]);
	xor p3xor(p3, A[3], B[3]);
	

	// C1
	and w00and(w00, p0, c0);
	or c1or(cout[0], g0, w00); // C1 = G0 + P0C0
	// C2
	and w10and(w10, c0, p0, p1);
	and w11and(w11, g0, p1);
	or c2or(cout[1], g1, w10, w11);
	// C3
	and w20and(w20, c0, p0, p1, p2);
	and w21and(w21, g0, p1, p2);
	and w22and(w22, g1, p2);
	or c3or(cout[2], g2, w20, w21, w22);
	// C4
	and w30and(w30, c0, p0, p1, p2, p3);
	and w31and(w31, g0, p1, p2, p3);
	and w32and(w32, g1, p2, p3);
	and w33and(w33, g2, p3);
	or c4or(cout[3], g3, w30, w31, w32, w33);

	and andP(P, p0, p1, p2, p3);
	or orG(G, g3, w33, w32, w31);


endmodule