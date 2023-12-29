// This module represents the instruction decode and execute stage.
// The outputs are updated based on the inputs on the positive edge of the clock or the negative edge of the reset signal.
// During the reset, the output values are set to their default values.
// Otherwise, the outputs are updated with the corresponding input values.

module ID_EX(
    clk_i, 
    rst_i, 
    RegWrite_i, 
    MemtoReg_i, 
    MemRead_i, 
    MemWrite_i, 
    ALUOp_i, 
    ALUSrc_i, 
    RS1data_i, 
    RS2data_i, 
    RS1addr_i,
    RS2addr_i, 
    func3_i, 
    func7_i, 
    immExtended_i, 
    RDaddr_i, 

    // lab3
    PC_i,
    Flush_i,
    Branch_i, 

    RegWrite_o, 
    MemtoReg_o, 
    MemRead_o, 
    MemWrite_o, 
    ALUOp_o,
    ALUSrc_o, 
    RS1data_o, 
    RS2data_o, 
    RS1addr_o, 
    RS2addr_o, 
    func3_o, 
    func7_o, 
    immExtended_o, 
    RDaddr_o,

    // lab3
    PC_o, 
    Branch_o
);

input clk_i;
input rst_i;
input RegWrite_i;
input MemtoReg_i;
input MemRead_i;
input MemWrite_i;
input [1:0] ALUOp_i;
input ALUSrc_i;
input [31:0] RS1data_i;
input [31:0] RS2data_i;
input [4:0] RS1addr_i;
input [4:0] RS2addr_i;
input [2:0] func3_i;
input [6:0] func7_i;
input [31:0] immExtended_i;
input [4:0] RDaddr_i;

input Flush_i;
input [31:0] PC_i;
input Branch_i;

output RegWrite_o;
output MemtoReg_o;
output MemRead_o;
output MemWrite_o;
output [1:0] ALUOp_o;
output ALUSrc_o;
output [31:0] RS1data_o;
output [31:0] RS2data_o;
output [4:0] RS1addr_o;
output [4:0] RS2addr_o;
output [2:0] func3_o;
output [6:0] func7_o;
output [31:0] immExtended_o;
output [4:0] RDaddr_o;

output [31:0] PC_o;
output Branch_o;

reg RegWrite_o;
reg MemtoReg_o;
reg MemRead_o;
reg MemWrite_o;
reg [1:0] ALUOp_o;
reg ALUSrc_o;
reg [31:0] RS1data_o;
reg [31:0] RS2data_o;
reg [4:0] RS1addr_o;
reg [4:0] RS2addr_o;
reg [2:0] func3_o;
reg [6:0] func7_o;
reg [31:0] immExtended_o;
reg [4:0] RDaddr_o;

reg [31:0] PC_o;
reg Branch_o;


always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i || Flush_i) begin 
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        MemRead_o <= 0;
        MemWrite_o <= 0;
        ALUOp_o <= 2'b00;
        ALUSrc_o <= 0;
        RS1data_o <= 32'b0;
        RS2data_o <= 32'b0;
        RS1addr_o <= 5'b0;
        RS2addr_o <= 5'b0;
        func3_o <= 3'b0;
        func7_o <= 7'b0;
        immExtended_o <= 32'b0;
        RDaddr_o <= 5'b0;

        PC_o <= 0;
        Branch_o <= 0;

    end else begin
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        MemRead_o <= MemRead_i;
        MemWrite_o <= MemWrite_i;
        ALUOp_o <= ALUOp_i;
        ALUSrc_o <= ALUSrc_i;
        RS1data_o <= RS1data_i;
        RS2data_o <= RS2data_i;
        RS1addr_o <= RS1addr_i;
        RS2addr_o <= RS2addr_i;
        func3_o <= func3_i;
        func7_o <= func7_i;
        immExtended_o <= immExtended_i;
        RDaddr_o <= RDaddr_i;

        PC_o <= PC_i;
        Branch_o <= Branch_i;
    end
end

endmodule