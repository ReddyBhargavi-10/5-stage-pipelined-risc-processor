`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 15:24:26
// Design Name: 
// Module Name: forwarding_unit
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

module forwarding_unit (

    input ex_mem_regwrite,
    input mem_wb_regwrite,

    input [2:0] ex_mem_rd,
    input [2:0] mem_wb_rd,

    input [2:0] id_ex_rs1,
    input [2:0] id_ex_rs2,

    output reg [1:0] forward_a,
    output reg [1:0] forward_b

);

always @(*) begin

    // Default: no forwarding
    forward_a = 2'b00;
    forward_b = 2'b00;

    //================================================
    // EX Hazard
    //================================================

    if (ex_mem_regwrite &&
        (ex_mem_rd == id_ex_rs1))
    begin
        forward_a = 2'b10;
    end

    if (ex_mem_regwrite &&
        (ex_mem_rd == id_ex_rs2))
    begin
        forward_b = 2'b10;
    end

    //================================================
    // MEM Hazard
    //================================================

    if (mem_wb_regwrite &&
        !(ex_mem_regwrite &&
          (ex_mem_rd == id_ex_rs1)) &&
        (mem_wb_rd == id_ex_rs1))
    begin
        forward_a = 2'b01;
    end

    if (mem_wb_regwrite &&
        !(ex_mem_regwrite &&
          (ex_mem_rd == id_ex_rs2)) &&
        (mem_wb_rd == id_ex_rs2))
    begin
        forward_b = 2'b01;
    end

end

endmodule