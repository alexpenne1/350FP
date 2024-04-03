`timescale 1 ns / 100 ps
module full_adder_tb;

	// Inputs to the module
	reg A, B, Cin;
	// Outputs
	wire S, Cout;
	// Instantiate
	full_adder adder(.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));
	// Input intialization
	initial begin
		A = 0;
		B = 0;
		Cin = 0;
		// Delay
		#80;
		$finish;
	end
	
	// Input manipulation
	always
		#10 A = ~A;
	always
		#20 B = ~B;
	always
		#40 Cin = ~Cin;
	
	// Output results
	always @(A,B,Cin) begin
		// Small delay so outputs can stabilize
		#1;
		$display("A:%b, B:%b => S:%b, Cout:%b", A, B, Cin, S, Cout);
	end
	
	
	initial begin
		$dumpfile("Wave_full_adder.vcd");
		$dumpvars(0, full_adder_tb);
	end
	
endmodule
