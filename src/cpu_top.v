// src/cpu_top.v
module cpu_top (
    input  wire clk,
    input  wire reset
);

    // --- Wires ---
    wire [31:0] pc;
    wire [31:0] pc_plus4;
    wire [31:0] instr_if;
    wire [31:0] instr_id;
    wire [31:0] pc4_id;

    // --- Program Counter ---
    pc pc_inst (
        .clk     (clk),
        .reset   (reset),
        .next_pc (pc_plus4),
        .pc_out  (pc)
    );

    // --- Instruction Memory ---
    instruction_mem imem_inst (
        .addr  (pc),
        .instr (instr_if)
    );

    // --- PC + 4 Calculation ---
    assign pc_plus4 = pc + 32'd4;

    // --- IF/ID Pipeline Register ---
    if_id_regs ifid_inst (
        .clk       (clk),
        .reset     (reset),
        .instr_if  (instr_if),
        .pc_plus4  (pc_plus4),
        .instr_id  (instr_id),
        .pc4_id    (pc4_id)
    );

endmodule
