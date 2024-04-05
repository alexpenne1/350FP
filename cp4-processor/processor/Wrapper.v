`timescale 1ns / 1ps
/**
 * 
 * READ THIS DESCRIPTION:
 *
 * This is the Wrapper module that will serve as the header file combining your processor, 
 * RegFile and Memory elements together.
 *
 * This file will be used to generate the bitstream to upload to the FPGA.
 * We have provided a sibling file, Wrapper_tb.v so that you can test your processor's functionality.
 * 
 * We will be using our own separate Wrapper_tb.v to test your code. You are allowed to make changes to the Wrapper files 
 * for your own individual testing, but we expect your final processor.v and memory modules to work with the 
 * provided Wrapper interface.
 * 
 * Refer to Lab 5 documents for detailed instructions on how to interface 
 * with the memory elements. Each imem and dmem modules will take 12-bit 
 * addresses and will allow for storing of 32-bit values at each address. 
 * Each memory module should receive a single clock. At which edges, is 
 * purely a design choice (and thereby up to you). 
 * 
 * You must change line 36 to add the memory file of the test you created using the assembler
 * For example, you would add sample inside of the quotes on line 38 after assembling sample.s
 *
 **/

module Wrapper (LED, BTNL, CLK100MHZ, CPU_RESETN, VGA_R, VGA_B, VGA_G, ps2_clk, ps2_data, hSync, vSync, BTNR, BTNU, BTND);
	input CLK100MHZ;
	input BTNL, BTNU, BTNR, BTND, CPU_RESETN;
	output[3:0] VGA_R;  // Red Signal Bits
	output[3:0] VGA_G;  // Green Signal Bits
	output[3:0] VGA_B;  // Blue Signal Bits
	output hSync, vSync;
	inout ps2_clk;
	inout ps2_data;
	output [15:0] LED;
	
	/* VGA SELECT GATE */
	reg [4:0] gate_select = 5'd1;
	
	/* Move Right */
	always @(posedge BTNR) begin
	   if (gate_select == 5'd8) begin
	       gate_select = 5'd1;
	   end else if (gate_select == 5'd16) begin
	       gate_select = 5'd9;
	   end else if (gate_select == 5'd18) begin
	       gate_select = 5'd17;
	   end else begin
	       gate_select = gate_select +1;
	   end
	end
	
	/* Move Left */
	always @(posedge BTNL) begin
	   if (gate_select == 5'd1) begin
	       gate_select = 5'd8;
	   end else if (gate_select == 5'd9) begin
	       gate_select = 5'd16;
	   end else if (gate_select == 5'd17) begin
	       gate_select = 5'd18;
	   end else begin
	       gate_select = gate_select -1;
	   end
	end
	
	/* Move Up */
	always @(posedge BTNU) begin
	   if (gate_select == 5'd17) begin
	       gate_select = 5'd10;
	   end else if (gate_select == 5'd18) begin
	       gate_select = 5'd15;
	   end else if (gate_select > 8 && gate_select < 17) begin
	       gate_select = gate_select - 8;
	   end
	end
	
	/* Move Down */
	always @(posedge BTND) begin
	   if (gate_select > 8 && gate_select < 13) begin
	       gate_select = 5'd17;
	   end else if (gate_select > 12 && gate_select < 17) begin
	       gate_select = 5'd18;
	   end else if (gate_select > 0 && gate_select < 9) begin
	       gate_select = gate_select + 8;
	   end
	end
	
	/* MAP GATE SELECT TO CENTER BIT, MAKE BORDER */
	
	
	
	/* VGA SCREEN */
	wire [7:0] rx_data;
	wire read_data;
	Ps2Interface psiface(.rx_data(rx_data), .read_data(read_data), .clk(CLK100MHZ), .ps2_clk(ps2_clk), .ps2_data(ps2_data));
	
	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock
    wire clkSlow;
	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
	reg[20:0] pixCounter2 = 0;
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
    assign clkSlow = pixCounter2[20];   
	always @(posedge CLK100MHZ) begin
		pixCounter <= pixCounter + 1; // Since the reg is only 3 bits, it will reset every 8 cycles
		pixCounter2 <= pixCounter2 + 1;
	end
	
	// VGA Timing Generation for a Standard VGA Screen
	localparam 
		VIDEO_WIDTH = 640,  // Standard VGA Width
		VIDEO_HEIGHT = 480; // Standard VGA Height

	wire active, screenEnd;
	wire[9:0] x;
	wire[8:0] y;
	
	VGATimingGenerator #(
		.HEIGHT(VIDEO_HEIGHT), // Use the standard VGA Values
		.WIDTH(VIDEO_WIDTH))
	Display( 
		.clk25(clk25),  	   // 25MHz Pixel Clock
		.reset(reset),		   // Reset Signal
		.screenEnd(screenEnd), // High for one cycle when between two frames
		.active(active),	   // High when drawing pixels
		.hSync(hSync),  	   // Set Generated H Signal
		.vSync(vSync),		   // Set Generated V Signal
		.x(x), 				   // X Coordinate (from left)
		.y(y)); 			   // Y Coordinate (from top)	  
	
	// Image Data to Map Pixel Location to Color Address
	localparam 
		PIXEL_COUNT = VIDEO_WIDTH*VIDEO_HEIGHT, 	             // Number of pixels on the screen
		PIXEL_ADDRESS_WIDTH = $clog2(PIXEL_COUNT) + 1,           // Use built in log2 command
		BITS_PER_COLOR = 12, 	  								 // Nexys A7 uses 12 bits/color
		PALETTE_COLOR_COUNT = 256, 								 // Number of Colors available
		PALETTE_ADDRESS_WIDTH = $clog2(PALETTE_COLOR_COUNT) + 1; // Use built in log2 Command

	wire[PIXEL_ADDRESS_WIDTH-1:0] imgAddress;  	 // Image address for the image data
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddr; 	 // Color address for the color palette
	assign imgAddress = x + 640*y;				 // Address calculated coordinate

	RAM_VGA #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE("image.mem")) // Memory initialization
	ImageData(
		.clk(CLK100MHZ), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading
	
	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
    
	RAM_VGA #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE("colors.mem"))  // Memory initialization
	ColorPalette(
		.clk(CLK100MHZ), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading


    wire [6:0] asciiCode;
	RAM_VGA #(
	   .DEPTH(128),
	   .DATA_WIDTH(7),
	   .ADDRESS_WIDTH(7),
	   .MEMFILE("ascii.mem"))
	Key(
	   .clk(CLK100MHZ),
	   .addr(key_data),
	   .dataOut(asciiCode),
	   .wEn(1'b0));
	   
	localparam
	   NUMBER_OF_SPRITES = 94,
	   SPRITE_WIDTH = 50,
	   SPRITE_AREA = 2500,
	   SPRITE_ADDR_WIDTH = $clog2(NUMBER_OF_SPRITES * SPRITE_AREA) + 1;
    
	wire spriteOut;
	RAM_VGA #(
	   .DEPTH(NUMBER_OF_SPRITES * SPRITE_AREA),
	   .DATA_WIDTH(1),
	   .ADDRESS_WIDTH(SPRITE_ADDR_WIDTH),
	   .MEMFILE("sprites.mem"))
	Sprite(
	   .clk(CLK100MHZ),
	   .addr((asciiCode - 1) * SPRITE_AREA + x - ref_pointx + SPRITE_WIDTH * (y - ref_pointy)),
	   .dataOut(spriteOut),
	   .wEn(1'b0));
	   




    	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorData : 12'd0; // When not active, output active
	
	assign {VGA_R, VGA_G, VGA_B} = colorOut;
	
	wire [11:0] spriteColor;
	assign spriteColor = {{12{spriteOut}}};
	
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
	
	assign LED[3:0] = VGA_B[3:0];
	assign LED[7:4] = VGA_R[3:0];
	assign LED[11:8] = VGA_G[3:0];
	assign LED[15] = active;
	assign LED[14] = 1'b0;
	assign LED[13] = 1'b0;
	assign LED[12] = 1'b0;
	wire reset = ~CPU_RESETN;
	

assign clock = BTNL;
	// ADD YOUR MEMORY FILE HERE
	localparam INSTR_FILE = "add_test";
	
	// Main Processing Unit
	processor CPU(.clock(clock), .reset(reset), 
								
		// ROM
		.address_imem(instAddr), .q_imem(instData),
									
		// Regfile
		.ctrl_writeEnable(rwe),     .ctrl_writeReg(rd),
		.ctrl_readRegA(rs1),     .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB),
									
		// RAM
		.wren(mwe), .address_dmem(memAddr), 
		.data(memDataIn), .q_dmem(memDataOut)); 
	
	// Instruction Memory (ROM)
	ROM #(.MEMFILE({INSTR_FILE, ".mem"}))
	InstMem(.clk(clock), 
		.addr(instAddr[11:0]), 
		.dataOut(instData));
	
	// Register File
	regfile RegisterFile(.clock(clock), 
		.ctrl_writeEnable(rwe), .ctrl_reset(reset), 
		.ctrl_writeReg(rd),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(rData), .data_readRegA(regA), .data_readRegB(regB));
						
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddr[11:0]), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
