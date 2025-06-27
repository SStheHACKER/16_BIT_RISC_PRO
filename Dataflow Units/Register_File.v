`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.12.2024 18:05:55
// Design Name: 
// Module Name: Register_File
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


module Register_File (
    input wire [2:0] RF_A1, RF_A2, RF_A3,     // 3-bit address inputs
    output wire [15:0] RF_D1, RF_D2,           // 16-bit data outputs
    input wire [15:0] RF_D3,                   // 16-bit data input
    output wire [15:0] RF_PC_R,                // PC read output
    input wire [15:0] RF_PC_W,                 // PC write input
    input wire RF_D3_EN, PC_EN,                // Enable signals
    input wire clk,                             // Clock input
    output wire [15:0] Reg0, Reg1, Reg2, Reg3, // 16-bit register outputs
    output wire [15:0] Reg4, Reg5, Reg6, Reg7  // 16-bit register outputs
);
    
    // Internal registers (16 bits each)
    reg [15:0] r0 = 16'b0000000000000000;
    reg [15:0] r1 = 16'b0000000000011111;
    reg [15:0] r2 = 16'b0000000000011111;
    reg [15:0] r3 = 16'b0000000000000000;
    reg [15:0] r4 = 16'b1111111111111111;
    reg [15:0] r5 = 16'b1111111111111111;
    reg [15:0] r6 = 16'b0000000000000000;
    reg [15:0] r7 = 16'b0000000000000000;

    // MUX instantiations for reading data
    mux81 m1 (
        .A0(r0), .A1(r1), .A2(r2), .A3(r3), .A4(r4), .A5(r5), .A6(r6), .A7(r7),
        .S(RF_A1),
        .Op(RF_D1)
    );

    mux81 m2 (
        .A0(r0), .A1(r1), .A2(r2), .A3(r3), .A4(r4), .A5(r5), .A6(r6), .A7(r7),
        .S(RF_A2),
        .Op(RF_D2)
    );

    // Output the value of register 0 as PC read value
    assign RF_PC_R = r0;

    // Process for writing to registers
    always @(posedge clk) begin
        if (PC_EN) begin
            r0 <= RF_PC_W;  // Update r0 with PC write value
        end

        if (RF_D3_EN) begin
            case (RF_A3)
                3'b000: r0 <= RF_D3;
                3'b001: r1 <= RF_D3;
                3'b010: r2 <= RF_D3;
                3'b011: r3 <= RF_D3;
                3'b100: r4 <= RF_D3;
                3'b101: r5 <= RF_D3;
                3'b110: r6 <= RF_D3;
                3'b111: r7 <= RF_D3;
            endcase
        end
    end

    // Assign outputs to register values
    assign Reg0 = r0;
    assign Reg1 = r1;
    assign Reg2 = r2;
    assign Reg3 = r3;
    assign Reg4 = r4;
    assign Reg5 = r5;
    assign Reg6 = r6;
    assign Reg7 = r7;

endmodule

