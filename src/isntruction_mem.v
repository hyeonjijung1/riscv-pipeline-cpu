// src/instruction_mem.v
// Simple read-only instruction ROM for RV32I CPU

module instruction_mem (
    input  wire [31:0] addr,    // PC value
    output wire [31:0] instr    // fetched instruction
);

    // 256 words of 32-bit memory
    reg [31:0] mem [0:255];

    initial begin
        // Load the hex program (sim/program.hex)
        $readmemh("sim/program.hex", mem);
    end

    // Word-addressed: drop bottom two bits of addr
    assign instr = mem[ addr[9:2] ];

endmodule