module extend(
    input  logic [31:0] Instr,
    input  logic        ImmSrc,
    output logic        ImmExt

);

    always_comb begin
        case (ImmSrc)
        00: immExt = {20{Instr[31]}, Instr[31:20]};                                    //I-Type
        01: immExt = {20{Instr[31]},Instr[31:25],Instr[11:7]};                         //S-Type
        10: immExt = {20{Instr[31]}, Instr[7],Instr[30:25],Instr[11:8],1'b0};          //B-Type
        endcase
    end

endmodule