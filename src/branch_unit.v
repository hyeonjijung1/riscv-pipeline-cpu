module branch_unit (
    input  wire [2:0]  funct3,
    input  wire [31:0] rs1_val,
    input  wire [31:0] rs2_val,
    output reg         take_branch
);
    wire signed [31:0] s_rs1 = rs1_val;
    wire signed [31:0] s_rs2 = rs2_val;

    always @(*) begin
        case (funct3)
            3'b000: take_branch = (rs1_val == rs2_val);
            3'b001: take_branch = (rs1_val != rs2_val);
            3'b100: take_branch = (s_rs1   <  s_rs2);
            3'b101: take_branch = (s_rs1   >= s_rs2);
            3'b110: take_branch = (rs1_val <  rs2_val);
            3'b111: take_branch = (rs1_val >= rs2_val);
            default: take_branch = 1'b0;
        endcase
    end
endmodule
