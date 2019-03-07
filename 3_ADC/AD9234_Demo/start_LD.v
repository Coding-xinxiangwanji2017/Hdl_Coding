`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/31 11:52:43
// Design Name: 
// Module Name: start_LD
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
module start_LD(
    input clk,
    input rst_n,
    //input en_LD,
    output start1
    );
    
    parameter HIGH_PERIOD = 'd6;
    parameter TOTAL_PERIOD = 'd1250;
    
    reg start1;
    reg [31:0] counter;
    
    always @(posedge clk or negedge rst_n)
        if (rst_n == 1'b0)
            counter <= 0;
        else if (counter == TOTAL_PERIOD)
            counter <= 0;
        else
            counter <= counter + 1;
      
     always @(negedge clk or negedge rst_n)
        if (rst_n == 1'b0)
            start1 <= 1'b0;
        //else if (en_LD == 1'b0)
        //    start1 <= 1'b0; 
        else if (counter == 'd1)
            start1 <= 1'b1;
        else if (counter == 'd1+HIGH_PERIOD)
            start1 <= 1'b0;
    
endmodule
