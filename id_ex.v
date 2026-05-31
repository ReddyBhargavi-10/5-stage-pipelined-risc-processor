module id_ex (

    input clk,
    input reset,
    input write_enable,

    // Data inputs
    input [7:0] pc_in,
    input [7:0] rd1_in,
    input [7:0] rd2_in,

    // NEW: source registers
    input [2:0] rs1_in,
    input [2:0] rs2_in,

    input [3:0] opcode_in,
    input [2:0] rd_in,

    // NEW: memory address
    input [8:0] mem_addr_in,

    // Control signals
    input reg_write_in,
    input mem_write_in,
    input mem_to_reg_in,

    // Data outputs
    output reg [7:0] pc_out,
    output reg [7:0] rd1_out,
    output reg [7:0] rd2_out,

    // NEW: source register outputs
    output reg [2:0] rs1_out,
    output reg [2:0] rs2_out,

    output reg [3:0] opcode_out,
    output reg [2:0] rd_out,

    // NEW: memory address output
    output reg [8:0] mem_addr_out,

    // Control outputs
    output reg reg_write_out,
    output reg mem_write_out,
    output reg mem_to_reg_out

);

always @(posedge clk or posedge reset) begin

    if (reset) begin

        pc_out <= 0;
        rd1_out <= 0;
        rd2_out <= 0;

        rs1_out <= 0;
        rs2_out <= 0;

        opcode_out <= 0;
        rd_out <= 0;

        mem_addr_out <= 0;

        reg_write_out <= 0;
        mem_write_out <= 0;
        mem_to_reg_out <= 0;

    end

    else if (write_enable) begin

        pc_out <= pc_in;
        rd1_out <= rd1_in;
        rd2_out <= rd2_in;

        rs1_out <= rs1_in;
        rs2_out <= rs2_in;

        opcode_out <= opcode_in;
        rd_out <= rd_in;

        mem_addr_out <= mem_addr_in;

        reg_write_out <= reg_write_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;

    end

end

endmodule