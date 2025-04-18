`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/14/2025 12:34:37 AM
// Design Name: 
// Module Name: Mux
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


module Mux(
    input [63:0] a,
    input [63:0] b,
    input sel,
    output reg [63:0] data_out
);
    
    always @(*) begin
        case (sel)
            1'b0: data_out = a;
            1'b1: data_out = b;
            default: data_out = a; // if sel is X or Z, default to a
        endcase
    end

endmodule

