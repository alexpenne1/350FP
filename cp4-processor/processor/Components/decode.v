module decode(in, out, en);

	input [4:0] in;
	output [31:0] out;
	
	input en;
	
	wire in0, in1, in2, in3, in4, nin0, nin1, nin2, nin3, nin4;
	
	assign in0 = in[0];
	assign in1 = in[1];
	assign in2 = in[2];
	assign in3 = in[3];
	assign in4 = in[4];
	
	not n0(nin0, in[0]);
	not n1(nin1, in[1]);
	not n2(nin2, in[2]);
	not n3(nin3, in[3]);
	not n4(nin4, in[4]);
	
	and and0(out[0], nin0, nin1, nin2, nin3, nin4, en);
	and and1(out[1], in0, nin1, nin2, nin3, nin4, en);
	and and2(out[2], nin0, in1, nin2, nin3, nin4, en); 
	and and3(out[3], in0, in1, nin2, nin3, nin4, en);
	and and4(out[4], nin0, nin1, in2, nin3, nin4, en);
	and and5(out[5], in0, nin1, in2, nin3, nin4, en);
	and and6(out[6], nin0, in1, in2, nin3, nin4, en);
	and and7(out[7], in0, in1, in2, nin3, nin4, en);
	and and8(out[8], nin0, nin1, nin2, in3, nin4, en);
	and and9(out[9], in0, nin1, nin2, in3, nin4, en);
	and and10(out[10], nin0, in1, nin2, in3, nin4, en); 
	and and11(out[11], in0, in1, nin2, in3, nin4, en);
	and and12(out[12], nin0, nin1, in2, in3, nin4, en);
	and and13(out[13], in0, nin1, in2, in3, nin4, en);
	and and14(out[14], nin0, in1, in2, in3, nin4, en);
	and and15(out[15], in0, in1, in2, in3, nin4, en);
	and and16(out[16], nin0, nin1, nin2, nin3, in4, en);
	and and17(out[17], in0, nin1, nin2, nin3, in4, en);
	and and18(out[18], nin0, in1, nin2, nin3, in4, en); 
	and and19(out[19], in0, in1, nin2, nin3, in4, en);
	and and20(out[20], nin0, nin1, in2, nin3, in4, en);
	and and21(out[21], in0, nin1, in2, nin3, in4, en);
	and and22(out[22], nin0, in1, in2, nin3, in4, en);
	and and23(out[23], in0, in1, in2, nin3, in4, en);
	and and24(out[24], nin0, nin1, nin2, in3, in4, en);
	and and25(out[25], in0, nin1, nin2, in3, in4, en);
	and and26(out[26], nin0, in1, nin2, in3, in4, en); 
	and and27(out[27], in0, in1, nin2, in3, in4, en);
	and and28(out[28], nin0, nin1, in2, in3, in4, en);
	and and29(out[29], in0, nin1, in2, in3, in4, en);
	and and30(out[30], nin0, in1, in2, in3, in4, en);
	and and31(out[31], in0, in1, in2, in3, in4, en);

endmodule