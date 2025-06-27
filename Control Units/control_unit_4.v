`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2025 20:40:59
// Design Name: 
// Module Name: control_unit_4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module control_unit_4(
input clk,
input wire [15:0] IF_ID_IR, ID_RR_IR, RR_EX_IR, EX_MEM_IR, MEM_WB_IR,
   input wire Current_Zero, Current_Carry,
     output reg EX_MEM_EN,
     input wire is_lm11,
    output reg is_lm1,
    output reg MUX_DEST2_SEL,
    output reg ZF_EN,
    output reg CF_EN,
    output reg [3:0] ALU_OP
    );
     reg [3:0] opcode;
    reg [2:0] last3bits;

    //MEANS MUX-DEST2 AFTERWARDS
    always @(posedge clk) begin
    opcode = RR_EX_IR[15:12];
last3bits = RR_EX_IR[2:0];
          EX_MEM_EN <= 1'b1;
    // LOAD MULTIPLE LM DONE AFTERWARDS
      if (RR_EX_IR[15:12] == 4'b0110) begin
        is_lm1 <= 1'b1;
    end
    else begin
      is_lm1<=1'b0;
      end

    // Check specific MEM_WB_IR value
    if (MEM_WB_IR == 16'b1011000010110000) begin
        is_lm1 <= 1'b0;
    end
        else begin
      is_lm1<=1'b0;
      end


    // After LM reaches EX
    if (is_lm11 == 1'b1) begin
        MUX_DEST2_SEL <= 1'b1;
    end else begin
        MUX_DEST2_SEL <= 1'b0;
    
    
    ZF_EN <= 1'b0;
    CF_EN <= 1'b0;
    ALU_OP <= 4'b1111; // Default values

    case (opcode)
        4'b0000: begin // ADA, ADI
            ZF_EN <= 1'b1;
            CF_EN <= 1'b1;
            ALU_OP <= 4'b0000;
        end
        4'b0001: begin
            case (last3bits)
                3'b000: begin // ADA, ADI
                    ZF_EN <= 1'b1;
                    CF_EN <= 1'b1;
                    ALU_OP <= 4'b0000;
                end
                3'b010: begin // ADC
                    if (Current_Carry) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0000;
                    end
                end
                3'b001: begin // ADZ
                    if (Current_Zero) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0000;
                    end
                end
                3'b011: begin // AWC
                    ZF_EN <= 1'b1;
                    CF_EN <= 1'b1;
                    ALU_OP <= 4'b0001;
                end
                3'b100: begin // ACA
                    ZF_EN <= 1'b1;
                    CF_EN <= 1'b1;
                    ALU_OP <= 4'b0010;
                end
                3'b110: begin // ACC
                    if (Current_Carry) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0010;
                    end
                end
                3'b101: begin // ACZ
                    if (Current_Zero) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0010;
                    end
                end
                3'b111: begin // ACW
                    ZF_EN <= 1'b1;
                    CF_EN <= 1'b1;
                    ALU_OP <= 4'b0011;
                end
            endcase
        end
        4'b0010: begin
            case (last3bits)
                3'b000: begin // NDU
                    ZF_EN <= 1'b1;
                    CF_EN <= 1'b1;
                    ALU_OP <= 4'b0100;
                end
                3'b010: begin // NDC
                    if (Current_Carry) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0100;
                    end
                end
                3'b001: begin // NDZ
                    if (Current_Zero) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0100;
                    end
                end
                3'b100: begin // NCU
                    ZF_EN <= 1'b1;
                    CF_EN <= 1'b1;
                    ALU_OP <= 4'b0101;
                end
                3'b110: begin // NCC
                    if (Current_Carry) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0101;
                    end
                end
                3'b101: begin // NCZ
                    if (Current_Zero) begin
                        ZF_EN <= 1'b1;
                        CF_EN <= 1'b1;
                        ALU_OP <= 4'b0101;
                    end
                end
            endcase
        end
        4'b0011: begin // LLI
            ALU_OP <= 4'b1001; 
        end
        4'b0100, 4'b0101: begin // LW, SW
            ALU_OP <= 4'b0000;
        end
        4'b0110: begin // LM
            ALU_OP <= 4'b1110;
        end
        4'b0111: begin // SM
            ALU_OP <= 4'b0000;
        end
        4'b1000: begin // BEQ
            ALU_OP <= 4'b0110;
        end
        4'b1001: begin // BLT
            ALU_OP <= 4'b0111;
        end
        4'b1010: begin // BLE
            ALU_OP <= 4'b1000;
        end
        4'b1100, 4'b1101: begin // JAL, JLR
            ALU_OP <= 4'b1111;
        end
        4'b1111: begin // JRI
            ALU_OP <= 4'b0000;
        end
    endcase
end
end
endmodule
