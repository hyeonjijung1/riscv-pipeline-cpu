// src/pc.v
// Program Counter for a 5-stage pipelined RISC-V CPU

module pc (
    input  wire        clk,       // system clock
    input  wire        reset,     // active-high synchronous reset
    input  wire [31:0] next_pc,   // computed next PC (e.g. PC+4 or branch target)
    output reg  [31:0] pc_out     // current PC value
);

    // On each rising clock edge:
    // - If reset is asserted, go to address 0
    // - Otherwise update PC to next_pc
    always @(posedge clk) begin
        if (reset)
            pc_out <= 32'd0;
        else
            pc_out <= next_pc;
    end

endmodule
