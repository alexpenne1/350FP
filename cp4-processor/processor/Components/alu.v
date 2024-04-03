module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;
	
	// Decode opcode and enable wires.
	wire [5:0] enable_wires;
	op_decode op_decode_enable(ctrl_ALUopcode, enable_wires);
	
	

	// Get each output for each opcode.
	
	//ADD
	wire [31:0] add_output;
	wire add_overflow;
	wire add_overflow_en;
	cla_32 adder(data_operandA, data_operandB, add_overflow, add_output, enable_wires[0]);
	and andover(add_overflow_en, add_overflow, enable_wires[0]);
	
	//SUB
	wire [31:0] sub_output;
	wire sub_overflow;
	wire sub_overflow_en;
	cls_32 subber(data_operandA, data_operandB, sub_overflow, sub_output, enable_wires[1]);
	and subover(sub_overflow_en, sub_overflow, enable_wires[1]);
	
	//AND
	wire [31:0] and_output;
	and_32 ander(data_operandA, data_operandB, enable_wires[2], and_output);
	
	//OR
	wire [31:0] or_output;
	or_32 orer(data_operandA, data_operandB, enable_wires[3], or_output);
	
	//SLL
	wire [31:0] sll_output;
	sll sller(data_operandA, ctrl_shiftamt, sll_output, enable_wires[4]);
	
	//SRA
	wire [31:0] sra_output;
	sra sraer(data_operandA, ctrl_shiftamt, sra_output, enable_wires[5]);
	
	// Output
	
	
	wire [31:0] or_addsub, or_andor, or_sllsra, or_addsubandor;
	
	or_32 or321(add_output, sub_output, 1'b1, or_addsub);
	or_32 or322(or_output, and_output, 1'b1, or_andor);
	or_32 or323(sra_output, sll_output, 1'b1, or_sllsra);
	or_32 or324(or_andor, or_addsub, 1'b1, or_addsubandor);
	or_32 or325(or_sllsra, or_addsubandor, 1'b1, data_result);
	or out_overflow(overflow, add_overflow_en, sub_overflow_en);
	
	// Not equal if any of sub output is 1. Need to fix. 
	or_32_input not_equal(sub_output, isNotEqual);
	
	// If sub_output is negative, must be less than. 
	wire sub_7, ovf_not, and_0, and_1;
	assign sub_7 = sub_output[31];
	not notovf(ovf_not, overflow);
	and and0(and_0, overflow, data_operandA[31]);
	and and1(and_1, ovf_not, data_result[31]);
	or or0(isLessThan, and_1, and_0);
    

endmodule