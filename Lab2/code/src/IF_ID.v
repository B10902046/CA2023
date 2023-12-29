// This module is responsible for the instruction fetch and decode stage.
// The PC_o and instr_o registers are updated on the positive edge of the clock or the negative edge of the reset signal.
// If a flush signal is asserted or the reset signal is active, the outputs are set to zero.
// If there is no stall signal, the outputs are updated with the inputs.
// store the values of the program counter and instruction for the next pipeline stage.
// It handles cases where the pipeline needs to be flushed or stalled due to certain conditions.

module IF_ID(
    clk_i, 
    rst_i,
    Stall_i, 
    Flush_i, 
    PC_i, 
    instr_i, 
    PC_o, 
    instr_o
);

input clk_i;
input rst_i;
input Stall_i;
input Flush_i;
input [31:0] PC_i;
input [31:0] instr_i;

output [31:0] PC_o;
output [31:0] instr_o;

reg [31:0] PC_o;
reg [31:0] instr_o;

always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        PC_o <= 32'b0;
        instr_o <= 32'b0;
    end 
    else if(Flush_i) begin
        PC_o <= 32'b0;
        instr_o <= 32'b0;
    end 
    else if(!Stall_i) begin
        PC_o <= PC_i;
        instr_o <= instr_i;
    end
end

endmodule

