module deb (
    input clk,
    input rst_n,
    input in,
    output out
);
    reg out_next, out_reg;
    assign out = out_reg;

    reg [1:0] ff_next, ff_reg; // actually 2 flip flops
    // those ffs save last 2 bits for every takts

    reg[7:0] cnt_next, cnt_reg; // counter for

    assign in_changed = ff_reg[0] ^ ff_reg[1];
    // if ffs are same => in_changed is 0
    // if ffs are different => in_changed is 1
    assign in_stable = (cnt_reg == 8'hFF) ? 1'b1: 1'b0;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            out_reg <= 1'b0;
            ff_reg <= 2'b00;
            cnt_reg <= 8'h00;

        end else begin
            out_reg <= out_next;            
            ff_reg <= ff_next;
            cnt_reg <= cnt_next;

        end
    end

    always @(*) begin
        ff_next[0] = in; // update ffs, similary to rising edge detector
        ff_next[1] = ff_reg[0];

        cnt_next = in_changed ? 0 : (cnt_reg + 1'b1); // reset to 0 or ++
        // how many tackts the same value is on input
        // when we chaged value 0 -> 1 or 1 -> 0, reset counter
        // we should wait untill the same value remains for 255 tackts
        out_next = in_stable ? ff_reg[1] : out_reg;
        // both ff_reg[0] and ff_reg[1] are stable so it does not matter what we send to out_next
    end
    
endmodule