module stavka_b #(
    parameter NUM = 5
)(
    input rst_n,
    input clk,
    input in,
    output reg out
);
    
    reg ff1_next, ff1_reg;
    reg ff2_next, ff2_reg;

    integer counter_next, counter_reg;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            ff1_reg <= 1'b0;            
            ff2_reg <= 1'b0;            

            counter_reg <= 0;

        end else begin
            // Moore -> current state is important!    
            ff1_reg <= ff1_next;            
            ff2_reg <= ff2_next;            

            counter_reg <= counter_next;

        end
    end

    always @(*) begin
        ff1_next = in;
        ff2_next = ff2_reg;
        counter_next = counter_reg;
        out = 1'b0;

        if(ff1_reg == 1'b1 && ff2_reg == 1'b1) begin
            // constant value of in == 1
            if(counter_reg >= 6 * NUM) begin
                counter_next = 0;
            end else begin
                // increment every time in has value 1 
                counter_next = counter_reg + 1;
            end
        end else begin
            // Moore -> reg is used! check in next situation, not immediatelly
            if(ff1_reg == 1'b0 && ff2_reg == 1'b1) begin
                // falling edge of in 1->0
                counter_next = 0; // reset on rising edge in - we did it on falling edge because we will on rising edge use this 0, no more usages of counter when zeros are comming
                if(counter_reg >= 3 * NUM) begin
                    // when in is falling and 3NUM
                    out = 1'b1;
                end
            end
        end

    end
endmodule