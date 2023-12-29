module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
);

// Ports
input   signed  [31:0]  data1_i;
input   signed  [31:0]  data2_i;
input   [2:0]           ALUCtrl_i;
output  signed  [31:0]  data_o;

assign data_o = (ALUCtrl_i == 3'b000) ? data1_i &   data2_i: // and
                (ALUCtrl_i == 3'b001) ? data1_i ^   data2_i: // xor
                (ALUCtrl_i == 3'b010) ? data1_i <<  data2_i: // sll
                (ALUCtrl_i == 3'b011) ? data1_i +   data2_i: // add
                (ALUCtrl_i == 3'b100) ? data1_i -   data2_i: // sub
                (ALUCtrl_i == 3'b101) ? data1_i *   data2_i: // mul
                (ALUCtrl_i == 3'b110) ? data1_i +   data2_i: // addi
                (ALUCtrl_i == 3'b111) ? data1_i >>> data2_i[4:0]: // sra  Unsigned right shift operator
                32'b0;

endmodule