module alu (
    input logic [31:0] SrcA,
    input logic [31:0] SrcB,
    input logic [2:0] AlUControl,

    output logic Zero,
    output logic [31:0] ALUResult
);

    always_comb begin
        case (AluControl)
            3'b000: ALUResult = SrcA & SrcB; // AND
            3'b001: ALUResult = SrcA | SrcB; // OR
            3'b010: ALUResult = SrcA + SrcB; // ADD
            3'b110: ALUResult = SrcA - SrcB; // SUBTRACT
            3'b111: ALUResult = (SrcA < SrcB) ? 32'b1 : 32'b0; // SLT
            default: ALUResult = 32'b0; // default case
        endcase

        Zero = (ALUResult == 32'b0);
    end

endmodule
