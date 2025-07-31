// src/register_file.v
// 32×32 integer registers with 2 read ports & 1 write port

module register_file (
    input  wire         clk,
    input  wire         we,        // write enable
    input  wire [4:0]   rd_addr,   // write register index
    input  wire [31:0]  rd_data,   // data to write
    input  wire [4:0]   rs1_addr,  // read port 1 index
    input  wire [4:0]   rs2_addr,  // read port 2 index
    output wire [31:0]  rs1_data,  // read port 1 data
    output wire [31:0]  rs2_data   // read port 2 data
);

    reg [31:0] regs [0:31];

    // Asynchronous read
    assign rs1_data = (rs1_addr != 0) ? regs[rs1_addr] : 32'd0;
    assign rs2_data = (rs2_addr != 0) ? regs[rs2_addr] : 32'd0;

    // Synchronous write on rising clock
    always @(posedge clk) begin
        if (we && rd_addr != 0)
            regs[rd_addr] <= rd_data;
    end

endmodule
