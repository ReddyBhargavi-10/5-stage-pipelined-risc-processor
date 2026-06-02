`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 20:22:08
// Design Name: 
// Module Name: instr_decoder
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


module instr_decoder(
input [15:0]instr,
output [3:0]opcode,
output [2:0]rd,
output [2:0]rs1,
output [2:0]rs2,
output [2:0]reg_m,
output [8:0] mem_addr
);

assign opcode = instr[15:12];
assign rd = instr [11:9];
assign rs1 = instr[8:6];
assign rs2 = instr[5:3];

assign reg_m = instr[11:9];
assign mem_addr = instr[8:0];

endmodule