module top_tb;
logic clk;
logic rst;

top DUT(
    .CLK(clk),
    .RST(rst)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    DUT.Datapath.InstrMem.instr_mem[0]  = 32'h00500093; // addi x1, x0, 5
    DUT.Datapath.InstrMem.instr_mem[4]  = 32'h00a00113; // addi x2, x0, 10
    DUT.Datapath.InstrMem.instr_mem[8]  = 32'h002081b3; // add  x3, x1, x2
    DUT.Datapath.InstrMem.instr_mem[12] = 32'h40208233; // sub  x4, x2, x1
    DUT.Datapath.InstrMem.instr_mem[16] = 32'h0020a293; // slt  x5, x1, x2
    DUT.Datapath.InstrMem.instr_mem[20] = 32'h0020e313; // or   x6, x1, x2
    DUT.Datapath.InstrMem.instr_mem[24] = 32'h0020f333; // and  x7, x1, x2
    DUT.Datapath.InstrMem.instr_mem[28] = 32'h00302023; // sw   x3, 0(x0)
    DUT.Datapath.InstrMem.instr_mem[32] = 32'h00002203; // lw   x8, 0(x0)
    DUT.Datapath.InstrMem.instr_mem[36] = 32'h00128293; // addi x9, x8, 1
    DUT.Datapath.InstrMem.instr_mem[40] = 32'h00100313; // addi x6, x0, 1
    DUT.Datapath.InstrMem.instr_mem[44] = 32'h00200333; // addi x7, x0, 2
    DUT.Datapath.InstrMem.instr_mem[48] = 32'h0063;      // beq x6, x7, 8 (not taken)
    DUT.Datapath.InstrMem.instr_mem[52] = 32'h02c00093; // addi x1, x0, 44
    DUT.Datapath.InstrMem.instr_mem[56] = 32'h0063;      // beq x6, x6, 8 (taken)
    DUT.Datapath.InstrMem.instr_mem[60] = 32'h02d00113; // addi x2, x0, 45

    #10;
    rst = 0;

    #1000;

    if (DUT.Datapath.Regfile.x[1] !== 44) begin
        $display("FAIL: x1 expected 44, got %0d", DUT.Datapath.Regfile.x[1]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[2] !== 10) begin
        $display("FAIL: x2 expected 10, got %0d", DUT.Datapath.Regfile.x[2]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[3] !== 15) begin
        $display("FAIL: x3 expected 15, got %0d", DUT.Datapath.Regfile.x[3]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[4] !== 5) begin
        $display("FAIL: x4 expected 5, got %0d", DUT.Datapath.Regfile.x[4]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[5] !== 1) begin
        $display("FAIL: x5 expected 1, got %0d", DUT.Datapath.Regfile.x[5]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[6] !== 15) begin
        $display("FAIL: x6 expected 15, got %0d", DUT.Datapath.Regfile.x[6]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[7] !== 0) begin
        $display("FAIL: x7 expected 0, got %0d", DUT.Datapath.Regfile.x[7]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[8] !== 15) begin
        $display("FAIL: x8 expected 15, got %0d", DUT.Datapath.Regfile.x[8]);
        $finish;
    end

    if (DUT.Datapath.Regfile.x[9] !== 16) begin
        $display("FAIL: x9 expected 16, got %0d", DUT.Datapath.Regfile.x[9]);
        $finish;
    end

    $display("All test cases passed.");
    $finish;
    end
endmodule
