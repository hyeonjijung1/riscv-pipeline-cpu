module cpu_top (
    input  wire clk,
    input  wire reset
);
    wire        pc_write;
    wire [31:0] pc_curr, pc_next, pc_plus4_if;
    wire [31:0] instr_if;

    wire        bp_predict_taken;
    wire        branch_taken_actual_ex;
    wire [31:0] branch_target_ex;

    wire        ifid_write;
    wire [31:0] pc_plus4_id, instr_id;

    wire  [6:0] opcode_id   = instr_id[6:0];
    wire  [2:0] funct3_id   = instr_id[14:12];
    wire  [6:0] funct7_id   = instr_id[31:25];
    wire  [4:0] rs1_id      = instr_id[19:15];
    wire  [4:0] rs2_id      = instr_id[24:20];
    wire  [4:0] rd_id       = instr_id[11:7];

    wire Branch_c, MemRead_c, MemtoReg_c, MemWrite_c, ALUSrc_c, RegWrite_c;
    wire [1:0] ALUOp_c;

    wire control_mux;
    wire Branch_id   = control_mux ? 1'b0 : Branch_c;
    wire MemRead_id  = control_mux ? 1'b0 : MemRead_c;
    wire MemtoReg_id = control_mux ? 1'b0 : MemtoReg_c;
    wire MemWrite_id = control_mux ? 1'b0 : MemWrite_c;
    wire ALUSrc_id   = control_mux ? 1'b0 : ALUSrc_c;
    wire RegWrite_id = control_mux ? 1'b0 : RegWrite_c;
    wire [1:0] ALUOp_id = control_mux ? 2'b00 : ALUOp_c;

    wire [31:0] rs1_data_id, rs2_data_id;
    wire [31:0] imm_id;

    wire [31:0] pc_plus4_ex, rs1_ex, rs2_ex, imm_ex;
    wire [4:0]  rs1_addr_ex, rs2_addr_ex, rd_ex;
    wire        Branch_ex, MemRead_ex, MemtoReg_ex, MemWrite_ex, ALUSrc_ex, RegWrite_ex;
    wire [1:0]  ALUOp_ex;
    wire [2:0]  funct3_ex;
    wire [6:0]  funct7_ex;

    wire [1:0] forwardA, forwardB;
    wire [31:0] alu_srcA_pre, alu_srcB_pre;
    wire [31:0] alu_srcA, alu_srcB;

    wire [3:0]  alu_ctrl_ex;
    wire [31:0] alu_result_ex;
    wire        zero_ex;

    wire [31:0] alu_op2_mux = ALUSrc_ex ? imm_ex : alu_srcB;

    wire [31:0] pc_branch_target_ex = pc_plus4_ex + (imm_ex << 0);

    wire [31:0] alu_result_mem, write_data_mem;
    wire [4:0]  rd_mem;
    wire        MemRead_mem, MemWrite_mem, MemtoReg_mem, RegWrite_mem;

    wire [31:0] read_data_mem;

    wire [31:0] alu_result_wb, mem_data_wb;
    wire [4:0]  rd_wb;
    wire        MemtoReg_wb, RegWrite_wb;

    wire [31:0] write_back_data = MemtoReg_wb ? mem_data_wb : alu_result_wb;

    pc u_pc (
        .clk      (clk),
        .reset    (reset),
        .pc_write (pc_write),
        .pc_in    (pc_next),
        .pc_out   (pc_curr)
    );

    assign pc_plus4_if = pc_curr + 32'd4;

    instruction_mem u_imem (
        .addr  (pc_curr),
        .instr (instr_if)
    );

    assign pc_next = (branch_taken_actual_ex) ? branch_target_ex : pc_plus4_if;

    branch_predictor u_bp (
        .clk                (clk),
        .reset              (reset),
        .branch_taken_actual(branch_taken_actual_ex),
        .pc_in              (pc_curr),
        .predict_taken      (bp_predict_taken)
    );

    if_id_regs u_ifid (
        .clk      (clk),
        .reset    (reset),
        .write_en (ifid_write),
        .pc_plus4_in (pc_plus4_if),
        .instr_in    (instr_if),
        .pc_plus4_out(pc_plus4_id),
        .instr_out   (instr_id)
    );

    control u_ctrl (
        .opcode  (opcode_id),
        .Branch  (Branch_c),
        .MemRead (MemRead_c),
        .MemtoReg(MemtoReg_c),
        .MemWrite(MemWrite_c),
        .ALUSrc  (ALUSrc_c),
        .RegWrite(RegWrite_c),
        .ALUOp   (ALUOp_c)
    );

    register_file u_rf (
        .clk   (clk),
        .we    (RegWrite_wb),
        .rs1   (rs1_id),
        .rs2   (rs2_id),
        .rd    (rd_wb),
        .wd    (write_back_data),
        .rd1   (rs1_data_id),
        .rd2   (rs2_data_id)
    );

    immediate_gen u_imm (
        .instr (instr_id),
        .imm   (imm_id)
    );

    hazard_detection u_haz (
        .MemRead_IDEX (MemRead_ex),
        .rd_IDEX      (rd_ex),
        .rs1_IFID     (rs1_id),
        .rs2_IFID     (rs2_id),
        .PCWrite      (pc_write),
        .IFIDWrite    (ifid_write),
        .control_mux  (control_mux)
    );

    id_ex_regs u_idex (
        .clk(clk), .reset(reset),
        .pc_plus4_in (pc_plus4_id),
        .rs1_in      (rs1_data_id),
        .rs2_in      (rs2_data_id),
        .imm_in      (imm_id),
        .rs1_addr_in (rs1_id),
        .rs2_addr_in (rs2_id),
        .rd_in       (rd_id),
        .funct3_in   (funct3_id),
        .funct7_in   (instr_id[31:25]),
        .Branch_in   (Branch_id),
        .MemRead_in  (MemRead_id),
        .MemtoReg_in (MemtoReg_id),
        .MemWrite_in (MemWrite_id),
        .ALUSrc_in   (ALUSrc_id),
        .RegWrite_in (RegWrite_id),
        .ALUOp_in    (ALUOp_id),

        .pc_plus4_out(pc_plus4_ex),
        .rs1_out     (rs1_ex),
        .rs2_out     (rs2_ex),
        .imm_out     (imm_ex),
        .rs1_addr_out(rs1_addr_ex),
        .rs2_addr_out(rs2_addr_ex),
        .rd_out      (rd_ex),
        .funct3_out  (funct3_ex),
        .funct7_out  (funct7_ex),
        .Branch_out  (Branch_ex),
        .MemRead_out (MemRead_ex),
        .MemtoReg_out(MemtoReg_ex),
        .MemWrite_out(MemWrite_ex),
        .ALUSrc_out  (ALUSrc_ex),
        .RegWrite_out(RegWrite_ex),
        .ALUOp_out   (ALUOp_ex)
    );

    alu_control u_aluctrl (
        .ALUOp    (ALUOp_ex),
        .funct3   (funct3_ex),
        .funct7_5 (funct7_ex[5]),
        .alu_ctrl (alu_ctrl_ex)
    );

    forwarding_unit u_fwd (
        .RegWrite_EXMEM (RegWrite_mem),
        .RegWrite_MEMWB (RegWrite_wb),
        .rd_EXMEM       (rd_mem),
        .rd_MEMWB       (rd_wb),
        .rs1_IDEX       (rs1_addr_ex),
        .rs2_IDEX       (rs2_addr_ex),
        .forwardA       (forwardA),
        .forwardB       (forwardB)
    );

    assign alu_srcA_pre = rs1_ex;
    assign alu_srcB_pre = rs2_ex;

    wire [31:0] exmem_forward_data = alu_result_mem;
    wire [31:0] memwb_forward_data = write_back_data;

    assign alu_srcA = (forwardA == 2'b10) ? exmem_forward_data :
                      (forwardA == 2'b01) ? memwb_forward_data :
                                             alu_srcA_pre;

    assign alu_srcB = (forwardB == 2'b10) ? exmem_forward_data :
                      (forwardB == 2'b01) ? memwb_forward_data :
                                             alu_srcB_pre;

    alu u_alu (
        .a       (alu_srcA),
        .b       (alu_op2_mux),
        .alu_ctrl(alu_ctrl_ex),
        .result  (alu_result_ex),
        .zero    (zero_ex)
    );

    assign branch_taken_actual_ex = Branch_ex && zero_ex;
    assign branch_target_ex = pc_branch_target_ex;

    ex_mem_regs u_exmem (
        .clk(clk), .reset(reset),
        .alu_result_in (alu_result_ex),
        .write_data_in (alu_srcB_pre),
        .rd_in         (rd_ex),
        .MemRead_in    (MemRead_ex),
        .MemWrite_in   (MemWrite_ex),
        .MemtoReg_in   (MemtoReg_ex),
        .RegWrite_in   (RegWrite_ex),

        .alu_result_out(alu_result_mem),
        .write_data_out(write_data_mem),
        .rd_out        (rd_mem),
        .MemRead_out   (MemRead_mem),
        .MemWrite_out  (MemWrite_mem),
        .MemtoReg_out  (MemtoReg_mem),
        .RegWrite_out  (RegWrite_mem)
    );

    data_mem u_dmem (
        .clk       (clk),
        .MemRead   (MemRead_mem),
        .MemWrite  (MemWrite_mem),
        .addr      (alu_result_mem),
        .write_data(write_data_mem),
        .read_data (read_data_mem)
    );

    mem_wb_regs u_memwb (
        .clk(clk), .reset(reset),
        .alu_result_in (alu_result_mem),
        .mem_data_in   (read_data_mem),
        .rd_in         (rd_mem),
        .MemtoReg_in   (MemtoReg_mem),
        .RegWrite_in   (RegWrite_mem),

        .alu_result_out(alu_result_wb),
        .mem_data_out  (mem_data_wb),
        .rd_out        (rd_wb),
        .MemtoReg_out  (MemtoReg_wb),
        .RegWrite_out  (RegWrite_wb)
    );
endmodule
