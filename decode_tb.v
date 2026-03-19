`timescale 1ns/1ps

module decode_tb;
    reg clk, rst, wb_reg_write;
    reg [4:0]  wb_write_reg_location;
    reg [31:0] mem_wb_write_data, if_id_instr, if_id_npc;

    wire [1:0]  id_ex_wb;
    wire [2:0]  id_ex_mem;
    wire [3:0]  id_ex_execute;
    wire [31:0] id_ex_npc, id_ex_readdat1, id_ex_readdat2, id_ex_sign_ext;
    wire [4:0]  id_ex_instr_bits_20_16, id_ex_instr_bits_15_11;

    decode DUT (
        .clk(clk), .rst(rst), .wb_reg_write(wb_reg_write),
        .wb_write_reg_location(wb_write_reg_location),
        .mem_wb_write_data(mem_wb_write_data),
        .if_id_instr(if_id_instr), .if_id_npc(if_id_npc),
        .id_ex_wb(id_ex_wb), .id_ex_mem(id_ex_mem),
        .id_ex_execute(id_ex_execute), .id_ex_npc(id_ex_npc),
        .id_ex_readdat1(id_ex_readdat1), .id_ex_readdat2(id_ex_readdat2),
        .id_ex_sign_ext(id_ex_sign_ext),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("decode_tb.vcd");
        $dumpvars(0, decode_tb);

        clk = 0; rst = 1; wb_reg_write = 0;
        wb_write_reg_location = 0; mem_wb_write_data = 0;
        if_id_instr = 0; if_id_npc = 32'h00000004;
        #10 rst = 0;

        // Test 1: R-format ADD ($3 = $1 + $2)
        // opcode=000000, rs=$1, rt=$2, rd=$3
        if_id_instr = 32'b000000_00001_00010_00011_00000_100000;
        #10;

        // Test 2: Write $5 = 0xDEADBEEF via WB writeback, then read it
        wb_reg_write = 1;
        wb_write_reg_location = 5;
        mem_wb_write_data = 32'hDEADBEEF;
        #10 wb_reg_write = 0;

        // Read back $5 via rs field
        if_id_instr = 32'b000000_00101_00000_00000_00000_100000;
        #10;

        // Test 3: LW  (opcode=100011)
        if_id_instr = 32'b100011_00001_00010_1111111111111111; // offset=-1
        #10;

        // Test 4: SW (opcode=101011)
        if_id_instr = 32'b101011_00001_00010_0000000000001000;
        #10;

        // Test 5: BEQ (opcode=000100)
        if_id_instr = 32'b000100_00001_00010_0000000000000101;
        #10;

        $finish;
    end
endmodule