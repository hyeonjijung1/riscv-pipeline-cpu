`timescale 1ns/1ps

module immgen_tb;
    reg [31:0] instr;
    wire [31:0] imm_out;

    immediate_gen DUT(.instr(instr), .imm_out(imm_out));

    initial begin
        // I-type example: ADDI x5, x0, -1  → imm = 0xFFF
        instr = 32'b1111_111111111111_00000_000_00101_0010011;
        #1 $display("I-type imm = 0x%0h", imm_out);

        // S-type example: SW x1, 8(x2) → imm = 8
        instr = {7'b0100011, 5'd1, 5'd2, 3'b010, 5'd0, 7'b0100011};
        instr[31:25] = 7'd0; instr[11:7] = 5'd8;
        #1 $display("S-type imm = 0x%0h", imm_out);

        // B-type example: BEQ x1, x2, 16 → imm = 16
        instr = 32'b0000000_00010_00001_000_00010_1100011;
        instr[31] = 1'b0; instr[7]=1'b0;
        instr[30:25]=6'b010000; instr[11:8]=4'b0001;
        #1 $display("B-type imm = 0x%0h", imm_out);

        #1 $finish;
    end
endmodule