module top(
    input logic CLK,
    input logic RST
);

    logic [6:0] Op;
    logic [2:0] funct3;
    logic       funct7b5;
    logic       Zero;

    logic       ResultSrc;
    logic       MemWrite;
    logic       PCSrc;
    logic       ALUSrc;
    logic       RegWrite;
    logic [1:0] ImmSrc;
    logic [2:0] AlUControl;

    controller Controller(
        .Op(Op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Zero(Zero),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .AlUControl(AlUControl)
    );

    datapath Datapath(
        .CLK(CLK),
        .RST(RST),
        .PCSrc(PCSrc),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .AlUControl(AlUControl),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Op(Op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .Zero(Zero)
    );

endmodule
