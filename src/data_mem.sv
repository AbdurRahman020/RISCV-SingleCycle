module data_mem(
    input logic        CLK,
    input logic        WE,
    input logic [31:0] A,
    input logic [31:0] WD,
    output logic       RD

);
    logic [31:0] data_mem [2^32-1:0] //Data Memory

    always_ff @(posedge CLK) begin //synchronus write
        if (WE) data_mem[A] <= WD;
    end

    assign RD = data_mem[A];    //Read
endmodule