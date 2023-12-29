module Hazard_Detection(
    IF_ID_RS1addr_i, 
    IF_ID_RS2addr_i, 
    ID_EX_RDaddr_i, 
    ID_EX_MemRead_i, 
    NoOp_o, 
    Stall_o, 
    PCWrite_o
);

input [4:0] IF_ID_RS1addr_i;
input [4:0] IF_ID_RS2addr_i;
input [4:0] ID_EX_RDaddr_i;
input ID_EX_MemRead_i;
output NoOp_o;
output Stall_o;
output PCWrite_o;

assign NoOp_o = ID_EX_MemRead_i && ((ID_EX_RDaddr_i == IF_ID_RS1addr_i) || (ID_EX_RDaddr_i == IF_ID_RS2addr_i)); // For control of PC
assign Stall_o = ID_EX_MemRead_i && ((ID_EX_RDaddr_i == IF_ID_RS1addr_i) || (ID_EX_RDaddr_i == IF_ID_RS2addr_i)); // For control of IF/ID & Instruction Memory
assign PCWrite_o = !(ID_EX_MemRead_i && ((ID_EX_RDaddr_i == IF_ID_RS1addr_i) || (ID_EX_RDaddr_i == IF_ID_RS2addr_i))); 


endmodule

