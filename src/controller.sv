module controller(
    input  logic [6:0] Op,
    input  logic [2:0] funct3,
    input  logic       funct7b5,
    input  logic       Zero,

    output logic       ResultSrc,   // select write-back source (alu or memory)
    output logic       MemWrite,    // data memory write enable
    output logic       PCSrc,       // PC source select (branch or PC+4)
    output logic       ALUSrc,      // select alu operand B (register/immediate)
    output logic       RegWrite,    // register file write enable
    output logic [1:0] ImmSrc,      // immediate type selector
    output logic [2:0] AlUControl   // alu operation control
);

    // Internal control signals
    logic [1:0] ALUOp;              // high level alu operation
    logic       Branch;             // branch instruction indicator

    // main decoder: generates control signals based on opcode
    always_comb begin
        case (Op)
            7'b0110011: begin       // R-type instructions
                RegWrite  = 1'b1;
                ImmSrc    = 2'bxx;
                ALUSrc    = 1'b0;
                MemWrite  = 1'b0;
                ResultSrc = 1'b0;
                Branch    = 1'b0;
                ALUOp     = 2'b10;
            end
            7'b0010011: begin       // I-type alu instructions (addi, slti, ori, andi)
                RegWrite  = 1'b1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b0;
                ResultSrc = 1'b0;
                Branch    = 1'b0;
                ALUOp     = 2'b10;
            end
            7'b0000011: begin       // load instructions
                RegWrite  = 1'b1;
                ImmSrc    = 2'b00;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b0;
                ResultSrc = 1'b1;
                Branch    = 1'b0;
                ALUOp     = 2'b00;
            end
            7'b0100011: begin       // store instructions
                RegWrite  = 1'b0;
                ImmSrc    = 2'b01;
                ALUSrc    = 1'b1;
                MemWrite  = 1'b1;
                ResultSrc = 1'bx;
                Branch    = 1'b0;
                ALUOp     = 2'b00;
            end
            7'b1100011: begin       // branch instructions (beq)
                RegWrite  = 1'b0;
                ImmSrc    = 2'b10;
                ALUSrc    = 1'b0;
                MemWrite  = 1'b0;
                ResultSrc = 1'bx;
                Branch    = 1'b1;
                ALUOp     = 2'b01;
            end
            default: begin          // unsupported opcode
                RegWrite  = 1'b0;
                ImmSrc    = 2'b00;
                ALUSrc    = 1'b0;
                MemWrite  = 1'b0;
                ResultSrc = 1'b0;
                Branch    = 1'b0;
                ALUOp     = 2'b00;
            end
        endcase
    end

    // alu decoder: determines specific alu operation
    always_comb begin
        case (ALUOp)
            2'b00: AlUControl = 3'b010;                                                      // load/store -> ADD
            2'b01: AlUControl = 3'b110;                                                      // branch -> SUB (for comparison)
            2'b10: begin                                                                     // r-type / i-type ALU instructions
                case (funct3)
                    3'b000:  AlUControl = (Op == 7'b0110011 && funct7b5) ? 3'b110 : 3'b010;  // SUB : ADD/ADDI
                    3'b010:  AlUControl = 3'b111;                                            // SLT/SLTI
                    3'b110:  AlUControl = 3'b001;                                            // OR/ORI
                    3'b111:  AlUControl = 3'b000;                                            // AND/ANDI
                    default: AlUControl = 3'b010;                                            // default to ADD
                endcase
            end
            default: AlUControl = 3'b010;
        endcase
    end

    // branch is taken only when branch instruction and alu Zero flag are both asserted
    assign PCSrc = Branch & Zero;

endmodule
