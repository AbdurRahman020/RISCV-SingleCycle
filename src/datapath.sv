module datapath(
    input logic         CLK,
    input logic         PCSrc,
    input logic         RegWrite
    input logic [1:0]   ImmSrc,
    input logic         ALUSrc,
    input logic         ALU_Control,
    input logic         MemWrite

);

    logic [31:0] PC, Instr;
    logic [31:0] PCNext;
    logic [31:0] ALUResult, ImmExt;
    logic [31:0] RD1, RD2;
    logic [31:0] Result;
    logic [31:0] ReadData;
    logic [31:0] SrcB;
    logic [31:0] PCPlus4;  
    assign PCPlus4  = PC + 4;
    logic [31:0] PCTarget; 
    assign PCTarget = PC + ImmExt;

    alu ALU(
        .SrcA(RD1),
        .SrcB(SrcB),
        .ALU_Control(ALU_Control),
        .ALUResult(ALUResult),
        .Zero()
    );

    pc PC(
        .CLK(CLK),
        .PCNEXT(PCNext),
        .PC(PC)
    );

    regfile Regfile(
        .CLK(CLK),
        .A1(Instr[19:15]),
        .A2(Instr[24:20]),
        .A3(Instr[11:7]),
        .WE3(RegWrite),
        .RD1(RD1),
        .RD2(RD2)
    );

    instr_mem InstrMem(
        .A(PC),
        .RD(Instr)
    );

    extend Extend(
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)

    );

    data_mem DataMem(
        .A(ALUResult),
        .WE(MemWrite),
        .WD(RD2),
        .RD(Data)
    );



    assign Result = ResultSrc ? ReadData : ALUResult;
    assign SrcB   = ALUSrc    ? ImmExt   : RD2;
    assign PCNext = PCSrc     ? PCTarget : PCPlus4;

endmodule
