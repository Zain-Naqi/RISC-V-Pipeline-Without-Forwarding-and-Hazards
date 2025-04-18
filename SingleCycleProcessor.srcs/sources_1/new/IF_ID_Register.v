`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/15/2025 01:32:36 PM
// Design Name: 
// Module Name: IF_ID_Register
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


module IF_ID_Register(
    input clk,
    input [63:0] PC,
    input [31:0] Inst,
    output reg [63:0] PC_Out,
    output reg [31:0] Inst_Out
);
    
always @(posedge clk) begin
    PC_Out = PC;
    Inst_Out = Inst;
end

endmodule
