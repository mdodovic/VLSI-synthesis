module stavka_d (
    input rst_n,
    input clk,
    input select,
    input add,
    input next,
    input [3:0] data_in,
    output [3:0] data_out
);
    
    wire add_red; // maximal duration is 1 period
    stavka_a red_add(clk, rst_n, add, add_red);

    wire next_red; // on active value, we should change (switch) state 
    stavka_a red_next(clk, rst_n, next, next_red);

    // we have states:
    localparam setup = 1'b0;
    localparam gcd = 1'b1;

    // and our current state:
    reg current_state_reg, current_state_next;
    
    reg [3:0] buffer_reg [1:0]; 
    reg [3:0] buffer_next [1:0]; 

    integer i;

    reg [3:0] data_out_reg;
    reg [3:0] data_out_next;
    assign data_out = data_out_reg;

    reg [3:0] j; // digit for gcd calculation
    reg [3:0] gcd_reg, gcd_next;
    reg [3:0] result_reg [1:0]; 
    reg [3:0] result_next [1:0]; 


    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            for (i = 0; i < 2; i = i + 1) begin
                buffer_reg[i] <= 4'h0;
                result_reg[i] <= 4'h0;
            end
            data_out_reg <= 4'h0;
            current_state_reg <= setup;
            gcd_reg <= 4'h0;

        end else begin
            for (i = 0; i < 2; i = i + 1) begin
                buffer_reg[i] <= buffer_next[i];
                result_reg[i] <= result_next[i];
            end
            data_out_reg <= data_out_next;
            current_state_reg <= current_state_next;
            gcd_reg <= gcd_next;
        end
    end


    always @(*) begin
        // we will always set data_out_next to buffer[select], so we do not need initial initialization
        data_out_next = data_out_reg;
        current_state_next = current_state_reg;
        gcd_next = gcd_reg;
        for (i = 0; i < 2; i = i + 1) begin
            buffer_next[i] = buffer_reg[i];
            result_next[i] <= result_reg[i];
        end
        j = 4'd0;

        case (current_state_reg)
            setup: begin
                if(next_red)
                    current_state_next = gcd;
                if(add_red) begin
                    buffer_next[select] = (buffer_reg[select] + data_in) % 4'd10;
                end
                data_out_next = buffer_next[select];
            end
            gcd: begin
                if(next_red) begin
                    // again rising edge - change state
                    current_state_next = setup;
                    // this is good, because we need output for changed state - here it is easy because output for setup state is just buffer[select]
                    data_out_next = buffer_next[select];
                end

                for (j = 4'd1; j < 4'd10 ; j = j + 1'd1) begin
                    if((buffer_reg[0] % j == 4'd0) && (buffer_reg[1] % j == 4'd0))
                        gcd_next = j;
                end

                data_out_next = buffer_next[select] / gcd_next;

            end 
        endcase

    end

endmodule