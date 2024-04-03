module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);
	
	

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;
	
	wire [31:0] any_data_result, mult_data_result, div_data_result;
	wire any_data_exception, mult_data_exception, mult_data_resultRDY;
	wire any_data_resultRDY, div_data_exception, div_data_resultRDY;
	
	wire reset;
	assign reset = ctrl_MULT | ctrl_DIV;

    mult multtest(data_operandA, data_operandB, clock, mult_data_result, mult_data_exception, mult_data_resultRDY, reset);
	
	// make ctrl unit
	wire ctrl;
	wire en;
	assign en = ctrl_MULT | ctrl_DIV;
	dffe_cus ctrller(ctrl, ctrl_MULT, clock, en, 1'b0, ctrl_MULT);
	
	
	// determine if A or B are neg
	wire isANeg, isBNeg;
	assign isANeg = data_operandA[31];
	assign isBNeg = data_operandB[31];
	
	wire [31:0] ANeg, BNeg;
	negate A(data_operandA, ANeg);
	negate B(data_operandB, BNeg);
	
	wire [31:0] divAIn, divBIn;
	assign divAIn = isANeg ? ANeg : data_operandA;
	assign divBIn = isBNeg ? BNeg : data_operandB;
	wire [31:0] divout;
	div divtest(divAIn, divBIn, clock, divout, div_data_exception, div_data_resultRDY, reset);
	
	wire isOutNeg;
	assign isOutNeg = (isANeg & ~isBNeg) | (~isANeg & isBNeg);
	wire [31:0] outNeg;
	
	negate out(divout, outNeg);
	wire [31:0] beforeExceptionDivOut;
	assign beforeExceptionDivOut = isOutNeg ? outNeg : divout;
	assign div_data_result = div_data_exception ? 32'b0 : beforeExceptionDivOut;
	/*
	assign any_data_result = ctrl_MULT ? mult_data_result : 31'bz;
	assign any_data_exception = ctrl_MULT ? mult_data_exception : 32'bz;
	assign any_data_resultRDY = ctrl_MULT ? mult_data_resultRDY : 32'bz;
	*/
	/*
	assign data_result = ctrl_MULT ? mult_data_result : div_data_result;
	assign data_exception = ctrl_MULT ? mult_data_exception : div_data_exception;
	assign data_resultRDY = ctrl_MULT ? mult_data_resultRDY : div_data_resultRDY;
	*/
	
	mux_2 multmux(data_result, ctrl, div_data_result, mult_data_result);
	assign data_exception = ctrl ? mult_data_exception : div_data_exception;
	assign data_resultRDY = ctrl ? mult_data_resultRDY: div_data_resultRDY;
	

endmodule