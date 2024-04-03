module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;
	
	// my code
	
	wire [31:0] enableWR; // enable wires
	wire [31:0] enableRRA; // enable wires
	wire [31:0] enableRRB; // enable wires
	
	decode enableWiresWR(ctrl_writeReg, enableWR, ctrl_writeEnable);
	decode enableWiresRRA(ctrl_readRegA, enableRRA, 1'b1);
	decode enableWiresRRB(ctrl_readRegB, enableRRB, 1'b1);
	
	wire [31:0] out [31:0]; // outputs from registers
	
	// do 0th register
	assign out[0] = 32'b0;
	assign data_readRegA = enableRRA[0] ? out[0] : 32'bz;
	assign data_readRegB = enableRRB[0] ? out[0] : 32'bz;
	
	
	genvar c;
	generate
		for (c = 1; c < 32; c = c + 1) begin: loop1
			
			register a_register(data_writeReg, out[c], clock, enableWR[c], ctrl_reset);
			
			// need muxes or tristate buffers to decide which values to read
			assign data_readRegA = enableRRA[c] ? out[c] : 32'bz;
			assign data_readRegB = enableRRB[c] ? out[c] : 32'bz;
			
			
		end
	endgenerate

endmodule
