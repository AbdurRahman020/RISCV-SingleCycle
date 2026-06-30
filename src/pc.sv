module pc(
    input  logic         CLK,
    input  logic         RST,
    input  logic  [31:0] D,
    output logic  [31:0] Q

);

always_ff @(posedge CLK) begin
    if (RST) Q <= 0;
    else     Q <= D;
end

endmodule