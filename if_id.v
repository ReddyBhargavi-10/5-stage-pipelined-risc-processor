module if_id (
    input clk,
    input rst,
    input write_enable,

    input [7:0] pc_in,
    input [15:0] instr_in,

    output reg [7:0] pc_out,
    output reg [15:0] instr_out
);

always @(posedge clk or posedge rst) begin

    if (rst) begin
        pc_out <= 8'd0;
        instr_out <= 16'd0;
    end

    else if (write_enable) begin
        pc_out <= pc_in;
        instr_out <= instr_in;
    end

end

endmodule