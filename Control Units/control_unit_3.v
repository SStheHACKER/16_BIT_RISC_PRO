`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2025 21:53:07
// Design Name: 
// Module Name: control_unit_3
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


module control_unit_3(
input clk,
  input [15:0] MEM_WB_IR, ID_RR_IR, EX_MEM_IR, RR_EX_IR, 
    input [2:0] prev3carry, prev3zero, 
    input Current_Carry, Current_Zero, IS_IMM_ZERO_SM, 
    input is_lm1, 
    output reg MUX_RF_A3_SEL, MUX_RF_D3_SEL,
    output reg RF_D3_EN, MUX_DEST_SEL, MUX_ALU_B_SEL, MUX_ALU_A_SEL,RR_EX_EN, MUX_LM_SEL,
    output reg is_sm1
    );
    
     wire [3:0] opcode,last3bits; 
     assign opcode = MEM_WB_IR[15:12];
   assign  last3bits = MEM_WB_IR[2:0];
    always @(posedge clk) begin
    //extracted opcode and last3 bits from the last stage
    
    //store multiple part not doing now do it later
      // Checking if SM has reached RR
    if (ID_RR_IR[15:12] == 4'b0111) begin
        is_sm1 <= 1'b1;
    end else if ((ID_RR_IR[15:12] == 4'b0111) && (IS_IMM_ZERO_SM == 1'b1)) begin
        is_sm1 <= 1'b0;
    end else begin
        is_sm1 <= is_sm1; // Maintain current value
    end

    // Address for storing gets updated from SM block
    if (is_sm1 == 1'b1) begin
        MUX_RF_A3_SEL <= 1'b1;
    end else begin
        MUX_RF_A3_SEL <= 1'b0;
    end
    
    //RF_D3_EN LOGIC
      if (opcode == 4'b0101 || opcode == 4'b0111 || opcode == 4'b1000 || opcode == 4'b1001 || opcode == 4'b1010 || opcode == 4'b1111 || opcode == 4'b1011) begin
       RF_D3_EN <= 1'b0;//1011 dala hai so latch not formed
    end
      else if ((opcode == 4'b0001 && last3bits == 3'b010) || (opcode == 4'b0001 && last3bits == 3'b110) ||
                 (opcode == 4'b0010 && last3bits == 3'b010) || (opcode == 4'b0010 && last3bits == 3'b110)) begin
        if (prev3carry[2] == 1'b0) begin
            RF_D3_EN <= 1'b0;
        end else begin
            RF_D3_EN <= 1'b1;
        end
    end else if ((opcode == 4'b0001 && last3bits == 3'b001) || (opcode == 4'b0001 && last3bits == 3'b101) ||
                 (opcode == 4'b0010 && last3bits == 3'b001) || (opcode == 4'b0010 && last3bits == 3'b101)) begin
        if (prev3zero[2] == 1'b0) begin
            RF_D3_EN <= 1'b0;
        end else begin
            RF_D3_EN <= 1'b1;
        end
    end else begin
    RF_D3_EN<=1'b1;
    end
    // MUX_RF_D3_SEL logic
    if (opcode == 4'b1100 || opcode == 4'b1101) begin
        MUX_RF_D3_SEL <= 1'b1;
    end else begin
        MUX_RF_D3_SEL <= 1'b0;
    end
     // MUX_DEST_SEL logic
    case (ID_RR_IR[15:12])
        4'b0001, 4'b0010: MUX_DEST_SEL <= 2'b00; // IR5TO3
        4'b0000: MUX_DEST_SEL <= 2'b01; // IR8TO6
        4'b0011, 4'b0100, 4'b1100, 4'b1101: MUX_DEST_SEL <= 2'b10; // IR11TO9
        default: MUX_DEST_SEL <= 2'b00; // Default: IR5TO
    endcase
    
        // MUX_ALU_B_SEL logic
    if (ID_RR_IR[15:12] == 4'b0000 || ID_RR_IR[15:12] == 4'b0011 || ID_RR_IR[15:12] == 4'b0100 ||
        ID_RR_IR[15:12] == 4'b0101 || ID_RR_IR[15:12] == 4'b1111) begin
        MUX_ALU_B_SEL <= 3'b001;
    end else begin
        MUX_ALU_B_SEL <= 3'b000;
    end

    // MUX_ALU_A_SEL logic
    if (ID_RR_IR[15:12] == 4'b0100 || ID_RR_IR[15:12] == 4'b0101) begin
        MUX_ALU_A_SEL <= 3'b001;
    end else begin
        MUX_ALU_A_SEL <= 3'b000;
    end
end
// here above for muxA 001 is reg B
// see this is between correct always block or not\
always @(posedge clk) begin
   
    // WB_Forwarding for ADD, NAND hazard
    if ((MEM_WB_IR[5:3] == ID_RR_IR[11:9]) &&
        ((MEM_WB_IR[15:12] == 4'b0010 || MEM_WB_IR[15:12] == 4'b0001) &&
         (MEM_WB_IR[2:0] == 3'b000 || MEM_WB_IR[2:0] == 3'b111 || MEM_WB_IR[2:0] == 3'b011 || MEM_WB_IR[2:0] == 3'b100 ||
          ((MEM_WB_IR[2:0] == 3'b010 || MEM_WB_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((MEM_WB_IR[2:0] == 3'b001 || MEM_WB_IR[2:0] == 3'b101) && Current_Zero == 1'b1))) &&
        ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
         (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
          ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1)))) begin
        MUX_ALU_A_SEL <= 3'b101;
    end

    // WB_Forwarding for ADI in I5
    else if ((MEM_WB_IR[8:6] == ID_RR_IR[11:9]) &&
             MEM_WB_IR[15:12] == 4'b0000 &&
             (ID_RR_IR[15:12] == 4'b0010 ||
              ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
               (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
                ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
                ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1))))) begin
        MUX_ALU_A_SEL <= 3'b101;
    end
     // ALU1_C_STG5_FORWARDING for ADD, NAND hazard
    else if ((EX_MEM_IR[5:3] == ID_RR_IR[11:9]) &&
        ((EX_MEM_IR[15:12] == 4'b0010 || EX_MEM_IR[15:12] == 4'b0001) &&
         (EX_MEM_IR[2:0] == 3'b000 || EX_MEM_IR[2:0] == 3'b111 || EX_MEM_IR[2:0] == 3'b011 || EX_MEM_IR[2:0] == 3'b100 ||
          ((EX_MEM_IR[2:0] == 3'b010 || EX_MEM_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((EX_MEM_IR[2:0] == 3'b001 || EX_MEM_IR[2:0] == 3'b101) && Current_Zero == 1'b1))) &&
        ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
         (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
          ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1)))) begin
        MUX_ALU_A_SEL <= 3'b100;
    end
    // ALU1_C_STG5_FORWARDING for ADI in I4
    else if ((EX_MEM_IR[8:6] == ID_RR_IR[11:9]) &&
             EX_MEM_IR[15:12] == 4'b0000 &&
             (ID_RR_IR[15:12] == 4'b0010 ||
              ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
               (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
                ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
                ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1))))) begin
        MUX_ALU_A_SEL <= 3'b100;
    end
     // ALU1_C_STG4_FORWARDING for ADD, NAND hazard
    else if ((RR_EX_IR[5:3] == ID_RR_IR[11:9]) &&
        ((RR_EX_IR[15:12] == 4'b0010 || RR_EX_IR[15:12] == 4'b0001) &&
         (RR_EX_IR[2:0] == 3'b000 || RR_EX_IR[2:0] == 3'b111 || RR_EX_IR[2:0] == 3'b011 || RR_EX_IR[2:0] == 3'b100 ||
          ((RR_EX_IR[2:0] == 3'b010 || RR_EX_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((RR_EX_IR[2:0] == 3'b001 || RR_EX_IR[2:0] == 3'b101) && Current_Zero == 1'b1))) &&
        ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
         (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
          ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1)))) begin
        MUX_ALU_A_SEL <= 3'b010;
    end
    // ALU1_C_STG4_FORWARDING for ADI in I3
    else if ((RR_EX_IR[8:6] == ID_RR_IR[11:9]) &&
             RR_EX_IR[15:12] == 4'b0000 &&
             (ID_RR_IR[15:12] == 4'b0010 ||
              ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
               (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
                ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
                ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1))))) begin
        MUX_ALU_A_SEL <= 3'b010;
    end
    else begin
     MUX_ALU_A_SEL <= 3'b000;
     end
     
     
      // WB_Forwarding for ADD, NAND hazard
    if ((MEM_WB_IR[5:3] == ID_RR_IR[11:9]) &&
        ((MEM_WB_IR[15:12] == 4'b0010 || MEM_WB_IR[15:12] == 4'b0001) &&
         (MEM_WB_IR[2:0] == 3'b000 || MEM_WB_IR[2:0] == 3'b111 || MEM_WB_IR[2:0] == 3'b011 || MEM_WB_IR[2:0] == 3'b100 ||
          ((MEM_WB_IR[2:0] == 3'b010 || MEM_WB_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((MEM_WB_IR[2:0] == 3'b001 || MEM_WB_IR[2:0] == 3'b101) && Current_Zero == 1'b1))) &&
        ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
         (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
          ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1)))) begin
        MUX_ALU_B_SEL <= 3'b101;
    end

    // WB_Forwarding for ADI in I5
    else if ((MEM_WB_IR[8:6] == ID_RR_IR[11:9]) &&
             MEM_WB_IR[15:12] == 4'b0000 &&
             (ID_RR_IR[15:12] == 4'b0010 ||
              ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
               (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
                ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
                ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1))))) begin
        MUX_ALU_B_SEL <= 3'b101;
    end
     // ALU1_C_STG5_FORWARDING for ADD, NAND hazard
    else if ((EX_MEM_IR[5:3] == ID_RR_IR[11:9]) &&
        ((EX_MEM_IR[15:12] == 4'b0010 || EX_MEM_IR[15:12] == 4'b0001) &&
         (EX_MEM_IR[2:0] == 3'b000 || EX_MEM_IR[2:0] == 3'b111 || EX_MEM_IR[2:0] == 3'b011 || EX_MEM_IR[2:0] == 3'b100 ||
          ((EX_MEM_IR[2:0] == 3'b010 || EX_MEM_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((EX_MEM_IR[2:0] == 3'b001 || EX_MEM_IR[2:0] == 3'b101) && Current_Zero == 1'b1))) &&
        ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
         (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
          ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1)))) begin
        MUX_ALU_B_SEL <= 3'b100;
    end
    // ALU1_C_STG5_FORWARDING for ADI in I4
    else if ((EX_MEM_IR[8:6] == ID_RR_IR[11:9]) &&
             EX_MEM_IR[15:12] == 4'b0000 &&
             (ID_RR_IR[15:12] == 4'b0010 ||
              ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
               (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
                ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
                ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1))))) begin
        MUX_ALU_B_SEL <= 3'b100;
    end
     // ALU1_C_STG4_FORWARDING for ADD, NAND hazard
    else if ((RR_EX_IR[5:3] == ID_RR_IR[11:9]) &&
        ((RR_EX_IR[15:12] == 4'b0010 || RR_EX_IR[15:12] == 4'b0001) &&
         (RR_EX_IR[2:0] == 3'b000 || RR_EX_IR[2:0] == 3'b111 || RR_EX_IR[2:0] == 3'b011 || RR_EX_IR[2:0] == 3'b100 ||
          ((RR_EX_IR[2:0] == 3'b010 || RR_EX_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((RR_EX_IR[2:0] == 3'b001 || RR_EX_IR[2:0] == 3'b101) && Current_Zero == 1'b1))) &&
        ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
         (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
          ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
          ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1)))) begin
        MUX_ALU_B_SEL <= 3'b010;
    end
    // ALU1_C_STG4_FORWARDING for ADI in I3
    else if ((RR_EX_IR[8:6] == ID_RR_IR[11:9]) &&
             RR_EX_IR[15:12] == 4'b0000 &&
             (ID_RR_IR[15:12] == 4'b0010 ||
              ((ID_RR_IR[15:12] == 4'b0010 || ID_RR_IR[15:12] == 4'b0001 || ID_RR_IR[15:12] == 4'b0000) &&
               (ID_RR_IR[2:0] == 3'b000 || ID_RR_IR[2:0] == 3'b111 || ID_RR_IR[2:0] == 3'b011 || ID_RR_IR[2:0] == 3'b100 ||
                ((ID_RR_IR[2:0] == 3'b010 || ID_RR_IR[2:0] == 3'b110) && Current_Carry == 1'b1) ||
                ((ID_RR_IR[2:0] == 3'b001 || ID_RR_IR[2:0] == 3'b101) && Current_Zero == 1'b1))))) begin
        MUX_ALU_B_SEL <= 3'b010;
    end
    else begin
     MUX_ALU_B_SEL <= 3'b000;
     end
     //LMA ND SM related controls
     if (is_lm1 == 1'b1) begin // Then LM has reached EX
    MUX_LM_SEL <= 1'b1;
    RR_EX_EN <= 1'b0;
end else begin
    MUX_LM_SEL <= 1'b0;
    RR_EX_EN <= 1'b1;
end
end

endmodule
