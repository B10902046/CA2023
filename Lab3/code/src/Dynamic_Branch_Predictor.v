module branch_predictor
(
    clk_i, 
    rst_i,

    ALUResult_i, 
    EX_Branch_i,
    EX_PC_i,
    Predict_i,
    EX_immExtended_i, 

	predict_o,
    PC_o, 
    Predict_wrong_o,
);
input clk_i, rst_i;
input EX_Branch_i;
input Predict_i;
input [31:0] ALUResult_i;
input [31:0] EX_PC_i;
input [31:0] EX_immExtended_i;
output predict_o, Predict_wrong_o;
output [31:0] PC_o;

reg [1:0] FSM;                                         // 11:strongly Taken
                                                       // 10:Taken
                                                       // 01:nonTaken
                                                       // 00:strongly nonTaken
  
assign predict_o = (FSM[1] == 1) ? 1 : 0;              // Predict Taken or nonTaken
assign Predict_wrong_o = (EX_Branch_i && (Predict_i != (ALUResult_i == 0))) ? 1 : 0;     // Wrong Predict
assign PC_o = (Predict_i) ? EX_PC_i + 4 : EX_PC_i + (EX_immExtended_i << 1);             // **** give correct pc when Predict wrong

// TODO
always@(posedge clk_i or negedge rst_i) begin
    if(~rst_i) begin
        FSM <= 2'b11;
    end 
    else if(EX_Branch_i) begin
        if(Predict_i == (ALUResult_i == 0)) begin // ALUResult == 0 : Taken
            if(FSM[1]) begin 
                FSM = 2'b11;
            end
            else begin
                FSM = 2'b00;
            end
        end
        else begin //Prediction Failed
            // Update the FSM
            if(FSM == 2'b11) begin
                FSM <= 2'b10;
            end
            else if(FSM == 2'b10) begin
                FSM <= 2'b01;
            end 
            else if(FSM == 2'b01) begin
                FSM <= 2'b10;
            end 
            else begin
                FSM <= 2'b01;
            end
        end
    end
end

endmodule
