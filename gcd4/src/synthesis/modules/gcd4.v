module gcd4 (
	input clk,
	input rst_n,
	input [3:0] a,
	input [3:0] b,
	output [3:0] out
);

	reg [3:0] i;
	reg [3:0] out_next, out_reg;
	assign out = out_reg;

	always @(posedge clk, negedge rst_n)
		if (!rst_n)
			out_reg <= 4'h0;
		else
			out_reg <= out_next;

	always @(*) begin
		out_next = out_reg;
		i = 4'h0;
		while (i <= a && i <= b) begin
			if (a % i == 0 && b % i == 0)
				out_next = i;
			i = i + 1;
		end
	end

endmodule