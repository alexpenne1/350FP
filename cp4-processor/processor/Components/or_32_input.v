module or_32_input(in, out);

	input [31:0] in;
	output out;
	
	wire w0, w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, w21, w22, w23, w24, w25, w26, w27, w28, w29, w30, w31;
	
	or or0(w0, in[0], in[1]);
	or or1(w1, w0, in[2]);
	or or2(w2, w1, in[3]);
	or or3(w3, w2, in[4]);
	or or4(w4, w3, in[5]);
	or or5(w5, w4, in[6]);
	or or6(w6, w5, in[7]);
	or or7(w7, w6, in[8]);
	or or8(w8, w7, in[9]);
	or or9(w9, w8, in[10]);
	or or10(w10, w9, in[11]);
	or or11(w11, w10, in[12]);
	or or12(w12, w11, in[13]);
	or or13(w13, w12, in[14]);
	or or14(w14, w13, in[15]);
	or or15(w15, w14, in[16]);
	or or16(w16, w15, in[17]);
	or or17(w17, w16, in[18]);
	or or18(w18, w17, in[19]);
	or or19(w19, w18, in[20]);
	or or20(w20, w19, in[21]);
	or or21(w21, w20, in[22]);
	or or22(w22, w21, in[23]);
	or or23(w23, w22, in[24]);
	or or24(w24, w23, in[25]);
	or or25(w25, w24, in[26]);
	or or26(w26, w25, in[27]);
	or or27(w27, w26, in[28]);
	or or28(w28, w27, in[29]);
	or or29(w29, w28, in[30]);
	or or30(out, w29, in[31]);
endmodule