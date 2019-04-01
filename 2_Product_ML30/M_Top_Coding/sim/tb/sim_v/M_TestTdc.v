////////////////////////////////////////////////////////////////////////////////    
//                 
//      ******** *           * *****           ***** *****   ***   ** 
//             *  *         *    *            *        *    *   *  * *    
//            *    *       *     *           *         *   *     * *  *   
//           *      *     *      *          *          *   *     * *   *   *
//         *         *   *       *         *           *   *     *      *  *
//       *            * *        *        *            *    *   *        * * 
//      ********       *       ***** *****           *****   ***          **
//
////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps


module M_TestTdc(
        ////////////////////////////////
        // Clock & Reset
        ////////////////////////////////
    input     CpSl_Rst_iN   ,           //Reset_activelow
    input     CpSl_Clk200M_i,           //200MHz
        
        ////////////////////////////////
        // Ladar_Trig
        ////////////////////////////////
      output  CpSl_LadarTrig_o ,                                      // Ladar Start Trig
      input  CpSl_LadarTrig_i           ,                        // Ladar Start Trig
        
        ////////////////////////////////
        // TDC_Data
        ////////////////////////////////
      output  CpSl_RefClkP_o	,						// TDC_GPX2_Clk_i
        
       input frame_data_en_i    ,
       input [71:0] frame1_data_i     ,
       input [71:0] frame2_data_i     ,
       input [71:0] frame3_data_i     ,
       input [71:0] frame4_data_i     ,
       input [71:0] frame5_data_i     ,
       input [71:0] frame6_data_i     ,
       input [71:0] frame7_data_i     ,
       input [71:0] frame8_data_i     ,
        
        // TDC0
		   output reg CpSl_Frame1_o					,
		   output reg CpSl_Frame2_o					,
		   output reg CpSl_Frame3_o					,
		   output reg CpSl_Frame4_o					,
		   output reg CpSl_Sdo1_o	     			,
		   output reg CpSl_Sdo2_o	 	    		,
		   output reg CpSl_Sdo3_o	     			,
		   output reg CpSl_Sdo4_o	 	    		,

        // TDC1
       output reg CpSl_Frame5_o         ,        
       output reg CpSl_Frame6_o         ,        
       output reg CpSl_Frame7_o         ,        
       output reg CpSl_Frame8_o         ,        
       output reg CpSl_Sdo5_o           ,        
       output reg CpSl_Sdo6_o           ,        
       output reg CpSl_Sdo7_o           ,        
       output reg CpSl_Sdo8_o                   
    );

parameter frame_c = 24'hff0000;
       reg [23:0] frame1_data_echo1  ;
       reg [23:0] frame2_data_echo1  ;
       reg [23:0] frame3_data_echo1  ;
       reg [23:0] frame4_data_echo1  ;
       reg [23:0] frame5_data_echo1  ;
       reg [23:0] frame6_data_echo1  ;
       reg [23:0] frame7_data_echo1  ;
       reg [23:0] frame8_data_echo1  ;
       
       reg [23:0] frame1_data_echo2  ;
       reg [23:0] frame2_data_echo2  ;
       reg [23:0] frame3_data_echo2  ;
       reg [23:0] frame4_data_echo2  ;
       reg [23:0] frame5_data_echo2  ;
       reg [23:0] frame6_data_echo2  ;
       reg [23:0] frame7_data_echo2  ;
       reg [23:0] frame8_data_echo2  ;
       
       reg [23:0] frame1_data_echo3  ;
       reg [23:0] frame2_data_echo3  ;
       reg [23:0] frame3_data_echo3  ;
       reg [23:0] frame4_data_echo3  ;
       reg [23:0] frame5_data_echo3  ;
       reg [23:0] frame6_data_echo3  ;
       reg [23:0] frame7_data_echo3  ;
       reg [23:0] frame8_data_echo3  ;

integer i,j,k;

  assign CpSl_RefClkP_o = CpSl_Clk200M_i;
  
  
  initial
    begin
        frame1_data_echo3 = 24'h0;
        frame2_data_echo3 = 24'h0;
        frame3_data_echo3 = 24'h0;
        frame4_data_echo3 = 24'h0;
        frame5_data_echo3 = 24'h0;
        frame6_data_echo3 = 24'h0;
        frame7_data_echo3 = 24'h0;
        frame8_data_echo3 = 24'h0;
        frame1_data_echo2 = 24'h0;
        frame2_data_echo2 = 24'h0;
        frame3_data_echo2 = 24'h0;
        frame4_data_echo2 = 24'h0;
        frame5_data_echo2 = 24'h0;
        frame6_data_echo2 = 24'h0;
        frame7_data_echo2 = 24'h0;
        frame8_data_echo2 = 24'h0;
        frame1_data_echo1 = 24'h0;
        frame2_data_echo1 = 24'h0;
        frame3_data_echo1 = 24'h0;
        frame4_data_echo1 = 24'h0;
        frame5_data_echo1 = 24'h0;
        frame6_data_echo1 = 24'h0;
        frame7_data_echo1 = 24'h0;
        frame8_data_echo1 = 24'h0;
            
     forever begin
      wait(frame_data_en_i)     
        frame1_data_echo3 = {frame1_data_i[23:0]};
        frame2_data_echo3 = {frame2_data_i[23:0]};
        frame3_data_echo3 = {frame3_data_i[23:0]};
        frame4_data_echo3 = {frame4_data_i[23:0]};
        frame5_data_echo3 = {frame5_data_i[23:0]};
        frame6_data_echo3 = {frame6_data_i[23:0]};
        frame7_data_echo3 = {frame7_data_i[23:0]};
        frame8_data_echo3 = {frame8_data_i[23:0]};
        frame1_data_echo2 = {frame1_data_i[47:24]};
        frame2_data_echo2 = {frame2_data_i[47:24]};
        frame3_data_echo2 = {frame3_data_i[47:24]};
        frame4_data_echo2 = {frame4_data_i[47:24]};
        frame5_data_echo2 = {frame5_data_i[47:24]};
        frame6_data_echo2 = {frame6_data_i[47:24]};
        frame7_data_echo2 = {frame7_data_i[47:24]};
        frame8_data_echo2 = {frame8_data_i[47:24]};
        frame1_data_echo1 = {frame1_data_i[71:48]};
        frame2_data_echo1 = {frame2_data_i[71:48]};
        frame3_data_echo1 = {frame3_data_i[71:48]};
        frame4_data_echo1 = {frame4_data_i[71:48]};
        frame5_data_echo1 = {frame5_data_i[71:48]};
        frame6_data_echo1 = {frame6_data_i[71:48]};
        frame7_data_echo1 = {frame7_data_i[71:48]};
        frame8_data_echo1 = {frame8_data_i[71:48]};
        
        repeat(50) 
        begin
          @(posedge CpSl_Clk200M_i); 
        end
        
        for(i=0; i<24 ; i=i+1) begin

          
          @(posedge CpSl_Clk200M_i);
          CpSl_Frame1_o = (frame1_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Frame2_o = (frame2_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Frame3_o = (frame3_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Frame4_o = (frame4_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Frame5_o = (frame5_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Frame6_o = (frame6_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Frame7_o = (frame7_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Frame8_o = (frame8_data_echo1 != 0) ? frame_c[23 - i] : 1'b0;
          CpSl_Sdo1_o   = frame1_data_echo1[23 - i];
          CpSl_Sdo2_o   = frame2_data_echo1[23 - i];
          CpSl_Sdo3_o   = frame3_data_echo1[23 - i];
          CpSl_Sdo4_o   = frame4_data_echo1[23 - i];
          CpSl_Sdo5_o   = frame5_data_echo1[23 - i];
          CpSl_Sdo6_o   = frame6_data_echo1[23 - i];
          CpSl_Sdo7_o   = frame7_data_echo1[23 - i];
          CpSl_Sdo8_o   = frame8_data_echo1[23 - i];
        end
        @(posedge CpSl_Clk200M_i);  
        CpSl_Sdo1_o   = 0;
        CpSl_Sdo2_o   = 0;
        CpSl_Sdo3_o   = 0;
        CpSl_Sdo4_o   = 0;
        CpSl_Sdo5_o   = 0;
        CpSl_Sdo6_o   = 0;
        CpSl_Sdo7_o   = 0;
        CpSl_Sdo8_o   = 0;
        
        
        repeat(50) 
        begin
          @(posedge CpSl_Clk200M_i); 
        end
        
        for(j=0; j<24 ; j=j+1) begin
          @(posedge CpSl_Clk200M_i);
          CpSl_Frame1_o = (frame1_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Frame2_o = (frame2_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Frame3_o = (frame3_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Frame4_o = (frame4_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Frame5_o = (frame5_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Frame6_o = (frame6_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Frame7_o = (frame7_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Frame8_o = (frame8_data_echo2 != 0) ? frame_c[23 - j] : 0;
          CpSl_Sdo1_o   = frame1_data_echo2[23 - j];
          CpSl_Sdo2_o   = frame2_data_echo2[23 - j];
          CpSl_Sdo3_o   = frame3_data_echo2[23 - j];
          CpSl_Sdo4_o   = frame4_data_echo2[23 - j];
          CpSl_Sdo5_o   = frame5_data_echo2[23 - j];
          CpSl_Sdo6_o   = frame6_data_echo2[23 - j];
          CpSl_Sdo7_o   = frame7_data_echo2[23 - j];
          CpSl_Sdo8_o   = frame8_data_echo2[23 - j];
        end
        @(posedge CpSl_Clk200M_i);  
        CpSl_Sdo1_o   = 0;
        CpSl_Sdo2_o   = 0;
        CpSl_Sdo3_o   = 0;
        CpSl_Sdo4_o   = 0;
        CpSl_Sdo5_o   = 0;
        CpSl_Sdo6_o   = 0;
        CpSl_Sdo7_o   = 0;
        CpSl_Sdo8_o   = 0;
        repeat(50) 
        begin
          @(posedge CpSl_Clk200M_i); 
        end
        
        for(k=0; k<24 ; k=k+1) begin
          @(posedge CpSl_Clk200M_i);
          CpSl_Frame1_o = (frame1_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Frame2_o = (frame2_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Frame3_o = (frame3_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Frame4_o = (frame4_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Frame5_o = (frame5_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Frame6_o = (frame6_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Frame7_o = (frame7_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Frame8_o = (frame8_data_echo3 != 0) ? frame_c[23 - k] : 0;
          CpSl_Sdo1_o   = frame1_data_echo3[23 - k];
          CpSl_Sdo2_o   = frame2_data_echo3[23 - k];
          CpSl_Sdo3_o   = frame3_data_echo3[23 - k];
          CpSl_Sdo4_o   = frame4_data_echo3[23 - k];
          CpSl_Sdo5_o   = frame5_data_echo3[23 - k];
          CpSl_Sdo6_o   = frame6_data_echo3[23 - k];
          CpSl_Sdo7_o   = frame7_data_echo3[23 - k];
          CpSl_Sdo8_o   = frame8_data_echo3[23 - k];
        end
        @(posedge CpSl_Clk200M_i);  
        CpSl_Sdo1_o   = 0;
        CpSl_Sdo2_o   = 0;
        CpSl_Sdo3_o   = 0;
        CpSl_Sdo4_o   = 0;
        CpSl_Sdo5_o   = 0;
        CpSl_Sdo6_o   = 0;
        CpSl_Sdo7_o   = 0;
        CpSl_Sdo8_o   = 0;
        
        #128;
    end
end
      

    
endmodule