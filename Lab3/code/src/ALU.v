`define  AND 3'b000
`define  XOR 3'b001
`define  SLL 3'b010
`define  ADD 3'b011
`define  SUB 3'b100
`define  MUL 3'b101
`define  ADDI 3'b110
`define  SRAI 3'b111

module ALU(
    ALUCtr_i, 
    RS1data_i, 
    RS2data_i,  
    data_o
);

input [2:0] ALUCtr_i;
input signed [31:0] RS1data_i;
input [31:0] RS2data_i;
output [31:0] data_o;


assign data_o = (ALUCtr_i == `AND) ? RS1data_i &   RS2data_i: // and
                (ALUCtr_i == `XOR) ? RS1data_i ^   RS2data_i: // xor
                (ALUCtr_i == `SLL) ? RS1data_i <<  RS2data_i: // sll
                (ALUCtr_i == `ADD) ? RS1data_i +   RS2data_i: // add
                (ALUCtr_i == `SUB) ? RS1data_i -   RS2data_i: // sub
                (ALUCtr_i == `MUL) ? RS1data_i *   RS2data_i: // mul
                (ALUCtr_i == `ADDI) ? RS1data_i +   RS2data_i: // addi
                (ALUCtr_i == `SRAI) ? RS1data_i >>> RS2data_i[4:0]: // sra
                32'b0;

endmodule


