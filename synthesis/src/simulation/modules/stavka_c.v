module stavka_c (
    input rst_n,
    input clk,
    input select,
    input add,
    input [3:0] data_in,
    output [3:0] data_out
);
    
    wire add_red; // maximal duration is 1 period
    stavka_a red_a(clk, rst_n, add, add_red);

    reg [3:0] buffer_reg [1:0]; 
    reg [3:0] buffer_next [1:0]; 

    integer i;

    reg [3:0] data_out_reg;
    reg [3:0] data_out_next;
    assign data_out = data_out_reg;

    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            for (i = 0; i < 2; i = i + 1) begin
                buffer_reg[i] <= 4'h0;
            end
            data_out_reg <= 4'h0;
        end else begin
            for (i = 0; i < 2; i = i + 1) begin
                buffer_reg[i] <= buffer_next[i];
            end
            data_out_reg <= data_out_next;
        end
    end

    always @(*) begin
        // we will always set data_out_next to buffer[select], so we do not need initial initialization
        for (i = 0; i < 2; i = i + 1) begin
            buffer_next[i] = buffer_reg[i];
        end

        if(add_red) begin
            buffer_next[select] = (buffer_reg[select] + data_in) % 4'd10;
        end

        data_out_next = buffer_next[select]; // immediatelly set to next value

    end

endmodule