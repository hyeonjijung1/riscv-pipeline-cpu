module data_mem(
    input         clk, MemRead, MemWrite,
    input  [31:0] addr, write_data,
    output reg [31:0] read_data
);
    reg [31:0] mem [0:255]; // 1KB for demo

    always @(posedge clk) begin
        if (MemWrite) mem[addr[9:2]] <= write_data;
    end

    always @(*) begin
        if (MemRead) read_data = mem[addr[9:2]];
        else read_data = 32'b0;
    end
endmodule
