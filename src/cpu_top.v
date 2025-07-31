
module cpu_top (
    input  wire        clk,
    input  wire        reset
);

    // ===== IF Stage =====
    wire [31:0] pc, pc_plus4, instr_if;
    pc            u_pc   (
        .clk     (clk),
        .reset   (reset),
        .next_pc (pc_plus4),
        .pc_out  (pc)
    );
    instruction_mem u_imem (
        .addr  (pc),
        .instr (instr_if)
    );
    assign pc_plus4 = pc + 32'd4;

    // IF/ID pipeline registers
    wire [31:0] instr_id, pc4_id;
    if_id_regs    u_ifid (
        .clk       (clk),
        .reset     (reset),
        .instr_if  (instr_if),
        .pc_plus4  (pc_plus4),
        .instr_id  (instr_id),
        .pc4_id    (pc4_id)
    );

    // ===== ID Stage =====
    // Control signals
    wire        RegWrite, MemRead, MemWrite, Branch, ALUSrc, MemToReg;
    wire [1:0]  ALUOp;

    control_unit u_ctrl (
        .opcode    (instr_id[6:0]),
        .RegWrite  (RegWrite),
        .MemRead   (MemRead),
        .MemWrite  (MemWrite),
        .Branch    (Branch),
        .ALUSrc    (ALUSrc),
        .ALUOp     (ALUOp),
        .MemToReg  (MemToReg)
    );

    // Immediate generator
    wire [31:0] imm_id;
    immediate_gen u_imm (
        .instr   (instr_id),
        .imm_out (imm_id)
    );

    // Register file
    wire [31:0] rs1_data, rs2_data;
    register_file u_rf (
        .clk      (clk),
        .we       (RegWrite),
        .rd_addr  (instr_id[11:7]),
        .rd_data  ( /* connect to WB-stage data later */ 32'b0),
        .rs1_addr (instr_id[19:15]),
        .rs2_addr (instr_id[24:20]),
        .rs1_data (rs1_data),
        .rs2_data (rs2_data)
    );

    // ID/EX pipeline registers
    // (snapshot all decode outputs for EX stage)
    wire        RegWrite_ex, MemRead_ex, MemWrite_ex, Branch_ex, ALUSrc_ex, MemToReg_ex;
    wire [1:0]  ALUOp_ex;
    wire [31:0] rs1_ex, rs2_ex, imm_ex, pc4_ex;
    wire [4:0]  rs1_addr_ex, rs2_addr_ex, rd_addr_ex;

    id_ex_regs u_idex (
        .clk          (clk),
        .reset        (reset),

        // control signals in
        .RegWrite_i   (RegWrite),
        .MemRead_i    (MemRead),
        .MemWrite_i   (MemWrite),
        .Branch_i     (Branch),
        .ALUSrc_i     (ALUSrc),
        .MemToReg_i   (MemToReg),
        .ALUOp_i      (ALUOp),

        // data in
        .rs1_data_i   (rs1_data),
        .rs2_data_i   (rs2_data),
        .imm_i        (imm_id),
        .pc4_i        (pc4_id),
        .rs1_addr_i   (instr_id[19:15]),
        .rs2_addr_i   (instr_id[24:20]),
        .rd_addr_i    (instr_id[11:7]),

        // outputs to EX stage
        .RegWrite_o   (RegWrite_ex),
        .MemRead_o    (MemRead_ex),
        .MemWrite_o   (MemWrite_ex),
        .Branch_o     (Branch_ex),
        .ALUSrc_o     (ALUSrc_ex),
        .MemToReg_o   (MemToReg_ex),
        .ALUOp_o      (ALUOp_ex),
        .rs1_data_o   (rs1_ex),
        .rs2_data_o   (rs2_ex),
        .imm_o        (imm_ex),
        .pc4_o        (pc4_ex),
        .rs1_addr_o   (rs1_addr_ex),
        .rs2_addr_o   (rs2_addr_ex),
        .rd_addr_o    (rd_addr_ex)
    );

    // ===== EX, MEM, WB Stages to be implemented next =====

endmodule
