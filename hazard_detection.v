`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.05.2026 15:28:47
// Design Name: 
// Module Name: hazard_detection
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

module hazard_detection (

    input id_ex_mem_to_reg,
    input [2:0] id_ex_rd,

    input [2:0] if_id_rs1,
    input [2:0] if_id_rs2,

    output reg pc_write,
    output reg if_id_write,
    output reg stall

);

always @(*) begin

    // Default: normal execution
    pc_write = 1;
    if_id_write = 1;
    stall = 0;

    // Load-use hazard detection
    if (id_ex_mem_to_reg &&
       ((id_ex_rd == if_id_rs1) ||
        (id_ex_rd == if_id_rs2)))
    begin

        // Stall pipeline
        pc_write = 0;
        if_id_write = 0;
        stall = 1;

    end

end

endmodule
