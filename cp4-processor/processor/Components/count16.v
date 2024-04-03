module count16(done, clock, reset, enable);

	// define ports
	input clock;
	wire [31:0] count;
	output done;
	input reset;
	output enable;
	
	// define wires
	wire [31:0] alu_out;
	wire [31:0] adding_factor;
	wire test;
	wire trash1, trash2, trash3, trash4;
	wire [31:0] trash5;
	wire isNotEqual, isLessThan, isEqual;
	
	// check if counter has reached 16 yet
	alu checkMax(count, 32'b10000, 5'b1, 5'b0, trash5, isNotEqual, isLessThan, trash4);
	
	// set enable bit to high if counter is <= 16
	wire w1;
	and and1(w1, isNotEqual, isLessThan);
	not not1(isEqual, isNotEqual);
	or or1(enable, w1, isEqual);
	
	// done bit is high if counter has reached 16
	assign done = isNotEqual && ~isLessThan;
	
	// add 1 to the count each clock cycle
	alu adder(count, 32'b1, 5'b0, 5'b0, alu_out, trash1, trash2, trash3);
	
	// update count with +1 if enable bit is high
	register countregister(alu_out, count, clock, enable, reset);
	
	
endmodule