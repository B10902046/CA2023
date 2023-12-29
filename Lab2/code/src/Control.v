`define  SW 7'b0100011
`define  BEQ 7'b1100011
`define  Rtype 7'b0110011
`define  LW 7'b0000011

module Control(
    NoOp_i,
    opcode_i, 
    ALUOp_o, 
    ALUSrc_o,
    RegWrite_o, 
    MemtoReg_o, 
    MemRead_o, 
    MemWrite_o, 
    Branch_o
);

input [6:0] opcode_i;
input NoOp_i;
output [1:0] ALUOp_o;
output ALUSrc_o;
output RegWrite_o;
output MemtoReg_o;
output MemRead_o;
output MemWrite_o;
output Branch_o;

// Define the different type of instructions
assign RegWrite_o = NoOp_i ? 0 : 
                    (opcode_i == `SW) ? 0 : //
                    (opcode_i == `BEQ) ? 0 : 1;


assign ALUSrc_o = NoOp_i ? 0 : 
                  (opcode_i == `Rtype) ? 0 :
                  (opcode_i == `BEQ) ? 0 : 1;


assign ALUOp_o = NoOp_i ? 2'b00 : 
                 (opcode_i == `Rtype) ? 2'b10 : 
                 (opcode_i == `BEQ) ? 2'b01 : 2'b00;


assign MemtoReg_o = NoOp_i ? 0 : 
                    (opcode_i == `LW) ? 1 : 0;


assign MemRead_o = NoOp_i ? 0 : 
                    (opcode_i == `LW) ? 1 : 0;

assign MemWrite_o = NoOp_i ? 0 : 
                    (opcode_i == `SW) ? 1 : 0;

assign Branch_o = NoOp_i ? 0 : 
                  (opcode_i == `BEQ) ? 1 : 0;

endmodule