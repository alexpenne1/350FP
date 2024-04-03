module and_32(data_operandA, data_operandB, and_enable, and_output);

	input [31:0] data_operandA, data_operandB;
	input and_enable;
	output [31:0] and_output;
	
	and and_0(and_output[0], data_operandA[0], data_operandB[0], and_enable);
	and and_1(and_output[1], data_operandA[1], data_operandB[1], and_enable);
	and and_2(and_output[2], data_operandA[2], data_operandB[2], and_enable);
	and and_3(and_output[3], data_operandA[3], data_operandB[3], and_enable);
	and and_4(and_output[4], data_operandA[4], data_operandB[4], and_enable);
	and and_5(and_output[5], data_operandA[5], data_operandB[5], and_enable);
	and and_6(and_output[6], data_operandA[6], data_operandB[6], and_enable);
	and and_7(and_output[7], data_operandA[7], data_operandB[7], and_enable);
	and and_8(and_output[8], data_operandA[8], data_operandB[8], and_enable);
	and and_9(and_output[9], data_operandA[9], data_operandB[9], and_enable);
	and and_10(and_output[10], data_operandA[10], data_operandB[10], and_enable);
	and and_11(and_output[11], data_operandA[11], data_operandB[11], and_enable);
	and and_12(and_output[12], data_operandA[12], data_operandB[12], and_enable);
	and and_13(and_output[13], data_operandA[13], data_operandB[13], and_enable);
	and and_14(and_output[14], data_operandA[14], data_operandB[14], and_enable);
	and and_15(and_output[15], data_operandA[15], data_operandB[15], and_enable);
	and and_16(and_output[16], data_operandA[16], data_operandB[16], and_enable);
	and and_17(and_output[17], data_operandA[17], data_operandB[17], and_enable);
	and and_18(and_output[18], data_operandA[18], data_operandB[18], and_enable);
	and and_19(and_output[19], data_operandA[19], data_operandB[19], and_enable);
	and and_20(and_output[20], data_operandA[20], data_operandB[20], and_enable);
	and and_21(and_output[21], data_operandA[21], data_operandB[21], and_enable);
	and and_22(and_output[22], data_operandA[22], data_operandB[22], and_enable);
	and and_23(and_output[23], data_operandA[23], data_operandB[23], and_enable);
	and and_24(and_output[24], data_operandA[24], data_operandB[24], and_enable);
	and and_25(and_output[25], data_operandA[25], data_operandB[25], and_enable);
	and and_26(and_output[26], data_operandA[26], data_operandB[26], and_enable);
	and and_27(and_output[27], data_operandA[27], data_operandB[27], and_enable);
	and and_28(and_output[28], data_operandA[28], data_operandB[28], and_enable);
	and and_29(and_output[29], data_operandA[29], data_operandB[29], and_enable);
	and and_30(and_output[30], data_operandA[30], data_operandB[30], and_enable);
	and and_31(and_output[31], data_operandA[31], data_operandB[31], and_enable);
endmodule
	