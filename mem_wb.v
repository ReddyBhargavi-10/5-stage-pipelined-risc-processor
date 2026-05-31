`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 14:00:14
// Design Name: 
// Module Name: mem_wb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module mem_wb (

    input clk,
    input reset,
    input write_enable,

    // Data inputs
    input [7:0] mem_data_in,
    input [7:0] alu_result_in,

    input [2:0] rd_in,

    // Control inputs
    input reg_write_in,
    input mem_to_reg_in,

    // Data outputs
    output reg [7:0] mem_data_out,
    output reg [7:0] alu_result_out,

    output reg [2:0] rd_out,

    // Control outputs
    output reg reg_write_out,
    output reg mem_to_reg_out

);

always @(posedge clk or posedge reset) begin

    if (reset) begin

        mem_data_out <= 0;
        alu_result_out <= 0;

        rd_out <= 0;

        reg_write_out <= 0;
        mem_to_reg_out <= 0;

    end

    else if (write_enable) begin

        mem_data_out <= mem_data_in;
        alu_result_out <= alu_result_in;

        rd_out <= rd_in;

        reg_write_out <= reg_write_in;
        mem_to_reg_out <= mem_to_reg_in;

    end

end

endmodule