--------------------------------------------------------------------------------
--
--      ******** *           * *****           ***** *****   ***   **
--             *  *         *    *            *        *    *   *  * *
--            *    *       *     *           *         *   *     * *  *
--           *      *     *      *          *          *   *     * *   *   *
--         *         *   *       *         *           *   *     *      *  *
--       *            * *        *        *            *    *   *        * *
--      ********       *       ***** *****           *****   ***          **
--
--------------------------------------------------------------------------------
-- 版    权  :  ZVISION
-- 文件名称  :  M_Tdc_group.vhd
-- 设    计  :  zhang shuqiang
-- 邮    件  :  shuqiang.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2019/01/15
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang shuqiang, 2019/01/15
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library altera;
use altera.altera_primitives_components.all;

entity M_Tdc_group is
    port (
		--------------------------------
		-- Clk & Reset
		--------------------------------
		CpSl_Rst_i							  : in  std_logic;						-- Reset,Active_low
      clk_40m_i 							  : in  std_logic;	
      CpSl_Clk200M_i                  : in  std_logic;	
      --------------------------------
		-- Ladar/CapEnd
		--------------------------------
      CpSl_Start1_i                   : in  std_logic;                        -- CpSl_Start1
      CpSl_Start2_i                   : in  std_logic;                        -- CpSl_Start2
      CpSl_Start3_i                   : in  std_logic;                        -- CpSl_Start3
      CpSl_Clk5M_i                    : in  std_logic;                        -- CpSl_Clk5M
      CpSl_RstId_i                    : in  std_logic;                        -- CpSl_RstId

      --------------------------------
      -- Image_Data
      --------------------------------
      CpSl_ImageVld_i                 : in  std_logic;                        -- Image Valid
      CpSl_FrameVld_i                 : in  std_logic;                        -- Frame Valid
        
		--------------------------------
		-- LVDS Interface
		--------------------------------		
      -- TDC0
		CpSl_RefClkP_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_Frame1_i					: in  std_logic;						-- TDC_GPX2_Frame1_high
		CpSl_Frame2_i					: in  std_logic;						-- TDC_GPX2_Frame2_30%
		CpSl_Frame3_i					: in  std_logic;						-- TDC_GPX2_Frame3_high
		CpSl_Frame4_i					: in  std_logic;						-- TDC_GPX2_Frame4_30%
		CpSl_Sdo1_i	     				: in  std_logic;						-- TDC_GPX2_SDO1
		CpSl_Sdo2_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO2
		CpSl_Sdo3_i	     				: in  std_logic;						-- TDC_GPX2_SDO3
		CpSl_Sdo4_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO4
		CpSl_RefClk1P_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_Frame5_i					: in  std_logic;						-- TDC_GPX2_Frame5_low
		CpSl_Frame6_i					: in  std_logic;						-- TDC_GPX2_Frame6_30%
		CpSl_Frame7_i					: in  std_logic;						-- TDC_GPX2_Frame7_Low
		CpSl_Frame8_i					: in  std_logic;						-- TDC_GPX2_Frame8_30%
		CpSl_Sdo5_i	     				: in  std_logic;						-- TDC_GPX2_SDO5
		CpSl_Sdo6_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO6
		CpSl_Sdo7_i	     				: in  std_logic;						-- TDC_GPX2_SDO7
		CpSl_Sdo8_i	 	    		    : in  std_logic;						-- TDC_GPX2_SDO8

        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSl_TdcDataVld_o				: out std_logic;						-- TDC_Recv_Data_Valid   
        CpSv_ld_num_o                   : out std_logic_vector(1 downto 0);     -- CpSv_ld_num_o
        CpSv_Tdc1Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC1_Echo1_Data
        CpSv_Tdc1Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC1_Echo2_Data
        CpSv_Tdc1Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC1_Echo3_Data
        CpSv_Tdc2Echo1_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc2Echo2_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc2Echo3_o                : out std_logic_vector(26 downto 0);    -- invalid    
        CpSv_Tdc3Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC3_Echo1_Data
        CpSv_Tdc3Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC3_Echo2_Data
        CpSv_Tdc3Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC3_Echo3_Data    
        CpSv_Tdc4Echo1_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc4Echo2_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc4Echo3_o                : out std_logic_vector(26 downto 0);    -- invalid
        CpSv_Tdc5Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC5_Echo1_Data
        CpSv_Tdc5Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC5_Echo2_Data
        CpSv_Tdc5Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC5_Echo3_Data
        CpSv_Tdc6Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC6_Echo1_Data
        CpSv_Tdc6Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC6_Echo2_Data
        CpSv_Tdc6Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC6_Echo3_Data    
        CpSv_Tdc7Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC7_Echo1_Data
        CpSv_Tdc7Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC7_Echo2_Data
        CpSv_Tdc7Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC7_Echo3_Data    
        CpSv_Tdc8Echo1_o                : out std_logic_vector(26 downto 0);    -- TDC8_Echo1_Data
        CpSv_Tdc8Echo2_o                : out std_logic_vector(26 downto 0);    -- TDC8_Echo2_Data
        CpSv_Tdc8Echo3_o                : out std_logic_vector(26 downto 0);    -- TDC8_Echo3_Data
		  
		  index_fifo_full_detect          : out std_logic;
		  wr_tdc_full_s_detect : out std_logic
	);
end M_Tdc_group;

architecture arch_M_Tdc_group of M_Tdc_group is


component M_Tdc_s2p is
    port (
		--------------------------------
		-- Reset
		--------------------------------
		CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
		--------------------------------
		-- LVDS Interface
		--------------------------------		
        -- TDC0
		CpSl_RefClkP_i					: in  std_logic;						-- TDC_GPX2_Clk_i
		CpSl_Frame_i					: in  std_logic;						-- TDC_GPX2_Frame1_low
		CpSl_Sdo_i	     				: in  std_logic;						-- TDC_GPX2_SDO1

      --------------------------------
      -- TDC_Data
      --------------------------------
      wr_tdc_data_en_o				   : out std_logic;						-- TDC_Recv_Data_Valid
      wr_tdc_data_o              : out std_logic_vector(31 downto 0);
      wr_tdc_full_i              : in  std_logic
		  
	);
end component;


component M_Tdc_group_sub is
    generic (
        frame_id_c                 : integer := 1
    );
    port (
		
	 CpSl_RefClkP_i	                         : in  std_logic;
    clk_40m_i                                 : in  std_logic;	  -- 40Mhz clock
	 CpSl_Rst_i					                   : in  std_logic;						-- Reset,Active_low
    
    start_grouping_i                          : in  std_logic;                       
    ref_index_cnt_start_i                     : in  std_logic_vector(15 downto 0);                       
    grouping_timeout_en_i                     : in  std_logic;   
	 wr_tdc_data_en_i				                  : in  std_logic;						-- TDC_Recv_Data_Valid
    wr_tdc_data_i                             : in  std_logic_vector(31 downto 0);
    wr_tdc_full_o				                      : out std_logic;						

    grouping_done_o                           : out std_logic;
    tdcecho1_o                                : out std_logic_vector(26 downto 0);
    tdcecho2_o                                : out std_logic_vector(26 downto 0);
    tdcecho3_o                                : out std_logic_vector(26 downto 0)    

	);
end component;
component sync_fifo_64x8 IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (17 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		rdusedw		: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
		wrfull		: OUT STD_LOGIC 
	);
END component;


    -- reference index count signals    
 		signal  CpSl_Start1_d1     : std_logic;
		signal  CpSl_Start1_d2     : std_logic;
		signal  CpSl_Start1_d3     : std_logic;
		signal  CpSl_Start2_d1     : std_logic;
		signal  CpSl_Start2_d2     : std_logic;
		signal  CpSl_Start2_d3     : std_logic;
		signal  CpSl_Start3_d1     : std_logic;
		signal  CpSl_Start3_d2     : std_logic;
		signal  CpSl_Start3_d3     : std_logic;
		signal  CpSl_Clk5M_d1      : std_logic;
		signal  CpSl_Clk5M_d2      : std_logic;
		signal  CpSl_Clk5M_d3      : std_logic;
		signal  CpSl_RstId_d1      : std_logic;
		signal  CpSl_RstId_d2      : std_logic;
		
		signal  CpSl_Start1_valid  : std_logic;
		signal  CpSl_Start2_valid  : std_logic;
		signal  CpSl_Start3_valid  : std_logic;
		signal  CpSl_Clk5M_valid   : std_logic;

    signal  ref_index_cnt            : std_logic_vector(15 downto 0);
    signal  ref_index_cnt_valid      : std_logic_vector(15 downto 0);
    signal  ref_index_cnt_start      : std_logic_vector(15 downto 0);
    signal  grouping_ld_num          : std_logic_vector(1 downto 0);

    signal  wr_tdc_data_en_s   : std_logic_vector(7 downto 0); 
    --signal  wr_tdc_data_s      : std_logic_vector(23 downto 0);
    signal  wr_tdc_full_s      : std_logic_vector(7 downto 0); 
    signal  wr_tdc_data_s      : std_logic_vector(8*32-1 downto 0); 
    signal  grouping_done_s    : std_logic_vector(7 downto 0);
    signal  grouping_done_keep : std_logic_vector(7 downto 0);
    
    signal  grouping_en        : std_logic;
    signal  tdcecho1_s         : std_logic_vector(8*27-1 downto 0);
    signal  tdcecho2_s         : std_logic_vector(8*27-1 downto 0);
    signal  tdcecho3_s         : std_logic_vector(8*27-1 downto 0);
	 signal  CpSl_TdcDataVld_s  : std_logic;


    signal  Tdc1Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc2Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc3Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc4Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc5Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc6Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc7Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc8Echo1          : std_logic_vector(26 downto 0);
    signal  Tdc1Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc2Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc3Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc4Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc5Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc6Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc7Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc8Echo2          : std_logic_vector(26 downto 0);
    signal  Tdc1Echo3          : std_logic_vector(26 downto 0);
    signal  Tdc2Echo3          : std_logic_vector(26 downto 0);
    signal  Tdc3Echo3          : std_logic_vector(26 downto 0);
    signal  Tdc4Echo3          : std_logic_vector(26 downto 0);
    signal  Tdc5Echo3          : std_logic_vector(26 downto 0);
    signal  Tdc6Echo3          : std_logic_vector(26 downto 0);
    signal  Tdc7Echo3          : std_logic_vector(26 downto 0);
    signal  Tdc8Echo3          : std_logic_vector(26 downto 0);
    
    
    signal  CpSl_RefClkP       : std_logic_vector(7 downto 0);
    signal  CpSl_Frame         : std_logic_vector(7 downto 0);
    signal  CpSl_Sdo           : std_logic_vector(7 downto 0);
    signal  start_grouping     : std_logic;
    signal  wr_index_en        : std_logic;
    signal  wr_index           : std_logic_vector(17 downto 0);
    signal  TdcDataVld_w       : std_logic;
    signal  ld_num             : std_logic_vector(1 downto 0);

    signal  wr_start_grouping       : std_logic;
    signal  rd_index_en             : std_logic;
    signal  rd_index_en_d1          : std_logic;
    signal  rd_index_en_d2          : std_logic;
    signal  rd_index                : std_logic_vector(17 downto 0);
    signal  grouping_timeout_en     : std_logic;
	 signal  index_fifo_full         : std_logic;
	 signal  index_fifo_empty        : std_logic;


    signal  pre_cmd_cnt        :  STD_LOGIC_VECTOR (5 DOWNTO 0);
	 
    -- Debug
    signal PrSl_Error_s                 : std_logic;
	 
    attribute keep : string;
    attribute keep of grouping_done_keep      : signal is "true";
    attribute keep of tdc1echo1      : signal is "true";
    attribute keep of tdc3echo1      : signal is "true";
    
begin


CpSl_RefClkP <= CpSl_RefClk1P_i & CpSl_RefClk1P_i & CpSl_RefClk1P_i & CpSl_RefClk1P_i & CpSl_RefClkP_i & CpSl_RefClkP_i & CpSl_RefClkP_i & CpSl_RefClkP_i;
CpSl_Frame   <= CpSl_Frame8_i & CpSl_Frame7_i & CpSl_Frame6_i & CpSl_Frame5_i & CpSl_Frame4_i & CpSl_Frame3_i & CpSl_Frame2_i & CpSl_Frame1_i; 
CpSl_Sdo     <= CpSl_Sdo8_i & CpSl_Sdo7_i & CpSl_Sdo6_i & CpSl_Sdo5_i & CpSl_Sdo4_i & CpSl_Sdo3_i & CpSl_Sdo2_i & CpSl_Sdo1_i; 


    M_Tdc_s2p_u0 : M_Tdc_s2p 
    port map(
        CpSl_Rst_i                      =>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i                  =>     CpSl_RefClkP(0)		                            ,
  		CpSl_Frame_i                    =>     CpSl_Frame(0)			                            ,
  		CpSl_Sdo_i                      =>     CpSl_Sdo(0)	     	                            ,
        wr_tdc_data_en_o                =>     wr_tdc_data_en_s(0)	                          ,
        wr_tdc_data_o                   =>     wr_tdc_data_s((0+1)*32 -1  downto 0*32),
        wr_tdc_full_i                   =>     wr_tdc_full_s(0)     
    );

  M_Tdc_s2p_u1 : M_Tdc_s2p 
      port map(
  		CpSl_Rst_i						=>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i				=>     CpSl_RefClkP(1)		                            ,
  		CpSl_Frame_i					=>     CpSl_Frame(1)			                            ,
  		CpSl_Sdo_i	     			=>     CpSl_Sdo(1)	     	                            ,
      wr_tdc_data_en_o			=>     wr_tdc_data_en_s(1)	                          ,
      wr_tdc_data_o         =>     wr_tdc_data_s((1+1)*32 -1  downto 1*32),
      wr_tdc_full_i         =>     wr_tdc_full_s(1)     
  
  	);
  M_Tdc_s2p_u2 : M_Tdc_s2p 
      port map(
  		CpSl_Rst_i						=>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i				=>     CpSl_RefClkP(2)		                            ,
  		CpSl_Frame_i					=>     CpSl_Frame(2)			                            ,
  		CpSl_Sdo_i	     			=>     CpSl_Sdo(2)	     	                            ,
      wr_tdc_data_en_o			=>     wr_tdc_data_en_s(2)	                          ,
      wr_tdc_data_o         =>     wr_tdc_data_s((2+1)*32 -1  downto 2*32),
      wr_tdc_full_i         =>     wr_tdc_full_s(2)     
  
  	);
  M_Tdc_s2p_u3 : M_Tdc_s2p 
      port map(
  		CpSl_Rst_i						=>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i				=>     CpSl_RefClkP(3)		                            ,
  		CpSl_Frame_i					=>     CpSl_Frame(3)			                            ,
  		CpSl_Sdo_i	     			=>     CpSl_Sdo(3)	     	                            ,
      wr_tdc_data_en_o			=>     wr_tdc_data_en_s(3)	                          ,
      wr_tdc_data_o         =>     wr_tdc_data_s((3+1)*32 -1  downto 3*32),
      wr_tdc_full_i         =>     wr_tdc_full_s(3)     
  
  	);
  M_Tdc_s2p_u4 : M_Tdc_s2p 
      port map(
  		CpSl_Rst_i						=>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i				=>     CpSl_RefClkP(4)		                            ,
  		CpSl_Frame_i					=>     CpSl_Frame(4)			                            ,
  		CpSl_Sdo_i	     			=>     CpSl_Sdo(4)	     	                            ,
      wr_tdc_data_en_o			=>     wr_tdc_data_en_s(4)	                          ,
      wr_tdc_data_o         =>     wr_tdc_data_s((4+1)*32 -1  downto 4*32),
      wr_tdc_full_i         =>     wr_tdc_full_s(4)     
  
  	);
  M_Tdc_s2p_u5 : M_Tdc_s2p 
      port map(
  		CpSl_Rst_i						=>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i				=>     CpSl_RefClkP(5)		                            ,
  		CpSl_Frame_i					=>     CpSl_Frame(5)			                            ,
  		CpSl_Sdo_i	     			=>     CpSl_Sdo(5)	     	                            ,
      wr_tdc_data_en_o			=>     wr_tdc_data_en_s(5)	                          ,
      wr_tdc_data_o         =>     wr_tdc_data_s((5+1)*32 -1  downto 5*32),
      wr_tdc_full_i         =>     wr_tdc_full_s(5)     
  
  	);
  M_Tdc_s2p_u6 : M_Tdc_s2p 
      port map(
  		CpSl_Rst_i						=>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i				=>     CpSl_RefClkP(6)		                            ,
  		CpSl_Frame_i					=>     CpSl_Frame(6)			                            ,
  		CpSl_Sdo_i	     			=>     CpSl_Sdo(6)	     	                            ,
      wr_tdc_data_en_o			=>     wr_tdc_data_en_s(6)	                          ,
      wr_tdc_data_o         =>     wr_tdc_data_s((6+1)*32 -1  downto 6*32),
      wr_tdc_full_i         =>     wr_tdc_full_s(6)     
  
  	);
  M_Tdc_s2p_u7 : M_Tdc_s2p 
      port map(
  		CpSl_Rst_i						=>     CpSl_Rst_i				                              ,
  		CpSl_RefClkP_i				=>     CpSl_RefClkP(7)		                            ,
  		CpSl_Frame_i					=>     CpSl_Frame(7)			                            ,
  		CpSl_Sdo_i	     			=>     CpSl_Sdo(7)	     	                            ,
      wr_tdc_data_en_o			=>     wr_tdc_data_en_s(7)	                          ,
      wr_tdc_data_o         =>     wr_tdc_data_s((7+1)*32 -1  downto 7*32),
      wr_tdc_full_i         =>     wr_tdc_full_s(7)     
  
  	);


M_Tdc_group_sub_u0 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 0                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(0),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						  =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,  
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i		        =>  wr_tdc_data_en_s(0)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((0+1)*32 -1  downto 0*32),
    wr_tdc_full_o				     =>  wr_tdc_full_s(0)		  ,
    grouping_done_o             =>  grouping_done_s(0)    ,
    tdcecho1_o                  =>  tdcecho1_s((0+1)*27 -1  downto 0*27) ,
    tdcecho2_o                  =>  tdcecho2_s((0+1)*27 -1  downto 0*27) ,
    tdcecho3_o                  =>  tdcecho3_s((0+1)*27 -1  downto 0*27)            
	);
	
M_Tdc_group_sub_u1 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 1                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(1),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						          =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,       
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i				    =>  wr_tdc_data_en_s(1)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((1+1)*32 -1  downto 1*32)      ,
    wr_tdc_full_o				        =>  wr_tdc_full_s(1)		  ,
    grouping_done_o             =>  grouping_done_s(1)    ,
    tdcecho1_o                  =>  tdcecho1_s((1+1)*27 -1  downto 1*27) ,
    tdcecho2_o                  =>  tdcecho2_s((1+1)*27 -1  downto 1*27) ,
    tdcecho3_o                  =>  tdcecho3_s((1+1)*27 -1  downto 1*27)            
	);
M_Tdc_group_sub_u2 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 2                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(2),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						          =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,       
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i				    =>  wr_tdc_data_en_s(2)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((2+1)*32 -1  downto 2*32)      ,
    wr_tdc_full_o				        =>  wr_tdc_full_s(2)		  ,
    grouping_done_o             =>  grouping_done_s(2)    ,
    tdcecho1_o                  =>  tdcecho1_s((2+1)*27 -1  downto 2*27) ,
    tdcecho2_o                  =>  tdcecho2_s((2+1)*27 -1  downto 2*27) ,
    tdcecho3_o                  =>  tdcecho3_s((2+1)*27 -1  downto 2*27)            
	);
M_Tdc_group_sub_u3 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 3                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(3),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						          =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,       
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i				    =>  wr_tdc_data_en_s(3)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((3+1)*32 -1  downto 3*32)      ,
    wr_tdc_full_o				        =>  wr_tdc_full_s(3)		  ,
    grouping_done_o             =>  grouping_done_s(3)    ,
    tdcecho1_o                  =>  tdcecho1_s((3+1)*27 -1  downto 3*27) ,
    tdcecho2_o                  =>  tdcecho2_s((3+1)*27 -1  downto 3*27) ,
    tdcecho3_o                  =>  tdcecho3_s((3+1)*27 -1  downto 3*27)            
	);
M_Tdc_group_sub_u4 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 4                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(4),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						          =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,       
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i				    =>  wr_tdc_data_en_s(4)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((4+1)*32 -1  downto 4*32)      ,
    wr_tdc_full_o				        =>  wr_tdc_full_s(4)		  ,
    grouping_done_o             =>  grouping_done_s(4)    ,
    tdcecho1_o                  =>  tdcecho1_s((4+1)*27 -1  downto 4*27) ,
    tdcecho2_o                  =>  tdcecho2_s((4+1)*27 -1  downto 4*27) ,
    tdcecho3_o                  =>  tdcecho3_s((4+1)*27 -1  downto 4*27)            
	);
M_Tdc_group_sub_u5 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 5                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(5),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						          =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,       
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i				    =>  wr_tdc_data_en_s(5)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((5+1)*32 -1  downto 5*32)      ,
    wr_tdc_full_o				        =>  wr_tdc_full_s(5)		  ,
    grouping_done_o             =>  grouping_done_s(5)    ,
    tdcecho1_o                  =>  tdcecho1_s((5+1)*27 -1  downto 5*27) ,
    tdcecho2_o                  =>  tdcecho2_s((5+1)*27 -1  downto 5*27) ,
    tdcecho3_o                  =>  tdcecho3_s((5+1)*27 -1  downto 5*27)            
	);
M_Tdc_group_sub_u6 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 6                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(6),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						          =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,       
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i				    =>  wr_tdc_data_en_s(6)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((6+1)*32 -1  downto 6*32)      ,
    wr_tdc_full_o				        =>  wr_tdc_full_s(6)		  ,
    grouping_done_o             =>  grouping_done_s(6)    ,
    tdcecho1_o                  =>  tdcecho1_s((6+1)*27 -1  downto 6*27) ,
    tdcecho2_o                  =>  tdcecho2_s((6+1)*27 -1  downto 6*27) ,
    tdcecho3_o                  =>  tdcecho3_s((6+1)*27 -1  downto 6*27)            
	);
M_Tdc_group_sub_u7 : M_Tdc_group_sub 
    generic map (
		frame_id_c                      => 7                         
	)

    port map(
	 CpSl_RefClkP_i              =>  CpSl_RefClkP(7),
    clk_40m_i                   =>  clk_40m_i             , 
	 CpSl_Rst_i						          =>  CpSl_Rst_i						    ,
    start_grouping_i            =>  start_grouping        ,
    ref_index_cnt_start_i       =>  ref_index_cnt_start   ,       
    grouping_timeout_en_i       =>  grouping_timeout_en   ,	 
    wr_tdc_data_en_i				    =>  wr_tdc_data_en_s(7)		,
    wr_tdc_data_i               =>  wr_tdc_data_s((7+1)*32 -1  downto 7*32)      ,
    wr_tdc_full_o				        =>  wr_tdc_full_s(7)		  ,
    grouping_done_o             =>  grouping_done_s(7)    ,
    tdcecho1_o                  =>  tdcecho1_s((7+1)*27 -1  downto 7*27) ,
    tdcecho2_o                  =>  tdcecho2_s((7+1)*27 -1  downto 7*27) ,
    tdcecho3_o                  =>  tdcecho3_s((7+1)*27 -1  downto 7*27)            
	);

index_start_u : sync_fifo_64x8 
	PORT map
	(
		wrclk		  =>   CpSl_Clk200M_i ,  --: IN STD_LOGIC ;
		wrreq		  =>   wr_index_en ,    --: IN STD_LOGIC ;
		data		  =>   wr_index ,   --: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrfull	  =>   index_fifo_full,	 --: OUT STD_LOGIC 
		rdclk		  =>   clk_40m_i ,  --: IN STD_LOGIC ;
		rdreq		  =>   rd_index_en ,  --: IN STD_LOGIC ;
		q		     =>   rd_index ,  --: OUT STD_LOGIC_VECTOR (9 DOWNTO 0);
		rdempty	  =>   index_fifo_empty   , --: OUT STD_LOGIC ;
		rdusedw	  =>   pre_cmd_cnt  --: OUT STD_LOGIC_VECTOR (5 DOWNTO 0);
	);


    process (CpSl_Rst_i,CpSl_Clk200M_i) begin
        if (CpSl_Rst_i = '0') then 
            index_fifo_full_detect <= '0';
				wr_tdc_full_s_detect <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then 
		      if(index_fifo_full = '1') then
		          index_fifo_full_detect <= '1';
				end if;
		      if(wr_tdc_full_s(0) = '1' or wr_tdc_full_s(1) = '1' or wr_tdc_full_s(2) = '1' or wr_tdc_full_s(3) = '1' or
				   wr_tdc_full_s(4) = '1' or wr_tdc_full_s(5) = '1' or wr_tdc_full_s(6) = '1' or wr_tdc_full_s(7) = '1' ) then
		          wr_tdc_full_s_detect <= '1';
				end if;
		  end if;
	 end process;

----------------------------------------------
-- tdc idx counter----------------------------
----------------------------------------------
    -- Signals Delay 
    process (CpSl_Rst_i,CpSl_Clk200M_i) begin
        if (CpSl_Rst_i = '0') then 
            CpSl_Start1_d1 <= '0';
            CpSl_Start1_d2 <= '0';
            CpSl_Start1_d3 <= '0';
            CpSl_Start2_d1 <= '0';
            CpSl_Start2_d2 <= '0';
            CpSl_Start2_d3 <= '0';
            CpSl_Start3_d1 <= '0';
            CpSl_Start3_d2 <= '0';
            CpSl_Start3_d3 <= '0';
            CpSl_Clk5M_d1  <= '0';
            CpSl_Clk5M_d2  <= '0';
            CpSl_Clk5M_d3  <= '0';
            CpSl_RstId_d1  <= '0';
            CpSl_RstId_d2  <= '0';
        elsif rising_edge(CpSl_Clk200M_i) then 
            CpSl_Start1_d1 <= CpSl_Start1_i;
            CpSl_Start1_d2 <= CpSl_Start1_d1;
            CpSl_Start1_d3 <= CpSl_Start1_d2;
            CpSl_Start2_d1 <= CpSl_Start2_i;
            CpSl_Start2_d2 <= CpSl_Start2_d1;
            CpSl_Start2_d3 <= CpSl_Start2_d2;
            CpSl_Start3_d1 <= CpSl_Start3_i;
            CpSl_Start3_d2 <= CpSl_Start3_d1;
            CpSl_Start3_d3 <= CpSl_Start3_d2;
            CpSl_Clk5M_d1  <= CpSl_Clk5M_i ;
            CpSl_Clk5M_d2  <= CpSl_Clk5M_d1 ;
            CpSl_Clk5M_d3  <= CpSl_Clk5M_d2 ;
            CpSl_RstId_d1  <= CpSl_RstId_i ;
            CpSl_RstId_d2  <= CpSl_RstId_d1 ;
        end if;
    end process;
    
		CpSl_Start1_valid  <= '1' when(CpSl_Start1_d3 = '0' and CpSl_Start1_d2 = '1' ) else '0';
		CpSl_Start2_valid  <= '1' when(CpSl_Start2_d3 = '0' and CpSl_Start2_d2 = '1' ) else '0';
		CpSl_Start3_valid  <= '1' when(CpSl_Start3_d3 = '0' and CpSl_Start3_d2 = '1' ) else '0';
		CpSl_Clk5M_valid   <= '1' when(CpSl_Clk5M_d3  = '0' and CpSl_Clk5M_d2  = '1' ) else '0';
    

    process (CpSl_Rst_i,CpSl_Clk200M_i) begin
        if (CpSl_Rst_i = '0') then
            ref_index_cnt <= (others => '0');
            ref_index_cnt_valid <= (others => '0');
        elsif rising_edge(CpSl_Clk200M_i) then
            if(CpSl_Clk5M_valid = '1' and CpSl_RstId_d2 = '1') then
                ref_index_cnt <= (others => '0');
                ref_index_cnt_valid <= ref_index_cnt;
            elsif(CpSl_Clk5M_valid = '1') then
                ref_index_cnt <= ref_index_cnt + '1';
                ref_index_cnt_valid <= ref_index_cnt;
            end if;
        end if;
    end process;
                
    process (CpSl_Rst_i,CpSl_Clk200M_i) begin
        if (CpSl_Rst_i = '0') then
            wr_index <= (others => '0');
            wr_index_en      <= '0';
				ld_num <= "00";
        elsif rising_edge(CpSl_Clk200M_i) then
            if(CpSl_Clk5M_valid = '1' and CpSl_Start1_valid = '1') then
               wr_index <= "01" & ref_index_cnt;
--               wr_index    <= "01" & ref_index_cnt_valid;
               wr_index_en <= '1';
               ld_num      <= "01";
            elsif(CpSl_Clk5M_valid = '1' and CpSl_Start2_valid = '1') then
               wr_index <= "10" & ref_index_cnt;
--               wr_index    <= "10" & ref_index_cnt_valid;
               wr_index_en <= '1';
               ld_num      <= "10";
            elsif(CpSl_Clk5M_valid = '1' and CpSl_Start3_valid = '1') then
               wr_index <= "11" & ref_index_cnt;
--               wr_index    <= "11" & ref_index_cnt_valid;
               wr_index_en <= '1';
               ld_num      <= "11";
           else
               wr_index_en <= '0';
           end if;
        end if;
    end process;
    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            rd_index_en <= '0';
        elsif rising_edge(clk_40m_i) then
            if(grouping_en = '0' and index_fifo_empty = '0' and rd_index_en = '0' and rd_index_en_d1 = '0' and rd_index_en_d2 = '0') then
                rd_index_en <= '1';
            else
                rd_index_en <= '0';
            end if;
        end if;
    end process;
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            rd_index_en_d1 <= '0';
            rd_index_en_d2 <= '0';
        elsif rising_edge(clk_40m_i) then
            rd_index_en_d1 <= rd_index_en;
            rd_index_en_d2 <= rd_index_en_d1;
      end if;
    end process;
    
    --rd_index_en  <= '1' when (grouping_en = '0' and index_fifo_empty = '0') else '0';
    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            start_grouping <= '0';
            ref_index_cnt_start <= (others => '0');
				grouping_ld_num <= "00";
        elsif rising_edge(clk_40m_i) then
            if(rd_index_en_d1 = '1') then
                start_grouping <= '1';
                ref_index_cnt_start <= rd_index(15 downto 0);
					 grouping_ld_num <= rd_index(17 downto 16);
            else
                start_grouping <= '0';
                ref_index_cnt_start <= ref_index_cnt_start;
					 grouping_ld_num <= grouping_ld_num;
            end if;
        end if;
    end process;

   
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            grouping_timeout_en <= '0';
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1') then
                grouping_timeout_en <= '0';
            elsif(pre_cmd_cnt > 28 and grouping_en = '1') then
                grouping_timeout_en <= '1';
            end if;
		  end if;
	 end process;
				
----------------------------------------------
--  grouping ---------------------------------
----------------------------------------------


    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc1Echo1 <=  (others => '0');
            Tdc1Echo2 <=  (others => '0');
            Tdc1Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(0) = '1') then
                Tdc1Echo1 <=  tdcecho1_s(26       downto 0     );
                Tdc1Echo2 <=  tdcecho2_s(26       downto 0     );
                Tdc1Echo3 <=  tdcecho3_s(26       downto 0     );
            end if;
        end if;
    end process;
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc2Echo1 <=  (others => '0');
            Tdc2Echo2 <=  (others => '0');
            Tdc2Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(1) = '1') then
                Tdc2Echo1 <=  tdcecho1_s(26+1*27  downto 0+1*27);
                Tdc2Echo2 <=  tdcecho2_s(26+1*27  downto 0+1*27);
                Tdc2Echo3 <=  tdcecho3_s(26+1*27  downto 0+1*27);
            end if;
        end if;
    end process;
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc3Echo1 <=  (others => '0');
            Tdc3Echo2 <=  (others => '0');
            Tdc3Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(2) = '1') then
                Tdc3Echo1 <=  tdcecho1_s(26+2*27  downto 0+2*27);
                Tdc3Echo2 <=  tdcecho2_s(26+2*27  downto 0+2*27);
                Tdc3Echo3 <=  tdcecho3_s(26+2*27  downto 0+2*27);
            end if;
        end if;
    end process;    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc4Echo1 <=  (others => '0');
            Tdc4Echo2 <=  (others => '0');
            Tdc4Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(3) = '1') then
                Tdc4Echo1 <=  tdcecho1_s(26+3*27  downto 0+3*27);
                Tdc4Echo2 <=  tdcecho2_s(26+3*27  downto 0+3*27);
                Tdc4Echo3 <=  tdcecho3_s(26+3*27  downto 0+3*27);
            end if;
        end if;
    end process;    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc5Echo1 <=  (others => '0');
            Tdc5Echo2 <=  (others => '0');
            Tdc5Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(4) = '1') then
                Tdc5Echo1 <=  tdcecho1_s(26+4*27  downto 0+4*27);
                Tdc5Echo2 <=  tdcecho2_s(26+4*27  downto 0+4*27);
                Tdc5Echo3 <=  tdcecho3_s(26+4*27  downto 0+4*27);
            end if;
        end if;
    end process;    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc6Echo1 <=  (others => '0');
            Tdc6Echo2 <=  (others => '0');
            Tdc6Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(5) = '1') then
                Tdc6Echo1 <=  tdcecho1_s(26+5*27  downto 0+5*27);
                Tdc6Echo2 <=  tdcecho2_s(26+5*27  downto 0+5*27);
                Tdc6Echo3 <=  tdcecho3_s(26+5*27  downto 0+5*27);
            end if;
        end if;
    end process;       
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc7Echo1 <=  (others => '0');
            Tdc7Echo2 <=  (others => '0');
            Tdc7Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(6) = '1') then
                Tdc7Echo1 <=  tdcecho1_s(26+6*27  downto 0+6*27);
                Tdc7Echo2 <=  tdcecho2_s(26+6*27  downto 0+6*27);
                Tdc7Echo3 <=  tdcecho3_s(26+6*27  downto 0+6*27);
            end if;
        end if;
    end process;    
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            Tdc8Echo1 <=  (others => '0');
            Tdc8Echo2 <=  (others => '0');
            Tdc8Echo3 <=  (others => '0');
        elsif rising_edge(clk_40m_i) then      
            if(grouping_done_s(7) = '1') then
                Tdc8Echo1 <=  tdcecho1_s(26+7*27  downto 0+7*27);
                Tdc8Echo2 <=  tdcecho2_s(26+7*27  downto 0+7*27);
                Tdc8Echo3 <=  tdcecho3_s(26+7*27  downto 0+7*27);
            end if;
        end if;
    end process;    
    

   
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            grouping_en      <= '0';
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1') then
                grouping_en <= '0';
            elsif(start_grouping = '1') then    
                grouping_en <= '1';
            end if;
        end if;
    end process;

    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            grouping_done_keep(0)      <= '0';
            grouping_done_keep(1)      <= '0';
            grouping_done_keep(2)      <= '0';
            grouping_done_keep(3)      <= '0';
            grouping_done_keep(4)      <= '0';
            grouping_done_keep(5)      <= '0';
            grouping_done_keep(6)      <= '0';
            grouping_done_keep(7)      <= '0';
        elsif rising_edge(clk_40m_i) then
            if(CpSl_TdcDataVld_s = '1') then
                grouping_done_keep(0)      <= '0';
            elsif(grouping_done_s(0) = '1') then
                grouping_done_keep(0)      <= '1';
            end if;
            if(CpSl_TdcDataVld_s = '1') then
                grouping_done_keep(2)      <= '0';
            elsif(grouping_done_s(2) = '1') then
                grouping_done_keep(2)      <= '1';
            end if;
            if(CpSl_TdcDataVld_s = '1') then
                grouping_done_keep(4)      <= '0';
            elsif(grouping_done_s(4) = '1') then
                grouping_done_keep(4)      <= '1';
            end if;
            if(CpSl_TdcDataVld_s = '1') then
                grouping_done_keep(5)      <= '0';
            elsif(grouping_done_s(5) = '1') then
                grouping_done_keep(5)      <= '1';
            end if;
            if(CpSl_TdcDataVld_s = '1') then
                grouping_done_keep(6)      <= '0';
            elsif(grouping_done_s(6) = '1') then
                grouping_done_keep(6)      <= '1';
            end if;
            if(CpSl_TdcDataVld_s = '1') then
                grouping_done_keep(7)      <= '0';
            elsif(grouping_done_s(7) = '1') then
                grouping_done_keep(7)      <= '1';
            end if;
        end if;
    end process;
        
    TdcDataVld_w <=  '1' when (grouping_done_keep(0) = '1' and
                               grouping_done_keep(2) = '1' and
                               grouping_done_keep(4) = '1' and
                               grouping_done_keep(5) = '1' and
                               grouping_done_keep(6) = '1' and
                               grouping_done_keep(7) = '1' and 
                               CpSl_TdcDataVld_s = '0') else '0';
                               
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSl_TdcDataVld_s      <= '0';
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1') then
               CpSl_TdcDataVld_s      <= '1';
             else
               CpSl_TdcDataVld_s      <= '0';
             end if;
         end if;
     end process;
     
     CpSl_TdcDataVld_o <= CpSl_TdcDataVld_s;

     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_ld_num_o <= "00";
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1') then
               CpSv_ld_num_o      <= grouping_ld_num;
             end if;
         end if;
     end process;
     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc1Echo1_o      <= (others => '0');
            CpSv_Tdc3Echo1_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc1echo1(23 downto 0) /= 0 and tdc3echo1(23 downto 0) /= 0) then
               CpSv_Tdc1Echo1_o      <= tdc1echo1;
               CpSv_Tdc3Echo1_o      <= tdc3echo1;
            elsif(TdcDataVld_w = '1') then        
               CpSv_Tdc1Echo1_o      <= (others => '0');
               CpSv_Tdc3Echo1_o      <= (others => '0');
            end if;
        end if;
    end process;     
          
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc2Echo1_o      <= (others => '0');
            CpSv_Tdc4Echo1_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then


               CpSv_Tdc2Echo1_o      <= (others => '0');

               CpSv_Tdc4Echo1_o      <= (others => '0');

         end if;
     end process;  
     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc5Echo1_o      <= (others => '0');
            CpSv_Tdc7Echo1_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc5echo1(23 downto 0) /= 0 and tdc7echo1(23 downto 0) /= 0) then
               CpSv_Tdc5Echo1_o      <= tdc5echo1;
               CpSv_Tdc7Echo1_o      <= tdc7echo1;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc5Echo1_o      <= (others => '0');
               CpSv_Tdc7Echo1_o      <= (others => '0');
             end if;
         end if;
     end process;  
     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc6Echo1_o      <= (others => '0');
            CpSv_Tdc8Echo1_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc6echo1(23 downto 0) /= 0 and tdc8echo1(23 downto 0) /= 0) then
               CpSv_Tdc6Echo1_o      <= tdc6echo1;
               CpSv_Tdc8Echo1_o      <= tdc8echo1;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc6Echo1_o      <= (others => '0');
               CpSv_Tdc8Echo1_o      <= (others => '0');
            end if;
        end if;
    end process;                      


    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc1Echo2_o      <= (others => '0');
            CpSv_Tdc3Echo2_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc1echo2(23 downto 0) /= 0 and tdc3echo2(23 downto 0) /= 0) then
               CpSv_Tdc1Echo2_o      <= tdc1echo2;
               CpSv_Tdc3Echo2_o      <= tdc3echo2;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc1Echo2_o      <= (others => '0');
               CpSv_Tdc3Echo2_o      <= (others => '0');
            end if;
        end if;
    end process;     
          
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc2Echo2_o      <= (others => '0');
            CpSv_Tdc4Echo2_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
               CpSv_Tdc2Echo2_o      <= (others => '0');
               CpSv_Tdc4Echo2_o      <= (others => '0');
         end if;
     end process;  
     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc5Echo2_o      <= (others => '0');
            CpSv_Tdc7Echo2_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc5echo2(23 downto 0) /= 0 and tdc7echo2(23 downto 0) /= 0) then
               CpSv_Tdc5Echo2_o      <= tdc5echo2;
               CpSv_Tdc7Echo2_o      <= tdc7echo2;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc5Echo2_o      <= (others => '0');
               CpSv_Tdc7Echo2_o      <= (others => '0');
             end if;
         end if;
     end process;  
     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc6Echo2_o      <= (others => '0');
            CpSv_Tdc8Echo2_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc6echo2(23 downto 0) /= 0 and tdc8echo2(23 downto 0) /= 0) then
               CpSv_Tdc6Echo2_o      <= tdc6echo2;
               CpSv_Tdc8Echo2_o      <= tdc8echo2;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc6Echo2_o      <= (others => '0');
               CpSv_Tdc8Echo2_o      <= (others => '0');
            end if;
        end if;
    end process;                      

    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc1Echo3_o      <= (others => '0');
            CpSv_Tdc3Echo3_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc1echo3(23 downto 0) /= 0 and tdc3echo3(23 downto 0) /= 0) then
               CpSv_Tdc1Echo3_o      <= tdc1echo3;
               CpSv_Tdc3Echo3_o      <= tdc3echo3;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc1Echo3_o      <= (others => '0');
               CpSv_Tdc3Echo3_o      <= (others => '0');
            end if;
        end if;
    end process;     
          
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc2Echo3_o      <= (others => '0');
            CpSv_Tdc4Echo3_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
               CpSv_Tdc2Echo3_o      <= (others => '0');
               CpSv_Tdc4Echo3_o      <= (others => '0');
         end if;
     end process;  
     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc5Echo3_o      <= (others => '0');
            CpSv_Tdc7Echo3_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc5echo3(23 downto 0) /= 0 and tdc7echo3(23 downto 0) /= 0) then
               CpSv_Tdc5Echo3_o      <= tdc5echo3;
               CpSv_Tdc7Echo3_o      <= tdc7echo3;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc5Echo3_o      <= (others => '0');
               CpSv_Tdc7Echo3_o      <= (others => '0');
             end if;
         end if;
     end process;  
     
    process (CpSl_Rst_i,clk_40m_i) begin
        if (CpSl_Rst_i = '0') then
            CpSv_Tdc6Echo3_o      <= (others => '0');
            CpSv_Tdc8Echo3_o      <= (others => '0');
        elsif rising_edge(clk_40m_i) then
            if(TdcDataVld_w = '1' and tdc6echo3(23 downto 0) /= 0 and tdc8echo3(23 downto 0) /= 0) then
               CpSv_Tdc6Echo3_o      <= tdc6echo3;
               CpSv_Tdc8Echo3_o      <= tdc8echo3;
            elsif(TdcDataVld_w = '1') then
               CpSv_Tdc6Echo3_o      <= (others => '0');
               CpSv_Tdc8Echo3_o      <= (others => '0');
            end if;
        end if;
    end process;                      




    ----------------------------------------------------------------------------
    -- End Coding
    ----------------------------------------------------------------------------
end arch_M_Tdc_group;