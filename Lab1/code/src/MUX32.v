module MUX32
(
    data1_i,
    data2_i,
    sel_i,
    data_o
);

input   [31:0] data1_i, data2_i;
input   sel_i;
output  [31:0] data_o;

assign data_o = sel_i? data2_i: data1_i;


endmodule