`timescale 1ns/1ps

module M_Sim_sv ();


    parameter SRC_FILE_DEEPTH = 32'd35360;

    ////////////////////////////////////////////////////////////////////////////
    // Constant declaration
    ////////////////////////////////////////////////////////////////////////////
    parameter PrSl_Sim_c                 = 1'b0;
    parameter PrSv_RxData_s                                             =  {1'b1,8'h39,1'b0,1'b1,8'h32,1'b0,1'b1,8'h2A,1'b0,1'b1,8'h4E,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h45,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h2C,1'b0,
                                                                            1'b1,8'h31,1'b0,1'b1,8'h31,1'b0,1'b1,8'h36,1'b0,1'b1,8'h30,1'b0,1'b1,8'h31,1'b0,1'b1,8'h31,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h30,1'b0,
                                                                            1'b1,8'h30,1'b0,1'b1,8'h30,1'b0,1'b1,8'h2E,1'b0,1'b1,8'h30,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h30,1'b0,1'b1,8'h30,1'b0,1'b1,8'h30,1'b0,
                                                                            1'b1,8'h2E,1'b0,1'b1,8'h30,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h45,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h36,1'b0,1'b1,8'h37,1'b0,1'b1,8'h30,1'b0,
                                                                            1'b1,8'h35,1'b0,1'b1,8'h38,1'b0,1'b1,8'h38,1'b0,1'b1,8'h2E,1'b0,1'b1,8'h36,1'b0,1'b1,8'h33,1'b0,1'b1,8'h36,1'b0,1'b1,8'h32,1'b0,
                                                                            1'b1,8'h31,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h4E,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h37,1'b0,1'b1,8'h33,1'b0,1'b1,8'h37,1'b0,1'b1,8'h34,1'b0,
                                                                            1'b1,8'h38,1'b0,1'b1,8'h32,1'b0,1'b1,8'h2E,1'b0,1'b1,8'h32,1'b0,1'b1,8'h34,1'b0,1'b1,8'h35,1'b0,1'b1,8'h34,1'b0,1'b1,8'h2C,1'b0,
                                                                            1'b1,8'h56,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h30,1'b0,1'b1,8'h30,1'b0,1'b1,8'h30,1'b0,1'b1,8'h2E,1'b0,1'b1,8'h35,1'b0,1'b1,8'h34,1'b0,
                                                                            1'b1,8'h39,1'b0,1'b1,8'h35,1'b0,1'b1,8'h33,1'b0,1'b1,8'h32,1'b0,1'b1,8'h2C,1'b0,1'b1,8'h43,1'b0,1'b1,8'h4D,1'b0,1'b1,8'h52,1'b0,
                                                                            1'b1,8'h4E,1'b0,1'b1,8'h47,1'b0,1'b1,8'h24,1'b0,1'b1};    // 751 bit
                                                                

    ////////////////////////////////////////////////////////////////////////////
    // signal declaration
    ////////////////////////////////////////////////////////////////////////////
    reg CLK_40MHz_IN    ;
    reg LVRESETN        ;
    reg F_STOP          ;
    wire F_START1        ;
    wire F_START2        ;
    wire F_START3        ;
    reg F_GAINRST       ;
    reg F_RPI           ;
    reg F_DA            ;
    reg F_DCSA          ;
    reg F_DCSB          ;
    reg F_DCSC          ;
    reg F_DWR	          ;
    
    ////////////////////////////////
    // GPS & PPS
    ////////////////////////////////
    reg F_PPS                  ;
    reg F_GPS_UART_RX          ;
        
    ////////////////////////////////
    // LTC2324_Interface
    ////////////////////////////////
    reg F_CNV                       ;
    reg F_SDR_DDR0                  ;
    reg F_CMOS_LVDS0                ;
    reg F_SDR_DDR1                  ;
    reg F_CMOS_LVDS1                ;
    wire F_SCK_1                     ;
    wire F_SD0_1                     ;
    wire F_SD1_1                     ;
    wire F_SD2_1                     ;
    wire F_SD3_1                     ;
    reg F_SCK_P                     ;
    wire F_SDO0_P                    ;
    wire F_SDO1_P                    ;
    wire F_SDO2_P                    ;
    wire F_SDO3_P                    ;
    reg F_AD_CLKOUT_P               ;
    wire F_AD_CLKOUT_1               ;  
    reg F_AD_CLKOUT_ENABLE          ;

   /////////////////////////////////
   /// TDC_GPX2_Interface
   /////////////////////////////////
    reg F_CLKOUT_P                 ;         // Not Found Input Signal 
    reg F_FRAME1_P                 ;
    reg F_SD1_P                    ;
    reg F_FRAME2_P                 ;
    reg F_SD2_P                    ;
    reg F_FRAME3_P                 ;
    reg F_SD3_P                    ;
    reg F_FRAME4_P                 ;
    reg F_SD4_P                    ;
    reg F_LCLK_OUT_P               ;                       // GPX(Pin_18)
    reg F_LCLK_IN_P                ;                       // GPX(Pin_63)
    reg F_DISABLE_P                ;
    reg F_REFCLK_P                 ;                       // RefClk_Open
    reg F_RSTIDX_P                 ;
    reg F_PARITY                   ;
    reg F_INTERRUPT                ;
    reg F_SSN                      ;
    reg F_SCK                      ;
    reg F_MOSI                     ;
    reg F_MISO                     ;
    reg F_LCLKIN_P                 ;                       // open 
    reg F_HV_ENABLE                ;
    reg F_SHDN                     ;
    wire F_SDA                      ;
    reg F_SCL                      ;
    reg CpSl_GpsPPS_i              ;                      // GPS_PPS 
    reg CpSl_GpsRxD_i              ;                      // GPS_Rx
    wire [15:0] F_ETH_D             ;
    reg [9:1]  F_ETH_A             ;
    reg F_ETH_WRN                  ;
    reg F_ETH_OEN                  ;
    reg F_ETH_CSN                  ;
    reg F_ETH_RSTN                 ;
    reg F_ETH_INT                  ;

    // Sim_Tdc_Data
    reg PrSl_StartTrig_s             ;
    reg CpSl_Clk200M_i               ;
    reg CpSl_RefClkP_i               ;
    reg CpSl_Frame1_i                ;
    reg CpSl_Frame2_i                ;
    reg CpSl_Frame3_i                ;
    reg CpSl_Frame4_i                ;
    reg CpSl_Sdo1_i	                 ;  
    reg CpSl_Sdo2_i	                 ;  
    reg CpSl_Sdo3_i	                 ;  
    reg CpSl_Sdo4_i	                 ;  
    reg CpSl_Frame5_i                ;
    reg CpSl_Frame6_i                ;
    reg CpSl_Frame7_i                ;
    reg CpSl_Frame8_i                ;
    reg CpSl_Sdo5_i                  ;
    reg CpSl_Sdo6_i                  ;
    reg CpSl_Sdo7_i                  ;
    reg CpSl_Sdo8_i                  ;
    
    wire F_RSTIDX_1P;
    //wire F_RSTIDX_P;
    reg [23:0] rsidata_s;
    reg    clk_200m;  wire trans_tdc_data_en;  reg rsidata_en_s;


reg  [7:0] data_src_mem [0:(SRC_FILE_DEEPTH -1)] ;//定义一个位宽为12bit，深度为1024的mem

reg  [31:0]   mem_addr                     ;//定义mem的地址

wire [7:0] data0;
wire [7:0] data1;
wire [7:0] data2;

reg  [71:0] file_1_data_s      ;
reg  [71:0] file_2_data_s      ;
reg  [71:0] file_3_data_s      ;
reg  [71:0] file_4_data_s      ;
reg  [71:0] file_5_data_s      ;
reg  [71:0] file_6_data_s      ;
reg  [71:0] file_7_data_s      ;
reg  [71:0] file_8_data_s      ;

reg         frame_data_en;


reg  [15:0] vx;
reg  [15:0] vy;







    integer fp;
    integer loopi;
    initial
    begin
        LVRESETN = 0;
        CLK_40MHz_IN = 0;
        CpSl_Clk200M_i = 0;
        mem_addr = 0;
        #25 ;
        LVRESETN = 1;
        
        force U_M_Top_0.PrSl_W5300InitSucc_s = 1;
        #1000;
        
        forever begin
          wait (F_START1 || F_START2 || F_START3);
          
          vx = {data_src_mem[mem_addr],data_src_mem[mem_addr+1]};
          vy = {data_src_mem[mem_addr+2],data_src_mem[mem_addr+3]};
          file_1_data_s = {data_src_mem[mem_addr+4],data_src_mem[mem_addr+5],data_src_mem[mem_addr+6],data_src_mem[mem_addr+7],data_src_mem[mem_addr+8],data_src_mem[mem_addr+9],data_src_mem[mem_addr+10],data_src_mem[mem_addr+11],data_src_mem[mem_addr+12]};
          file_2_data_s = {data_src_mem[mem_addr+13],data_src_mem[mem_addr+14],data_src_mem[mem_addr+15],data_src_mem[mem_addr+16],data_src_mem[mem_addr+17],data_src_mem[mem_addr+18],data_src_mem[mem_addr+19],data_src_mem[mem_addr+20],data_src_mem[mem_addr+21]};
          file_3_data_s = {data_src_mem[mem_addr+22],data_src_mem[mem_addr+23],data_src_mem[mem_addr+24],data_src_mem[mem_addr+25],data_src_mem[mem_addr+26],data_src_mem[mem_addr+27],data_src_mem[mem_addr+28],data_src_mem[mem_addr+29],data_src_mem[mem_addr+30]};
          file_4_data_s = {data_src_mem[mem_addr+31],data_src_mem[mem_addr+32],data_src_mem[mem_addr+33],data_src_mem[mem_addr+34],data_src_mem[mem_addr+35],data_src_mem[mem_addr+36],data_src_mem[mem_addr+37],data_src_mem[mem_addr+38],data_src_mem[mem_addr+39]};
          file_5_data_s = {data_src_mem[mem_addr+40],data_src_mem[mem_addr+41],data_src_mem[mem_addr+42],data_src_mem[mem_addr+43],data_src_mem[mem_addr+44],data_src_mem[mem_addr+45],data_src_mem[mem_addr+46],data_src_mem[mem_addr+47],data_src_mem[mem_addr+48]};
          file_6_data_s = {data_src_mem[mem_addr+49],data_src_mem[mem_addr+50],data_src_mem[mem_addr+51],data_src_mem[mem_addr+52],data_src_mem[mem_addr+53],data_src_mem[mem_addr+54],data_src_mem[mem_addr+55],data_src_mem[mem_addr+56],data_src_mem[mem_addr+57]};
          file_7_data_s = {data_src_mem[mem_addr+58],data_src_mem[mem_addr+59],data_src_mem[mem_addr+60],data_src_mem[mem_addr+61],data_src_mem[mem_addr+62],data_src_mem[mem_addr+63],data_src_mem[mem_addr+64],data_src_mem[mem_addr+65],data_src_mem[mem_addr+66]};
          file_8_data_s = {data_src_mem[mem_addr+67],data_src_mem[mem_addr+68],data_src_mem[mem_addr+69],data_src_mem[mem_addr+70],data_src_mem[mem_addr+71],data_src_mem[mem_addr+72],data_src_mem[mem_addr+73],data_src_mem[mem_addr+74],data_src_mem[mem_addr+75]};
          frame_data_en = 1;
          #8;
          frame_data_en = 0;
          
          
          mem_addr = mem_addr + 76;
          
          # 1000;
        end
        
    end
wire [71:0]   seq_frame1_data      = file_1_data_s   ;
wire [71:0]   seq_frame2_data      = file_2_data_s   ;
wire [71:0]   seq_frame3_data      = file_5_data_s   ;
wire [71:0]   seq_frame4_data      = file_6_data_s   ;
wire [71:0]   seq_frame5_data      = file_8_data_s   ;
wire [71:0]   seq_frame6_data      = file_7_data_s   ;
wire [71:0]   seq_frame7_data      = file_4_data_s   ;
wire [71:0]   seq_frame8_data      = file_3_data_s   ;
    
wire [71:0]   frame1_data      = seq_frame1_data   ;
wire [71:0]   frame3_data      = seq_frame8_data   ;
wire [71:0]   frame5_data      = seq_frame2_data   ;
wire [71:0]   frame7_data      = seq_frame7_data   ;
wire [71:0]   frame6_data      = seq_frame3_data   ;
wire [71:0]   frame8_data      = seq_frame6_data   ;

wire [71:0]   frame2_data      = 0   ;
wire [71:0]   frame4_data      = 0   ;








integer j;

initial

begin
    $readmemh("F:/sim_file/VxVy_TDC_24Chs.txt",data_src_mem);//将path路径下得data.txt的数据以十六进制的形式写入到data_src_mem中

end
assign data0  = data_src_mem[0];
assign data1  = data_src_mem[1];
assign data2  = data_src_mem[2];

    always
    begin 
        forever begin
          # 12.5;
          CLK_40MHz_IN <= ~CLK_40MHz_IN;
        end
    end 
    
    always
    begin
        # 2.5;
        CpSl_Clk200M_i <= ~CpSl_Clk200M_i;
    end 
    
    

    
    
    // PPS 
    initial
    begin 
        F_PPS = 0;
        # 2000;
        F_PPS = 1;
        # 50;
        F_PPS = 0;

    end 

    assign F_SDA = 1'bZ;
    

    // W5300  
    //assign F_ETH_INT = 0;
    
    //initial
    //begin
      assign  F_ETH_D = 16'hZZZZ;
      //  # 200;
      //  F_ETH_D   = 16'hEB90;
        
    //end 
    
    initial 
      begin
        for (loopi=0;loopi<751 ;loopi=loopi+1)begin
          F_GPS_UART_RX = PrSv_RxData_s[loopi];
          # 104166;
        end
      end
      
      
    reg [7:0]  temp_tdc_data;
      
  task read_file1     ;
  begin 
      repeat(1) @(posedge clk_200m);
      temp_tdc_data = $fgetc(fp);
      while(!$feof(fp)) begin
            wait(trans_tdc_data_en == 1) 
            #100; 
            //$display("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff  is %h ",temp_tdc_data);
            rsidata_s = temp_tdc_data;
            rsidata_en_s = 1;
            wait(trans_tdc_data_en == 1)
            repeat(1)  @(posedge clk_200m);
            temp_tdc_data = $fgetc(fp);
      end
      $fclose(fp);    
  end
  endtask
  
  
  

M_Top  #(
    .PrSl_Sim_c      (PrSl_Sim_c),
    .PrSv_PointCnt_c       (8'h04)
    ) U_M_Top_0 (
    .CLK_40MHz_IN         (CLK_40MHz_IN         ),
    .LVRESETN             (LVRESETN             ),
    .F_CapTrig            (                     ),
    .F_START1             (F_START1     ),
    .F_START2             (F_START2             ),
    .F_START3             (F_START3             ),
    .F_GAINRST            (F_GAINRST            ),
    .F_RPI                (F_RPI                ),
    .F_DA                 (                     ),
    .F_DWR                (                     ),
    .F_DCSAB              (                     ),
    .F_DCS1               (                     ),
    .F_DCSC               (                     ),
    .F_DCS2               (                     ),
    .F_SDA                (F_SDA                ),
    .F_SCL                (                ),
    .F_PPS                (F_PPS                ),
    .F_GPS_UART_RX        (F_GPS_UART_RX        ),
    .F_CNV                (                ),
    .F_SDR_DDR0           (           ),
    .F_SCK_1              (F_SCK_1              ),
    .F_SD0_1              (F_SD0_1              ),
    .F_SD1_1              (F_SD1_1              ),
    .F_SD2_1              (F_SD2_1              ),
    .F_SD3_1              (F_SD3_1              ),
    .F_AD_CLKOUT_1        (F_AD_CLKOUT_1        ),
    .F_FRAME1_P           (CpSl_Frame1_i             ),
    .F_SD1_P              (CpSl_Sdo1_i               ),
    .F_FRAME2_P           (CpSl_Frame2_i             ),
    .F_SD2_P              (CpSl_Sdo2_i	             ),
    .F_FRAME3_P           (CpSl_Frame3_i             ),
    .F_SD3_P              (CpSl_Sdo3_i               ),
    .F_FRAME4_P           (CpSl_Frame4_i	           ),
    .F_SD4_P              (CpSl_Sdo4_i	             ),
    .F_LCLK_OUT_P         (CpSl_RefClkP_i          ),
    .F_LCLK_IN_P          (                        ),
    .F_DISABLE_P          (                        ),
    .F_REFCLK_P           (                        ),
    .F_RSTIDX_P           (F_RSTIDX_P              ),
    .F_PARITY             (F_PARITY                ),
    .F_INTERRUPT          (F_INTERRUPT             ),
    .F_SSN                (                        ),
    .F_SCK                (                        ),
    .F_MOSI               (                        ),
    .F_MISO               (F_MISO                  ),
    .F_SHDN               (F_SHDN                  ),
    .F_FRAME5_P           (CpSl_Frame5_i              ),
    .F_SD5_P              (CpSl_Sdo5_i                 ),
    .F_FRAME6_P           (CpSl_Frame6_i              ),
    .F_SD6_P              (CpSl_Sdo6_i                 ),
    .F_FRAME7_P           (CpSl_Frame7_i              ),
    .F_SD7_P              (CpSl_Sdo7_i                 ),
    .F_FRAME8_P           (CpSl_Frame8_i              ),
    .F_SD8_P              (CpSl_Sdo8_i                 ),
    .F_LCLK_OUT_1P        (CpSl_RefClkP_i           ),
    .F_LCLK_IN_1P         (F_LCLK_IN_1P            ),
    .F_REFCLK_1P          (F_REFCLK_1P             ),
    .F_RSTIDX_1P          (F_RSTIDX_1P             ),
    .F_SSN_1              (F_SSN               ),
    .F_SCK_T              (F_SCK               ),
    .F_MOSI_1             (F_MOSI              ),
    .F_MISO_1             (F_MISO              ),
    .CpSv_Addr_o          (                    ),
    .F_ETH_D              (F_ETH_D              ),
    .F_ETH_A              (F_ETH_A              ),
    .F_ETH_WRN            (F_ETH_WRN            ),
    .F_ETH_OEN            (F_ETH_OEN            ),
    .F_ETH_CSN            (F_ETH_CSN            ),
    .F_ETH_RSTN           (F_ETH_RSTN           ),
    .F_ETH_INT            (F_ETH_INT            )
    );

    eth_5300_model eth_5300_model_u(
    .CLK_40MHz_IN         (CLK_40MHz_IN         ),
    .rst_n                (LVRESETN             ),
    
    .F_ETH_D              (F_ETH_D              ),
    .F_ETH_A              (F_ETH_A              ),
    .F_ETH_WRN            (F_ETH_WRN            ),
    .F_ETH_RDN            (F_ETH_OEN            ),
    .F_ETH_CSN            (F_ETH_CSN            ),
    .F_ETH_RSTN           (F_ETH_RSTN           ),
    .F_ETH_INT            (F_ETH_INT            )
    );
    
 M_TestTdc   U_M_TestTdc_0   (
        .CpSl_Rst_iN                     (LVRESETN         ), 
        .CpSl_Clk200M_i                  (CpSl_Clk200M_i   ), //200MHz
        .CpSl_LadarTrig_o                (open             ), 
        .CpSl_LadarTrig_i                (F_START1 || F_START2 || F_START3 ), 
        .CpSl_RefClkP_o					         (CpSl_RefClkP_i   ),		
        		
        .frame_data_en_i                 (frame_data_en ),
        .frame1_data_i                   (frame1_data   ),
        .frame2_data_i                   (frame2_data   ),
        .frame3_data_i                   (frame3_data   ),
        .frame4_data_i                   (frame4_data   ),
        .frame5_data_i                   (frame5_data   ),
        .frame6_data_i                   (frame6_data   ),
        .frame7_data_i                   (frame7_data   ),
        .frame8_data_i                   (frame8_data  	),	
		    .CpSl_Frame1_o		               (CpSl_Frame1_i    ),					
		    .CpSl_Frame2_o		               (CpSl_Frame2_i    ),					
		    .CpSl_Frame3_o		               (CpSl_Frame3_i    ),					
		    .CpSl_Frame4_o		               (CpSl_Frame4_i    ),					
		    .CpSl_Sdo1_o	     	             (CpSl_Sdo1_i	     ),			
		    .CpSl_Sdo2_o	 	                 (CpSl_Sdo2_i	     ),			
		    .CpSl_Sdo3_o	     	             (CpSl_Sdo3_i	     ),			
		    .CpSl_Sdo4_o	 	                 (CpSl_Sdo4_i	     ),			
        .CpSl_Frame5_o                   (CpSl_Frame5_i    ),  
        .CpSl_Frame6_o                   (CpSl_Frame6_i    ),  
        .CpSl_Frame7_o                   (CpSl_Frame7_i    ),  
        .CpSl_Frame8_o                   (CpSl_Frame8_i    ),  
        .CpSl_Sdo5_o                     (CpSl_Sdo5_i      ),  
        .CpSl_Sdo6_o                     (CpSl_Sdo6_i      ),  
        .CpSl_Sdo7_o                     (CpSl_Sdo7_i      ),  
        .CpSl_Sdo8_o                     (CpSl_Sdo8_i      )  
    );
    
    
    
    ad_model ad_model_u(
    
        .ad_data_en_i                 (frame_data_en ),
        .vx_i                   (vx   ),
        .vy_i                   (vy   ),
    .F_SD0_1              (F_SD0_1              ),
    .F_SD1_1              (F_SD1_1              ),
    .F_SD2_1              (F_SD2_1              ),
    .F_SD3_1              (F_SD3_1              ),
    .F_AD_CLKOUT_1        (F_SCK_1        ));
    
    
    
endmodule