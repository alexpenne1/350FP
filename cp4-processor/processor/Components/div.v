module div(data_operandA, data_operandB, clock, data_result, data_exception, data_resultRDY, reset);

	// declare inputs and outputs
	input [31:0] data_operandA, data_operandB;
	input clock;
	output [31:0] data_result;
	output data_exception, data_resultRDY;
	
	input reset;

	// make timer and set data result ready to timer == 31
	wire [4:0] timer;
	tff32 tfftimer(clock, 1'b1, reset, timer);
	assign data_resultRDY = timer[4] & timer[3] & timer[2] & timer[1] & timer[0];
	
	// make registers, reg inputs, reg outputs
	wire [31:0] in_regQ, out_regQ, in_regR, out_regR;
	register regR(in_regR, out_regR, clock, 1'b1, reset);
	register regQ(in_regQ, out_regQ, clock, 1'b1, reset);
	
	// get pos and neg divisor
	wire [31:0] divisor, neg_divisor;
	assign divisor = data_operandB;
	negate negDiv(data_operandB, neg_divisor);
	
	// *************** CYCLE 0 MANUAL ********************** //
		// determine shifts
	wire [31:0] cycle0_shiftR, cycle0_shiftQ, cycle0_new_regR, cycle0_new_regQ;
	assign cycle0_shiftR[31:1] = 31'b0;
	assign cycle0_shiftR[0] = data_operandA[31];
	assign cycle0_shiftQ[31:1] = data_operandA[30:0];
		// if cycle0_shiftR - B is negative, make cycle0_shiftQ[0] = 0 and make new_regR = cycle0_shiftR.
		// if cycle0_shiftR - B is positive, make cycle0_shiftQ[0] = 1 and make new_regR = cycle0_shiftR - B.
	wire [31:0] cycle0_regR_minus_B;
	alu adder(.data_operandA(cycle0_shiftR), .data_operandB(neg_divisor), .ctrl_ALUopcode(5'b0), .data_result(cycle0_regR_minus_B));
	assign cycle0_shiftQ[0] = cycle0_regR_minus_B[31] ? 1'b0 : 1'b1;
	
	assign cycle0_new_regR = cycle0_regR_minus_B[31] ? cycle0_shiftR : cycle0_regR_minus_B;
	assign cycle0_new_regQ = cycle0_shiftQ;

	
	
	// ************** NORMAL OPERATION ********************* //
		// determine shifts
	wire [31:0] shiftR, shiftQ, new_regR, new_regQ;
	assign shiftR[31:1] = out_regR[30:0];
	assign shiftR[0] = out_regQ[31];
	assign shiftQ[31:1] = out_regQ[30:0];
		// subtract
	wire [31:0] regR_minus_B;
	alu adder2(.data_operandA(shiftR), .data_operandB(neg_divisor), .ctrl_ALUopcode(5'b0), .data_result(regR_minus_B));
	assign shiftQ[0] = regR_minus_B[31] ? 1'b0 : 1'b1;
	assign new_regQ = shiftQ;
	assign new_regR = regR_minus_B[31] ? shiftR : regR_minus_B;
	

	// Make new reg0 and new reg1 muxed with cycle 0.
	wire isZero;
	assign isZero = ~timer[4] & ~timer[3] & ~timer[2] & ~timer[1] & ~timer[0];
	assign in_regQ = isZero ? cycle0_new_regQ : new_regQ;
	assign in_regR = isZero ? cycle0_new_regR : new_regR;
	
	// assign out
	assign data_result = in_regQ;
	
	assign data_exception = data_operandB == 32'b0;

endmodule