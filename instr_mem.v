
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.05.2026 20:04:54
// Design Name: 
// Module Name: instr_mem
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
module instr_mem (
    input imem_read,
    input [7:0] addr,
    output [15:0] instr
);

reg [15:0] mem [0:255];
integer i;

initial begin

    // Initialize all locations
    for(i=0;i<256;i=i+1)
        mem[i] = 16'hF000;

    // Load program
    $readmemh("program1.mem", mem);

    $display("Instruction Memory Loaded");
    $display("mem[0]=%h", mem[0]);
    $display("mem[1]=%h", mem[1]);
    $display("mem[7]=%h", mem[7]);

end

assign instr = (imem_read) ? mem[addr] : 16'h0000;

endmodule