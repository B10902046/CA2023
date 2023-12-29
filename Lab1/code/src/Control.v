module Control
(
    Op_i,
    
    ALUOp_o,
    ALUSrc_o,
    RegWrite_o,
);

input   [6:0]       Op_i;

output  [1:0]       ALUOp_o;
output              ALUSrc_o;
output              RegWrite_o;

assign ALUOp_o =    (Op_i == 7'b0110011) ? 2'b10: // R-type
                    (Op_i == 7'b0010011) ? 2'b00: // I-type
                    2'b0;
assign ALUSrc_o =   (Op_i == 7'b0110011) ? 1'b0: // R-type
                    (Op_i == 7'b0010011) ? 1'b1: // I-type
                    1'b0;

assign RegWrite_o = 1'b1;


endmodule