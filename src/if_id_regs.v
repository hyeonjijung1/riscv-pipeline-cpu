// src/if_id_regs.v
// IF/ID pipeline register for a 5-stage RISC-V CPU

module if_id_regs (
    input  wire        clk,        // system clock
    input  wire        reset,      // synchronous reset
    input  wire [31:0] instr_if,   // instruction from IMEM
    input  wire [31:0] pc_plus4,   // PC+4 from PC module
    output reg  [31:0] instr_id,   // latched instruction for ID stage
    output reg  [31:0] pc4_id      // latched PC+4 for ID stage
);

    always @(posedge clk) begin
        if (reset) begin
            instr_id <= 32'd0;
            pc4_id   <= 32'd0;
        end else begin
            instr_id <= instr_if;   // snapshot the fetched instruction
            pc4_id   <= pc_plus4;   // snapshot the next-PC value
        end
    end

endmodule
