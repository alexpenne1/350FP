module mult(data_operandA, data_operandB, clock, data_result, data_exception, data_resultRDY, reset);

	input [31:0] data_operandA, data_operandB;
    input clock;
	input reset;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	
	// Put multiplicandA into negate logic to get 5 wires. 
	
	wire signed [31:0] posA, posAshift, negA, negAshift;
	assign posA = data_operandA;
	negate neg(posA, negA);
	assign posAshift = $signed(posA)<<<1;
	assign negAshift = $signed(negA)<<<1;
	
	// Put into mux with controller output as select bits. Need to define product to put into controller.
	
	wire [31:0] next_to_add;
	wire [31:0] control_code;
	wire [31:0] product_reg1, product_reg0;
	wire ghost_bit;
	wire reset;
	wire [31:0] input_to_reg0;
	wire [31:0] input_to_reg1;
	wire input_to_ghost_bit;
	
	wire [2:0] last3bits;
	assign last3bits[2:1] = product_reg0[1:0];
	assign last3bits[0:0] = ghost_bit;
	
	wire [3:0] timer;
	
	control controller(last3bits, control_code, reset, data_resultRDY, clock, 1'b1, timer);
	
	mux_32 mux1(.out(next_to_add), .select(control_code[4:0]), .in0(32'b0), .in1(posA), .in2(posAshift), .in3(negA), .in4(negAshift));
	
	wire [31:0] reg1_added;
	
	alu adder(.data_operandA(product_reg1), .data_operandB(next_to_add), .ctrl_ALUopcode(5'b0), .data_result(reg1_added));
	
	wire [31:0] new_reg0, new_reg1;
	wire new_ghost_bit;
	wire isZero;
	assign isZero = ~timer[3] & ~timer[2] & ~timer[1] & ~timer[0];
	
	rrd_shift shifter(reg1_added, product_reg0, new_reg1, new_reg0, new_ghost_bit);
	
	register reg1(input_to_reg1, product_reg1, clock, 1'b1,  reset);
	
	register reg0(input_to_reg0, product_reg0, clock, 1'b1,  reset);
	
	dffe_ref gbdff(ghost_bit, input_to_ghost_bit, clock, 1'b1, reset);
	
	assign data_result = new_reg0;
	
	
	wire [31:0] cycle00, cycle01;
	wire cycle0dff;
	
	mux_2 muxed(input_to_reg0, isZero, new_reg0, cycle00);
	mux_2 muxed2(input_to_reg1, isZero, new_reg1, cycle01);
	assign input_to_ghost_bit = isZero ? cycle0dff : new_ghost_bit;
	
	// determine last three bits (last is 0)

	wire [2:0] cycle0_last3bits;
	assign cycle0_last3bits[2:1] = data_operandB[1:0];
	assign cycle0_last3bits[0] = 1'b0;
	// get control code from this
	wire [31:0] cycle0_code;
	mux_8 select_code1(cycle0_code, cycle0_last3bits, 32'b0, 32'b1, 32'b1, 32'b10, 32'b100, 32'b11, 32'b11, 32'b0);
	// use to mux to assign cycle 01preshift
	wire signed [31:0] cycle01_preshift;
	mux_32 mux68(.out(cycle01_preshift), .select(cycle0_code[4:0]), .in0(32'b0), .in1(posA), .in2(posAshift), .in3(negA), .in4(negAshift));
	// do shifts and all
	assign cycle0dff = data_operandB[1];
	assign cycle01 = cycle01_preshift >>> 2;
	assign cycle00[29:0] = data_operandB[31:2];
	assign cycle00[31:30] = cycle01_preshift[1:0];
	
	
	// DETERMINE EXCEPTION
	// if either operands are the max, make exception
	wire isReg1Zero, isReg1Max;
	wire isAMax, isBMax, isAMaxNeg, isBMaxNeg, isAOne, isAZero, isBOne, isBZero;
	assign isReg1Zero = new_reg1 == 32'b0;
	assign isReg1Max = new_reg1 == 32'b11111111111111111111111111111111;
	assign data_exception = (isAMax & ~isBZero & ~isBOne) | (isAMaxNeg & ~isBZero & ~isBOne) | (isBMax & ~isAZero & ~isAOne) | (isBMaxNeg & ~isAZero & ~isAOne) | (~isReg1Zero & ~isReg1Max) | (isReg1Zero & new_reg0[31]) | (isReg1Max & ~new_reg0[31]);
	
	assign isAMax = data_operandA == 32'b01111111111111111111111111111111;
	assign isBMax = data_operandB == 32'b01111111111111111111111111111111;
	assign isAMaxNeg = data_operandA == 32'b10000000000000000000000000000000;
	assign isBMaxNeg = data_operandB == 32'b10000000000000000000000000000000;
	assign isAZero = data_operandA == 32'b0;
	assign isAOne = data_operandA == 32'b1;
	assign isBZero = data_operandB == 32'b0;
	assign isBOne = data_operandB == 32'b1;
endmodule