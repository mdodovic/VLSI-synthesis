module stavka_f #(
    parameter NUM = 50_000_000
)(
    input rst_n,
    input clk,
    input select,
    input add,
    input next,
    input [3:0] data_in,
//    output [3:0] data_out
    output [6:0] data_out_seven_segment
);
    
    wire add_red; // maximal duration is 1 period
    stavka_b hold_add(clk, rst_n, add, add_red);

    wire next_red; // on active value, we should change (switch) state 
    stavka_a red_next(clk, rst_n, next, next_red);

    // we have states:
    localparam setup = 2'b00;
    localparam gcd = 2'b01;
    localparam decrement = 2'b10;

    // and our current state:
    reg[1:0] current_state_reg, current_state_next;
    
    reg [3:0] buffer_reg [1:0]; 
    reg [3:0] buffer_next [1:0]; 

    integer i;

    reg [6:0] data_out_reg;
    reg [6:0] data_out_next;
    assign data_out_seven_segment = data_out_reg;

    reg [3:0] j; // digit for gcd calculation
    reg [3:0] gcd_reg, gcd_next;
    reg [3:0] result_reg [1:0]; 
    reg [3:0] result_next [1:0]; 


    integer counter_next, counter_reg;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            for (i = 0; i < 2; i = i + 1) begin
                buffer_reg[i] <= 4'h0;
                result_reg[i] <= 4'h0;
            end
            data_out_reg <= 4'h0;
            current_state_reg <= setup;
            gcd_reg <= 4'h0;
            counter_reg <= 0;;

        end else begin
            for (i = 0; i < 2; i = i + 1) begin
                buffer_reg[i] <= buffer_next[i];
                result_reg[i] <= result_next[i];
            end
            data_out_reg <= data_out_next;
            current_state_reg <= current_state_next;
            gcd_reg <= gcd_next;
            counter_reg <= counter_next;

        end
    end


    always @(*) begin
        data_out_next = data_out_reg;
        current_state_next = current_state_reg;
        gcd_next = gcd_reg;
        for (i = 0; i < 2; i = i + 1) begin
            buffer_next[i] = buffer_reg[i];
            result_next[i] = result_reg[i];
        end
        j = 4'd0;
        counter_next = counter_reg;

        case (current_state_reg)
            setup: begin
                if(next_red)
                    current_state_next = gcd;
                if(add_red) begin
                    buffer_next[select] = (buffer_reg[select] + data_in) % 4'd10;
                end

                data_out_next = hex7(buffer_next[select]);
                
            end
            gcd: begin
                if(next_red) begin
                    // again rising edge - change state
                    current_state_next = decrement;                    
                end

                for (j = 4'd1; j < 4'd10 ; j = j + 1'd1) begin
                    if((buffer_reg[0] % j == 4'd0) && (buffer_reg[1] % j == 4'd0))
                        gcd_next = j;
                end

                data_out_next = hex7(buffer_next[select] / gcd_next);

            end 
            decrement: begin
                if(next_red) begin
                    if((buffer_reg[0] % gcd_reg == 4'd0) && (buffer_reg[1] % gcd_reg == 4'd0)) begin
                        current_state_next = setup;
                        data_out_next = hex7(buffer_next[select]);
                    end
                end
                
                if(counter_reg == NUM) begin
                    counter_next = 0; 
                    gcd_next = gcd_reg - 4'd1;
                end else begin
                    counter_next = counter_reg + 1;
                end

                data_out_next = hex7(gcd_next);

                if(gcd_reg == 4'd0) begin
                    current_state_next = setup;
                    data_out_next = hex7(buffer_next[select]);
                end


            end 
        endcase

    end

    function [6:0] hex7 (
        input [3:0] in
    );
        begin
            case (in)
                4'b0000: hex7 = ~7'h3F;
                4'b0001: hex7 = ~7'h06;
                4'b0010: hex7 = ~7'h5B;
                4'b0011: hex7 = ~7'h4F;
                4'b0100: hex7 = ~7'h66;
                4'b0101: hex7 = ~7'h6D;
                4'b0110: hex7 = ~7'h7D;
                4'b0111: hex7 = ~7'h07;
                4'b1000: hex7 = ~7'h7F;
                4'b1001: hex7 = ~7'h6F;
                4'b1010: hex7 = ~7'h77;
                4'b1011: hex7 = ~7'h7C;
                4'b1100: hex7 = ~7'h39;
                4'b1101: hex7 = ~7'h5E;
                4'b1110: hex7 = ~7'h79;
                4'b1111: hex7 = ~7'h71;
            endcase
        end
        
    endfunction

endmodule