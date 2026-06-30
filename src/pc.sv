module pc(
    input  logic         CLK,
    input  logic         RST,
    input  logic  [31:0] PCNext,
    output logic  [31:0] PC

);

always_ff @(posedge CLK) begin
    if (RST) PC <= 0;
    else     PC <= PCNext;
end

endmodule