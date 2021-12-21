module regN #(
	parameter WIDTH = 8
)(
	input clk,
	input rst_n,
	input ld,
	input inc,
	input [WIDTH - 1:0] in,
	output [WIDTH - 1:0] out
);
	// parameter has default 8
	// so if we specify this parameter, WIDTH will be the specified value
	
	reg [WIDTH-1:0] out_next, out_reg;

	assign out = out_reg;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			// set it with all zeros, especially with WIDTH zeros
			// out_reg <= WIDTH'h0 -error
			out_reg <= {WIDTH{1'b0}};			
		end else begin
			out_reg <= out_next;
		end
	end

	always @(*) begin
		out_next = out_reg;
		if(ld)
			out_next = in;
		else if(inc)
			out_next = out_reg + 1'b1;
	end

endmodule 
