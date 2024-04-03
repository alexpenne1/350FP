module mux_32_tb;

	wire [31:0] out;
	wire [4:0] select;
	wire [31:0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
	
	mux_32 tb_mux_32(out, select, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31);
	integer i;
	assign {select} = i[4:0];
	
	initial begin
		for (i = 0; i < 32; i=i+1) begin
			#20;
			$display("Select:%d, Out:%d", select, out);
		end
		$finish;
	end
	initial begin
		$dumpfile("Wave_32_mux.vcd");
		$dumpvars(0, mux_32_tb);
	end
endmodule