module full_adder(S, A, B, Cin);

	input A, B, Cin;
	wire P, G;
	output S;
	wire w1, w2, w3;

	xor XOR1(P, A, B);
	and AND1(G, A, B);
	xor XOR2(S, P, Cin);

endmodule