// Extract & sign-extend immediates from a 32-bit RISC-V instruction

module immediate_gen (
    input  wire [31:0] instr,    // full instruction from IF/ID
    output reg  [31:0] imm_out   // sign-extended immediate
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)
            7'b0000011, // I-type loads  (LW)
            7'b0010011: // I-type ALU   (ADDI, ANDI,…)
                imm_out = {{20{instr[31]}}, instr[31:20]};

            7'b0100011: // S-type stores (SW)
                imm_out = {{20{instr[31]}},
                           instr[31:25], instr[11:7]};

            7'b1100011: // B-type branches (BEQ)
                imm_out = {{19{instr[31]}},
                           instr[31], instr[7],
                           instr[30:25], instr[11:8], 1'b0};

            7'b1101111: // J-type jump   (JAL)
                imm_out = {{11{instr[31]}},
                           instr[31], instr[19:12],
                           instr[20], instr[30:21], 1'b0};

            default:
                imm_out = 32'd0;
        endcase
    end

endmodule