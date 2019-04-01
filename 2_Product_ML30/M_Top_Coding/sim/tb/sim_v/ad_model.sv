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

module ad_model
     (
    
    input  ad_data_en_i         ,
    input  [15:0]  vx_i         ,
    input  [15:0]  vy_i         ,
    output F_SD0_1              ,
    output F_SD1_1              ,
    output reg F_SD2_1              ,
    output reg F_SD3_1              ,
    input  F_AD_CLKOUT_1        
    );


    reg  [15:0]  vx                 ;
    reg  [15:0]  vy                 ;


always @(posedge F_AD_CLKOUT_1 or posedge ad_data_en_i) begin
    if(ad_data_en_i) begin
      vx <= vx_i;
      vy <= vy_i;
    end
    else begin
      vx <= {vx[14:0],1'b0};      
      vy <= {vy[14:0],1'b0};      
    end
end

always @(posedge F_AD_CLKOUT_1) begin
  F_SD2_1 <= vx[15];
  F_SD3_1 <= vy[15];
end


    
endmodule