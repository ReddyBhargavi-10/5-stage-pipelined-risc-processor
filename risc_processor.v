
module risc_processor (

    input clk,
    input rst

);

//====================================================
// IF STAGE
//====================================================

wire [7:0] pc_out;
wire [15:0] instr;

wire pc_write;
wire if_id_write;

pc PC (
    .clk(clk),
    .rst(rst),
    .pc_write(pc_write & ~halt),
    .pc_out(pc_out)
);

instr_mem IMEM (
    .imem_read(1'b1),
    .addr(pc_out),
    .instr(instr)
);

//====================================================
// IF/ID PIPELINE REGISTER
//====================================================

wire [7:0] if_id_pc;
wire [15:0] if_id_instr;

if_id IF_ID (

    .clk(clk),
    .rst(rst),
    .write_enable(if_id_write),

    .pc_in(pc_out),
    .instr_in(instr),

    .pc_out(if_id_pc),
    .instr_out(if_id_instr)

);

//====================================================
// ID STAGE
//====================================================

wire [3:0] opcode;
wire [2:0] rd;
wire [2:0] rs1;
wire [2:0] rs2;
wire [2:0] reg_m;
wire [8:0] mem_addr;

instr_decoder DECODER (

    .instr(if_id_instr),

    .opcode(opcode),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .reg_m(reg_m),
    .mem_addr(mem_addr)

);

//====================================================
// CONTROL UNIT
//====================================================

wire reg_write;
wire mem_write;
wire mem_to_reg;
wire halt;

control_unit CU (

    .opcode(opcode),

    .reg_write(reg_write),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .halt(halt)

);

//====================================================
// REGISTER FILE
//====================================================

wire [7:0] rd1;
wire [7:0] rd2;

wire [7:0] write_back_data;

wire mem_wb_reg_write;
wire [2:0] mem_wb_rd;
wire [7:0] rd1_fixed;
wire [7:0] rd2_fixed;
assign rd1_fixed = (mem_wb_reg_write && (mem_wb_rd == rs1))? write_back_data : rd1;
assign rd2_fixed = (mem_wb_reg_write && (mem_wb_rd == rs2))? write_back_data : rd2;

register_file RF (

    .clk(clk),
    .rst(rst),
    .we(mem_wb_reg_write),

    .read_addr1(rs1),
    .read_addr2(rs2),

    .write_addr(mem_wb_rd),
    .write_data(write_back_data),

    .read_data1(rd1),
    .read_data2(rd2)

);

//====================================================
// HAZARD DETECTION UNIT
//====================================================

wire stall;

wire id_ex_mem_to_reg;
wire [2:0] id_ex_rd;

hazard_detection HDU (

    .id_ex_mem_to_reg(id_ex_mem_to_reg),
    .id_ex_rd(id_ex_rd),

    .if_id_rs1(rs1),
    .if_id_rs2(rs2),

    .pc_write(pc_write),
    .if_id_write(if_id_write),
    .stall(stall)

);

//====================================================
// ID/EX PIPELINE REGISTER
//====================================================

wire [7:0] id_ex_pc;
wire [7:0] id_ex_rd1;
wire [7:0] id_ex_rd2;

wire [3:0] id_ex_opcode;

wire id_ex_reg_write;
wire id_ex_mem_write;
wire [2:0] id_ex_rs1;
wire [2:0] id_ex_rs2;
wire [8:0] id_ex_mem_addr;
wire reg_write_safe;
wire mem_write_safe;
wire mem_to_reg_safe;

assign reg_write_safe =
       (stall) ? 1'b0 : reg_write;

assign mem_write_safe =
       (stall) ? 1'b0 : mem_write;

assign mem_to_reg_safe =
       (stall) ? 1'b0 : mem_to_reg;

id_ex ID_EX (

    .clk(clk),
    .reset(rst),
    .write_enable(1'b1),

    .pc_in(if_id_pc),
    .rd1_in(rd1_fixed),
    .rd2_in(rd2_fixed),

    // NEW
    .rs1_in(rs1),
    .rs2_in(rs2),

    .opcode_in(opcode),
    .rd_in(rd),

    // NEW
    .mem_addr_in(mem_addr),

    .reg_write_in(reg_write_safe),
    .mem_write_in(mem_write_safe),
    .mem_to_reg_in(mem_to_reg_safe),

    .pc_out(id_ex_pc),
    .rd1_out(id_ex_rd1),
    .rd2_out(id_ex_rd2),

    // NEW
    .rs1_out(id_ex_rs1),
    .rs2_out(id_ex_rs2),

    .opcode_out(id_ex_opcode),
    .rd_out(id_ex_rd),

    // NEW
    .mem_addr_out(id_ex_mem_addr),

    .reg_write_out(id_ex_reg_write),
    .mem_write_out(id_ex_mem_write),
    .mem_to_reg_out(id_ex_mem_to_reg)

);

//====================================================
// FORWARDING UNIT
//====================================================

wire [1:0] forward_a;
wire [1:0] forward_b;

wire ex_mem_reg_write;
wire [2:0] ex_mem_rd;

forwarding_unit FU (

    .ex_mem_regwrite(ex_mem_reg_write),
    .mem_wb_regwrite(mem_wb_reg_write),

    .ex_mem_rd(ex_mem_rd),
    .mem_wb_rd(mem_wb_rd),

    .id_ex_rs1(id_ex_rs1),
    .id_ex_rs2(id_ex_rs2),

    .forward_a(forward_a),
    .forward_b(forward_b)

);

//====================================================
// ALU + MULTIPLIER
//====================================================

wire [7:0] alu_result;
wire [7:0] mul_result;
wire [7:0] ex_result;
reg [7:0] alu_src_a;
reg [7:0] alu_src_b;

wire zero;

always @(*) begin

    // Forward A
    case(forward_a)

        2'b00:
            alu_src_a = id_ex_rd1;

        2'b10:
            alu_src_a = ex_mem_alu_result;

        2'b01:
            alu_src_a = write_back_data;

        default:
            alu_src_a = id_ex_rd1;

    endcase

    // Forward B
    case(forward_b)

        2'b00:
            alu_src_b = id_ex_rd2;

        2'b10:
            alu_src_b = ex_mem_alu_result;

        2'b01:
            alu_src_b = write_back_data;

        default:
            alu_src_b = id_ex_rd2;

    endcase

end

alu ALU (

    .a(alu_src_a),
    .b(alu_src_b),

    .opcode(id_ex_opcode),

    .result(alu_result),
    .zero(zero)

);

multiplier MUL (

    .a(alu_src_a),
    .b(alu_src_b),

    .result(mul_result)

);

// Select ALU or MUL result
assign ex_result =
        (id_ex_opcode == 4'b0011) ?
        mul_result :
        alu_result;

//====================================================
// EX/MEM PIPELINE REGISTER
//====================================================

wire [7:0] ex_mem_alu_result;
wire [7:0] ex_mem_rd2;

wire ex_mem_mem_write;
wire ex_mem_mem_to_reg;
wire [8:0] ex_mem_mem_addr;

ex_mem EX_MEM (

    .clk(clk),
    .reset(rst),
    .write_enable(1'b1),

    .alu_result_in(ex_result),
    .rd2_in(alu_src_b),

    .rd_in(id_ex_rd),

    .reg_write_in(id_ex_reg_write),
    .mem_write_in(id_ex_mem_write),
    .mem_to_reg_in(id_ex_mem_to_reg),
    .mem_addr_in(id_ex_mem_addr),

    .alu_result_out(ex_mem_alu_result),
    .rd2_out(ex_mem_rd2),

    .rd_out(ex_mem_rd),
    .mem_addr_out(ex_mem_mem_addr),

    .reg_write_out(ex_mem_reg_write),
    .mem_write_out(ex_mem_mem_write),
    .mem_to_reg_out(ex_mem_mem_to_reg)

);

//====================================================
// MEMORY STAGE
//====================================================

wire [7:0] mem_data;

data_mem DMEM (

    .clk(clk),
    .we(ex_mem_mem_write),

    .addr(ex_mem_mem_addr),

    .wd(ex_mem_rd2),

    .rd(mem_data)

);

//====================================================
// MEM/WB PIPELINE REGISTER
//====================================================

wire [7:0] mem_wb_mem_data;
wire [7:0] mem_wb_alu_result;

wire mem_wb_mem_to_reg;

mem_wb MEM_WB (

    .clk(clk),
    .reset(rst),
    .write_enable(1'b1),

    .mem_data_in(mem_data),
    .alu_result_in(ex_mem_alu_result),

    .rd_in(ex_mem_rd),

    .reg_write_in(ex_mem_reg_write),
    .mem_to_reg_in(ex_mem_mem_to_reg),

    .mem_data_out(mem_wb_mem_data),
    .alu_result_out(mem_wb_alu_result),

    .rd_out(mem_wb_rd),

    .reg_write_out(mem_wb_reg_write),
    .mem_to_reg_out(mem_wb_mem_to_reg)

);

//====================================================
// WRITE BACK STAGE
//====================================================

assign write_back_data =
        (mem_wb_mem_to_reg) ?
        mem_wb_mem_data :
        mem_wb_alu_result;

endmodule