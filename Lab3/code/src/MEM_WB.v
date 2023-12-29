// This module represents the memory access and write-back stage.
// The outputs are updated based on the inputs on the positive edge of the clock or the negative edge of the reset signal.
// During the reset, the output values are set to their default values.
// Otherwise, the outputs are updated with the corresponding input values.

module MEM_WB(
    clk_i, 
    rst_i, 
    RegWrite_i, 
    MemtoReg_i, 
    ALUResult_i, 
    MemReadData_i, 
    RDaddr_i, 
    RegWrite_o, 
    MemtoReg_o, 
    ALUResult_o, 
    MemReadData_o, 
    RDaddr_o
);

input clk_i;
input rst_i;
input RegWrite_i;
input MemtoReg_i;
input [31:0] ALUResult_i;
input [31:0] MemReadData_i;
input [4:0] RDaddr_i;
output RegWrite_o;
output MemtoReg_o;
output [31:0] ALUResult_o;
output [31:0] MemReadData_o;
output [4:0] RDaddr_o;

reg RegWrite_o;
reg MemtoReg_o;
reg [31:0] ALUResult_o;
reg [31:0] MemReadData_o;
reg [4:0] RDaddr_o;

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        RegWrite_o <= 0;
        MemtoReg_o <= 0;
        ALUResult_o <= 32'b0;
        MemReadData_o <= 32'b0;
        RDaddr_o <= 5'b0;
    end else begin 
        RegWrite_o <= RegWrite_i;
        MemtoReg_o <= MemtoReg_i;
        ALUResult_o <= ALUResult_i;
        MemReadData_o <= MemReadData_i;
        RDaddr_o <= RDaddr_i;
    end
end

endmodule