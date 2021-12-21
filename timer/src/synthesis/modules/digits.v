module digits (
    input [9:0] in,
    output [6:0] out_ones,
    output [6:0] out_tens,
    output [6:0] out_hundreds,
    output [6:0] out_thousands
);
    // multiple and conditionally instancing
    // generate: for in harwdare to instance multiple times

    // multiple instancing:
    wire [3:0] ones      = in / 1    % 10;
    wire [3:0] tens      = in / 10   % 10;
    wire [3:0] hundreds  = in / 100  % 10;
    wire [3:0] thousands = in / 1000 % 10;

    // multiple instancig:
    hex hex_inst1(ones, out_ones);
    hex hex_inst10(tens, out_tens);
    hex hex_inst100(hundreds, out_hundreds);
    hex hex_inst1000(thousands, out_thousands);

endmodule