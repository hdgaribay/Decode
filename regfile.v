module regfile (
    input  wire        clk,
    input  wire        rst,
    input  wire        regwrite,
    input  wire [4:0]  rs,          // Read Reg1 -> instruction[25:21]
    input  wire [4:0]  rt,          // Read Reg2 -> instruction[20:16]
    input  wire [4:0]  rd,          // Write Reg  -> from Mem/WB latch
    input  wire [31:0] writedata,   // Write Data -> from WB Mux
    output wire [31:0] A_readdat1,
    output wire [31:0] B_readdat2
);
    reg [31:0] registers [0:31];    // 32 x 32-bit registers
    integer i;

    // Synchronous write, async reset
    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;
        end else if (regwrite && rd != 5'b0) begin
            // $0 is hardwired to 0 in MIPS, so guard against writing it
            registers[rd] <= writedata;
        end
    end

    // Asynchronous (combinational) reads
    assign A_readdat1 = registers[rs];
    assign B_readdat2 = registers[rt];
endmodule