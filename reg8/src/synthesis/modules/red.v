module red (
    input clk,
    input rst_n,
    input in,
    output out
);

    // rising edge detector
    // on 0->1 flip generate out signal

    reg ff1_next, ff1_reg; // newer
    reg ff2_next, ff2_reg; // older

    assign out = ff1_reg & ~ff2_reg;
    // newer = 1 and older = 0

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            ff1_reg <= 1'b0;
            ff2_reg <= 1'b0;
        end else begin
            ff1_reg <= ff2_next;
            ff2_reg <= ff1_next;

        end
    end

    always @(*) begin
        ff1_next = in; // the newest input
        ff2_next = ff1_reg; // become older
        
    end

endmodule