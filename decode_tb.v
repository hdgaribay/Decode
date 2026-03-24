module decode_tb;

    reg clk_tb, rst_tb, wb_reg_write_tb;
    reg [4:0]  wb_write_reg_location_tb;
    reg [31:0] mem_wb_write_data_tb, if_id_instr_tb, if_id_npc_tb;
    wire [1:0]  id_ex_wb_tb;
    wire [2:0]  id_ex_mem_tb;
    wire [3:0]  id_ex_execute_tb;
    wire [31:0] id_ex_npc_tb, id_ex_readdat1_tb, id_ex_readdat2_tb, id_ex_sign_ext_tb;
    wire [4:0]  id_ex_instr_bits_20_16_tb, id_ex_instr_bits_15_11_tb;


    decode DUT(
        .clk(clk_tb), .rst(rst_tb), .wb_reg_write(wb_reg_write_tb),
        .wb_write_reg_location(wb_write_reg_location_tb),
        .mem_wb_write_data(mem_wb_write_data_tb),
        .if_id_instr(if_id_instr_tb), .if_id_npc(if_id_npc_tb),
        .id_ex_wb(id_ex_wb_tb), .id_ex_mem(id_ex_mem_tb),
        .id_ex_execute(id_ex_execute_tb), .id_ex_npc(id_ex_npc_tb),
        .id_ex_readdat1(id_ex_readdat1_tb), .id_ex_readdat2(id_ex_readdat2_tb),
        .id_ex_sign_ext(id_ex_sign_ext_tb),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16_tb),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11_tb)
    );
    initial begin 
        clk_tb = 0;
        forever #1 clk_tb = ~clk_tb;
    end

    initial begin
        $dumpfile("decode_tb.vcd");
        $dumpvars(0, decode_tb);
    end
initial begin
        rst_tb = 1; 
        wb_reg_write_tb = 0;
        wb_write_reg_location_tb = 5'd2; 
        mem_wb_write_data_tb = 32'h64;
        if_id_npc_tb = 32'h0000001;
// ------------------------------------------------------------------
        // Instruction 1: ADD $v0, $a1, $a0
        // Hex: 32'h00a41020
        // Binary: 00000000101001000001000000100000
        // Format: R-Type
        // Breakdown: opcode  | rs (src1) | rt (src2) | rd (dest) | shamt | funct
        // Binary:    000000  | 00101     | 00100     | 00010     | 00000 | 100000
        // Decimal:   0       | 5 ($a1)   | 4 ($a0)   | 2 ($v0)   | 0     | 32 (ADD)
        // ------------------------------------------------------------------
        if_id_instr_tb = 32'h00a41020;
        #2;

        rst_tb = 0; //reset disabled
        #2

        if_id_npc_tb = 32'h0000002;
        
        // ------------------------------------------------------------------
        // Instruction 2: BEQ $zero, $zero, 0x8
        // Hex: 32'h10000008
        // Binary: 00010000000000000000000000001000
        // Format: I-Type
        // Breakdown: opcode  | rs (src1) | rt (src2) | immediate (16-bit offset)
        // Binary:    000100  | 00000     | 00000     | 0000000000001000
        // Decimal:   4 (BEQ) | 0 ($zero) | 0 ($zero) | 8
        // ------------------------------------------------------------------
        if_id_instr_tb = 32'h10000008;
        #2
        if_id_npc_tb = 32'h0000003;
        
        // ------------------------------------------------------------------
        // Instruction 3: LW $v0, 2($a0)
        // Hex: 32'h8c820002
        // Binary: 10001100100000100000000000000010
        // Format: I-Type
        // Breakdown: opcode  | rs (base) | rt (dest) | immediate (16-bit offset)
        // Binary:    100011  | 00100     | 00010     | 0000000000000010
        // Decimal:   35 (LW) | 4 ($a0)   | 2 ($v0)   | 2
        // ------------------------------------------------------------------
        if_id_instr_tb = 32'h8c820002;
        #2

        if_id_npc_tb = 32'h0000004;
        
        // ------------------------------------------------------------------
        // Instruction 4: SW $v0, 2($a0)
        // Hex: 32'hac820002
        // Binary: 10101100100000100000000000000010
        // Format: I-Type
        // Breakdown: opcode  | rs (base) | rt (src)  | immediate (16-bit offset)
        // Binary:    101011  | 00100     | 00010     | 0000000000000010
        // Decimal:   43 (SW) | 4 ($a0)   | 2 ($v0)   | 2
        // ------------------------------------------------------------------
        if_id_instr_tb = 32'hac820002;
        #2

        if_id_npc_tb = 32'h0000005;
        wb_reg_write_tb = 1;
        #2
        
        // ------------------------------------------------------------------
        // Instruction 5: ADD $v0, $v0, $v0
        // Hex: 32'h00421020
        // Binary: 00000000010000100001000000100000
        // Format: R-Type
        // Breakdown: opcode  | rs (src1) | rt (src2) | rd (dest) | shamt | funct
        // Binary:    000000  | 00010     | 00010     | 00010     | 00000 | 100000
        // Decimal:   0       | 2 ($v0)   | 2 ($v0)   | 2 ($v0)   | 0     | 32 (ADD)
        // ------------------------------------------------------------------
        if_id_instr_tb = 32'h00421020;
        
        if_id_npc_tb = 32'h000006;
        wb_reg_write_tb = 0;
        #2
        #2
        $display("Decode Complete");
        $finish;
end
        endmodule