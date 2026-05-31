`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 19:34:30
// Design Name: 
// Module Name: pc
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

module pc (
    input clk,
    input rst, 
    input pc_write, 
    output reg [7:0] pc_out
);

always @(posedge clk or posedge rst) begin 
    if (rst) 
        pc_out <= 8'd0;
    else if (pc_write) 
        pc_out <= pc_out + 8'd1; 
end

endmodule
