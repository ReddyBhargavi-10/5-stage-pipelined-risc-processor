`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 20:28:49
// Design Name: 
// Module Name: control_unit
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
module control_unit (
    input [3:0] opcode,

    output reg reg_write,
    output reg mem_write,
    output reg mem_to_reg,
    output reg halt
);

always @(*) begin

    reg_write = 0;
    mem_write = 0;
    mem_to_reg = 0;
    halt = 0;

    case (opcode)

        4'b0001,
        4'b0010,
        4'b0011,
        4'b0100:
            reg_write = 1;

        4'b0110: begin
            reg_write = 1;
            mem_to_reg = 1;
        end

        4'b0111: begin
            mem_write = 1;
        end

        4'b1111: begin
            halt = 1;
        end

        default: begin
            reg_write = 0;
            mem_write = 0;
            mem_to_reg = 0;
            halt = 0;
        end

    endcase

end

endmodule