--------------------------------------------------------------------------------
-- °æ    È¨  :  ZVISION
-- ÎÄ¼þÃû³Æ  :  ocf_ctrl.vhd
-- Éè    ¼Æ  :  Zhang Shuqiang
-- ÓÊ    ¼þ  :  shuqiang.zhang@zvision.xyz
-- Ð£    ¶Ô  :
-- Éè¼ÆÈÕÆÚ  :  2019/02/15
-- ¹¦ÄÜ¼òÊö  :  on chip flash controller
-- °æ±¾ÐòºÅ  :  0.1
-- ÐÞ¸ÄÀúÊ·  :  1. Initial, Zhang Shuqiang, 2019/02/15
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity ocf_ctrl is
    generic (
        PrSl_Sim_c                      : integer := 1                         -- Simulation
    );
    port (
        --------------------------------
        -- Reset and clock
        --------------------------------
        rst_n_i                         : in  std_logic;                        -- Reset, active low
        clk_i                           : in  std_logic;                        -- 40MHz Clock,single

        test_mode_i                     : in  std_logic;
        op_flash_cmd_en_i               : in  std_logic;
        op_flash_cmd_i                  : in  std_logic_vector(31 downto 0);
        
        -- Flash_Rd 
        wr_flash_frame_req              : in  std_logic;
        wr_flash_frame_len              : in  std_logic_vector(15 downto 0);
        wr_flash_frame_addr             : in  std_logic_vector(18 downto 0);
        
        -- Flash_WrData
        wr_ufm_en_i                     : in  std_logic;
        wr_ufm_data_i                   : in  std_logic_vector(15 downto 0);
        
        rw_flash_frame_done             : out std_logic_vector( 1 downto 0);
        rd_ufm_data_o                   : out std_logic_vector(255 downto 0);
        prsv_s1dportrdata_o             : out std_logic_vector(15 downto 0); 
        prsv_w5300siprdata_o            : out std_logic_vector(31 downto 0); 
        sip_dport_en_o                  : out std_logic_vector(15 downto 0); 
        
        -- TCP/IP_Config_Data
        wr_reg_ram_en_o                 : out std_logic;
        wr_reg_ram_data_o               : out std_logic_vector(31 downto 0);
        wr_reg_ram_addr_o               : out std_logic_vector(18 downto 0);
        --memscan_x
        wr_memx_ram_en_o                : out std_logic;                     
        wr_memx_ram_data_o              : out std_logic_vector(31 downto 0); 
        wr_memx_ram_addr_o              : out std_logic_vector(18 downto 0);   
         --memscan_Y
        wr_memy_ram_en_o                : out std_logic;                       
        wr_memy_ram_data_o              : out std_logic_vector(31 downto 0);   
        wr_memy_ram_addr_o              : out std_logic_vector(18 downto 0);   
        --APD_Select_Channel_Num
        wr_as_ram_en_o                  : out std_logic;
        wr_as_ram_data_o                : out std_logic_vector(31 downto 0);
        wr_as_ram_addr_o                : out std_logic_vector(18 downto 0);
        --APD_LTC2631_data
        wr_av_ram_en_o                  : out std_logic;
        wr_av_ram_data_o                : out std_logic_vector(31 downto 0);
        wr_av_ram_addr_o                : out std_logic_vector(18 downto 0);
        --Gray ration
        wr_gc_ram_en_o                  : out std_logic;
        wr_gc_ram_data_o                : out std_logic_vector(31 downto 0);
        wr_gc_ram_addr_o                : out std_logic_vector(18 downto 0);
        --Distance constant 
        wr_cc_ram_en_o                  : out std_logic;
        wr_cc_ram_data_o                : out std_logic_vector(31 downto 0);
        wr_cc_ram_addr_o                : out std_logic_vector(18 downto 0);
        
        --------------------------------
        -- Apd_Channel_Dly(Num : 96)
        --------------------------------
        wr_ApdDly_ram_en_o              : out std_logic;
        wr_ApdDly_ram_data_o            : out std_logic_vector(31 downto 0);
        wr_ApdDly_ram_addr_o            : out std_logic_vector(18 downto 0);
        
        -- 16bit(Real_12bit) * 227
        wr_capav_ram_en_o               : out std_logic;
        wr_capav_ram_data_o             : out std_logic_vector(31 downto 0);
        wr_capav_ram_addr_o             : out std_logic_vector(18 downto 0);

        initial_done_o                 : out std_logic  
    );
end ocf_ctrl;

architecture arch_ocf_ctrl of ocf_ctrl is

    component on_chip_flash is
    port (
		clock                   : in  std_logic                     := '0';             --    clk.clk
		avmm_csr_addr           : in  std_logic                     := '0';             --    csr.address
		avmm_csr_read           : in  std_logic                     := '0';             --       .read
		avmm_csr_writedata      : in  std_logic_vector(31 downto 0) := (others => '0'); --       .writedata
		avmm_csr_write          : in  std_logic                     := '0';             --       .write
		avmm_csr_readdata       : out std_logic_vector(31 downto 0);                    --       .readdata
		avmm_data_addr          : in  std_logic_vector(17 downto 0) := (others => '0'); --   data.address
		avmm_data_read          : in  std_logic                     := '0';             --       .read
		avmm_data_writedata     : in  std_logic_vector(31 downto 0) := (others => '0'); --       .writedata
		avmm_data_write         : in  std_logic                     := '0';             --       .write
		avmm_data_readdata      : out std_logic_vector(31 downto 0);                    --       .readdata
		avmm_data_waitrequest   : out std_logic;                                        --       .waitrequest
		avmm_data_readdatavalid : out std_logic;                                        --       .readdatavalid
		avmm_data_burstcount    : in  std_logic_vector(3 downto 0)  := (others => '0'); --       .burstcount
		reset_n                 : in  std_logic                     := '0'              -- nreset.reset_n
    );
    end component;
	 
    component ocf_model is
    port (
		clock                   : in  std_logic                     := '0';             --    clk.clk
		avmm_csr_addr           : in  std_logic                     := '0';             --    csr.address
		avmm_csr_read           : in  std_logic                     := '0';             --       .read
		avmm_csr_writedata      : in  std_logic_vector(31 downto 0) := (others => '0'); --       .writedata
		avmm_csr_write          : in  std_logic                     := '0';             --       .write
		avmm_csr_readdata       : out std_logic_vector(31 downto 0);                    --       .readdata
		avmm_data_addr          : in  std_logic_vector(17 downto 0) := (others => '0'); --   data.address
		avmm_data_read          : in  std_logic                     := '0';             --       .read
		avmm_data_writedata     : in  std_logic_vector(31 downto 0) := (others => '0'); --       .writedata
		avmm_data_write         : in  std_logic                     := '0';             --       .write
		avmm_data_readdata      : out std_logic_vector(31 downto 0);                    --       .readdata
		avmm_data_waitrequest   : out std_logic;                                        --       .waitrequest
		avmm_data_readdatavalid : out std_logic;                                        --       .readdatavalid
		avmm_data_burstcount    : in  std_logic_vector(3 downto 0)  := (others => '0'); --       .burstcount
		reset_n                 : in  std_logic                     := '0'              -- nreset.reset_n
    );
    end component;
	 
    component sync_fifo_32x512 IS
    PORT (
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		rdclk		: IN STD_LOGIC ;
		rdreq		: IN STD_LOGIC ;
		wrclk		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		q           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdempty		: OUT STD_LOGIC ;
		wrfull		: OUT STD_LOGIC 
    );
    END component;

    constant IDLE_C             : std_logic_vector(4 downto 0) := '0' & x"0";
    constant PRE_RD_PARA_C      : std_logic_vector(4 downto 0) := '0' & x"1";
    constant RD_PARA_C          : std_logic_vector(4 downto 0) := '0' & x"2";
    constant RD_PARA_DONE       : std_logic_vector(4 downto 0) := '0' & x"3";
    constant PRE_UC_RD_PARA_C   : std_logic_vector(4 downto 0) := '0' & x"4";
    constant UC_RD_PARA_C       : std_logic_vector(4 downto 0) := '0' & x"5";
    constant UC_RD_PARA_DONE    : std_logic_vector(4 downto 0) := '0' & x"6";
    constant DIS_WP_C           : std_logic_vector(4 downto 0) := '0' & x"7";--关闭写保护
    constant PRE_ERASE_C        : std_logic_vector(4 downto 0) := '0' & x"8";--预擦除
    constant ERASE_C            : std_logic_vector(4 downto 0) := '0' & x"9"; 
    constant JUDGE_ERASE_DONE_C : std_logic_vector(4 downto 0) := '0' & x"A";
    constant PRE_WR_DATA_C      : std_logic_vector(4 downto 0) := '0' & x"B";
    constant WR_DATA_C          : std_logic_vector(4 downto 0) := '0' & x"C";
    constant RD_STATUS_C        : std_logic_vector(4 downto 0) := '0' & x"D";
    constant WR_OK_JUDGE        : std_logic_vector(4 downto 0) := '0' & x"F";
    constant ENB_WP_C           : std_logic_vector(4 downto 0) := '1' & x"0";
    constant PROC_DONE          : std_logic_vector(4 downto 0) := '1' & x"1";
    constant WR_DATA_FAILED     : std_logic_vector(4 downto 0) := '1' & x"2";
	 
    constant RD_PARA_WAIT_C     : std_logic_vector(4 downto 0) := '1' & x"3";

    constant MODE_TEST_C        : std_logic := '1';
    constant MODE_COMMON_C      : std_logic := '0';
    constant MODE_CURRENT_C     : std_logic := MODE_TEST_C;
    
    constant PARA_GRP_NUM_C     : std_logic_vector( 7 downto 0) := X"04";  
    constant MEMX_LEN_C         : std_logic_vector(18 downto 0) := "000" & X"1388";  -- 5000
    constant MEMY_LEN_C         : std_logic_vector(18 downto 0) := "000" & X"1388";  -- 5000
    constant APDS_LEN_C         : std_logic_vector(18 downto 0) := "000" & X"1D4C";  -- APD SELECT 7500
    constant APDv_LEN_C         : std_logic_vector(18 downto 0) := "000" & X"0072";  -- APD VOL 114
    constant GRAYC_LEN_C        : std_logic_vector(18 downto 0) := "000" & X"1D4C";  -- GRAY coefficient 15000
    constant CURVEC_LEN_C       : std_logic_vector(18 downto 0) := "000" & X"005A";  -- CURVE coefficient 90
    constant APDDLY_LEN_C       : std_logic_vector(18 downto 0) := "000" & X"0060";  -- APD DLY coefficient 96
    constant CAPAV_LEN_C        : std_logic_vector(18 downto 0) := "000" & X"0072";  -- CAPA VOL DLY coefficient 114
	 
	 
    constant MIF_BASE_ADDR      : std_logic_vector(18 downto 0) := "000" & x"4000";
    constant MEMX_FST_AD_C      : std_logic_vector(18 downto 0) := (MIF_BASE_ADDR   + 0);		      -- Memscan_X_5000   -- 0x4000
    constant MEMY_FST_AD_C      : std_logic_vector(18 downto 0) := (MEMX_FST_AD_C   + MEMX_LEN_C   );  -- Memscan_Y_5000   --0x5388
    constant APDS_FST_AD_C      : std_logic_vector(18 downto 0) := (MEMY_FST_AD_C   + MEMY_LEN_C   );  -- Point_APD_Channel_Num_Select_7500	--0x6710
    constant APDv_FST_AD_C      : std_logic_vector(18 downto 0) := (APDS_FST_AD_C   + APDS_LEN_C   );  -- APD_LTC2631_Data_114   --0x845c
    constant GRAYC_FST_AD_C     : std_logic_vector(18 downto 0) := (APDv_FST_AD_C   + APDv_LEN_C   );  -- Gray_Ratio_Real_7500(Desinger_15000) --0x84ce
    constant CURVEC_FST_AD_C    : std_logic_vector(18 downto 0) := (GRAYC_FST_AD_C  + GRAYC_LEN_C  );  -- Distance_Constant_90  	--0xa21a
    constant APDDLY_FST_AD_C    : std_logic_vector(18 downto 0) := (CURVEC_FST_AD_C + CURVEC_LEN_C );  -- APD_Chanel_Dly_96 		--0xa274
    constant CAPAV_FST_AD_C     : std_logic_vector(18 downto 0) := (APDDLY_FST_AD_C + APDDLY_LEN_C );  -- APD_Real_Vol_114(CAPA VOL DLY coefficient) --0xa2d4
    constant FLASH_MAX_ADDR     : std_logic_vector(18 downto 0) := (CAPAV_FST_AD_C + CAPAV_LEN_C);     -- 0xa346
    
    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal cur_state                    : std_logic_vector( 4 downto 0);        -- Frame state
    signal cur_state_d1                 : std_logic_vector( 4 downto 0);        -- Frame state delay 1
    signal PrSl_Ind_s                   : std_logic;                            -- Address_Ind
    signal ctrl_reg_wr_data             : std_logic_vector(31 downto 0);
    signal status_reg_rd_data           : std_logic_vector(31 downto 0);
    
    signal csr_addr                     :  std_logic                     ;       
    signal csr_read                     :  std_logic                     ;       
    signal csr_writedata                :  std_logic_vector(31 downto 0) ;       
    signal csr_write                    :  std_logic                     ;       
    signal csr_readdata                 :  std_logic_vector(31 downto 0) ;       
    signal data_addr                    :  std_logic_vector(18 downto 0) ;       
    signal uc_data_addr                 :  std_logic_vector(18 downto 0) ;       
    signal data_addr_r                  :  std_logic_vector(17 downto 0) ;       
    signal data_read                    :  std_logic                     ;       
    signal data_writedata               :  std_logic_vector(31 downto 0) ;       
    signal data_write                   :  std_logic                     ;       
    signal data_readdata                :  std_logic_vector(31 downto 0) ;       
    signal data_waitrequest             :  std_logic                     ;       
    signal data_readdatavalid           :  std_logic                     ;       
    signal data_burstcount_r            :  std_logic_vector(18 downto 0)  ;       
    signal data_burstcount              :  std_logic_vector(3  downto 0)  ;  
    signal inburst_rd_num_r             :  std_logic_vector(18 downto 0)  ; 	 
    signal inburst_rd_num               :  std_logic_vector(3 downto 0)  ;       
    signal wr_word_cnt                  :  std_logic_vector(15 downto 0) ;
                  
    signal rd_flash_cnt                 :  std_logic_vector(18 downto 0)  ;      
    signal rd_flash_addr                :  std_logic_vector(18 downto 0)  ; 
	 attribute keep : string;
	 attribute keep of rd_flash_addr     : signal is "true";	
	 
    signal rd_flash_num                 :  std_logic_vector(18 downto 0)  ;      
    signal inburst_rd_cnt               :  std_logic_vector(3 downto 0)  ;       

    signal rd_para_done_en              :  std_logic;
    signal ds_cfg_fifo_rd_req           :  std_logic;
    signal ds_cfg_fifo_rd_data          :  std_logic_vector(31 downto 0)  ;       
    signal ds_cfg_fifo_empty            :  std_logic;
	signal wr_reg_ram_addr_s            :  std_logic_vector(18 downto 0)  ;
	signal wr_memx_ram_addr_s           :  std_logic_vector(18 downto 0)  ;
	signal wr_memy_ram_addr_s           :  std_logic_vector(18 downto 0)  ;
	signal wr_as_ram_addr_s             :  std_logic_vector(18 downto 0)  ;
	signal wr_av_ram_addr_s             :  std_logic_vector(18 downto 0)  ;
	signal wr_gc_ram_addr_s             :  std_logic_vector(18 downto 0)  ;
	signal wr_cc_ram_addr_s             :  std_logic_vector(18 downto 0)  ;
	signal wr_apddly_ram_addr_s         :  std_logic_vector(18 downto 0)  ;
	signal wr_capav_ram_addr_s          :  std_logic_vector(18 downto 0)  ;

	signal wr_flash_frame_len_lock      :  std_logic_vector(15 downto 0);
    signal wr_flash_frame_addr_lock     :  std_logic_vector(18 downto 0);
	 
	 
    signal state_wait_cnt               :  std_logic_vector( 15 downto 0);
    signal op_flash_cmd                 :  std_logic_vector( 31 downto 0);
	 
    signal rd_ufm_data                  :  std_logic_vector(255 downto 0);
	 
	 signal wr_flash_frame_req_keep      :  std_logic;
	 signal op_flash_cmd_en_keep         :  std_logic;
	 
	 
	 signal wr_reg_ram_en                 : std_logic;
	 signal wr_reg_ram_data               : std_logic_vector(31 downto 0);
        
	 signal wr_memx_ram_en                : std_logic;                     
	 signal wr_memx_ram_data              : std_logic_vector(31 downto 0); 
		     
	 signal wr_memy_ram_en                : std_logic;                       
	 signal wr_memy_ram_data              : std_logic_vector(31 downto 0);   
		    
	 signal wr_as_ram_en                  : std_logic;
	 signal wr_as_ram_data                : std_logic_vector(31 downto 0);

	 signal wr_av_ram_en                  : std_logic;
	 signal wr_av_ram_data                : std_logic_vector(31 downto 0);

	 signal wr_gc_ram_en                  : std_logic;
	 signal wr_gc_ram_data                : std_logic_vector(31 downto 0);
			 
	 signal wr_cc_ram_en                  : std_logic;
	 signal wr_cc_ram_data                : std_logic_vector(31 downto 0);
	 
	signal wr_reg_ram_en_s               : std_logic;
	signal wr_reg_ram_data_s             : std_logic_vector(31 downto 0);
	
	signal prsv_s1dportrdata_s           : std_logic_vector(15 downto 0); 
	signal prsv_w5300siprdata_s          : std_logic_vector(31 downto 0); 
	signal sip_dport_en_s                : std_logic_vector(15 downto 0); 
    	
	signal rst                           : std_logic;
    
    signal wr_ApdDly_ram_en              : std_logic;
    signal wr_ApdDly_ram_data            : std_logic_vector(31 downto 0);
	 
    signal wr_capav_ram_en               : std_logic;                        
    signal wr_capav_ram_data             : std_logic_vector(31 downto 0);
	 
	 
	 
	 
begin
                                            
    ds_cfg_fifo : sync_fifo_32x512                                                            
    PORT map(                                                                                      
     		rdclk		=> clk_i,
     		wrclk		=> clk_i,
     		wrreq		=> wr_ufm_en_i,                                         
     		data		=> wr_ufm_data_i,                                         
     		wrfull		=> open,                                         
     		rdreq		=> ds_cfg_fifo_rd_req,                                         
     		q		    => ds_cfg_fifo_rd_data,                                             
     		rdempty		=> ds_cfg_fifo_empty                                         
    );                                                                                     
            
--    ocf_gen : if (PrSl_Sim_c = 1) generate
--	 on_chip_flash_u : on_chip_flash 
--	  port map(
--		    clock                   => clk_i               ,         --    clk.clk
--		    reset_n                 => rst_n_i             ,         -- nreset.reset_n
--		    avmm_csr_addr           => csr_addr            ,         --    csr.address
--		    avmm_csr_read           => csr_read            ,         --       .read
--		    avmm_csr_writedata      => csr_writedata       ,         --       .writedata
--		    avmm_csr_write          => csr_write           ,         --       .write
--		    avmm_csr_readdata       => csr_readdata        ,         --       .readdata
--		    avmm_data_addr          => data_addr           ,         --   data.address
--		    avmm_data_read          => data_read           ,         --       .read
--		    avmm_data_writedata     => data_writedata      ,         --       .writedata
--		    avmm_data_write         => data_write          ,         --       .write
--		    avmm_data_readdata      => data_readdata       ,         --       .readdata
--		    avmm_data_waitrequest   => data_waitrequest    ,         --       .waitrequest
--		    avmm_data_readdatavalid => data_readdatavalid  ,         --       .readdatavalid
--		    avmm_data_burstcount    => data_burstcount               --       .burstcount
--	  );
--    end generate ocf_gen;    
	  
    --sim_ocf : if (PrSl_Sim_c = 0) generate
--	 ocf_model_u : ocf_model 
	 on_chip_flash_u : on_chip_flash ----------
	  port map(
		    clock                   => clk_i               ,         --    clk.clk
		    reset_n                 => rst_n_i             ,         -- nreset.reset_n
		    avmm_csr_addr           => csr_addr            ,         --    csr.address
		    avmm_csr_read           => csr_read            ,         --       .read
		    avmm_csr_writedata      => csr_writedata       ,         --       .writedata
		    avmm_csr_write          => csr_write           ,         --       .write
		    avmm_csr_readdata       => csr_readdata        ,         --       .readdata
		    avmm_data_addr          => data_addr_r         ,         --   data.address
		    avmm_data_read          => data_read           ,         --       .read
		    avmm_data_writedata     => data_writedata      ,         --       .writedata
		    avmm_data_write         => data_write          ,         --       .write
		    avmm_data_readdata      => data_readdata       ,         --       .readdata
		    avmm_data_waitrequest   => data_waitrequest    ,         --       .waitrequest
		    avmm_data_readdatavalid => data_readdatavalid  ,         --       .readdatavalid
		    avmm_data_burstcount    => data_burstcount               --       .burstcount
	  );
    --end generate sim_ocf; 	  

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            cur_state <= IDLE_C;
        elsif rising_edge(clk_i) then
            case cur_state is
                when  IDLE_C => 
                    -- Flash_WrData(BB + Addr(7:0) + "00000" + Addr(18:8) + Data)
                    if(wr_flash_frame_req_keep = '1' and MODE_CURRENT_C = MODE_TEST_C) then
                        cur_state <=  PRE_WR_DATA_C;
                    elsif(op_flash_cmd_en_keep = '1' and op_flash_cmd(31 downto 16) = x"BA01") then -- Flash_Config_Begin
                        cur_state <=  DIS_WP_C;
                    elsif(op_flash_cmd_en_keep = '1' and op_flash_cmd(31 downto 16) = x"BA02") then -- Flash_Erase(Erase_Flase_ID)
                        cur_state <=  PRE_ERASE_C;
                    elsif(op_flash_cmd_en_keep = '1' and op_flash_cmd(31 downto 16) = x"BA03") then -- Flash_Config_End
                        cur_state <=  ENB_WP_C;
                    -- Flash_RdData(BC + Addr(7:0) + "00000" + Addr(18:8) + Data)
                    elsif(op_flash_cmd_en_keep = '1' and op_flash_cmd(31 downto 24) = x"BC") then 
                        cur_state <=  PRE_UC_RD_PARA_C;
                    elsif(rd_para_done_en = '0') then
                    --elsif(MODE_CURRENT_C = MODE_COMMON_C) then
                        cur_state <=  RD_PARA_WAIT_C;
                    else -- hold
                    end if;
                    
                when RD_PARA_WAIT_C =>   -- READ APD SLECT PARAMETER
                    if(cur_state = cur_state_d1 and state_wait_cnt >= x"5ff") then
                        cur_state <= PRE_RD_PARA_C; 
                    else
                    end if;
                when  PRE_RD_PARA_C =>   -- READ APD SLECT PARAMETER 
                    if(cur_state = cur_state_d1 and data_waitrequest = '0') then
                        cur_state <= RD_PARA_C; 
                    else
                    end if;
                when  RD_PARA_C =>      
                    if((rd_flash_cnt + inburst_rd_num) >= rd_flash_num and inburst_rd_cnt >= (inburst_rd_num - '1') and data_readdatavalid = '1') then
                        cur_state <= RD_PARA_DONE; 
                    elsif(inburst_rd_cnt >= (inburst_rd_num - '1') and data_readdatavalid = '1') then
                        cur_state <= PRE_RD_PARA_C; 
                    end if;
                when  RD_PARA_DONE =>
                    cur_state <= IDLE_C; 
                    
                when  PRE_UC_RD_PARA_C =>   -- up computer READ PARAMETER 
                    if(cur_state = cur_state_d1 and data_waitrequest = '0') then
                        cur_state <= UC_RD_PARA_C; 
                    else
                    end if;
                when  UC_RD_PARA_C =>      
                    if(inburst_rd_cnt >= (inburst_rd_num - '1') and data_readdatavalid = '1') then
                        cur_state <= UC_RD_PARA_DONE;
						  else	
                    end if;
                when  UC_RD_PARA_DONE =>
                    cur_state <= PROC_DONE;

                when  DIS_WP_C => -- Flash_Config_Begin
                    cur_state <= PROC_DONE; 
                when  PRE_ERASE_C => -- Erase_Flash
				    if(csr_readdata(1 downto 0) = "00") then
					    cur_state <= ERASE_C; 
					end if;
                when  ERASE_C =>
  				    cur_state <= JUDGE_ERASE_DONE_C; 
				when  JUDGE_ERASE_DONE_C =>
				    if(cur_state = cur_state_d1 and state_wait_cnt >= 5 and csr_readdata(4) = '1') then
					    cur_state <= PROC_DONE; 
				    elsif(cur_state = cur_state_d1 and state_wait_cnt >= 5 and csr_readdata(4) = '0' and csr_readdata(1 downto 0) = "00") then
					    cur_state <= WR_DATA_FAILED; 
                    end if;

                -- Flash_WrData
                when  PRE_WR_DATA_C   =>
                    if(cur_state = cur_state_d1 and state_wait_cnt >= 0) then
                        cur_state <= WR_DATA_C; 
					else --hold
					end if;
				when  WR_DATA_C   =>
                    if(cur_state = cur_state_d1 and data_waitrequest = '0') then
                        cur_state <= RD_STATUS_C; 
                    else --hold
                    end if;
                when  RD_STATUS_C =>
                    cur_state <= WR_OK_JUDGE; 
                when  WR_OK_JUDGE =>
                    if(csr_readdata(1 downto 0) = "10") then
                        cur_state <= RD_STATUS_C;
                    elsif(csr_readdata(3) = '1' and wr_word_cnt >= (wr_flash_frame_len_lock - 1)) then
                        cur_state <= PROC_DONE;
                    elsif(csr_readdata(3) = '1' and wr_word_cnt <  (wr_flash_frame_len_lock - 1)) then
                        cur_state <= PRE_WR_DATA_C;
                    else
                        cur_state <= WR_DATA_FAILED;
                    end if;
                
                when  ENB_WP_C => -- Flash_Config_End
                    cur_state <= PROC_DONE;

                when  PROC_DONE => -- State_End
                    if(cur_state = cur_state_d1 and state_wait_cnt >= 30) then
                        cur_state <= IDLE_C;
					else
                    end if;
                    
				when  WR_DATA_FAILED =>
                    cur_state <= IDLE_C;

				when  others =>
                    cur_state <= IDLE_C;
            end case;
        end if;
    end process; 

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            cur_state_d1 <= (others => '0');
        elsif rising_edge(clk_i) then    
            cur_state_d1 <= cur_state;
          end if;
    end process;

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            state_wait_cnt <= (others => '0');
        elsif rising_edge(clk_i) then  
            if(cur_state /= cur_state_d1) then
                    state_wait_cnt <= (others => '0');
                elsif(state_wait_cnt < x"ffff") then 
                 state_wait_cnt <= state_wait_cnt + '1';
                end if;              
          end if;
    end process;

    -- Flash_Command
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            op_flash_cmd_en_keep  <= '0';
        elsif rising_edge(clk_i) then
            if(cur_state /= IDLE_C and cur_state_d1 = IDLE_C) then
                op_flash_cmd_en_keep  <= '0';
            elsif(op_flash_cmd_en_i = '1') then
                op_flash_cmd_en_keep  <= '1';
            end if;
        end if;
    end process;

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
             op_flash_cmd <= (others => '0');
        elsif rising_edge(clk_i) then
            if(op_flash_cmd_en_i = '1') then
                op_flash_cmd <= op_flash_cmd_i;
            end if;
        end if;
    end process;

    ------------------------------------------------------
    -- Flash_RdData
    ------------------------------------------------------
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            data_read <= '0'; 
	    elsif rising_edge(clk_i) then
            if(cur_state = PRE_RD_PARA_C or cur_state = PRE_UC_RD_PARA_C) then 
		    	data_read <= '1';
		    else
		    	data_read <= '0'; 
		    end if;
    	end if;
    end process;

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
		      data_burstcount_r <= (others => '0');
	    elsif rising_edge(clk_i) then
            case cur_state is
                when PRE_RD_PARA_C     => 
					    if((rd_flash_num - rd_flash_cnt) >= '0' & x"0008") then
						    data_burstcount_r <= ("000" & x"0008");
						else
						    data_burstcount_r <= rd_flash_num - rd_flash_cnt;
						end if;
                when PRE_UC_RD_PARA_C  => 
					    data_burstcount_r <= ("000" & x"0008");
                when others            => 
					     data_burstcount_r <= ("000" & x"0001");
            end case;    
		  end if;
    end process;
    data_burstcount   <= data_burstcount_r(3 downto 0); 

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            rd_ufm_data <= (others => '0');
        elsif rising_edge(clk_i) then
            if(cur_state = UC_RD_PARA_C and data_readdatavalid = '1') then
                rd_ufm_data <= rd_ufm_data(223 downto 0) & data_readdata;
            else
            end if;
        end if;
    end process;   
    rd_ufm_data_o <= rd_ufm_data;

	process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            rw_flash_frame_done <= "00";
        elsif rising_edge(clk_i) then
            if(cur_state = PROC_DONE and state_wait_cnt >= 30 and cur_state = cur_state_d1) then
                rw_flash_frame_done <= "10";
            elsif(cur_state = WR_DATA_FAILED) then
                rw_flash_frame_done <= "11";
			else
                rw_flash_frame_done <= "00"; 
            end if;
        end if;
    end process;   

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            rd_para_done_en <= '0';
        elsif rising_edge(clk_i) then
            if(cur_state = ENB_WP_C) then    -- repeat read flash
                rd_para_done_en <= '0';
            elsif(cur_state = RD_PARA_DONE) then
                rd_para_done_en <= '1';
            else
            end if;
        end if;
    end process;    

	process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            inburst_rd_cnt <= (others => '0');
        elsif rising_edge(clk_i) then  
            if (cur_state = PRE_UC_RD_PARA_C or cur_state = PRE_RD_PARA_C) then
		        inburst_rd_cnt <= (others => '0');
		    elsif(inburst_rd_cnt < inburst_rd_num and (cur_state = UC_RD_PARA_C or cur_state = RD_PARA_C) and data_readdatavalid = '1') then
	            inburst_rd_cnt <= inburst_rd_cnt + '1';
	        end if;
	    end if;
    end process;	  
    
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
		      inburst_rd_num_r <= (others => '0');
	    elsif rising_edge(clk_i) then
            if(cur_state = PRE_RD_PARA_C) then
                if((rd_flash_num - rd_flash_cnt) >= '0' & x"0008") then
                    inburst_rd_num_r <= ("000" & x"0008");
                else
                    inburst_rd_num_r <= rd_flash_num - rd_flash_cnt;
                end if;
            elsif(cur_state = PRE_UC_RD_PARA_C) then
                inburst_rd_num_r <= ("000" & x"0008");
            else
                inburst_rd_num_r <= inburst_rd_num_r;
    	    end if;
	    end if;
    end process;
    inburst_rd_num <= inburst_rd_num_r(3 downto 0);
	  
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            rd_flash_cnt <= (others => '0');
        elsif rising_edge(clk_i) then  
            if((rd_flash_cnt + inburst_rd_num) >= rd_flash_num and cur_state = RD_PARA_C and inburst_rd_cnt >= (inburst_rd_num - '1')) then
                rd_flash_cnt <= (others => '0');
            elsif(inburst_rd_cnt >= (inburst_rd_num - '1') and cur_state = RD_PARA_C) then
                rd_flash_cnt <= rd_flash_cnt + inburst_rd_num;
            end if;
        end if;
    end process;

    rd_flash_addr <= rd_flash_cnt + inburst_rd_cnt;
    rd_flash_num  <= FLASH_MAX_ADDR;    


	 
    wr_reg_ram_en        <= '1' when (rd_flash_addr >= 0               and rd_flash_addr < MEMX_FST_AD_C   and data_readdatavalid = '1') else '0';
    wr_memx_ram_en       <= '1' when (rd_flash_addr >= MEMX_FST_AD_C   and rd_flash_addr < MEMY_FST_AD_C   and data_readdatavalid = '1') else '0';
    wr_memy_ram_en       <= '1' when (rd_flash_addr >= MEMY_FST_AD_C   and rd_flash_addr < APDS_FST_AD_C   and data_readdatavalid = '1') else '0';
    wr_as_ram_en         <= '1' when (rd_flash_addr >= APDS_FST_AD_C   and rd_flash_addr < APDv_FST_AD_C   and data_readdatavalid = '1') else '0';
    wr_av_ram_en         <= '1' when (rd_flash_addr >= APDv_FST_AD_C   and rd_flash_addr < GRAYC_FST_AD_C  and data_readdatavalid = '1') else '0';
    wr_gc_ram_en         <= '1' when (rd_flash_addr >= GRAYC_FST_AD_C  and rd_flash_addr < CURVEC_FST_AD_C and data_readdatavalid = '1') else '0';
    wr_cc_ram_en         <= '1' when (rd_flash_addr >= CURVEC_FST_AD_C and rd_flash_addr < APDDLY_FST_AD_C and data_readdatavalid = '1') else '0';
    wr_ApdDly_ram_en     <= '1' when (rd_flash_addr >= APDDLY_FST_AD_C and rd_flash_addr < CAPAV_FST_AD_C  and data_readdatavalid = '1') else '0';
    wr_capav_ram_en      <= '1' when (rd_flash_addr >= CAPAV_FST_AD_C  and rd_flash_addr < FLASH_MAX_ADDR  and data_readdatavalid = '1') else '0';

	wr_reg_ram_data      <= data_readdata when (rd_flash_addr >= 0               and rd_flash_addr < MEMX_FST_AD_C   and data_readdatavalid = '1') else (others => '0');
	wr_memx_ram_data     <= data_readdata when (rd_flash_addr >= MEMX_FST_AD_C   and rd_flash_addr < MEMY_FST_AD_C   and data_readdatavalid = '1') else (others => '0');
	wr_memy_ram_data     <= data_readdata when (rd_flash_addr >= MEMY_FST_AD_C   and rd_flash_addr < APDS_FST_AD_C   and data_readdatavalid = '1') else (others => '0');
	wr_as_ram_data       <= data_readdata when (rd_flash_addr >= APDS_FST_AD_C   and rd_flash_addr < APDv_FST_AD_C   and data_readdatavalid = '1') else (others => '0');
	wr_av_ram_data       <= data_readdata when (rd_flash_addr >= APDv_FST_AD_C   and rd_flash_addr < GRAYC_FST_AD_C  and data_readdatavalid = '1') else (others => '0');
	wr_gc_ram_data       <= data_readdata when (rd_flash_addr >= GRAYC_FST_AD_C  and rd_flash_addr < CURVEC_FST_AD_C and data_readdatavalid = '1') else (others => '0');
	wr_cc_ram_data       <= data_readdata when (rd_flash_addr >= CURVEC_FST_AD_C and rd_flash_addr < APDDLY_FST_AD_C and data_readdatavalid = '1') else (others => '0');
	wr_ApdDly_ram_data   <= data_readdata when (rd_flash_addr >= APDDLY_FST_AD_C and rd_flash_addr < CAPAV_FST_AD_C  and data_readdatavalid = '1') else (others => '0');
    wr_capav_ram_data	 <= data_readdata when (rd_flash_addr >= CAPAV_FST_AD_C  and rd_flash_addr < FLASH_MAX_ADDR  and data_readdatavalid = '1') else (others => '0');  

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_reg_ram_en_s       <= '0' ;
            wr_reg_ram_data_s     <= (others => '0');
             wr_memx_ram_en_o     <= '0' ;
             wr_memy_ram_en_o     <= '0' ;
             wr_as_ram_en_o       <= '0' ;
             wr_av_ram_en_o       <= '0' ;
             wr_gc_ram_en_o       <= '0' ;
             wr_cc_ram_en_o       <= '0' ;
             wr_ApdDly_ram_en_o   <= '0' ;
             wr_capav_ram_en_o    <= '0' ;
	          wr_memx_ram_data_o   <= (others => '0');
	          wr_memy_ram_data_o   <= (others => '0');
	          wr_as_ram_data_o     <= (others => '0');
	          wr_av_ram_data_o     <= (others => '0');
	          wr_gc_ram_data_o     <= (others => '0');
	          wr_cc_ram_data_o     <= (others => '0');
	          wr_ApdDly_ram_data_o <= (others => '0');  
	          wr_capav_ram_data_o  <= (others => '0');  
         elsif rising_edge(clk_i) then 
             wr_reg_ram_en_s    <= wr_reg_ram_en ;
	          wr_reg_ram_data_s  <= wr_reg_ram_data;
             wr_memx_ram_en_o   <= wr_memx_ram_en ;
             wr_memy_ram_en_o   <= wr_memy_ram_en ;
             wr_as_ram_en_o     <= wr_as_ram_en ;
             wr_av_ram_en_o     <= wr_av_ram_en ;
             wr_gc_ram_en_o     <= wr_gc_ram_en ;
             wr_cc_ram_en_o     <= wr_cc_ram_en ;
             wr_ApdDly_ram_en_o <= wr_ApdDly_ram_en ;
             wr_capav_ram_en_o  <= wr_capav_ram_en ;
	          wr_memx_ram_data_o <= wr_memx_ram_data;
	          wr_memy_ram_data_o <= wr_memy_ram_data;
	          wr_as_ram_data_o   <= wr_as_ram_data;
	          wr_av_ram_data_o   <= wr_av_ram_data;
	          wr_gc_ram_data_o   <= wr_gc_ram_data;
	          wr_cc_ram_data_o   <= wr_cc_ram_data;
	          wr_ApdDly_ram_data_o <= wr_ApdDly_ram_data;  
	          wr_capav_ram_data_o  <= wr_capav_ram_data;  
		  end if;
    end process;
    wr_reg_ram_en_o    <= wr_reg_ram_en_s   ;
    wr_reg_ram_data_o  <= wr_reg_ram_data_s ;

     process (rst_n_i, clk_i) begin
         if (rst_n_i = '0') then
             prsv_s1dportrdata_s    <= (others => '0');
             prsv_w5300siprdata_s   <= (others => '0');
			elsif rising_edge(clk_i) then
             if(wr_reg_ram_en_s = '1') then
				     case wr_reg_ram_addr_s is
					      when "000" & x"0000"  => prsv_w5300siprdata_s <= wr_reg_ram_data_s;
					      when "000" & x"0001"  => sip_dport_en_s <= wr_reg_ram_data_s(31 downto 16); prsv_s1dportrdata_s <= wr_reg_ram_data_s(15 downto 0); 
					      when others => null ;
					  end case;
				 end if;
			end if;
    end process;
	  
    prsv_s1dportrdata_o    <= prsv_s1dportrdata_s;
    prsv_w5300siprdata_o   <= prsv_w5300siprdata_s;
    sip_dport_en_o         <= sip_dport_en_s;

	  
	  process (rst_n_i, clk_i) begin
         if (rst_n_i = '0') then
             wr_reg_ram_addr_s    <= (others => '0');
         elsif rising_edge(clk_i) then 
		       if(cur_state = IDLE_C) then 
				     wr_reg_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= 0   and rd_flash_addr < MEMX_FST_AD_C  and data_readdatavalid = '1') then
	              wr_reg_ram_addr_s <= rd_flash_addr - 0;
	          end if;
	      end if;
	  end process;
	  wr_reg_ram_addr_o <= wr_reg_ram_addr_s;  
	  process (rst_n_i, clk_i) begin
         if (rst_n_i = '0') then
             wr_memx_ram_addr_s    <= (others => '0');
         elsif rising_edge(clk_i) then 
		       if(cur_state = IDLE_C) then 
				     wr_memx_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= MEMX_FST_AD_C  and rd_flash_addr < MEMY_FST_AD_C  and data_readdatavalid = '1') then
	              wr_memx_ram_addr_s <= rd_flash_addr - MEMX_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_memx_ram_addr_o <= wr_memx_ram_addr_s;  
	  process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_memy_ram_addr_s    <= (others => '0');
        elsif rising_edge(clk_i) then  
		       if(cur_state = IDLE_C) then 
				     wr_memy_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= MEMY_FST_AD_C  and rd_flash_addr < APDS_FST_AD_C and data_readdatavalid = '1') then
	              wr_memy_ram_addr_s <= rd_flash_addr - MEMY_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_memy_ram_addr_o <= wr_memy_ram_addr_s;
	  process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_as_ram_addr_s    <= (others => '0');
        elsif rising_edge(clk_i) then  
		       if(cur_state = IDLE_C) then 
				     wr_as_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= APDS_FST_AD_C  and rd_flash_addr < APDv_FST_AD_C and data_readdatavalid = '1') then
	              wr_as_ram_addr_s <= rd_flash_addr - APDS_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_as_ram_addr_o <= wr_as_ram_addr_s;
	  process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_av_ram_addr_s    <= (others => '0');
        elsif rising_edge(clk_i) then  
		       if(cur_state = IDLE_C) then 
				     wr_av_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= APDv_FST_AD_C  and rd_flash_addr < GRAYC_FST_AD_C and data_readdatavalid = '1') then
	              wr_av_ram_addr_s <= rd_flash_addr - APDv_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_av_ram_addr_o <= wr_av_ram_addr_s;
	  process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_gc_ram_addr_s    <= (others => '0');
        elsif rising_edge(clk_i) then  
		       if(cur_state = IDLE_C) then 
				     wr_gc_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= GRAYC_FST_AD_C  and rd_flash_addr < CURVEC_FST_AD_C and data_readdatavalid = '1') then
	              wr_gc_ram_addr_s <= rd_flash_addr - GRAYC_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_gc_ram_addr_o <= wr_gc_ram_addr_s;
	  process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_cc_ram_addr_s    <= (others => '0');
        elsif rising_edge(clk_i) then  
		       if(cur_state = IDLE_C) then 
				     wr_cc_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= CURVEC_FST_AD_C and rd_flash_addr < APDDLY_FST_AD_C and data_readdatavalid = '1') then
	              wr_cc_ram_addr_s <= rd_flash_addr - CURVEC_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_cc_ram_addr_o <= wr_cc_ram_addr_s;
	  process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_apddly_ram_addr_s    <= (others => '0');
        elsif rising_edge(clk_i) then  
		       if(cur_state = IDLE_C) then 
				     wr_apddly_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= APDDLY_FST_AD_C and rd_flash_addr < CAPAV_FST_AD_C and data_readdatavalid = '1') then
	              wr_apddly_ram_addr_s <= rd_flash_addr - APDDLY_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_apddly_ram_addr_o <= wr_apddly_ram_addr_s;
	  process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_capav_ram_addr_s    <= (others => '0');
        elsif rising_edge(clk_i) then  
		       if(cur_state = IDLE_C) then 
				     wr_capav_ram_addr_s    <= (others => '0');
             elsif(rd_flash_addr >= CAPAV_FST_AD_C and rd_flash_addr < FLASH_MAX_ADDR and data_readdatavalid = '1') then
	              wr_capav_ram_addr_s <= rd_flash_addr - CAPAV_FST_AD_C;
	          end if;
	      end if;
	  end process;
	  wr_capav_ram_addr_o <= wr_capav_ram_addr_s;
	      
    ------------------------------------------------------------------------------------------
    -- Control_Flash(Status / Control_Reg)
    ------------------------------------------------------------------------------------------
    csr_read  <= '1' when (cur_state = RD_STATUS_C) else '0';   -- Read_Address = "00"
    csr_write <= '1' when (cur_state = DIS_WP_C or cur_state = ERASE_C or cur_state = ENB_WP_C)    else '0';
    csr_addr  <= '1' when (cur_state = DIS_WP_C or cur_state = ERASE_C or cur_state = ENB_WP_C)    else '0';

    process (cur_state) begin
        case cur_state is
            when DIS_WP_C     => csr_writedata <= x"f00fffff";
            when ERASE_C      => csr_writedata <= x"f0" & '0' & op_flash_cmd(10 downto 8) & x"fffff";
            --when DIS_WP_C     => csr_writedata <= x"f0700000";
            --when ENB_WP_C     => csr_writedata <= x"ff800000";
            when ENB_WP_C     => csr_writedata <= x"ff8fffff";
            when others       => csr_writedata <= (others => '0');
        end case;
    end process;      
    
    ----------------------------------------------------------
    -- Flash_WrData
    ----------------------------------------------------------
    -- Rd_FifoData -> Flash_WrData
    ds_cfg_fifo_rd_req <= '1' when (cur_state = PRE_WR_DATA_C and cur_state /= cur_state_d1) else '0';

    -- WrData_Valid
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_flash_frame_req_keep  <= '0';
        elsif rising_edge(clk_i) then
		    if(cur_state /= IDLE_C and cur_state_d1 = IDLE_C) then
                wr_flash_frame_req_keep  <= '0';
			elsif(wr_flash_frame_req = '1') then
                wr_flash_frame_req_keep  <= '1';
			end if;
		end if;
    end process;
    
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_flash_frame_len_lock  <= (others => '0');
            wr_flash_frame_addr_lock <= (others => '0');
        elsif rising_edge(clk_i) then
            if(wr_flash_frame_req = '1') then
                wr_flash_frame_len_lock  <= ('0' & wr_flash_frame_len(15 downto 1));
                wr_flash_frame_addr_lock <= wr_flash_frame_addr;
            end if;
        end if; 
    end process;

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            wr_word_cnt <= (others => '0');
        elsif rising_edge(clk_i) then
            if(cur_state = IDLE_C) then
                wr_word_cnt <= (others => '0');
            elsif(cur_state = WR_OK_JUDGE and csr_readdata(3) = '1' and wr_word_cnt < (wr_flash_frame_len_lock - 1)) then
                wr_word_cnt <= wr_word_cnt + 1;
            end if;
        end if;
    end process;

    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            data_write <= '0'; 
		elsif rising_edge(clk_i) then
            if((cur_state = WR_DATA_C and cur_state /= cur_state_d1) or (cur_state = WR_DATA_C and data_waitrequest = '1')) then 
			    data_write <= '1';
			else
			    data_write <= '0'; 
			end if;
		end if;
	end process;
    
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            data_writedata <= (others => '0'); 
        elsif rising_edge(clk_i) then
            if(cur_state = WR_DATA_C) then 
                data_writedata <= ds_cfg_fifo_rd_data;
            else
                data_writedata <= (others => '0'); 
			end if;
		end if;
	end process;

    ----------------------------------------------------------
    -- Flash_RdData
    ----------------------------------------------------------
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            uc_data_addr <= (others => '0'); 
        elsif rising_edge(clk_i) then
            if(op_flash_cmd_en_i = '1' and op_flash_cmd_i(31 downto 24) = x"BC") then 
                uc_data_addr <= op_flash_cmd_i(10 downto 0) & op_flash_cmd_i(23 downto 16);
            else
            end if;
        end if;
    end process;

    -- Wr/Rd_Addr
  	process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            data_addr <= (others => '0'); 
		elsif rising_edge(clk_i) then
            case cur_state is
                when WR_DATA_C         => data_addr <= wr_flash_frame_addr_lock + wr_word_cnt;
                when PRE_RD_PARA_C     => data_addr <= rd_flash_cnt;
                when PRE_UC_RD_PARA_C  => data_addr <= uc_data_addr;
                when others            => data_addr <= (others => '0');
            end case;
        end if; 
    end process;		  
    data_addr_r <= data_addr(17 downto 0);
    
    process (rst_n_i, clk_i) begin
        if (rst_n_i = '0') then
            initial_done_o <= '0';
        elsif rising_edge(clk_i) then
            --if(cur_state = RD_PARA_DONE or test_mode_i = '1') then
            if(cur_state = RD_PARA_DONE) then
                initial_done_o <= '1';
            end if;
        end if;
    end process;    

    ---------------------------------------------
    -- End_Coding
    ---------------------------------------------
end arch_ocf_ctrl;