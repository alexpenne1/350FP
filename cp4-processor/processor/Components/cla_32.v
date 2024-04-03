module cla_32(A, B, Cout, S, enable);
	
	input [31:0] A, B;
	input enable;
	output Cout;
	output [31:0] S;
	
	wire [7:0] P, G; // get from cla_4 adders. set S to correct location. set carry-in from combinational_32 carries
	wire [7:0] carries; // get carries from combinational_32
	wire [31:0] S_e;
	cla_combinational_32 cla_comb(P, G, 1'b0, carries);
	
	wire w1, w2, w3, w4, w5, w6, w7, w8;
	wire carry_7, and_combo, and_combo2;
	cla_4 adder1(A[3:0], B[3:0], 1'b0, P[0], G[0], w1, S_e[3:0]);
	cla_4 adder2(A[7:4], B[7:4], carries[0], P[1], G[1], w2, S_e[7:4]);
	cla_4 adder3(A[11:8], B[11:8], carries[1], P[2], G[2], w3, S_e[11:8]);
	cla_4 adder4(A[15:12], B[15:12], carries[2], P[3], G[3], w4, S_e[15:12]);
	cla_4 adder5(A[19:16], B[19:16], carries[3], P[4], G[4], w5, S_e[19:16]);
	cla_4 adder6(A[23:20], B[23:20], carries[4], P[5], G[5], w6, S_e[23:20]);
	cla_4 adder7(A[27:24], B[27:24], carries[5], P[6], G[6], w7, S_e[27:24]);
	cla_4 adder8(A[31:28], B[31:28], carries[6], P[7], G[7], w8, S_e[31:28]);
	assign carry_7 = carries[7];
	wire a_not, b_not, s_not;
	not not0(a_not, A[31]);
	not not1(b_not, B[31]);
	not not2(s_not, S[31]);
	and and0(and_combo, a_not, b_not, S[31]);
	and and1(and_combo2, A[31], B[31], s_not);
	or or0(Cout, and_combo2, and_combo);
	
	
	and_32 check_enable(S_e, S_e, enable, S);
	
	

endmodule