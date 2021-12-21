module timer #(
	parameter second = 50_000_000
)(
	input clk,
	input rst_n,
	output [9:0] out
);

	// timer counts seconds
	reg [9:0] out_next, out_reg;
	assign out = out_reg;

	// out counts seconds
	// so we need counter that counts ticks
	integer timer_next, timer_reg;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			out_reg <= 10'h000;			
			timer_reg <= 0;
		end else begin
			out_reg <= out_next;
			timer_reg <= timer_next;
		end
	end

	always @(*) begin
		out_next = out_reg;
		timer_next = timer_reg;

		// we need clk frequency
		// on every posedge of clk, we need to count 
		// every up-dow-up is 1 period => period = 1 / frequency
		// frequency is number of ticks per 1 second
		// In this case frequency is 50MHz
		// we can count up to 50*10^6 and when we reach this value, we can say that second has passed
		
		// simply we need this
		if(timer_reg == second) begin
			out_next = out_reg + 1; // second has passed
			timer_next = 0; // reset timer for next second
		end else begin
			timer_next = timer_reg + 1; // count untill frequency
		end	
	end

endmodule 
