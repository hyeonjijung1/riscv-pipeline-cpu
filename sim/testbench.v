module imem_tb;
    reg  [31:0] addr = 0;
    wire [31:0] instr;

    instruction_mem imem(.addr(addr), .instr(instr));

    initial begin
        $readmemh("program.hex", imem.mem);
        $display("PC=0x%0h -> instr=0x%0h", addr, instr);
        #10 addr = 4;
        #10 $display("PC=0x%0h -> instr=0x%0h", addr, instr);
        #10 $finish;
    end
endmodule
