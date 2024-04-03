module sra_tb;

	wire [31:0] data_operandA;
	wire [4:0] ctrl_shiftamt;
	wire [31:0] shifted_output;
	wire shift_enable;
	

	sra tb_sra(data_operandA, ctrl_shiftamt, shifted_output, shift_enable);
	
	
	integer i;
	integer j;
	integer k;
	assign {ctrl_shiftamt} = i[4:0];
	assign {shift_enable} = j[0:0];
	assign {data_operandA} = k[31:0];
	
	initial begin
		k = 1;
		j = 1;
		for (i=0; i < 32; i++) begin
			#20;
			$display("Shift: %d, Output: %b", ctrl_shiftamt, shifted_output);
		end
		$finish;
	end
endmodule