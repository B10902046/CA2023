module CPU
(
    clk_i,  //clocks
    rst_i 
);

// Ports
input               clk_i;
input               rst_i;

wire     [31:0]     pc_o;
wire     [31:0]     Add_PC_o;
wire     [31:0]     instr_o;
wire     [6:0]      Opcode;
wire     [1:0]      ALUOp_o;
wire                ALUSrc_o;
wire                RegWrite_o;
wire     [4:0]      RS1addr_i;
wire     [4:0]      RS2addr_i;
wire     [4:0]      RDaddr_i;
wire     [31:0]     RS1data_o;
wire     [31:0]     RS2data_o;
wire     [31:0]     RDdata_i;
wire     [11:0]     Imm_i;
wire     [31:0]     Imm_o;
wire     [2:0]      ALUCtrl_o;
wire     [31:0]     ALUdata_i;
wire     [31:0]     ALUdata_o;
wire     [9:0]      funct_i;

//Instruction Fetch
assign Opcode = instr_o[6:0];
assign RS1addr_i = instr_o[19:15];
assign RS2addr_i = instr_o[24:20];
assign RDaddr_i = instr_o[11:7];
assign funct_i = {instr_o[31:25],instr_o[14:12]};
assign Imm_i =  instr_o[31:20];   

Adder Add_PC(
    .data1_in   (pc_o),
    .data2_in   (32'd4),
    .data_o     (Add_PC_o)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .pc_i       (Add_PC_o),
    .pc_o       (pc_o)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc_o), 
    .instr_o    (instr_o)
);

Registers Registers(
    .rst_i      (rst_i),
    .clk_i       (clk_i),
    .RS1addr_i   (RS1addr_i),
    .RS2addr_i   (RS2addr_i), 
    .RDaddr_i    (RDaddr_i), 
    .RDdata_i    (ALUdata_o),
    .RegWrite_i  (RegWrite_o),
    .RS1data_o   (RS1data_o), 
    .RS2data_o   (RS2data_o)
);

Control Control(
    .Op_i       (Opcode),
    .ALUOp_o    (ALUOp_o),
    .ALUSrc_o   (ALUSrc_o),
    .RegWrite_o (RegWrite_o)
);

Sign_Extend Sign_Extend(
    .data_i     (Imm_i),
    .data_o     (Imm_o)
);
  
MUX32 MUX_ALUSrc(
    .data1_i    (RS2data_o),
    .data2_i    (Imm_o),
    .sel_i   (ALUSrc_o),
    .data_o     (ALUdata_i)
);

ALU ALU(
    .data1_i    (RS1data_o),
    .data2_i    (ALUdata_i),
    .ALUCtrl_i  (ALUCtrl_o),
    .data_o     (ALUdata_o)
);

ALU_Control ALU_Control(
    .funct_i    (funct_i),
    .ALUOp_i    (ALUOp_o),
    .ALUCtrl_o  (ALUCtrl_o)
);

endmodule