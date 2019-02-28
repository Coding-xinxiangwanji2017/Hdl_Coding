//------------------------------------------------------------------------------
//        *****************          *****************
//                        **        **
//            ***          **      **           **
//           *   *          **    **           * *
//          *     *          **  **              *
//          *     *           ****               *
//          *     *          **  **              *
//           *   *          **    **             *
//            ***          **      **          *****
//                        **        **
//        *****************          *****************
//------------------------------------------------------------------------------
//Com     :  BiXing Tech
//Text    :  Verilog_Demo.v
//Per     :  zhang wenjun
//E-mail  :  xinxiangwanji2013@163.com
//Data    :  2016/09/27
//Cust    :  Verilog use demo 
//Int     :  0.1
//IntTime :  1. Initial, zhang wenjun, 2016/09/27
//------------------------------------------------------------------------------
'timescale 1ns/100ps

module Verilog_Demo (
    //----------------------------------
    // Reset & Clock
    //----------------------------------
    input  wire                         CpSl_Clk_i                              , // Clock signal 100M
    input  wire                         CpSl_Rst_iN                             , // Reset active low
    input  wire                         CpSl_Clk_iP                             , // Clock Diff_P 200M
    input  wire                         CpSl_Clk_iN                             , // Clock Diff_N 200M
    
    //---------------------------------- 
    // Uart interface             
    //---------------------------------- 
    input  wire                         CpSl_RxData_i                           , // RxData from PC
    output wire                         CpSl_Txdata_o                             // TxData to PC
    );

    //----------------------------------
    // parameter describe
    //----------------------------------
    parameter PrSl_Cnt_c = 8'h2A;
    
    //----------------------------------
    // signal_describe
    //----------------------------------
    // wire
    wire            PrSl_Cnt_w;
    wire [4 : 0]    PrSv_UartCnt_w;         
    wire [124 : 0]  PrSv_UartBit_w;
    
    // Reg
    reg             PrSv_Cnt_r;
    reg  [2 : 0]    PrSv_Name_r;
    reg  [3 : 0]    PrSv_State_r;
    
    //memory
    reg  [3 : 0]    PrSv__m [2 : 0];
        
    
    
    //--------------------------------------------------------------------------
    // Main_Coding
    //--------------------------------------------------------------------------
    always @(posedge CpSl_Clk_i or negedge CpSl_Rst_iN)
    begin 
        if (!CpSl_Rst_iN)
            PrSv_Name_r <= 0;
        else if (PrSv_Name_r = 5) 
            PrSv_Name_r <= 0;
        else 
            PrSv_Name_r <= PrSv_Name_r + 1;
    end 
    
    // PrSv_State_r
    always @(posedge CpSl_Clk_i or negedge CpSl_Rst_iN) 
    begin
        if (!CpSl_Rst_iN)
            PrSv_State_r <= 4h'0;
        else
            case (PrSv_State_r)
                4h'0 : begin 
                    
                end 
                
                4h'1 : begin 
                    
                end   
                    
                
                default : PrSv_State_r <= 4h'0;
            endcase
    end 

    
    
    
    //--------------------------------------------------------------------------
    // Out_Data
    //--------------------------------------------------------------------------
    assign CpSl_Txdata_o = 1b'1;
    
    
    
    //--------------------------------------------------------------------------
    // End_Coding
    //--------------------------------------------------------------------------
endmodule;