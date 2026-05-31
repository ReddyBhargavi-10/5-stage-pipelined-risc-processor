`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 20:35:38
// Design Name: 
// Module Name: data_mem
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

module data_mem (
    input clk,
    input we,
    input [8:0] addr,
    input [7:0] wd,
    output [7:0] rd
);

reg [7:0] memory [0:511];

integer i;

initial begin

    for(i = 0; i < 512; i = i + 1)
        memory[i] = 8'd0;

    memory[10] = 8'd10;
    memory[11] = 8'd11;

end

assign rd =
       (^addr === 1'bX) ?
       8'd0 :
       memory[addr];

always @(posedge clk) begin

    if (we)
        memory[addr] <= wd;

end

endmodule