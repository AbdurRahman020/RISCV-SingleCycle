module data_mem(
    input logic         CLK,
    input logic         WE,
    input logic  [31:0] A,
    input logic  [31:0] WD,
    output logic [31:0] RD
);

    logic [31:0] data_mem [256:0]; // data Memory

    always_ff @(posedge CLK) begin // synchronus write
        if (WE) data_mem[A] <= WD;
    end

    assign RD = data_mem[A];       // read

endmodule
