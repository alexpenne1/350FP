`timescale 1 ns/ 100 ps
module VGAController(     
	input clk, 			// 100 MHz System Clock
	input reset, 		// Reset Signal
	input BTNU, 
	input BTND, 
	input BTNL, 
	input BTNR,
	output hSync, 		// H Sync Signal
	output vSync, 		// Veritcal Sync Signal
	output[3:0] VGA_R,  // Red Signal Bits
	output[3:0] VGA_G,  // Green Signal Bits
	output[3:0] VGA_B,  // Blue Signal Bits
	inout ps2_clk,
	inout ps2_data);
	
	// Lab Memory Files Location
	localparam FILES_PATH = "C:/Users/adp69/OneDrive - Duke University/Senior/ECE350/Lab6/lab6-7_kit/lab6_kit/";
	
	wire [7:0] rx_data;
	wire read_data;
	Ps2Interface psiface(.rx_data(rx_data), .read_data(read_data), .clk(clk), .ps2_clk(ps2_clk), .ps2_data(ps2_data));

	// Clock divider 100 MHz -> 25 MHz
	wire clk25; // 25MHz clock
    wire clkSlow;
	reg[1:0] pixCounter = 0;      // Pixel counter to divide the clock
	reg[20:0] pixCounter2 = 0;
    assign clk25 = pixCounter[1]; // Set the clock high whenever the second bit (2) is high
    assign clkSlow = pixCounter2[20];   
	always @(posedge clk) begin
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

	RAM #(		
		.DEPTH(PIXEL_COUNT), 				     // Set RAM depth to contain every pixel
		.DATA_WIDTH(PALETTE_ADDRESS_WIDTH),      // Set data width according to the color palette
		.ADDRESS_WIDTH(PIXEL_ADDRESS_WIDTH),     // Set address with according to the pixel count
		.MEMFILE({FILES_PATH, "image.mem"})) // Memory initialization
	ImageData(
		.clk(clk), 						 // Falling edge of the 100 MHz clk
		.addr(imgAddress),					 // Image data address
		.dataOut(colorAddr),				 // Color palette address
		.wEn(1'b0)); 						 // We're always reading

	// Color Palette to Map Color Address to 12-Bit Color
	wire[BITS_PER_COLOR-1:0] colorData; // 12-bit color data at current pixel

	RAM #(
		.DEPTH(PALETTE_COLOR_COUNT), 		       // Set depth to contain every color		
		.DATA_WIDTH(BITS_PER_COLOR), 		       // Set data width according to the bits per color
		.ADDRESS_WIDTH(PALETTE_ADDRESS_WIDTH),     // Set address width according to the color count
		.MEMFILE({FILES_PATH, "colors.mem"}))  // Memory initialization
	ColorPalette(
		.clk(clk), 							   	   // Rising edge of the 100 MHz clk
		.addr(colorAddr),					       // Address from the ImageData RAM
		.dataOut(colorData),				       // Color at current pixel
		.wEn(1'b0)); 						       // We're always reading
		
	wire [6:0] asciiCode;
	RAM #(
	   .DEPTH(128),
	   .DATA_WIDTH(7),
	   .ADDRESS_WIDTH(7),
	   .MEMFILE({FILES_PATH, "ascii.mem"}))
	Key(
	   .clk(clk),
	   .addr(key_data),
	   .dataOut(asciiCode),
	   .wEn(1'b0));
	   
	localparam
	   NUMBER_OF_SPRITES = 94,
	   SPRITE_WIDTH = 50,
	   SPRITE_AREA = 2500,
	   SPRITE_ADDR_WIDTH = $clog2(NUMBER_OF_SPRITES * SPRITE_AREA) + 1;
    
	wire spriteOut;
	RAM #(
	   .DEPTH(NUMBER_OF_SPRITES * SPRITE_AREA),
	   .DATA_WIDTH(1),
	   .ADDRESS_WIDTH(SPRITE_ADDR_WIDTH),
	   .MEMFILE({FILES_PATH, "sprites.mem"}))
	Sprite(
	   .clk(clk),
	   .addr((asciiCode - 1) * SPRITE_AREA + x - ref_pointx + SPRITE_WIDTH * (y - ref_pointy)),
	   .dataOut(spriteOut),
	   .wEn(1'b0));
	   
	

	// Assign to output color from register if active
	wire[BITS_PER_COLOR-1:0] colorOut; 			  // Output color 
	assign colorOut = active ? colorData : 12'd0; // When not active, output black
    
    
    reg [9:0] ref_pointx;
    reg [8:0] ref_pointy;
    reg [9:0] ref_pointxt;
    reg [8:0] ref_pointyt;
    reg [7:0] key_data;
    initial begin 
        ref_pointx =  10'd295;
        ref_pointy =  10'd215;
        ref_pointxt=  10'd295;
        ref_pointyt=  10'd215;
        key_data = 8'b0;
    
    end
    wire isInSquare = (x - ref_pointx >= 0) & (x - ref_pointx < 50) & (y - ref_pointy >= 0) & (y - ref_pointy < 50);
    
    
    always @(posedge read_data) begin
        key_data = rx_data;
    end
    
    always @(posedge clkSlow) begin
        if (BTNU) begin
            ref_pointyt = ref_pointyt - 1;
        end else if (BTND) begin
            ref_pointyt= ref_pointyt + 1;
        end
        if (BTNR) begin
            ref_pointxt = ref_pointxt + 1;
        end else if (BTNL) begin
            ref_pointxt= ref_pointxt - 1;
        end
    
    end
    /*always @(posedge BTNU or posedge BTND) begin
        if (BTNU) begin
            ref_pointyt = ref_pointyt + 1;
        end else begin
            ref_pointyt= ref_pointyt - 1;
        end
        
        
    end
    
    always @(posedge BTNL or posedge BTNR) begin
        if (BTNR) begin
            ref_pointxt = ref_pointxt + 1;
        end else begin
            ref_pointxt= ref_pointxt - 1;
        end
        
        
    end */
    
 
    
   
    
    always @(posedge screenEnd) begin
        ref_pointx = ref_pointxt;
        ref_pointy = ref_pointyt;
    end
    
	// Quickly assign the output colors to their channels using concatenation
	wire [3:0] squareR = 4'b1111;
	wire [3:0] squareG = 4'd0;
	wire [3:0] squareB = 4'd0;
	
	wire [11:0] spriteColor;
	assign spriteColor = {{12{spriteOut}}};
	
	assign {VGA_R, VGA_G, VGA_B} = isInSquare ? spriteColor : colorOut;
endmodule