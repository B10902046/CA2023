module Forwarding(
    input [4:0] ID_EX_RS1addr_i,
    input [4:0] ID_EX_RS2addr_i,
    input [4:0] EX_MEM_RDaddr_i,
    input EX_MEM_RegWrite_i,
    input [4:0] MEM_WB_RDaddr_i,
    input MEM_WB_RegWrite_i,

    output [1:0] Forward_A_o,
    output [1:0] Forward_B_o
);

assign Forward_A_o = (EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && (EX_MEM_RDaddr_i == ID_EX_RS1addr_i)) ? 2'b10 :
                     (MEM_WB_RegWrite_i && (MEM_WB_RDaddr_i != 0) && !(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && (EX_MEM_RDaddr_i == ID_EX_RS1addr_i)) && (MEM_WB_RDaddr_i == ID_EX_RS1addr_i)) ? 2'b01 :
                     2'b00;

assign Forward_B_o = (EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && (EX_MEM_RDaddr_i == ID_EX_RS2addr_i)) ? 2'b10 :
                     (MEM_WB_RegWrite_i && (MEM_WB_RDaddr_i != 0) && !(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && (EX_MEM_RDaddr_i == ID_EX_RS2addr_i)) && (MEM_WB_RDaddr_i == ID_EX_RS2addr_i)) ? 2'b01 :
                     2'b00;


endmodule


/*
always @(*) begin // unknown assign
    // EX hazard
    Forward_A_o = 2'b00;
    Forward_B_o = 2'b00;
    if (EX_MEM_RegWrite_i
        && (EX_MEM_RDaddr_i != 0)
        && (EX_MEM_RDaddr_i == ID_EX_RS1addr_i)
    ) begin
        Forward_A_o = 2'b10;
    end
    if (EX_MEM_RegWrite_i
        && (EX_MEM_RDaddr_i != 0)
        && (EX_MEM_RDaddr_i == ID_EX_RS2addr_i)
    ) begin
        Forward_B_o = 2'b10;
    end
     //MEM hazard
    if(MEM_WB_RegWrite_i && (MEM_WB_RDaddr_i != 0) && !(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && (EX_MEM_RDaddr_i == ID_EX_RS1addr_i)) &&(MEM_WB_RDaddr_i == ID_EX_RS1addr_i))begin
        Forward_A_o = 2'b01;
    end
    if(MEM_WB_RegWrite_i && (MEM_WB_RDaddr_i != 0) && !(EX_MEM_RegWrite_i && (EX_MEM_RDaddr_i != 0) && (EX_MEM_RDaddr_i == ID_EX_RS2addr_i)) &&(MEM_WB_RDaddr_i == ID_EX_RS2addr_i))begin
        Forward_B_o = 2'b01;
    end
end
*/