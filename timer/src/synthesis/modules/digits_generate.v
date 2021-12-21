module digits_generate (
    input [9:0] in,
    output [27:0] out
);

    // genvar must be before generate
    genvar i;

    generate
        // multiple instancing
        for (i = 0; i < 4; i = i + 1) begin : name
            //                                  ^ our block name
            // 4 times instancing, same names are not problem, because it is in generate block
            wire [3:0] digit = (in / 10 ** i) % 10; // 4 times instancing
            hex hex_inst(digit, out[(i * 7 + 7 - 1): i * 7]);
                                // i = 0: 6, 0
                                // i = 1: 13, 7
                                // i = 2: 20, 14
                                // i = 3: 27, 21
        end

    endgenerate

endmodule