module regfile(
    input  logic              CLK,
    input  logic  [4:0]       A1, A2, A3,
    input  logic  [31:0]      WD3,
    input  logic              WE3,
    output logic  [31:0]      RD1, RD2
);

    logic [31:0] x [31:0];          // 32-bit 32 registers

    always_ff @(posedge CLK) begin  // synchronus write
        if (WE3 && A3 != 5'b0)
            x[A3] <= WD3;
    end

    assign x[0] = 0;                // x0 hardwired to 0
    assign RD1 = x[A1];             // read port 1
    assign RD2 = x[A2];             // read port 2

endmodule
