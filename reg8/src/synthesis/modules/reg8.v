module reg8 (
	input clk,
	input rst_n,
	input ld,
	input inc,
	input [7:0] in,
	output [7:0] out
);

	reg [7:0] out_next, out_reg;
	assign out = out_reg;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n)
			out_reg <= 8'h00;
		else
			out_reg <= out_next;
	end

	always @(*) begin
		out_next = out_reg;

		if (ld)
			out_next = in; 
			else if (inc)
				out_next = out_reg + 1'b1;
	end
	
endmodule