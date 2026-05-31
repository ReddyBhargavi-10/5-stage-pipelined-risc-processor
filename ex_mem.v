module ex_mem (

    input clk,
    input reset,
    input write_enable,

    // Data inputs
    input [7:0] alu_result_in,
    input [7:0] rd2_in,

    input [2:0] rd_in,
    input [8:0] mem_addr_in,

    // Control inputs
    input reg_write_in,
    input mem_write_in,
    input mem_to_reg_in,

    // Data outputs
    output reg [7:0] alu_result_out,
    output reg [7:0] rd2_out,

    output reg [2:0] rd_out,
    output reg [8:0] mem_addr_out,

    // Control outputs
    output reg reg_write_out,
    output reg mem_write_out,
    output reg mem_to_reg_out

);

always @(posedge clk or posedge reset) begin

    if (reset) begin

        alu_result_out <= 0;
        rd2_out <= 0;

        rd_out <= 0;

        reg_write_out <= 0;
        mem_write_out <= 0;
        mem_to_reg_out <= 0;
        mem_addr_out <= 0;

    end

    else if (write_enable) begin

        alu_result_out <= alu_result_in;
        rd2_out <= rd2_in;

        rd_out <= rd_in;

        reg_write_out <= reg_write_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        mem_addr_out <= mem_addr_in;

    end

end

endmodule