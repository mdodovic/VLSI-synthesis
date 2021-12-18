module m41(
	input I0, 
	input I1, 
	input I2, 
	input I3, 
	input [1:0] S, 
	output reg Y
);

always @(I0, I1, I2, I3, S) begin
	case (S)
		2'b00: Y = I0; 
		2'b01: Y = I1; 
		2'b10: Y = I2; 
		2'b11: Y = I3; 
	endcase
end

endmodule 
