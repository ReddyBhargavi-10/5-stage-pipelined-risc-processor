`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.05.2026 20:42:12
// Design Name: 
// Module Name: risc_processor_tb
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

module risc_processor_tb;

reg clk;
reg rst;

// Instantiate processor
risc_processor DUT (

    .clk(clk),
    .rst(rst)

);

// Clock generation
always #5 clk = ~clk;

// Simulation
initial begin

    clk = 0;
    rst = 1;

    // Reset duration
    #10;
    rst = 0;

    // Run simulation
    wait(DUT.halt);
    
    #300;
    $display("Reached end of simulation");
    $finish;

end

// Monitor values
initial begin

    $monitor(
        "TIME=%0t PC=%d R1=%d R2=%d R3=%d R4=%d R5=%d",
        $time,
        DUT.pc_out,
        DUT.RF.registers[1],
        DUT.RF.registers[2],
        DUT.RF.registers[3],
        DUT.RF.registers[4],
        DUT.RF.registers[5]
    );

end


endmodule