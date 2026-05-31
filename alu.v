`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 19:18:01
// Design Name: 
// Module Name: alu
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

module alu (
    input [7:0] a, b,
    input [3:0] opcode,
    output reg [7:0] result,
    output reg zero
);

always @(*) begin
    case (opcode)
        4'b0001: result = a + b; // ADD
        4'b0010: result = a - b; // SUB
        4'b0100: result = (a == b) ? 8'd1 : 8'd0; // CMP
        default: result = 8'd0;
    endcase

    zero = (result == 0);
end

endmodule
