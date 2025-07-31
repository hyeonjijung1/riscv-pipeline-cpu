// writes a value into one register and then reads it back (and checks that x0 stays zero):
// sim/regfile_tb.v
`timescale 1ns/1ps

module regfile_tb;
    // Inputs
    reg         clk = 0;
    reg         we  = 0;
    reg  [4:0]  rd_addr;
    reg  [31:0] rd_data;
    reg  [4:0]  rs1_addr;
    reg  [4:0]  rs2_addr;

    // Outputs
    wire [31:0] rs1_data;
    wire [31:0] rs2_data;

    // Instantiate the register file
    register_file DUT (
        .clk      (clk),
        .we       (we),
        .rd_addr  (rd_addr),
        .rd_data  (rd_data),
        .rs1_addr (rs1_addr),
        .rs2_addr (rs2_addr),
        .rs1_data (rs1_data),
        .rs2_data (rs2_data)
    );

    // Clock generation
    always #5 clk = ~clk;  // 10 ns period

    initial begin
        // 1) Write 0xDEADBEEF into x5
        #10;                     // wait 10 ns
        we      = 1;
        rd_addr = 5;
        rd_data = 32'hDEAD_BEEF;
        #10;                     // complete one clock cycle
        we      = 0;

        // 2) Read back from x5 and from x0
        #10;
        rs1_addr = 5;
        rs2_addr = 0;
        #5;                      // wait for combinational read
        $display("Read x5 = 0x%0h (expected DEAD_BEEF)", rs1_data);
        $display("Read x0 = 0x%0h (expected 00000000)", rs2_data);

        #10;
        $finish;
    end
endmodule
