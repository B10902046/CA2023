module Branch_Pc( 
    pc_addr_i, 
    immExtended_i,  
    Predict_wrong_i,
    pc_right_i, 
    PCbranch_o
);


input [31:0] pc_addr_i;
input [31:0] immExtended_i;
input [31:0] pc_right_i;
input Predict_wrong_i; 
output [31:0] PCbranch_o;

assign PCbranch_o = Predict_wrong_i ? pc_right_i : (pc_addr_i + (immExtended_i << 1));

endmodule