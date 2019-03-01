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
//Com     :  Company
//Text    :  Verilog_Demo.v
//Per     :  zhang wenjun
//E-mail  :  xinxiangwanji2013@163.com
//Data    :  2016/09/27
//Cust    :  Verilog Using Demo 
//Int     :  0.1
//IntTime :  1. Initial, zhang wenjun, 2016/09/27
//------------------------------------------------------------------------------
`timescale 1ns/100ps

module Verilog_Demo 
    #(
        parameter PrSv_LanceNum_c       = 1,
        parameter PrSv_LinkNum_c        = 1 
    )(
        //------------------------------
        // Reset & Clock
        //------------------------------
        input                           CpSl_Clk_i                              , // Clock signal 100M
        input                           CpSl_Rst_iN                             , // Reset active low
        input                           CpSl_Clk_iP                             , // Clock Diff_P 200M
        input                           CpSl_Clk_iN                             , // Clock Diff_N 200M
        
        //------------------------------
        // Uart interface             
        //------------------------------
        input                           CpSl_RxData_i                           , // RxData from PC
        output                          CpSl_Txdata_o                             // TxData to PC
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
    reg             PrSl_TxData_r;
    
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
                    if (PrSv_Name_r == 3) begin 
                        PrSv_State_r <= 4h'1; 
                    end
                end 
                
                4h'1 : begin 
                    PrSv_State_r <= 4h'0;
                end   

                default : PrSv_State_r <= 4h'0;
            endcase
    end 
    
    //----------------------------------
    // Repeat_Demo
    //----------------------------------
    parameter size = 8;
    parameter longsize = 16;
    reg [size : 1] opa;
    reg [size : 1] opb;
    reg [longsize:1] result;
    begin : mult
        reg [longsize:1] shift_opa, shift_opb£»
        shift_opa = opa;
        shift_opb = opb;
        result = 0;
        repeat (size) begin
            if(shift_opb[1])
                result = result + shift_opa;
                shift_opa = shift_opa << 1;
                shift_opb = shift_opb >> 1;
        end
    end
    
    
    //----------------------------------
    // While_Demo
    //----------------------------------
    begin : count1s
    reg  [7 : 0] tempreg;
    count = 0;
    tempreg = rega;
    while(tempreg) begin
        if(tempreg[0])
            count = count + 1;
            tempreg = tempreg >> 1;
        end
    end 
    
    
    //--------------------------------------------------------------------------
    // Out_Data
    //--------------------------------------------------------------------------
    assign CpSl_Txdata_o = PrSl_TxData_r;
    
    
    //--------------------------------------------------------------------------
    // End_Coding
    //--------------------------------------------------------------------------
endmodule;