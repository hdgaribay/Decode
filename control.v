module control (
    input  wire        clk,
    input  wire        rst,
    input  wire [5:0]  opcode,
    output reg  [1:0]  wb,       // [1]=MemToReg, [0]=RegWrite
    output reg  [2:0]  mem,      // [2]=Branch,   [1]=MemRead, [0]=MemWrite
    output reg  [3:0]  ex        // [3:2]=ALUOp,  [1]=ALUSrc,  [0]=RegDst
);
    always @(*) begin
        case (opcode)
            6'b000000: begin  // R-format
                wb  = 2'b01;  // RegWrite=1, MemToReg=0
                mem = 3'b000; // Branch=0, MemRead=0, MemWrite=0
                ex  = 4'b1001;// ALUOp=10, ALUSrc=0, RegDst=1
            end
            6'b100011: begin  // LW
                wb  = 2'b11;  // RegWrite=1, MemToReg=1
                mem = 3'b010; // Branch=0, MemRead=1, MemWrite=0
                ex  = 4'b0010;// ALUOp=00, ALUSrc=1, RegDst=0
            end
            6'b101011: begin  // SW
                wb  = 2'b00;  // RegWrite=0, MemToReg=X
                mem = 3'b001; // Branch=0, MemRead=0, MemWrite=1
                ex  = 4'b0010;// ALUOp=00, ALUSrc=1, RegDst=X
            end
            6'b000100: begin  // BEQ
                wb  = 2'b00;  // RegWrite=0
                mem = 3'b100; // Branch=1, MemRead=0, MemWrite=0
                ex  = 4'b0100;// ALUOp=01, ALUSrc=0, RegDst=X
            end
            default: begin
                wb  = 2'b00;
                mem = 3'b000;
                ex  = 4'b0000;
            end
        endcase
    end
endmodule