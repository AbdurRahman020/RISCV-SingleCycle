module datapath(
    input  logic       CLK,
    input  logic       RST,
    input  logic       PCSrc,       // select next PC: PC+4 or branch/jump target
    input  logic       RegWrite,    // register file write enable
    input  logic [1:0] ImmSrc,      // immediate type selector
    input  logic       ALUSrc,      // select alu operand B: register or immediate
    input  logic [2:0] AlUControl,  // alu operation control
    input  logic       MemWrite,    // data memory write enable
    input  logic       ResultSrc,   // select write-back data: alu result or memory data

    output logic [6:0] Op,          // opcode field sent to controller
    output logic [2:0] funct3,      // funct3 field sent to controller
    output logic       funct7b5,    // bit 30 of instruction (used for alu decoding)
    output logic       Zero         // zero flag from alu (used for branches)
);

    // internal datapath signals
    logic [31:0] PC, Instr;
    logic [31:0] PCNext;
    logic [31:0] ALUResult, ImmExt;
    logic [31:0] RD1, RD2;
    logic [31:0] Result;
    logic [31:0] ReadData;
    logic [31:0] SrcB;

    // PC + 4 calculation
    logic [31:0] PCPlus4;
    assign PCPlus4  = PC + 4;
    
    // branch/jump target address calculation
    logic [31:0] PCTarget;
    assign PCTarget = PC + ImmExt;

    // arithmetic logic unit
    alu ALU(
        .SrcA(RD1),
        .SrcB(SrcB),
        .AlUControl(AlUControl),
        .ALUResult(ALUResult),
        .Zero(Zero)
    );

    // program Counter register
    pc PC(
        .CLK(CLK),
        .RST(RST),
        .PCNext(PCNext),
        .PC(PC)
    );

    // register file
    regfile Regfile(
        .CLK(CLK),
        .A1(Instr[19:15]),   // rs1
        .A2(Instr[24:20]),   // rs2
        .A3(Instr[11:7]),    // rd
        .WD3(Result),        // write back data
        .WE3(RegWrite),
        .RD1(RD1),
        .RD2(RD2)
    );

    // instruction memory
    instr_mem InstrMem(
        .A(PC),
        .RD(Instr)
    );

    // immediate value generator
    extend Extend(
        .Instr(Instr),
        .ImmSrc(ImmSrc),
        .ImmExt(ImmExt)

    );

    // data memory
    data_mem DataMem(
        .CLK(CLK),
        .A(ALUResult),
        .WE(MemWrite),
        .WD(RD2),
        .RD(ReadData)
    );

    // write back data selection
    assign Result = ResultSrc ? ReadData : ALUResult;
    // alu operand B selection
    assign SrcB   = ALUSrc    ? ImmExt   : RD2;
    // next PC selection
    assign PCNext = PCSrc     ? PCTarget : PCPlus4;

    // instruction fields forwarded to the controller
    assign Op       = Instr[6:0];
    assign funct3   = Instr[14:12];
    assign funct7b5 = Instr[30];

endmodule
