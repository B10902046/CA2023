module CPU(
    clk_i, 
    rst_i
);

input clk_i;
input rst_i;

PC PC(
    .clk_i(clk_i),
    .rst_i(rst_i),
    .PCWrite_i(Hazard_Detection.PCWrite_o),
    .pc_i(MUX_add4_branch.data_o)
);

Adder Adder_pc(
    .data1_in(PC.pc_o), 
    .data2_in(32'd4)
);

MUX32 MUX_add4_branch(
    .data1_i(Adder_pc.data_o), 
    .data2_i(Branch_Pc.PCbranch_o), 
    .sel_i(Branch_flush.Flush_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i(PC.pc_o)
);

IF_ID IF_ID(
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    .Stall_i(Hazard_Detection.Stall_o), 
    .flush_i(Branch_flush.Flush_o), 
    .PC_i(PC.pc_o), 
    .instr_i(Instruction_Memory.instr_o)
);

Registers Registers(
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    .RS1addr_i(IF_ID.instr_o[19:15]),
    .RS2addr_i(IF_ID.instr_o[24:20]),
    .RDaddr_i(MEM_WB.RDaddr_o), 
    .RDdata_i(MUX_WB.data_o),
    .RegWrite_i(MEM_WB.RegWrite_o)
);

Control Control(
    .NoOp_i(Hazard_Detection.NoOp_o), 
    .opcode_i(IF_ID.instr_o[6:0])
);

Imm_Gen Imm_Gen(
    .instr_i(IF_ID.instr_o)
);

ID_EX ID_EX(
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    .RegWrite_i(Control.RegWrite_o), 
    .MemtoReg_i(Control.MemtoReg_o), 
    .MemRead_i(Control.MemRead_o), 
    .MemWrite_i(Control.MemWrite_o), 
    .ALUOp_i(Control.ALUOp_o), 
    .ALUSrc_i(Control.ALUSrc_o), 
    .RS1data_i(Registers.RS1data_o), 
    .RS2data_i(Registers.RS2data_o), 
    .RS1addr_i(IF_ID.instr_o[19:15]),
    .RS2addr_i(IF_ID.instr_o[24:20]), 
    .func3_i(IF_ID.instr_o[14:12]), 
    .func7_i(IF_ID.instr_o[31:25]), 
    .immExtended_i(Imm_Gen.immExtended_o), 
    .RDaddr_i(IF_ID.instr_o[11:7]), 

    .Flush_i(branch_predictor.Predict_wrong_o),
    .PC_i(IF_ID.PC_o),
    .Branch_i(Control.Branch_o)              
);

MUX32_4 MUX_rs1(
    .data00_i(ID_EX.RS1data_o), 
    .data01_i(MUX_WB.data_o), 
    .data10_i(EX_MEM.ALUResult_o), 
    .data11_i(),                          //neglect
    .sel_i(Forwarding.Forward_A_o)
);

MUX32_4 MUX_rs2(
    .data00_i(ID_EX.RS2data_o), 
    .data01_i(MUX_WB.data_o), 
    .data10_i(EX_MEM.ALUResult_o), 
    .data11_i(),                          //neglect
    .sel_i(Forwarding.Forward_B_o)
);

MUX32 MUX_imm_rs2(
    .data1_i(MUX_rs2.data_o), 
    .data2_i(ID_EX.immExtended_o), 
    .sel_i(ID_EX.ALUSrc_o)
);

ALU_Control ALU_Control(
    .ALUOp_i(ID_EX.ALUOp_o),
    .func3_i(ID_EX.func3_o),
    .func7_i(ID_EX.func7_o)
);

ALU ALU(
    .ALUCtr_i(ALU_Control.ALUCtr_o), 
    .RS1data_i(MUX_rs1.data_o), 
    .RS2data_i(MUX_imm_rs2.data_o)
);

Forwarding Forwarding(
    .EX_MEM_RegWrite_i(EX_MEM.RegWrite_o), 
    .EX_MEM_RDaddr_i(EX_MEM.RDaddr_o), 
    .MEM_WB_RegWrite_i(MEM_WB.RegWrite_o), 
    .MEM_WB_RDaddr_i(MEM_WB.RDaddr_o),
    .ID_EX_RS1addr_i(ID_EX.RS1addr_o), 
    .ID_EX_RS2addr_i(ID_EX.RS2addr_o)
);

EX_MEM EX_MEM(
    .clk_i(clk_i), 
    .rst_i(rst_i),
    .RegWrite_i(ID_EX.RegWrite_o), 
    .MemtoReg_i(ID_EX.MemtoReg_o), 
    .MemRead_i(ID_EX.MemRead_o), 
    .MemWrite_i(ID_EX.MemWrite_o), 
    .ALUResult_i(ALU.data_o), 
    .MemWriteData_i(MUX_rs2.data_o), 
    .RDaddr_i(ID_EX.RDaddr_o)
);

Data_Memory Data_Memory(
    .clk_i(clk_i), 
    .addr_i(EX_MEM.ALUResult_o), 
    .MemRead_i(EX_MEM.MemRead_o),
    .MemWrite_i(EX_MEM.MemWrite_o),
    .data_i(EX_MEM.MemWriteData_o)
);

MEM_WB MEM_WB(
    .clk_i(clk_i), 
    .rst_i(rst_i), 
    .RegWrite_i(EX_MEM.RegWrite_o), 
    .MemtoReg_i(EX_MEM.MemtoReg_o), 
    .ALUResult_i(EX_MEM.ALUResult_o), 
    .MemReadData_i(Data_Memory.data_o), 
    .RDaddr_i(EX_MEM.RDaddr_o)
);

MUX32 MUX_WB(
    .data1_i(MEM_WB.ALUResult_o), 
    .data2_i(MEM_WB.MemReadData_o), 
    .sel_i(MEM_WB.MemtoReg_o)
);

Branch_Pc Branch_Pc(
    .pc_addr_i(IF_ID.PC_o), 
    .immExtended_i(Imm_Gen.immExtended_o),
    .Predict_wrong_i(branch_predictor.Predict_wrong_o), 
    .pc_right_i(branch_predictor.PC_o)
);

Branch_flush Branch_flush(
    .Predict_i(branch_predictor.predict_o), 
    .Predict_wrong_i(branch_predictor.Predict_wrong_o), 
    .Branch_i(Control.Branch_o)
);

Hazard_Detection Hazard_Detection(
    .IF_ID_RS1addr_i(IF_ID.instr_o[19:15]), 
    .IF_ID_RS2addr_i(IF_ID.instr_o[24:20]), 
    .ID_EX_RDaddr_i(ID_EX.RDaddr_o),
    .ID_EX_MemRead_i(ID_EX.MemRead_o)
);

branch_predictor branch_predictor(
    .clk_i(clk_i), 
    .rst_i(rst_i),
    .ALUResult_i(ALU.data_o), 
    .EX_Branch_i(ID_EX.Branch_o),
    .EX_PC_i(ID_EX.PC_o),
    .Predict_i(branch_predictor.predict_o),
    .EX_immExtended_i(ID_EX.immExtended_o)
);

endmodule