module reg4 (
	input clk,
	input rst_n,
	input ld,
	input inc,
	input [3:0] in,
	output [3:0] out
);

	reg [3:0] out_next, out_reg;
	assign out = out_reg;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n)
			out_reg <= 4'h0;
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