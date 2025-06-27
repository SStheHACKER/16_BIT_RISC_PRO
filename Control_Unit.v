`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.01.2025 21:06:12
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input CLK,
    input Current_Zero, Current_Carry,
    input New_Carry, New_Zero, 
    input Sign_Bit, IS_IMM_ZERO_LM, IS_IMM_ZERO_SM,
    input [15:0] IF_ID_IR, ID_RR_IR, RR_EX_IR, EX_MEM_IR, MEM_WB_IR,

    output reg  IF_ID_CLR, ID_RR_CLR, RR_EX_CLR, EX_MEM_CLR, MEM_WB_CLR,
    output reg  ZF_EN, CF_EN, RF_D3_EN, RF_PC_EN, SH_EN, IF_ID_EN, ID_RR_EN, RR_EX_EN, EX_MEM_EN, MEM_WB_EN, MEM_WR_EN,
    output reg  MUX_SE_SEL, MUX_RF_D3_SEL, MUX_ALU1B_SEL, MUX_MEMDOUT_SEL, MUX_LM_SEL, MUX_SM_SEL, MUX_DEST2_SEL, MUX_RF_A3_SEL,
    output reg [1:0] MUX_PC_SEL, MUX_DEST_SEL,
    output reg [2:0] MUX_ALU_B_SEL, MUX_ALU_A_SEL,
    output reg [3:0] ALU_OP
);

    // Shared variables translated to internal registers
    reg [2:0] prev3carry = 3'b000; 
    reg [2:0] prev3zero = 3'b000;
    reg is_lm0 = 1'b0;
    reg is_lm1 = 1'b0;
    reg is_sm0 = 1'b0;
    reg is_sm1 = 1'b0;


//stage 1

    always @(*) begin
    // Default assignments
    MEM_WB_CLR = 1'b0;
    EX_MEM_CLR = 1'b0;
    RR_EX_CLR = 1'b0;
    ID_RR_CLR = 1'b0;
    IF_ID_CLR = 1'b0;
    IF_ID_EN = 1'b1;
    RF_PC_EN = 1'b1; // PC_EN is ON by default
    MUX_PC_SEL = 2'b00;

    // Load-Store operations
    if ((IF_ID_IR[15:12] == 4'b0110) || (is_lm0 == 1'b1)) begin // LM
        IF_ID_CLR = 1'b1;
        is_lm0 = 1'b1;
        RF_PC_EN = 1'b0;
    end else if ((IF_ID_IR[15:12] == 4'b0111) || (is_sm0 == 1'b1)) begin // SM
        IF_ID_CLR = 1'b1;
        is_sm0 = 1'b1;
        RF_PC_EN = 1'b0;
    end else if (MEM_WB_IR == 16'b1011000010110000) begin
        is_lm0 = 1'b0;
    end else begin
        is_lm0 = 1'b0;
        is_sm0 = 1'b0;
    end

    // Branch and Jump instructions
    if (((RR_EX_IR[15:12] == 4'b1000 || RR_EX_IR[15:12] == 4'b1001 || RR_EX_IR[15:12] == 4'b1010) && (Sign_Bit == 1'b1)) || 
        (RR_EX_IR[15:12] == 4'b1100)) begin // BLT, BLE, BEQ, JAL
        MUX_PC_SEL = 2'b01;
        RR_EX_CLR = 1'b1;
        ID_RR_CLR = 1'b1;
        IF_ID_CLR = 1'b1;
    end else if (ID_RR_IR[15:12] == 4'b1101) begin // JLR
        MUX_PC_SEL = 2'b10;
        ID_RR_CLR = 1'b1;
        IF_ID_CLR = 1'b1;
    end else if (RR_EX_IR[15:12] == 4'b1111) begin // JRI
        MUX_PC_SEL = 2'b11;
        RR_EX_CLR = 1'b1;
        ID_RR_CLR = 1'b1;
        IF_ID_CLR = 1'b1;
    end else begin
        MUX_PC_SEL = 2'b00;
    end

    // LM with IMM = 0
    if ((RR_EX_IR[15:12] == 4'b0110) && (IS_IMM_ZERO_LM == 1'b1)) begin
        RR_EX_CLR = 1'b1; // NOP for LM
    end

    // SM with IMM = 0
    if ((ID_RR_IR[15:12] == 4'b0111) && (IS_IMM_ZERO_SM == 1'b1)) begin
        ID_RR_CLR = 1'b1; // NOP for SM
        is_sm0 = 1'b0;
    end
end

//stage 2

    always @(*) begin
    // Default assignments
    ID_RR_EN = 1'b1;

    // MUX_SE_SEL Control
    if ((IF_ID_IR[15:12] == 4'b0011) || (IF_ID_IR[15:12] == 4'b0110) || 
        (IF_ID_IR[15:12] == 4'b0111) || (IF_ID_IR[15:12] == 4'b1100) || 
        (IF_ID_IR[15:12] == 4'b1111)) begin // LLI, LM, SM, JAL, JRI
        MUX_SE_SEL = 1'b1;
    end else begin
        MUX_SE_SEL = 1'b0; // SE_6 is default
    end

    // SH_EN Control
    if ((IF_ID_IR[15:12] == 4'b1000) || (IF_ID_IR[15:12] == 4'b1001) || 
        (IF_ID_IR[15:12] == 4'b1010) || (IF_ID_IR[15:12] == 4'b1100) || 
        (IF_ID_IR[15:12] == 4'b1111)) begin // BEQ, BLE, BLT, JAL, JRI
        SH_EN = 1'b1;
    end else begin
        SH_EN = 1'b0;
    end

    // MUX_SM_SEL and ID_RR_EN Control
    if (is_sm1 == 1'b1) begin
        MUX_SM_SEL = 1'b1;
        ID_RR_EN = 1'b0;
    end else begin
        MUX_SM_SEL = 1'b0; // Default for all non-SM situations
    end
end

//stage3

    reg [3:0] opcode,last3bits; 
   
    always @(posedge CLK) begin
    //extracted opcode and last3 bits from the last stage
    opcode = MEM_WB_IR[15:12];
    last3bits = MEM_WB_IR[2:0];
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

//stage 4

    always @(posedge CLK) begin
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
    if (is_lm1 == 1'b1) begin
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

//stage5
    always @(posedge CLK) begin
        opcode = EX_MEM_IR[15:12];
        MEM_WB_EN <= 1'b1; // Default enable
    
        // Check opcode for SM or SW
        if (opcode == 4'b0101 || opcode == 4'b0111) begin
            MEM_WR_EN <= 1'b1;
        end else begin
            MEM_WR_EN <= 1'b0;
        end
    end
    
//stage6
  
  always @(posedge CLK) begin
  
    opcode= MEM_WB_IR[15:12];
    // Check opcode for LW or LM
    if (opcode == 4'b0100 || opcode == 4'b0110) begin
        MUX_MEMDOUT_SEL <= 1'b1; // Select MEM_DOUT
    end else begin
        MUX_MEMDOUT_SEL <= 1'b0; // Select ALU_C
    end
    // 1 and zero shayad interchange
    
    end
    
//UPDATE_PREV

   always @(posedge CLK) begin
        // Shift the carry values
        prev3carry[2:1] <= prev3carry[1:0];
        prev3carry[0] <= New_Carry;
    
        // Shift the zero values
        prev3zero[2:1] <= prev3zero[1:0];
        prev3zero[0] <= New_Zero;
    end

    

endmodule
