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

module Wrapper (LED, BTNL, CLK100MHZ, CPU_RESETN, VGA_R, VGA_B, VGA_G, ps2_clk, ps2_data, hSync, vSync, BTNR, BTNU, BTND, BTNC);
	input CLK100MHZ;
	input BTNL, BTNU, BTNR, BTND, BTNC, CPU_RESETN;
	output[3:0] VGA_R;  // Red Signal Bits
	output[3:0] VGA_G;  // Green Signal Bits
	output[3:0] VGA_B;  // Blue Signal Bits
	output hSync, vSync;
	inout ps2_clk;
	inout ps2_data;
	output [15:0] LED;
	
	/* VGA SELECT GATE */
	reg [4:0] gate_select = 5'd1;
	
	/* for every clock cycle, check if button pressed */
	always @(posedge clkSlow) begin
	
	   if (BTNR) begin
	       if (gate_select == 5'd8) begin
	           gate_select = 5'd1;
	       end else if (gate_select == 5'd16) begin
	           gate_select = 5'd9;
	       end else if (gate_select == 5'd18) begin
	           gate_select = 5'd17;
	       end else begin
	           gate_select = gate_select +1;
	       end 
	   end else if (BTNL) begin
	       if (gate_select == 5'd1) begin
	           gate_select = 5'd8;
	       end else if (gate_select == 5'd9) begin
	           gate_select = 5'd16;
	       end else if (gate_select == 5'd17) begin
	           gate_select = 5'd18;
	       end else begin
	           gate_select = gate_select -1;
	       end
	   end else if (BTNU) begin
	       if (gate_select == 5'd17) begin
	           gate_select = 5'd10;
	       end else if (gate_select == 5'd18) begin
	           gate_select = 5'd15;
	       end else if (gate_select > 8 && gate_select < 17) begin
	           gate_select = gate_select - 8;
	       end
	   end else if (BTND) begin
	       if (gate_select > 8 && gate_select < 13) begin
	           gate_select = 5'd17;
	       end else if (gate_select > 12 && gate_select < 17) begin
	           gate_select = 5'd18;
	       end else if (gate_select > 0 && gate_select < 9) begin
	           gate_select = gate_select + 8;
	       end
	    end
	end
	
	/* Map Gate Select to Center Bit */
	
	reg [9:0] center_x = 10'd44;
	reg [8:0] center_y = 9'd43;
	reg [9:0] x_min = 10'd32;
	reg [9:0] x_max = 10'd36;
	reg [8:0] y_min = 10'd34;
	reg [8:0] y_max = 10'd38;
	always @(gate_select) begin
	
	   if (gate_select == 5'd17) begin
	       x_min = 10'd128;
	       x_max = 10'd132;
	       y_min = 10'd34;
	       y_max = 10'd38;
	       
	   end else if (gate_select == 5'd18) begin
	       x_min = 10'd104;
	       x_max = 10'd108;
	       y_min = 10'd34;
	       y_max = 10'd38;
	   end else begin
	       x_min = 10'd32;
	       x_max = 10'd36;
	       y_min = 10'd34;
	       y_max = 10'd38;
	   end
	
	   
	   if (gate_select == 5'd1) begin
	       center_x = 10'd44;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd2) begin
	       center_x = 10'd121;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd3) begin
	       center_x = 10'd200;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd4) begin
	       center_x = 10'd278;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd5) begin
	       center_x = 10'd357;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd6) begin
	       center_x = 10'd433;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd7) begin
	       center_x = 10'd512;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd8) begin
	       center_x = 10'd590;
	       center_y = 9'd43;
	   end else if (gate_select == 5'd9) begin
	       center_x = 10'd45;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd10) begin
	       center_x = 10'd121;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd11) begin
	       center_x = 10'd200;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd12) begin
	       center_x = 10'd278;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd13) begin
	       center_x = 10'd357;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd14) begin
	       center_x = 10'd433;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd15) begin
	       center_x = 10'd512;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd16) begin
	       center_x = 10'd590;
	       center_y = 9'd123;
	   end else if (gate_select == 5'd17) begin
	       center_x = 10'd167;
	       center_y = 9'd207;
	   end else if (gate_select == 5'd18) begin
	       center_x = 10'd498;
	       center_y = 9'd207;
	   end
	end
	
	/* MAKE BORDER */
	wire isInBorderX = (((x >= (center_x - x_max)) & (x <= (center_x - x_min))) | ((x >= (center_x + x_min)) & (x <= (center_x + x_max)))) & (((y <= center_y + y_max) & (y >= center_y - y_max)));
	wire isInBorderY = (((y >= (center_y - y_max)) & (y <= (center_y - y_min))) | ((y >= (center_y + y_min)) & (y <= (center_y + y_max)))) & (((x <= center_x + x_max) & (x >= center_x - x_max)));
	wire isInBorder = (~isDoneWire) & (isInBorderX | isInBorderY);
	reg simulateReady = 1'b0;
	reg[3:0] num_gates = 4'b0;
	reg[4:0] gate_1 = 5'b0;
	reg[4:0] gate_2 = 5'b0;
	reg[4:0] gate_3 = 5'b0;
	reg[4:0] gate_4 = 5'b0;
	reg[4:0] gate_5 = 5'b0;
	
	reg[9:0] gate_1_cx = 10'd0;
	reg[9:0] gate_2_cx = 10'd0;
	reg[9:0] gate_3_cx = 10'd0;
	reg[9:0] gate_4_cx = 10'd0;
	reg[9:0] gate_5_cx = 10'd0;
	
	reg[8:0] gate_1_cy = 9'd0;
	reg[8:0] gate_2_cy = 9'd0;
	reg[8:0] gate_3_cy = 9'd0;
	reg[8:0] gate_4_cy = 9'd0;
	reg[8:0] gate_5_cy = 9'd0;
	
	/* SELECTING GATES */
	always @(posedge BTNC) begin
	   if (gate_select == 5'd18) begin
	       num_gates = 4'b0;
	       gate_1 = 5'b0;
	       gate_2 = 5'b0;
	       gate_3 = 5'b0;
	       gate_4 = 5'b0;
	       gate_5 = 5'b0;
	       
	       gate_1_cx = 10'd0;
	       gate_2_cx = 10'd0;
	       gate_3_cx = 10'd0;
	       gate_4_cx = 10'd0;
	       gate_5_cx = 10'd0;
	
	       gate_1_cy = 9'd0;
	       gate_2_cy = 9'd0;
	       gate_3_cy = 9'd0;
           gate_4_cy = 9'd0;
	       gate_5_cy = 9'd0;
	       
	   end else if (gate_select == 5'd17) begin
	       simulateReady = 1'b1;
	   end else begin
	       if (num_gates == 4'd0) begin
	           gate_1 = gate_select;
	           gate_1_cx = center_x;
	           gate_1_cy = center_y;
	           num_gates = num_gates + 1;
	       end else if (num_gates == 4'd1) begin
	           gate_2 = gate_select;
	           gate_2_cx = center_x;
	           gate_2_cy = center_y;
	           num_gates = num_gates + 1;
	       end else if (num_gates == 4'd2) begin
	           gate_3 = gate_select;
	           gate_3_cx = center_x;
	           gate_3_cy = center_y;
	           num_gates = num_gates + 1;
	       end else if (num_gates == 4'd3) begin
	           gate_4 = gate_select;
	           gate_4_cx = center_x;
	           gate_4_cy = center_y;
	           num_gates = num_gates + 1;
	       end else if (num_gates == 4'd4) begin
	           gate_5 = gate_select;
	           gate_5_cx = center_x;
	           gate_5_cy = center_y;
	           num_gates = num_gates + 1;
	       end
	   end
	end
	
	
	
	
	
	
    /* VGA SCREEN TIMING */
	wire [7:0] rx_data;
	wire read_data;
	Ps2Interface psiface(.rx_data(rx_data), .read_data(read_data), .clk(CLK100MHZ), .ps2_clk(ps2_clk), .ps2_data(ps2_data));
	
	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock
    wire clkSlow;
	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
	reg[23:0] pixCounter2 = 0;
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
    assign clkSlow = pixCounter2[23];   
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
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddrStat; 	 // Color address for the color palette
	wire[PALETTE_ADDRESS_WIDTH-1:0] colorAddrCircuit; 	 // Color address for the color palette
	reg[PIXEL_ADDRESS_WIDTH-1:0] curImgAddress =0;
	reg[PIXEL_ADDRESS_WIDTH-1:0] initImgAddress=0;
	reg[PIXEL_ADDRESS_WIDTH-1:0] blankAddr =0;
	wire isDoneWire;
	assign isDoneWire = isDone;
	assign imgAddress = curImgAddress;
	wire[9:0] a1cx = 10'd100;
	wire[8:0] a1cy = 9'd328;
	wire[9:0] a2cx = 10'd210;
	wire[8:0] a2cy = 9'd328;
	wire[9:0] a3cx = 10'd320;
	wire[8:0] a3cy = 9'd328;
	wire[9:0] a4cx = 10'd430;
	wire[8:0] a4cy = 9'd328;
	wire[9:0] a5cx = 10'd540;
	wire[8:0] a5cy = 9'd328;
	
	wire[9:0] b1cx = 10'd100;
	wire[8:0] b1cy = 9'd430;
	wire[9:0] b2cx = 10'd210;
	wire[8:0] b2cy = 9'd430;
	wire[9:0] b3cx = 10'd320;
	wire[8:0] b3cy = 9'd430;
	wire[9:0] b4cx = 10'd430;
	wire[8:0] b4cy = 9'd430;
	wire[9:0] b5cx = 10'd540;
	wire[8:0] b5cy = 9'd430;
	
	wire[9:0] x_square_max = 10'd36;
	wire[8:0] y_square_max = 9'd38;
	
	
	
	
	wire isInA1Gate = ((x >= (a1cx - x_square_max)) & (x <= (a1cx + x_square_max))) & ((y >= (a1cy - y_square_max)) & (y <= (a1cy + y_square_max)));
	wire isInB1Gate = ((x >= (b1cx - x_square_max)) & (x <= (b1cx + x_square_max))) & ((y >= (b1cy - y_square_max)) & (y <= (b1cy + y_square_max)));
	wire isInA2Gate = ((x >= (a2cx - x_square_max)) & (x <= (a2cx + x_square_max))) & ((y >= (a2cy - y_square_max)) & (y <= (a2cy + y_square_max)));
	wire isInB2Gate = ((x >= (b2cx - x_square_max)) & (x <= (b2cx + x_square_max))) & ((y >= (b2cy - y_square_max)) & (y <= (b2cy + y_square_max)));
	wire isInA3Gate = ((x >= (a3cx - x_square_max)) & (x <= (a3cx + x_square_max))) & ((y >= (a3cy - y_square_max)) & (y <= (a3cy + y_square_max)));
	wire isInB3Gate = ((x >= (b3cx - x_square_max)) & (x <= (b3cx + x_square_max))) & ((y >= (b3cy - y_square_max)) & (y <= (b3cy + y_square_max)));
	wire isInA4Gate = ((x >= (a4cx - x_square_max)) & (x <= (a4cx + x_square_max))) & ((y >= (a4cy - y_square_max)) & (y <= (a4cy + y_square_max)));
	wire isInB4Gate = ((x >= (b4cx - x_square_max)) & (x <= (b4cx + x_square_max))) & ((y >= (b4cy - y_square_max)) & (y <= (b4cy + y_square_max)));
	wire isInA5Gate = ((x >= (a5cx - x_square_max)) & (x <= (a5cx + x_square_max))) & ((y >= (a5cy - y_square_max)) & (y <= (a5cy + y_square_max)));
	wire isInB5Gate = ((x >= (b5cx - x_square_max)) & (x <= (b5cx + x_square_max))) & ((y >= (b5cy - y_square_max)) & (y <= (b5cy + y_square_max)));
	
	reg[9:0] x_offset=0;
	reg[8:0] y_offset=0;
	reg[9:0] new_x =0;
	reg[8:0] new_y =0;
	
	reg[8:0] p_a = 100;
	reg[8:0] p_b = 50;
	always @(x) begin
	   initImgAddress = x + 640*y;
	   /*vert line */
	   if ((x > 10'd135) & (x < 10'd140) & (y > 9'd154) & (y < 9'd415)) begin
	       colorDataStat = 12'b0;
	   /*a*/
	   end else if ((x > 10'd173) & (x < 10'd270) & (y > (9'd413 - (p_a << 1))) & (y < 9'd413)) begin
	       colorDataStat = 12'b111000000;
	   /*b*/
	   end else if ((x > 10'd397) & (x < 10'd495) & (y > (9'd413 - (p_b << 1))) & (y < 9'd413)) begin
	       colorDataStat = 12'b000111000;
	   /*1*/
	   end else if ((x > 10'd120) & (x < 10'd127) & (y > 9'd154) & (y < 9'd190)) begin
	       colorDataStat = 12'b0;
	   /*0*/
	   end else if ((x > 10'd115) & (x < 10'd120) & (y > 9'd380) & (y < 9'd415)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd125) & (x < 10'd130) & (y > 9'd380) & (y < 9'd415)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd115) & (x < 10'd130) & (y > 9'd380) & (y < 9'd385)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd115) & (x < 10'd130) & (y > 9'd410) & (y < 9'd415)) begin
	       colorDataStat = 12'b0;
	   /*horizontal line */
	   end else if ((x > 10'd135) & (x < 10'd530) & (y > 9'd410) & (y < 9'd415)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd200) & (x < 10'd235) & (y > 9'd437) & (y < 9'd445)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd200) & (x < 10'd210) & (y > 9'd444) & (y < 9'd470)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd225) & (x < 10'd235) & (y > 9'd444) & (y < 9'd470)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd200) & (x < 10'd235) & (y > 9'd455) & (y < 9'd460)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd415) & (x < 10'd425) & (y > 9'd437) & (y < 9'd470)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd415) & (x < 10'd450) & (y > 9'd437) & (y < 9'd442)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd415) & (x < 10'd450) & (y > 9'd465) & (y < 9'd470)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd415) & (x < 10'd450) & (y > 9'd451) & (y < 9'd455)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd450) & (x < 10'd457) & (y > 9'd442) & (y < 9'd451)) begin
	       colorDataStat = 12'b0;
	   end else if ((x > 10'd450) & (x < 10'd457) & (y > 9'd455) & (y < 9'd465)) begin
	       colorDataStat = 12'b0;
	   end else begin
	       colorDataStat = 12'b111111111111;
	   end
	   
	   
	   
	   if (isInA1Gate) begin
	       if ((gate_1 == 5'd1) |(gate_1 == 5'd2) |(gate_1 == 5'd3) |(gate_1 == 5'd4) |(gate_1 == 5'd9) |(gate_1 == 5'd10) |(gate_1 == 5'd11) |(gate_1 == 5'd12)) begin
	           x_offset = x - a1cx;
	           y_offset = y - a1cy;
	           new_x = gate_1_cx + x_offset;
	           new_y = gate_1_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	   end else if (isInB1Gate) begin
	       if ((gate_1 == 5'd5) |(gate_1 == 5'd6) |(gate_1 == 5'd7) |(gate_1 == 5'd8) |(gate_1 == 5'd13) |(gate_1 == 5'd14) |(gate_1 == 5'd15) |(gate_1 == 5'd16)) begin
	           x_offset = x - b1cx;
	           y_offset = y - b1cy;
	           new_x = gate_1_cx + x_offset;
	           new_y = gate_1_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	   end else if (isInA2Gate) begin
	       if ((gate_2 == 5'd1) |(gate_2 == 5'd2) |(gate_2 == 5'd3) |(gate_2 == 5'd4) |(gate_2 == 5'd9) |(gate_2 == 5'd10) |(gate_2 == 5'd11) |(gate_2 == 5'd12)) begin
	           x_offset = x - a2cx;
	           y_offset = y - a2cy;
	           new_x = gate_2_cx + x_offset;
	           new_y = gate_2_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	   end else if (isInB2Gate) begin
	       if ((gate_2 == 5'd5) |(gate_2 == 5'd6) |(gate_2 == 5'd7) |(gate_2 == 5'd8) |(gate_2 == 5'd13) |(gate_2 == 5'd14) |(gate_2 == 5'd15) |(gate_2 == 5'd16)) begin
	           x_offset = x - b2cx;
	           y_offset = y - b2cy;
	           new_x = gate_2_cx + x_offset;
	           new_y = gate_2_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	   end else if (isInA3Gate) begin
	       if ((gate_3 == 5'd1) |(gate_3 == 5'd2) |(gate_3 == 5'd3) |(gate_3 == 5'd4) |(gate_3 == 5'd9) |(gate_3 == 5'd10) |(gate_3 == 5'd11) |(gate_3 == 5'd12)) begin
	           x_offset = x - a3cx;
	           y_offset = y - a3cy;
	           new_x = gate_3_cx + x_offset;
	           new_y = gate_3_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	   end else if (isInB3Gate) begin
	       if ((gate_3 == 5'd5) |(gate_3 == 5'd6) |(gate_3 == 5'd7) |(gate_3 == 5'd8) |(gate_3 == 5'd13) |(gate_3 == 5'd14) |(gate_3 == 5'd15) |(gate_3 == 5'd16)) begin
	           x_offset = x - b3cx;
	           y_offset = y - b3cy;
	           new_x = gate_3_cx + x_offset;
	           new_y = gate_3_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	  end else if (isInA4Gate) begin
	       if ((gate_4 == 5'd1) |(gate_4 == 5'd2) |(gate_4 == 5'd3) |(gate_4 == 5'd4) |(gate_4 == 5'd9) |(gate_4 == 5'd10) |(gate_4 == 5'd11) |(gate_4 == 5'd12)) begin
	           x_offset = x - a4cx;
	           y_offset = y - a4cy;
	           new_x = gate_4_cx + x_offset;
	           new_y = gate_4_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	   end else if (isInB4Gate) begin
	       if ((gate_4 == 5'd5) |(gate_4 == 5'd6) |(gate_4 == 5'd7) |(gate_4 == 5'd8) |(gate_4 == 5'd13) |(gate_4 == 5'd14) |(gate_4 == 5'd15) |(gate_4 == 5'd16)) begin
	           x_offset = x - b4cx;
	           y_offset = y - b4cy;
	           new_x = gate_4_cx + x_offset;
	           new_y = gate_4_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end   
	       
	   end else if (isInA5Gate) begin
	       if ((gate_5 == 5'd1) |(gate_5 == 5'd2) |(gate_5 == 5'd3) |(gate_5 == 5'd4) |(gate_5 == 5'd9) |(gate_5 == 5'd10) |(gate_5 == 5'd11) |(gate_5 == 5'd12)) begin
	           x_offset = x - a5cx;
	           y_offset = y - a5cy;
	           new_x = gate_5_cx + x_offset;
	           new_y = gate_5_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end
	       
	   end else if (isInB5Gate) begin
	       if ((gate_5 == 5'd5) |(gate_5 == 5'd6) |(gate_5 == 5'd7) |(gate_5 == 5'd8) |(gate_5 == 5'd13) |(gate_5 == 5'd14) |(gate_5 == 5'd15) |(gate_5 == 5'd16)) begin
	           x_offset = x - b5cx;
	           y_offset = y - b5cy;
	           new_x = gate_5_cx + x_offset;
	           new_y = gate_5_cy + y_offset;
	           curImgAddress = new_x + 640*new_y;
	           
	       end else begin 
	           curImgAddress = x + 640*y;		 // Address calculated coordinate
	       end  
	   
	       
	   end else begin
	       curImgAddress = x + 640*y;		 // Address calculated coordinate
	   end
	   
	
	end
	
	/* stat image objects */

	

	RAM_VGA #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE("image.mem")) // Memory initialization
	ImageData(
		.clk(CLK100MHZ), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddrCircuit),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading
	
	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel
	reg[BITS_PER_COLOR-1:0] colorDataStat=0; // 12-bit color data at current pixel
	wire[BITS_PER_COLOR-1:0] colorDataCircuit; // 12-bit color data at current pixel
	
    assign colorAddr = colorAddrCircuit;
    
    
	RAM_VGA #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE("colors.mem"))  // Memory initialization
	ColorPalette(
		.clk(CLK100MHZ), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorDataCircuit),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
		

	
		
		

    
	
    
	
	   

    reg [9:0] percent_a = 75;
    reg [9:0] percent_b = 25;
    
    


    	// Assign to output color from register if active
    
    assign colorData = isDoneWire ? colorDataStat : colorDataCircuit;
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorData : 12'd0; // When not active, output active
	assign LED[0] = isDoneWire;
	assign LED[1] = active;
	assign LED[2] = isInBorder;
	assign LED[5:3] = VGA_R;
	wire [11:0] borderColor = 12'b0;
	
	assign {VGA_R, VGA_G, VGA_B} = isInBorder ? borderColor : colorOut;
	
	
	
	wire rwe, mwe;
	wire[4:0] rd, rs1, rs2;
	wire[31:0] instAddr, instData, 
		rData, regA, regB,
		memAddr, memDataIn, memDataOut;
	
	
	
	
	
	wire[31:0] reg1_value;
	
	dffe_ref reg1_latch_1(.q(reg1_value[0]), .d(dataToWrite[0]), .en((regToWrite==5'd8)), .clr(1'b0), .clk(clock));
	dffe_ref reg1_latch_2(.q(reg1_value[1]), .d(dataToWrite[1]), .en((regToWrite==5'd8)), .clr(1'b0), .clk(clock));
	dffe_ref reg1_latch_3(.q(reg1_value[2]), .d(dataToWrite[2]), .en((regToWrite==5'd8)), .clr(1'b0), .clk(clock));
	dffe_ref reg1_latch_4(.q(reg1_value[3]), .d(dataToWrite[3]), .en((regToWrite==5'd8)), .clr(1'b0), .clk(clock));
	dffe_ref reg1_latch_5(.q(reg1_value[4]), .d(dataToWrite[4]), .en((regToWrite==5'd8)), .clr(1'b0), .clk(clock));
	assign LED[15] = isReallyDone;
	
	/* check reg 8 to see if done */
	
	
	
	
	wire reset = ~CPU_RESETN;
	
	/* If selecting gate, put that value into a register. */
	/* $1: gate1
	   $2: gate2
	   ...
	   */
	   
	reg[4:0] regToWrite = 0;
    reg[31:0] dataToWrite = 0;
    reg enableWrite = 0;
    
    reg isDone = 0;
    
always @(posedge clock) begin

    if (instAddr > 32'd1000) begin
        memWriteEnable = 1'b0;
        memAddrIn = 32'd21;
        
    end else begin
        memWriteEnable = mwe;
        memAddrIn = memAddr[11:0];
    end

    
    if (~isDone) begin
    if (BTNC) begin
    
        if (gate_select == 5'd17) begin
            regToWrite = 5'd6;
            dataToWrite = 32'd999;
            enableWrite = 1'b1;
            isDone = 1;
        end else begin
            regToWrite[4] = 1'b0;
            regToWrite[3:0] = num_gates;
            
            
            dataToWrite = gate_select;
            enableWrite = 1'b1;
        end
        
    end else begin
        regToWrite = rd;
        dataToWrite = rData;
        enableWrite = rwe;
        
    end
    
    end else begin
        regToWrite = rd;
        dataToWrite = rData;
        enableWrite = rwe;
    end
    
    
    /* end sequence from assembly */
    
end	

assign clock = CLK100MHZ;
localparam INSTR_FILE = "matrixmult";
	
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
		.ctrl_writeEnable(enableWrite), .ctrl_reset(reset), 
		.ctrl_writeReg(regToWrite),
		.ctrl_readRegA(rs1), .ctrl_readRegB(rs2), 
		.data_writeReg(dataToWrite), .data_readRegA(regA), .data_readRegB(regB));
		
	/* if done, want to get the matrix data and set to LED */

	
	wire isReallyDone = instAddr >= 32'd1000;
	reg [31:0] memAddrIn = 0;
	reg memWriteEnable = 0;
				
	// Processor Memory (RAM)
	RAM ProcMem(.clk(clock), 
		.wEn(mwe), 
		.addr(memAddrIn), 
		.dataIn(memDataIn), 
		.dataOut(memDataOut));

endmodule
