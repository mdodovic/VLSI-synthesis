module regN_fsm #(
	parameter WIDTH = 8,
	parameter HIGH = WIDTH - 1
)(
	input clk,
	input rst_n,
	input select,
	input ld_inc,
	input [HIGH:0] in,
	output [HIGH:0] out
);
	// fsm is Final State Machine

	reg state_next, state_reg; // this is 1b for this ld_inc, in general state register has larger width
	// different states has different names

	localparam LD = 1'b0;  	// local parameter is very similar to
	localparam INC = 1'b1; 	// define or enum

	reg [HIGH:0] out_next, out_reg;

	assign out = out_reg;

	always @(posedge clk, negedge rst_n) begin
		if(!rst_n) begin
			out_reg <= {WIDTH{1'b0}};			
			state_reg <= LD; // state is initially in LD state
		end else begin
			out_reg <= out_next;
			state_reg <= state_next;
		end
	end

	always @(*) begin
		// We need final state machine logic
		// module has different states
		// behavior is different depends on state where the module is

		out_next = out_reg;
		state_next = state_reg;

		case (state_reg)

			LD: begin
				// switch state
				if(select == 1'b1)
					state_next = INC;
				
				// do combinational logic depends on the state
				if(ld_inc)
					out_next = in;

			end

			INC: begin
				// switch state
				if(select == 1'b0)
					state_next = LD;

				// do combinational logic depends on the state
				if(ld_inc)
					out_next = out_reg + 1'b1;
				
			end

		endcase

	end

endmodule 
