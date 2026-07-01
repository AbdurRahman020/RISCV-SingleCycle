module instr_mem(
    input  logic [31:0] A,
    output logic [31:0] RD
);

    logic [31:0] instr_mem [63:0];

    initial begin
        instr_mem[0]  = 32'h00500093; // addi x1, x0, 5
        instr_mem[1]  = 32'h00A00113; // addi x2, x0, 10
        instr_mem[2]  = 32'h002081B3; // add x3, x1, x2
        instr_mem[3]  = 32'h40110233; // sub x4, x2, x1
        instr_mem[4]  = 32'h0020F2B3; // and x5, x1, x2
        instr_mem[5]  = 32'h0020E333; // or x6, x1, x2
        instr_mem[6]  = 32'h0020A3B3; // slt x7, x1, x2
        instr_mem[7]  = 32'h00302023; // sw x3, 0(x0)
        instr_mem[8]  = 32'h00002403; // lw x8, 0(x0)
        instr_mem[9]  = 32'h00818463; // beq x3, x8, +8
        instr_mem[10] = 32'h00100493; // addi x9, x0, 1
        instr_mem[11] = 32'h00200513; // addi x10, x0, 2
        instr_mem[12] = 32'h0000006F; // jal x0, 0
    end

    assign RD = instr_mem[A[31:2]];

endmodule
