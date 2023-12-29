module MUX32_4(
    data00_i, 
    data01_i, 
    data10_i, 
    data11_i, 
    sel_i,
    data_o
);

input [31:0] data00_i;
input [31:0] data01_i;
input [31:0] data10_i;
input [31:0] data11_i;
input [1:0] sel_i;
output [31:0] data_o;

assign data_o = (sel_i == 2'b00) ? data00_i : 
                (sel_i == 2'b01) ? data01_i :
                (sel_i == 2'b10) ? data10_i : data11_i;

endmodule