/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

	/* YOUR CODE STARTS HERE */
	
	wire run;
	wire stall;
	
	/* INSTRUCTION FETCH */
		
	/* PC COUNTER */
	
	wire [31:0] next_pc;
	wire [31:0] current_pc_f;
	wire [31:0] pc_plus_one;
	wire addr_imem_reg_en = run & ~stall; 
	// register outputs current pc addr and takes in next pc addr to get
	register PC_addr(.in(next_pc), .out(current_pc_f), .clk(~clock), .en(addr_imem_reg_en), .clr(reset));
	// assign current pc to output address_imem. will return the instruction in next clock cycle
	assign address_imem = current_pc_f;
	// add 1 to pc to put next addr in pc addr reg
	alu get_next_pc(.data_operandA(current_pc_f), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0), .data_result(pc_plus_one)); 
	
	
	
	// FD latches with insns, pc
	
	wire [31:0] next_d;
	wire [31:0] current_insn_d, current_pc_d;
	wire flush;
	// remove ths line
	assign next_d = flush ? 32'b0 : q_imem;
	
	
	
	wire insn_reg_fd_latch_en = run & ~stall;
	wire pc_reg_fd_latch_en = run & ~stall;
	// change next_d back to current_insn_d
	register INSN_reg_fd_latch(.in(next_d), .out(current_insn_d), .clk(~clock), .en(insn_reg_fd_latch_en), .clr(reset));
	register PC_reg_fd_latch(.in(current_pc_f), .out(current_pc_d), .clk(~clock), .clr(reset), .en(pc_reg_fd_latch_en));
	wire [4:0] rs, rt, fd_rd;
	assign rs = current_insn_d[21:17];
	assign rt = current_insn_d[16:12];
	assign fd_rd = current_insn_d[26:22];
	assign ctrl_readRegA = rs;
	// if I type, want data from rd, not rt
	
	wire [4:0] fd_opcode = current_insn_d[31:27];
	wire fd_needRdVal = (fd_opcode == 5'b111) | (fd_opcode == 5'b10) | (fd_opcode == 5'b100) | (fd_opcode == 5'b110);
	
	// if fd_needrd, B = rd. If bex, need rstatus. if neither, need rt.
	wire [2:0] getBSelect;
	wire is_bex_d = (fd_opcode == 5'b10110);
	assign getBSelect[0] = fd_needRdVal;
	assign getBSelect[1] = is_bex_d;
	assign getBSelect[2] = 1'b0;
	mux_8_5 getBMux(.out(ctrl_readRegB), .select(getBSelect), .in0(rt), .in1(fd_rd), .in2(5'd30));
	
	
	/* END INSTRUCTION FETCH */
	
	/* INSTRUCTION DECODE */
	
	wire multdiv_exception, multdiv_ready;
	
	// registers
	wire [31:0] current_insn_x, current_pc_x;
	wire INSN_reg_dx_latch_en = run;
	wire pc_reg_x_en = run;
	wire decode_A_en = run;
	wire decode_B_en = run;
	wire isMult_x_en = 1'b1;
	wire isMult_x;
	wire isDiv_x_en = 1'b1;
	wire isDiv_x;
	wire [31:0] to_m_alu_output, alu_output_m;
	wire [4:0] opcode_d, alu_opcode_d;
	assign opcode_d = current_insn_d[31:27];
	assign alu_opcode_d = current_insn_d[6:2];
	wire isRType_d = (opcode_d == 5'b0);
	wire isMult_d = isRType_d && (alu_opcode_d == 5'd6);
	wire isDiv_d = isRType_d && (alu_opcode_d == 5'd7);
	wire [31:0] x_a, x_b;
	wire multdiv_on;
	// determine if jump
	wire is_j = (opcode_d == 5'b1);
	wire [26:0] target = current_insn_d[26:0];
	wire [31:0] target_extended;
	extender_target extarget(.in(target), .out(target_extended));
	
	// determine if bne (datareadB already has rd in it)
	wire [16:0] immediate_d = current_insn_d[16:0];
	wire [31:0] immediate_extended_d;
	wire [31:0] immediate_extended_d_m1;
	wire [31:0] pc_plus_immed;
	wire [31:0] rs_minus_rd;
	wire [31:0] cur2;
	extender immex_d(.in(immediate_d), .out(immediate_extended_d));
	alu addtopcimmed(.data_operandA(current_pc_d), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0), .data_result(cur2));
	
	alu addtopcimmed2(.data_operandA(cur2), .data_operandB(immediate_extended_d), .ctrl_ALUopcode(5'b0), .data_result(pc_plus_immed));
	
	// determine if bne, blt and if rd is in x or m. if so, pass that into alu
	wire [31:0] toRd;
	wire need_rd_x_branch = (rd_d == rd_x);
	wire need_rd_m_branch = (rd_d == rd) & ~need_rd_x_branch;
	wire [4:0] toRdSelect;
	assign toRdSelect[0] = need_rd_x_branch;
	assign toRdSelect[1] = need_rd_m_branch;
	assign toRdSelect[2] = 1'b0;
	assign toRdSelect[3] = 1'b0;
	assign toRdSelect[4] = 1'b0;
	mux_32 toRdBranchMux(.out(toRd), .select(toRdSelect), .in0(data_readRegB), .in1(to_m_alu_output), .in2(alu_output_m));
	
	alu rs_minus_rd_alu(.data_operandA(data_readRegA), .data_operandB(toRd), .ctrl_ALUopcode(5'b1), .data_result(rs_minus_rd));
	wire isEqual = (rs_minus_rd == 32'b0);
	wire isLessThan = (rs_minus_rd[31] == 1'b0 & ~isEqual);
	wire is_bne = (opcode_d == 5'b10);
	wire is_blt = (opcode_d == 5'b110);
	
	// determine if jal
	// if jal, readDataB already as rd in it
	wire is_jr = (opcode_d == 5'b100);
	wire is_jal = (opcode_d == 5'b11);
	wire is_bex_d2 = (opcode_d == 5'b10110);
	wire isBZero = (data_readRegB == 32'b0);
	
	// if jr, next pc == dataReadB. if j, target extended. if neither, pcplusone. 
	wire [4:0] pcmux_select;
	assign pcmux_select[0] = is_j | is_jal | (~isBZero & is_bex_d2);
	assign pcmux_select[1] = is_jr;
	assign pcmux_select[2] = (is_bne & ~isEqual) | (is_blt & isLessThan);
	assign pcmux_select[3] = 1'b0;
	assign pcmux_select[4] = 1'b0;
	
	/***** STALL LOGIC *******/
	
	wire [4:0] opcode_x;
	wire isLoadX = (opcode_x == 5'b01000);
	wire isLoadM = isLW;
	wire rtMatch = (rd_x == rt) & (opcode_d == 5'b0);
	wire rsMatch = (rd_x == rs) & ((opcode_d == 5'b00101) | (opcode_d == 5'b01000) | (opcode_d == 5'b00010) | (opcode_d == 5'b00110));
	wire rtMatchM = (rd == rt) & (opcode_m == 5'b0);
	wire rsMatchM = (rd == rs) & ((opcode_m == 5'b00101) | (opcode_m == 5'b01000) | (opcode_m == 5'b00010) | (opcode_m == 5'b00110));
	assign stall = (isLoadX & (rsMatch | rtMatch)) | (isLoadM & (rsMatchM | rtMatchM));
	
	/****** BYPASS JR **********/
	wire need_rd_x_jr = is_jr & (rd_d == rd_x);
	wire need_rd_m_jr = is_jr & (rd_d == rd) & (~need_rd_x_jr);
	wire [4:0] toJrSelect;
	assign toJrSelect[0] = need_rd_x_jr;
	assign toJrSelect[1] = need_rd_m_jr;
	assign toJrSelect[2] = 1'b0;
	assign toJrSelect[3] = 1'b0;
	assign toJrSelect[4] = 1'b0;
	wire [31:0] toJrPC;
	mux_32 toJRMux(.out(toJrPC), .select(toJrSelect), .in0(data_readRegB), .in1(to_m_alu_output), .in2(alu_output_m));
	
	
	assign flush = pcmux_select[0] | pcmux_select [1] | pcmux_select[2];
	//assign flush = 1'b0;
	
	mux_32 pcmux(.out(next_pc), .select(pcmux_select), .in0(pc_plus_one), .in1(target_extended), .in2(toJrPC), .in4(pc_plus_immed));
	
	
	/********* X/M->D BYPASS *****************/
	// if rs in Decode is rd in x or m, use that as input to x_a register. must be r or i type. 
	wire consider_bypass = (opcode_d == 5'b0)  | (opcode_d == 5'b01000) | (opcode_d == 5'b00101) | (opcode_d == 5'b00010) | (opcode_d == 5'b00110);
	wire [4:0] rs_d = current_insn_d[21:17];
	wire need_rd_x = (rs_d == rd_x) & consider_bypass & ~rs_d_zero & ~(current_insn_x[31:27] == 5'b00110) & ~(current_insn_x[31:27] == 5'b00010); // to_m_alu_output
	wire need_rd_m = (~need_rd_x & (rs_d == rd)) & consider_bypass & ~rs_d_zero & ~(current_insn_m[31:27] == 5'b00110) & ~(current_insn_m[31:27] == 5'b00010); // m alu output
	wire rs_d_zero = (rs_d == 5'b0)&consider_bypass;
	wire [31:0] status_x;
	// consider status
	wire Rs30 = (rs_d == 5'd30);
	wire Rt30 = (rt_d == 5'd30);
	wire statusBypassRs30 = ~(status_x == 32'b0) && (Rs30);
	wire statusBypassRt30 = ~(status_x == 32'b0) && (Rt30);
	
	
	wire [31:0] to_alu_A;
	wire [4:0] toAluSelect;
	assign toAluSelect[0] = need_rd_x & ~statusBypassRs30;
	assign toAluSelect[1] = need_rd_m & ~statusBypassRs30;
	assign toAluSelect[2] = rs_d_zero & ~statusBypassRs30;
	assign toAluSelect[3] = statusBypassRs30;
	assign toAluSelect[4] = 1'b0;
	mux_32 toAluAMux(.out(to_alu_A), .select(toAluSelect), .in0(data_readRegA), .in1(to_m_alu_output), .in2(alu_output_m), .in4(32'b0), .in8(status_x));
	
	// consider sw
	// if sw and the rd val is in x or m, need to send that to x_b. if in X, send to_m_alu_output, if in M, send alu_output_m
	
	// consider rt 
	wire consider_bypass_rt = (opcode_d == 5'b0) & ~(alu_opcode_d == 5'b00100) & ~(alu_opcode_d == 5'b00101);
	wire [4:0] rt_d = current_insn_d[16:12];
	wire need_rd_x_rt = (rt_d == rd_x) & consider_bypass_rt & ~rt_d_zero & ~(current_insn_x[31:27] == 5'b00110) & ~(current_insn_x[31:27] == 5'b00010);
	wire need_rd_m_rt = (rt_d == rd) & consider_bypass_rt & ~need_rd_x_rt & ~rt_d_zero & ~(current_insn_m[31:27] == 5'b00110) & ~(current_insn_m[31:27] == 5'b00010);
	wire rt_d_zero = (rt_d == 5'b0)&consider_bypass_rt;
	
	wire isSW_d = (opcode_d == 5'b111);
	wire [4:0] rd_d = current_insn_d[26:22];
	wire need_rd_x_sw = (rd_d == rd_x) & isSW_d & ~rd_d_zero;
	wire need_rd_m_sw = (rd_d == rd) & isSW_d & ~need_rd_x_sw & ~rd_d_zero;
	
	wire rd_d_zero = (rd_d == 5'b0)&isSW_d;
	
	
	
	wire [31:0] to_alu_B;
	wire [4:0] toAluBSelect;
	assign toAluBSelect[0] = (need_rd_x_rt | need_rd_x_sw) & ~statusBypassRt30;
	assign toAluBSelect[1] = (need_rd_m_rt | need_rd_m_sw) & ~statusBypassRt30;
	assign toAluBSelect[2] = (rt_d_zero | rd_d_zero) & ~statusBypassRt30 ;
	assign toAluBSelect[3] = statusBypassRt30;
	assign toAluBSelect[4] = 1'b0;
	mux_32 toAluBMux(.out(to_alu_B), .select(toAluBSelect), .in0(data_readRegB), .in1(to_m_alu_output), .in2(alu_output_m), .in4(32'b0), .in8(status_x));
	
	wire [31:0] toXInsn = (stall) ? 32'b0 : current_insn_d;
	wire [31:0] toXPC = stall ? 32'b0 : current_pc_d;
	register INSN_reg_dx_latch(.in(toXInsn), .out(current_insn_x), .clr(reset), .clk(~clock), .en(INSN_reg_dx_latch_en));
	register pc_reg_dx_latch(.in(toXPC), .out(current_pc_x), .clr(reset), .clk(~clock), .en(pc_reg_x_en));
	register decode_A(.in(to_alu_A), .out(x_a), .clr(reset), .clk(~clock), .en(decode_A_en));
	register decode_B(.in(to_alu_B), .out(x_b), .clr(reset), .clk(~clock), .en(decode_B_en));
	dffe_ref ismultreg(.d((isMult_d & ~multdiv_on) | (isMult_d & multdiv_ready)), .q(isMult_x), .clr(reset), .clk(~clock), .en(isMult_x_en));
	dffe_ref isdivreg(.d((isDiv_d & ~multdiv_on) | (isDiv_d & multdiv_ready)), .q(isDiv_x), .clr(reset), .clk(~clock), .en(isDiv_x_en));
	/* determine run in decode*/
	


	
	// check if R type, Mult, or Div
	
	
	/* END INSTRUCTION DECODE */
	
	/* EXECUTE */
	
	// X INPUTS: current_insn_x, current_pc_x, x_a, x_d
	
	wire [4:0] opcode, alu_opcode, shamt;
	wire [16:0] immediate;
	wire [31:0] immediate_extended;
	
	
	
	
	assign opcode = current_insn_x[31:27];
	assign alu_opcode = current_insn_x[6:2];
	assign shamt = current_insn_x[11:7];
	assign immediate = current_insn_x[16:0];
	extender ex(.in(immediate), .out(immediate_extended));
	
	
	
	
	// check if R type, Mult, or Div
	wire isRType = (opcode == 5'b0);
	wire isMult = opcode && (alu_opcode == 5'd6);
	wire isDiv = isRType && (alu_opcode == 5'd7);
	
	// MULT/DIV Stalling
	wire [31:0] multdiv_result;
	
	wire mult_div_active = (multdiv_on | (multdiv_ready));
	
	wire multsignal;
	xor xor1(multsignal, isMult_d, multdiv_on);
	
	dffe_ref multdiv_onreg(.d(isMult_d | isDiv_d), .q(multdiv_on), .clk(~clock), .en(isMult_d | isDiv_d | multdiv_ready), .clr(reset));
	multdiv multdiv_unit(.data_operandA(x_a), .data_operandB(x_b), .ctrl_MULT(isMult_x), .ctrl_DIV(isDiv_x), .clock(~clock), .data_result(multdiv_result), .data_exception(multdiv_exception), .data_resultRDY(multdiv_ready));
	
	
	wire [4:0] to_alu_opcode;
	wire isAddi = opcode == 5'b101;
	assign to_alu_opcode = isAddi ? 5'b0 : alu_opcode;
	// if R type, send in data A and B
	wire [31:0] in_alu_B = isRType ? x_b : immediate_extended;
	wire [31:0] in_alu_A = isRType ? x_a : x_a;
	
	
	// go into alu 
	wire [31:0] alu_output;
	wire alu_ovf;
	alu alu_unit(.data_operandA(in_alu_A), .data_operandB(in_alu_B), .ctrl_ALUopcode(to_alu_opcode), .ctrl_shiftamt(shamt), .data_result(alu_output), .overflow(alu_ovf));
	// send out the output, instruction, pc
	
	assign to_m_alu_output = (multdiv_ready & multdiv_on) ? multdiv_result : alu_output;
	wire to_m_alu_exception = (multdiv_ready & multdiv_on) ? multdiv_exception : alu_ovf;
	wire [31:0] dataB_m;
	wire INSN_reg_xm_latch_en = run;
	wire pc_reg_xm_latch_en = run;
	wire alu_output_m_latch_en = run;
	wire dataB_reg_xm_latch_en = run;
	wire alu_ovf_m_latch_en = run;
	wire alu_ovf_m;
	wire [4:0] rd_x = current_insn_x[26:22];
	assign opcode_x = current_insn_x[31:27];
	wire alu_opcode_x = current_insn_x[6:2];
	
	
	wire [4:0] statusSelect_x;
	wire is_add_x = (opcode_x == 5'b0 & alu_opcode_x == 5'b0 & to_m_alu_exception);
	wire is_addi_x = (opcode_x == 5'b101 & to_m_alu_exception);
	wire is_sub_x = (opcode_x == 5'b0 & alu_opcode_x == 5'b1 & to_m_alu_exception);
	wire is_mult_x = (opcode_x == 5'b0 & alu_opcode_x == 5'b110 & to_m_alu_exception);
	wire is_div_x = (opcode_x == 5'b0 & alu_opcode_x == 5'b111 & to_m_alu_exception);
	assign statusSelect_x[0] = is_add_x;
	assign statusSelect_x[1] = is_addi_x;
	assign statusSelect_x[2] = is_sub_x;
	assign statusSelect_x[3] = is_mult_x;
	assign statusSelect_x[4] = is_div_x;
	mux_32 getStatus_x(.out(status_x), .select(statusSelect_x), .in0(32'b0), .in1(32'b1), .in2(32'b10), .in4(32'b11), .in8(32'b100), .in16(32'b101));
	
	
	
	
	
	//wire [31:0] alu_output_m;
	wire [31:0] current_pc_m, current_insn_m;
	
	wire flush_insn = is_jal_m;
	wire [31:0] to_next_insn;
	assign to_next_insn = flush_insn ? 32'b0 : current_insn_x;
	
	register INSN_reg_xm_latch(.in(to_next_insn), .out(current_insn_m), .clr(reset), .clk(~clock), .en(INSN_reg_xm_latch_en));
	register pc_reg_xm_latch(.in(current_pc_x), .out(current_pc_m), .clr(reset), .clk(~clock), .en(pc_reg_xm_latch_en));
	register alu_output_m_latch(.in(to_m_alu_output), .out(alu_output_m), .clr(reset), .clk(~clock), .en(alu_output_m_latch_en));
	dffe_ref alu_exception_m_latch(.d(to_m_alu_exception), .q(alu_ovf_m), .clr(reset), .clk(~clock), .en(alu_ovf_m_latch_en));
	assign address_dmem = to_m_alu_output;
	
	/************ BYPASS M->X IF LW->SW ******************/
	wire lw_sw_bypass = ((opcode == 5'b111) & (isLW) & (rd == rd_x));
	
	assign data = lw_sw_bypass ? q_dmem : x_b;
	// if sw, wren = 1, data = x_b (rd), address_dmem = to_m_alu_output(rs+N)
	// if lw in M, rd is different. rd is about to be changed to q_dmem. So, if LW in M, SW in X, data is q_dmem. address_dmem stays the same. only if rd are same
	assign wren = (opcode == 5'b111)&&run;
	register dataB_reg_xm_latch(.in(x_b), .out(dataB_m), .clk(~clock), .en(dataB_reg_xm_latch_en));
	
	
	// X OUTPUTS: current_insn_x, current_pc_x, alu_output
	
	// MEMORY
	
	// when is ctrl_writeEnable on? if opcode == 0, 3, 8, or 4  (alu, addi, lw, jal T)
	
	wire [4:0] opcode_m = current_insn_m[31:27];
	assign ctrl_writeEnable = (~(current_insn_m == 32'b0) & ((opcode_m == 5'b10101) | (opcode_m == 5'b11) | (opcode_m == 5'b0) | (opcode_m == 5'b101) | (opcode_m == 5'b1000))&&(run));
	wire is_jal_m = (opcode_m ==5'b11);
	wire is_setx_m = (opcode_m == 5'b10101);
	wire [26:0] target_m = current_insn_m[26:0];
	wire [31:0] target_ex_m;
	extender_target exmtarget(.in(target_m), .out(target_ex_m));
	wire [4:0] alu_opcode_m = current_insn_m[6:2];
	wire [4:0] rd = current_insn_m[26:22];
	// if jal, write reg should be 31
	
	// if jal, ctrl is d31. if setx, ctrl is 30.
	
	
	wire [31:0] status;
	wire [4:0] statusSelect;
	wire is_add_m = (opcode_m == 5'b0 & alu_opcode_m == 5'b0 & alu_ovf_m);
	wire is_addi_m = (opcode_m == 5'b101 & alu_ovf_m);
	wire is_sub_m = (opcode_m == 5'b0 & alu_opcode_m == 5'b1 & alu_ovf_m);
	wire is_mult_m = (opcode_m == 5'b0 & alu_opcode_m == 5'b110 & alu_ovf_m);
	wire is_div_m = (opcode_m == 5'b0 & alu_opcode_m == 5'b111 & alu_ovf_m);
	assign statusSelect[0] = is_add_m;
	assign statusSelect[1] = is_addi_m;
	assign statusSelect[2] = is_sub_m;
	assign statusSelect[3] = is_mult_m;
	assign statusSelect[4] = is_div_m;
	mux_32 getStatus(.out(status), .select(statusSelect), .in0(32'b0), .in1(32'b1), .in2(32'b10), .in4(32'b11), .in8(32'b100), .in16(32'b101));
	
	wire [2:0] ctrlMuxSelect;
	assign ctrlMuxSelect[0] = is_jal_m;
	assign ctrlMuxSelect[1] = is_setx_m | (~(status == 32'b0));
	assign ctrlMuxSelect[2] = 1'b0;
	mux_8_5 ctrlWriteRegMux(.out(ctrl_writeReg), .select(ctrlMuxSelect), .in0(rd), .in1(5'd31), .in2(5'd30));
	// assign ctrl_writeReg = rd;
	// if lw, data should be q_dmem. if jal, data should be current pc + 1. if neither, data should be alu_output_m
	wire isLW = (opcode_m) == 5'b1000;
	wire [4:0] dataWriteSelect;
	assign dataWriteSelect[0] = isLW;
	assign dataWriteSelect[1] = is_jal_m;
	assign dataWriteSelect[2] = is_setx_m;
	assign dataWriteSelect[3] = ~(status == 32'b0);
	assign dataWriteSelect[4] = 5'b0;
	wire [31:0] data_writeReg_before;
	wire [31:0] pc_plus_one_m;
	alu addtopc(.data_operandA(current_pc_m), .data_operandB(32'b1), .ctrl_ALUopcode(5'b0), .data_result(pc_plus_one_m));
	mux_32 data_writeRegmux(.out(data_writeReg_before), .select(dataWriteSelect), .in0(alu_output_m), .in1(q_dmem), .in2(pc_plus_one_m), .in4(target_ex_m), .in8(status));
	wire isReg0 = (ctrl_writeReg == 5'b0);
	assign data_writeReg = isReg0 ? 32'b0 : data_writeReg_before;
	// ASSIGN Stalling
	assign run = ~multdiv_on | multdiv_ready;
	
	
	// If lw, wren = 0, write enable on
	
	// If sw, wren = 1, send rd (data) into address (alu output)
	
	//assign address_dmem = alu_output_m;
	//assign data = dataB_m;
	
	/* END CODE */

endmodule
