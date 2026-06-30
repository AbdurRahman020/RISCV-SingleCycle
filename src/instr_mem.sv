module instr_mem(
    input  logic [31:0] A,
    output logic [31:0] RD,

);

    logic [31:0] instr_mem [63:0]

    assign RD = instr_mem[A1];
    
endmodule
