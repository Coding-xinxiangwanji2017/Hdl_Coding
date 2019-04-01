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
-- ��    Ȩ  :  ZVISION
-- �ļ�����  :  M_RomCtrl.vhd
-- ��    ��  :  zhang wenjun
-- ��    ��  :  wenjun.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2018/05/17
-- ���ܼ���  :  Ocntrol Memory Data
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

----------------------------------------
-- library Xilinx
----------------------------------------
--library unisim;
--use unisim.vcomponents.all;

----------------------------------------
-- library Altera
----------------------------------------
--library altera_mf;
--use altera_mf.all;

----------------------------------------
-- library work
----------------------------------------

entity M_RomCtrl is
    generic (
        PrSl_Sim_c                      : integer := 1                          -- Simulation
    );
    port (
        --------------------------------
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
        
        --------------------------------
        -- Rom Start Trig
        --------------------------------
        test_mode_i                     : in  std_logic;
        CpSv_vxData_i                   : in  std_logic_vector(11 downto 0);
        CpSv_vyData_i                   : in  std_logic_vector(11 downto 0);
        CpSv_Mems_noscan_i              : in  std_logic;

        CpSl_FrameEndTrig_o             : out std_logic;                        -- Frame End Trig
        CpSl_MemoryAddTrig_i            : in  std_logic;                        -- Memory Add Trig     
        CpSl_MemoryRdTrig_i             : in  std_logic;                        -- Memory start Trig
        
        --------------------------------
        -- AD_link Cap Trig
        --------------------------------
	send_trig_point_num_i           : in  std_logic_vector(15 downto 0);
        send_trig_close_i               : in  std_logic; 
        CpSl_CapTrig_o                  : out std_logic;                        -- ADLink Capture Trig
		  
        --------------------------------
        -- Head/Ench Number/LdNum
        --------------------------------
        CpSv_EochCnt_i                  : in  std_logic_vector(1 downto 0);     -- Ench Cnt
        CpSl_UdpTest_i                  : in  std_logic;                        -- UDP Test Module
        CpSv_LdNum_i                    : in  std_logic_vector(1 downto 0);     -- LD_Num
        
        --------------------------------
        -- TrigCycle
        --------------------------------
        CpSl_UdpCycleEnd_i              : in  std_logic;                        -- UDP Cycle End
        
        --------------------------------
        -- LTC2324 Data
        --------------------------------
        CpSl_EndTrig_i                  : in  std_logic;                        -- LTC2324 Valid
        CpSv_MemxData_i                 : in  std_logic_vector(15 downto 0);    -- Mem x Data 
        CpSv_MemyData_i                 : in  std_logic_vector(15 downto 0);    -- Mem Y Data
        CpSv_MemTemp_i                  : in  std_logic_vector(15 downto 0);    -- Mem Temp

        --------------------------------
        -- TDC_GPX2 Data
        --------------------------------
        -- TDC_Wave/Gray
        CpSl_EchoDVld_i                 : in  std_logic;                        -- TDC_Data_Valid
        CpSv_EchoWave_i                 : in  std_logic_vector(18 downto 0);    -- TDC_Data_Wave
        CpSv_EchoGray_i                 : in  std_logic_vector(15 downto 0);    -- TDC_Data_Gray
        PrSv_EchoPW20_i                 : in  std_logic_vector(18 downto 0);

        CpSl_ApdNumVld_i                : in  std_logic;                        -- ADP_NumVld
        CpSv_ApdNum_i                   : in  std_logic_vector( 6 downto 0);    -- ADP_Num   
        
        --------------------------------
        -- Group_Rd
        --------------------------------
        CpSl_GroupRd_i                  : in  std_logic;                        -- Group_Rd
        CpSl_GroupRdData_o              : out std_logic_vector(13 downto 0);    -- Group_RdData
        
        -- Debug_TdcData
        CpSl_TdcDataVld_i               : in  std_logic;                        -- TDC_Recv_Data Valid
        CpSv_TdcData_i                  : in  std_logic_vector(15 downto 0);    -- TDC Recv Data1
        CpSv_Tdc2Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data2
        CpSv_Tdc3Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data3
        CpSv_Tdc4Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data4
        CpSv_Tdc5Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data5
        CpSv_Tdc6Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data6
        CpSv_Tdc7Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data7
        CpSv_Tdc8Data_i                 : in  std_logic_vector(15 downto 0);    -- TDC Recv Data8
                  
        --------------------------------                
        -- Test_MemX|Y
        --------------------------------
        CpSl_MemXYVld_o                 : out std_logic;                        -- Memxy_Valid

        --------------------------------
        -- MEMSCAN X/Y Data
        --------------------------------
        CpSl_MemTrig_o                  : out std_logic;                        -- Memscan Trig
        CpSv_MemXData_o                 : out std_logic_vector(11 downto 0);    -- Memscan_X Data       
        CpSv_MemYData_o                 : out std_logic_vector(11 downto 0);    -- Memscan_Y Data

        --------------------------------
        -- Fifo Interface
        --------------------------------
        CpSl_RdFifo_i                   : in  std_logic;                        -- Fifo Read
        CpSl_FifoDataVld_o              : out std_logic;                        -- Fifo Data Valid
        CpSv_FifoData_o                 : out std_logic_vector(31 downto 0);    -- Fifo Data
		  
		  
        tdc_fifo_full_detect              : out std_logic;                        -- Fifo Data Valid
        apd_slt_fifo_full_detect              : out std_logic;                        -- Fifo Data Valid
        vxvy_fifo_full_detect              : out std_logic;                        -- Fifo Data Valid
        PrSl_FifoFull_s_detect              : out std_logic;                       -- Fifo Data Valid

		  --------------------------------
		  -- 5300ctrl
		  --------------------------------
        CpSv_pck_lenth_i                : in  std_logic_vector(15 downto 0);    -- CpSv_pck_lenth
		  CpSl_start_send_o               : out std_logic                    ;
		  
 	     wr_memx_ram_en_i                : in std_logic;
		  wr_memx_ram_data_i              : in std_logic_vector(31 downto 0);
		  wr_memx_ram_addr_i              : in std_logic_vector(18 downto 0);		  
 	     wr_memy_ram_en_i                : in std_logic;
		  wr_memy_ram_data_i              : in std_logic_vector(31 downto 0);
		  wr_memy_ram_addr_i              : in std_logic_vector(18 downto 0)
		  

    );
end M_RomCtrl;

architecture arch_M_RomCtrl of M_RomCtrl is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
 --   constant PrSv_MemsCnt_c             : std_logic_vector(14 downto 0) := "100" & x"E1F"; -- 19999
    constant PrSv_MemsCnt_c             : std_logic_vector(14 downto 0) := "010" & x"70F"; -- 9999

    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    -- Memscan_X
--    component M_Memx is
--    port (
--        address		                    : IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
--        clock		                    : IN  STD_LOGIC := '1';
--        q                               : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
--	);
--    end component;

    component M_MemFifo is
    port (
	    clock                           : IN  STD_LOGIC ;
	    data                            : IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
	    rdreq                           : IN  STD_LOGIC ;
	    wrreq                           : IN  STD_LOGIC ;
	    empty                           : OUT STD_LOGIC ;
	    full                            : OUT STD_LOGIC ;
	    q                               : OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
    end component;
	 
    component dpram_mem IS
    PORT(
		   clock		: IN STD_LOGIC  := '1';
		   data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		   rdaddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		   wraddress		: IN STD_LOGIC_VECTOR (12 DOWNTO 0);
		   wren		: IN STD_LOGIC  := '0';
	 	   q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    END component;
    -- Memscan_Y
    component M_MemY is
    port (
        address		                    : IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		                    : IN  STD_LOGIC := '1';
		q		                        : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
    END component;
	 
	component sync_fifo_16x64 IS
	PORT
	(
		clock		: IN STD_LOGIC ;
		data		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdreq		: IN STD_LOGIC ;
		wrreq		: IN STD_LOGIC ;
		empty		: OUT STD_LOGIC ;
		full		: OUT STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
   END component;

    -- Fifo
    component M_CombDataFifo is
    port (
		clock		                    : IN  STD_LOGIC ;
		data		                    : IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdreq		                    : IN  STD_LOGIC ;
		wrreq		                    : IN  STD_LOGIC ;
		empty		                    : OUT STD_LOGIC ;
		full		                    : OUT STD_LOGIC ;
		q		                       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
		usedw		                    : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
	);
    end component;

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    -- Memory X/Y
    signal PrSv_RomAddr_s               : std_logic_vector(13 downto 0);        -- Rom Address
    signal PrSv_MemXData_s              : std_logic_vector(15 downto 0);        -- MemX Data
    signal PrSv_MemYData_s              : std_logic_vector(15 downto 0);        -- MemY Data
    
    -- Recv_Data
    signal PrSl_TdcVldDly1Clk_s         : std_logic;                            -- TDC Data Valid Delay 1Clk       
    signal PrSl_TdcVldTrig_s            : std_logic;                            -- TDC Data Valid Trig
    signal PrSl_EndTrigDly1_s           : std_logic;                            -- CpSl_UdpCycleEnd_i 1 Clk
    signal PrSl_EndTrigDly2_s           : std_logic;                            -- CpSl_UdpCycleEnd_i 2 Clk
    signal PrSl_CapEndTrig_s            : std_logic;                            -- ADC Capture End
    
    -- Test_Data
    signal PrSl_TdcVldTrigDly1_s        : std_logic;
    signal PrSv_TdcTestD1_s             : std_logic_vector( 18 downto 0);          
    signal PrSv_TdcTestD2_s             : std_logic_vector( 18 downto 0);          
    signal PrSv_TdcTestD3_s             : std_logic_vector( 18 downto 0);
    
    signal PrSv_MemsData_s              : std_logic_vector( 31 downto 0);       -- MemScan_Data
    signal PrSv_TdcTest_s               : std_logic_vector( 95 downto 0);       -- TDC_TestData
    signal PrSv_Eoch1Data_s             : std_logic_vector( 63 downto 0);       -- Eoch 1 Data
    signal PrSv_Eoch2Data_s             : std_logic_vector( 95 downto 0);       -- Eoch 2 Data
    signal PrSv_Eoch3Data_s             : std_logic_vector(127 downto 0);       -- Eoch 3 Data

    -- CombFifo
    signal PrSv_FifoWrNum_s             : std_logic_vector(  3 downto 0);       -- Write Fifo Num
    signal PrSv_FifoWrNum_s_d           : std_logic_vector(  3 downto 0);       -- Write Fifo Num
    signal PrSv_FifoWrCnt_s             : std_logic_vector(  3 downto 0);       -- Write Fifo Cnt
    signal PrSv_FifoWrData_s            : std_logic_vector( 31 downto 0);       -- Combine Fifo Write Data
    signal PrSl_FifoWr_s                : std_logic;                            -- Combine Fifo Write Trig
    signal PrSl_FifoWrDly1_s            : std_logic;                            -- Combine Fifo Write Trig Dly1
    signal PrSl_RdFifo_s                : std_logic;                            -- Combone Fifo Read Trig
    signal PrSv_FifoData_s              : std_logic_vector( 31 downto 0);       -- Combine Fifo Read Data
    signal PrSl_FifoEmpty_s             : std_logic;                            -- Combine Fifo Empty
    signal PrSl_FifoFull_s              : std_logic;                            -- Combine Fifo Full 
    signal PrSv_Fifousedw_s             : std_logic_vector( 11 downto 0);       -- Combine Fifo Read Data

    -- RdFifoState
    signal PrSv_RdFifostate_s           : std_logic_vector(  2 downto 0);       -- Rd Fifo State
    signal vxvy_fifo_q                  : std_logic_vector( 31 downto 0);       
    signal tdc_fifo_q                   : std_logic_vector( 31 downto 0);       
    signal apd_slt_fifo_q                   : std_logic_vector( 31 downto 0);       
    signal ld_cnt                       : std_logic_vector(  1 downto 0);       -- Rd Fifo State
    signal apd_slt_ld_cnt                       : std_logic_vector(  1 downto 0);       -- Rd Fifo State
    signal tdc_fifo_data                : std_logic_vector( 31 downto 0);       
    signal apd_slt_fifo_data                : std_logic_vector( 31 downto 0);       
    signal vxvy_fifo_data               : std_logic_vector( 31 downto 0);       

	 signal CpSl_MemoryAddTrig_d1        : std_logic;
	 signal CpSl_MemoryAddTrig_d2        : std_logic;
	 signal CpSl_MemoryAddTrig_d3        : std_logic;
	 
	 signal PrSl_MemWrTrig_s            : std_logic;
	 signal CpSl_MemTrig_s        : std_logic;
	 signal tdc_fifo_wrreq        : std_logic;
	 signal tdc_fifo_rdreq        : std_logic;
	 signal tdc_fifo_full         : std_logic;
	 signal tdc_fifo_empty        : std_logic;
	 signal tdc_fifo_rdreq_d1     : std_logic;
	 signal tdc_fifo_rdreq_d2     : std_logic;
	 signal tdc_fifo_rdreq_d3     : std_logic;
	 signal apd_slt_fifo_wrreq        : std_logic;
	 signal apd_slt_fifo_rdreq        : std_logic;
	 signal apd_slt_fifo_full         : std_logic;
	 signal apd_slt_fifo_empty        : std_logic;
	 signal apd_slt_fifo_rdreq_d1     : std_logic;
	 signal apd_slt_fifo_rdreq_d2     : std_logic;
	 signal apd_slt_fifo_rdreq_d3     : std_logic;
	 signal vxvy_fifo_wrreq       : std_logic;
	 signal vxvy_fifo_rdreq       : std_logic;
	 signal vxvy_fifo_full        : std_logic;
	 signal vxvy_fifo_empty       : std_logic;
	 signal vxvy_fifo_rdreq_d1    : std_logic;
	 signal vxvy_fifo_rdreq_d2    : std_logic;
	 signal vxvy_fifo_rdreq_d3    : std_logic;
    signal trans_vxvy_data_ok    : std_logic;
    signal trans_vxvy_data_ok_d  : std_logic;
    signal trans_tdc_data_ok     : std_logic;
    signal trans_apd_slt_data_ok     : std_logic;
    signal trans_tdc_data_ok_d   : std_logic;
    signal joint_tdc_vxvy_en     : std_logic;
    signal CpSl_EndTrig_d1       : std_logic;
    signal CpSl_EndTrig_d2       : std_logic;
    signal CpSl_EndTrig_d3       : std_logic;
    signal CpSl_EchoDVld_s       : std_logic;
	
	-- Group_Rd
    signal PrSl_GroupRd_s        : std_logic;
    signal PrSl_GroupRdData_s    : STD_LOGIC_VECTOR (13 DOWNTO 0);
	
	-- CapTrig
    signal CapTrig_cnt           : std_logic_vector(15 downto 0);
	 
begin
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
    U_M_MemFifo_0 : M_MemFifo
    port map (
	    clock                           => CpSl_Clk_i                           , -- IN  STD_LOGIC ;
	    data                            => PrSv_RomAddr_s                       , -- IN  STD_LOGIC_VECTOR (13 DOWNTO 0);
	    rdreq                           => CpSl_GroupRd_i                       , -- IN  STD_LOGIC ;
	    wrreq                           => PrSl_MemWrTrig_s                     , -- IN  STD_LOGIC ;
	    empty                           => open                                 , -- OUT STD_LOGIC ;
	    full                            => open                                 , -- OUT STD_LOGIC ;
	    q                               => PrSl_GroupRdData_s                     -- OUT STD_LOGIC_VECTOR (13 DOWNTO 0)
	);
    
    -- Delay CpSl_GroupRd_i
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_GroupRd_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_GroupRd_s <= CpSl_GroupRd_i;
        end if;
    end process;
    
    -- CpSl_GroupRdData_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_GroupRdData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_GroupRd_s = '1') then 
                CpSl_GroupRdData_o <= PrSl_GroupRdData_s;    
            else -- hold
            end if;
        end if;
    end process;
    
        
    Real_Memscan : if (PrSl_Sim_c = 1) generate
    -- Memscan_X
    U_M_Memx_0 : dpram_mem
    port map (
        rdaddress	                    => PrSv_RomAddr_s,                      -- IN STD_LOGIC_VECTOR (13 DOWNTO 0);  
        clock		                    => CpSl_Clk_i,                          -- IN STD_LOGIC  := '1';               
        q                             => PrSv_MemXData_s,                     -- OUT STD_LOGIC_VECTOR (15 DOWNTO 0)  
		  wren                          => wr_memx_ram_en_i,
		  wraddress                     => wr_memx_ram_addr_i(12 downto 0),
		  data                          => wr_memx_ram_data_i
	);

    -- Memscan_Y
    U_M_Memy_0 : dpram_mem
    port map (
        rdaddress	                    => PrSv_RomAddr_s,                      -- IN STD_LOGIC_VECTOR (13 DOWNTO 0);  
        clock		                    => CpSl_Clk_i,                          -- IN STD_LOGIC  := '1';               
        q                             => PrSv_MemyData_s,                     -- OUT STD_LOGIC_VECTOR (15 DOWNTO 0)  
		  wren                          => wr_memy_ram_en_i,
		  wraddress                     => wr_memy_ram_addr_i(12 downto 0),
		  data                          => wr_memy_ram_data_i
	);
    end generate Real_Memscan;
    
    Sim_Memscan : if (PrSl_Sim_c = 0) generate
        PrSv_MemXData_s <= x"A5B4";
        PrSv_MemYData_s <= x"B4A5";
    end generate Sim_Memscan;

	
	tdc_fifo_u : sync_fifo_16x64 
	PORT map
	(
		clock	      => 	CpSl_Clk_i,                       --: IN STD_LOGIC ;
		wrreq	      => 	tdc_fifo_wrreq,                  --: IN STD_LOGIC ;
		data	      => 	tdc_fifo_data,--: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		full	      => 	tdc_fifo_full,                   --: OUT STD_LOGIC ;
		rdreq	      => 	tdc_fifo_rdreq,                  --: IN STD_LOGIC ;
		q		      =>    tdc_fifo_q,                      --: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		empty	      => 	tdc_fifo_empty                   --: OUT STD_LOGIC ;
	);
	apd_slt_fifo_u : sync_fifo_16x64 
	PORT map
	(
		clock	      => 	CpSl_Clk_i,                       --: IN STD_LOGIC ;
		wrreq	      => 	apd_slt_fifo_wrreq,                  --: IN STD_LOGIC ;
		data	      => 	apd_slt_fifo_data,--: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		full	      => 	apd_slt_fifo_full,                   --: OUT STD_LOGIC ;
		rdreq	      => 	apd_slt_fifo_rdreq,                  --: IN STD_LOGIC ;
		q		      =>    apd_slt_fifo_q,                      --: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		empty	      => 	apd_slt_fifo_empty                   --: OUT STD_LOGIC ;
	);

	
	vxvy_fifo_u : sync_fifo_16x64 
	PORT map
	(
		clock	      => 	CpSl_Clk_i,                       --: IN STD_LOGIC ;
		wrreq	      => 	vxvy_fifo_wrreq,                  --: IN STD_LOGIC ;
		data	      => 	vxvy_fifo_data,--: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		full	      => 	vxvy_fifo_full,                   --: OUT STD_LOGIC ;
		rdreq	      => 	vxvy_fifo_rdreq,                  --: IN STD_LOGIC ;
		q		      =>    vxvy_fifo_q,                      --: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		empty	      => 	vxvy_fifo_empty                   --: OUT STD_LOGIC ;
	);

    -- Fifo
    U_M_CombDataFifo_0 : M_CombDataFifo
    port map (
		clock		                    => CpSl_Clk_i,                          -- IN  STD_LOGIC ;
		data		                    => PrSv_FifoWrData_s,                   -- IN  STD_LOGIC_VECTOR (31 DOWNTO 0);
		rdreq		                    => PrSl_RdFifo_s,                       -- IN  STD_LOGIC ;
		wrreq		                    => PrSl_FifoWr_s,                       -- IN  STD_LOGIC ;
		empty		                    => PrSl_FifoEmpty_s,                    -- OUT STD_LOGIC ;
		full		                    => PrSl_FifoFull_s,                     -- OUT STD_LOGIC ;
		q		                       => PrSv_FifoData_s,                     -- OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
		usedw                        => PrSv_Fifousedw_s
	);                                             
	--tdc_fifo_data   <= CpSv_EchoWave_i & CpSv_EchoGray_i(12 downto 0);
	apd_slt_fifo_data   <= '0' & x"000000" & CpSv_ApdNum_i(6 downto 0);
	vxvy_fifo_data  <= CpSv_MemxData_i & CpSv_MemyData_i;
	apd_slt_fifo_wrreq  <= '1' when (CpSl_ApdNumVld_i = '1' and apd_slt_fifo_full  = '0') else '0';

    process(CpSl_Rst_iN,CpSl_Clk_i) begin
       if (CpSl_Rst_iN = '0') then
		     tdc_fifo_data    <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if(test_mode_i = '1') then
                tdc_fifo_data   <= '0' & x"000" & PrSv_EchoPW20_i;
            else
                tdc_fifo_data   <= CpSv_EchoWave_i & CpSv_EchoGray_i(12 downto 0);
            end if;
        end if;
    end process;	
	
	tdc_fifo_wrreq  <= '1' when (CpSl_EchoDVld_s = '1' and tdc_fifo_full  = '0') else '0';
	process(CpSl_Rst_iN,CpSl_Clk_i) begin
       if (CpSl_Rst_iN = '0') then
		     CpSl_EchoDVld_s    <= '0';
		 elsif rising_edge(CpSl_Clk_i) then		
		     CpSl_EchoDVld_s   <= CpSl_EchoDVld_i;
	    end if;
	end process;
				
	process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      CpSl_start_send_o    <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(PrSv_Fifousedw_s > CpSv_pck_lenth_i(14 downto 2)) then
				    CpSl_start_send_o    <= '1';
				else
				    CpSl_start_send_o    <= '0';
			   end if;
		  end if;
	end process;
		  
	process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      tdc_fifo_full_detect    <= '0';
		      apd_slt_fifo_full_detect    <= '0';
		      vxvy_fifo_full_detect    <= '0';
		      PrSl_FifoFull_s_detect    <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(tdc_fifo_full = '1') then
		          tdc_fifo_full_detect    <= '1';
				end if;
		      if(apd_slt_fifo_full = '1') then
		          apd_slt_fifo_full_detect    <= '1';
				end if;
		      if(vxvy_fifo_full = '1') then
		          vxvy_fifo_full_detect    <= '1';
				end if;
		      if(PrSl_FifoFull_s = '1') then
		          PrSl_FifoFull_s_detect    <= '1';
				end if;
		  end if;
    end process;
				
				
				
	process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      tdc_fifo_rdreq_d1    <= '0';
		      tdc_fifo_rdreq_d2    <= '0';
		      tdc_fifo_rdreq_d3    <= '0';
		      apd_slt_fifo_rdreq_d1    <= '0';
		      apd_slt_fifo_rdreq_d2    <= '0';
		      apd_slt_fifo_rdreq_d3    <= '0';
				trans_tdc_data_ok_d  <= '0';
				trans_vxvy_data_ok_d <= '0';
				PrSv_FifoWrNum_s_d   <= (others => '0');
				CpSl_EndTrig_d1      <= '0';
				CpSl_EndTrig_d2      <= '0';
				CpSl_EndTrig_d3      <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      tdc_fifo_rdreq_d1    <= tdc_fifo_rdreq;
		      tdc_fifo_rdreq_d2    <= tdc_fifo_rdreq_d1;
		      tdc_fifo_rdreq_d3    <= tdc_fifo_rdreq_d2;
		      apd_slt_fifo_rdreq_d1    <= apd_slt_fifo_rdreq;
		      apd_slt_fifo_rdreq_d2    <= apd_slt_fifo_rdreq_d1;
		      apd_slt_fifo_rdreq_d3    <= apd_slt_fifo_rdreq_d2;
				trans_tdc_data_ok_d  <= trans_tdc_data_ok;
				trans_vxvy_data_ok_d <= trans_vxvy_data_ok;
				PrSv_FifoWrNum_s_d   <= PrSv_FifoWrNum_s;
				CpSl_EndTrig_d1      <= CpSl_EndTrig_i;
				CpSl_EndTrig_d2      <= CpSl_EndTrig_d1;
				CpSl_EndTrig_d3      <= CpSl_EndTrig_d2;
		  end if;
	 end process;
    
	 process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            tdc_fifo_rdreq <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(tdc_fifo_empty = '0' and tdc_fifo_rdreq = '0' and tdc_fifo_rdreq_d1 = '0' and trans_tdc_data_ok = '0') then
					 tdc_fifo_rdreq <= '1';
			   else
					 tdc_fifo_rdreq <= '0'; 
			   end if;
		  end if;
	 end process;	 

	 process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            apd_slt_fifo_rdreq <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(apd_slt_fifo_empty = '0' and apd_slt_fifo_rdreq = '0' and apd_slt_fifo_rdreq_d1 = '0' and trans_apd_slt_data_ok = '0') then
					 apd_slt_fifo_rdreq <= '1';
			   else
					 apd_slt_fifo_rdreq <= '0'; 
			   end if;
		  end if;
	 end process;	 

    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      trans_tdc_data_ok <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(PrSv_FifoWrNum_s_d /= x"f" and PrSv_FifoWrNum_s = x"f") then
				    trans_tdc_data_ok <= '0';
				elsif(tdc_fifo_empty = '0' and trans_tdc_data_ok = '0' and ld_cnt = 2) then
		          trans_tdc_data_ok <= '1';
			   end if;
		  end if;
	 end process;
	 
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      trans_apd_slt_data_ok <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(PrSv_FifoWrNum_s_d /= x"f" and PrSv_FifoWrNum_s = x"f") then
				    trans_apd_slt_data_ok <= '0';
				elsif(apd_slt_fifo_empty = '0' and trans_apd_slt_data_ok = '0' and apd_slt_ld_cnt = 2) then
		          trans_apd_slt_data_ok <= '1';
			   end if;
		  end if;
	 end process;
	 

    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      ld_cnt <= "00";
		  elsif rising_edge(CpSl_Clk_i) then
		      if(ld_cnt = 2 and tdc_fifo_rdreq_d1 = '1') then
				    ld_cnt <= "00";
				elsif(tdc_fifo_rdreq_d1 = '1') then
		          ld_cnt <= ld_cnt + '1';
			   end if;
		  end if;
	 end process;

    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      apd_slt_ld_cnt <= "00";
		  elsif rising_edge(CpSl_Clk_i) then
		      if(apd_slt_ld_cnt = 2 and apd_slt_fifo_rdreq_d1 = '1') then
				    apd_slt_ld_cnt <= "00";
				elsif(apd_slt_fifo_rdreq_d1 = '1') then
		          apd_slt_ld_cnt <= apd_slt_ld_cnt + '1';
			   end if;
		  end if;
	 end process;

	 
	 --vxvy fifo ctrl
	 vxvy_fifo_wrreq <= '1' when (CpSl_EndTrig_d3  = '0' and CpSl_EndTrig_d2  = '1' and vxvy_fifo_full = '0') else '0';
	 
	 process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            vxvy_fifo_rdreq <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(vxvy_fifo_empty = '0' and trans_vxvy_data_ok = '0') then
					 vxvy_fifo_rdreq <= '1';
			   else
					 vxvy_fifo_rdreq <= '0'; 
			   end if;
		  end if;
	 end process;
	 
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      vxvy_fifo_rdreq_d1 <= '0';
		      vxvy_fifo_rdreq_d2 <= '0';
		      vxvy_fifo_rdreq_d3 <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      vxvy_fifo_rdreq_d1 <= vxvy_fifo_rdreq;
		      vxvy_fifo_rdreq_d2 <= vxvy_fifo_rdreq_d1;
		      vxvy_fifo_rdreq_d3 <= vxvy_fifo_rdreq_d2;
		  end if;
	 end process;
	 
	 --PrSv_MemsData_s
	 process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      PrSv_MemsData_s <= (others => '0');
		  elsif rising_edge(CpSl_Clk_i) then
		      if(vxvy_fifo_rdreq_d2 = '1') then
		          PrSv_MemsData_s <= vxvy_fifo_q;
            end if;
		  end if;
	 end process;

    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
		      trans_vxvy_data_ok <= '0';
		  elsif rising_edge(CpSl_Clk_i) then
		      if(PrSv_FifoWrNum_s_d /= x"f" and PrSv_FifoWrNum_s = x"f") then
				    trans_vxvy_data_ok <= '0';
				elsif(vxvy_fifo_empty = '0' and trans_vxvy_data_ok = '0') then
		          trans_vxvy_data_ok <= '1';
			   end if;
		  end if;
	 end process;
	 
	 
	----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    -- CpSl_MemTrig_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_MemoryAddTrig_d1 <= '0';
            CpSl_MemoryAddTrig_d2 <= '0';
            CpSl_MemoryAddTrig_d3 <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            CpSl_MemoryAddTrig_d1 <= CpSl_MemoryAddTrig_i;
            CpSl_MemoryAddTrig_d2 <= CpSl_MemoryAddTrig_d1;
            CpSl_MemoryAddTrig_d3 <= CpSl_MemoryAddTrig_d2;
		  end if;
	 end process;

    PrSl_MemWrTrig_s <= '1' when (CpSl_MemoryAddTrig_d1 = '0' and CpSl_MemoryAddTrig_i = '1') else '0';
    CpSl_MemTrig_s <= '1' when (CpSl_MemoryAddTrig_d3 = '0' and CpSl_MemoryAddTrig_d2 = '1') else '0';
    CpSl_MemTrig_o <= CpSl_MemTrig_s;

    -- CapTrig_cnt
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CapTrig_cnt <= (others => '1');
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSl_MemTrig_s = '1') then 
                if (PrSv_RomAddr_s = send_trig_point_num_i(13 downto 0) and send_trig_close_i = '0') then 
						  CapTrig_cnt <= (others => '0');
                elsif(CapTrig_cnt <= 2000) then 
                    CapTrig_cnt <= CapTrig_cnt + '1';
					 else
					     CapTrig_cnt <= CapTrig_cnt;
                end if;
            else -- hold
            end if;
        end if; 
    end process;
    
	 CpSl_CapTrig_o <= '1' when (CapTrig_cnt <= 2000)  else '0';

    -- PrSv_RomAddr_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_RomAddr_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSl_MemTrig_s = '1') then
                if (PrSv_RomAddr_s = PrSv_MemsCnt_c) then 
                    PrSv_RomAddr_s <= (others => '0');
                else 
                    PrSv_RomAddr_s <= PrSv_RomAddr_s + '1';
                end if;
            else -- hold
            end if;
        end if; 
    end process;
    
    -- CpSl_MemXYVld_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            CpSl_MemXYVld_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_RomAddr_s = 100) then
                CpSl_MemXYVld_o <= '1'; 
            else 
                CpSl_MemXYVld_o <= '0';
            end if;
        end if;
    end process;
    
    -- CpSl_FrameEndTrig_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_FrameEndTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_RomAddr_s = PrSv_MemsCnt_c) then
                CpSl_FrameEndTrig_o <= '1';
            else 
                CpSl_FrameEndTrig_o <= '0';
            end if;
        end if;
    end process;
   
   -- Memory X/Y Data
   process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_MemXData_o <= (others => '0');
            CpSv_MemYData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if(test_mode_i = '1' and CpSv_Mems_noscan_i = '1') then
				    CpSv_MemXData_o <= CpSv_vxData_i;
				    CpSv_MemYData_o <= CpSv_vyData_i;
				elsif (CpSl_MemoryRdTrig_i = '1' and CpSv_Mems_noscan_i = '0') then 
                CpSv_MemXData_o <= PrSv_MemXData_s(11 downto 0);
                CpSv_MemYData_o <= PrSv_MemYData_s(11 downto 0);
            else -- hold
            end if;
        end if;
    end process;

    -- PrSl_TdcVldDly1Clk_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_TdcVldDly1Clk_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
--            PrSl_TdcVldDly1Clk_s <= CpSl_TdcDataVld_i;
            PrSl_TdcVldDly1Clk_s <= CpSl_EchoDVld_i;
        end if;
    end process;
    
    -- PrSl_TdcVldTrig_s
--    PrSl_TdcVldTrig_s <= '1' when (PrSl_TdcVldDly1Clk_s = '0' and CpSl_TdcDataVld_i = '1') else '0';
--    PrSl_TdcVldTrig_s <= '1' when (PrSl_TdcVldDly1Clk_s = '0' and CpSl_EchoDVld_i = '1') else '0';
    PrSl_TdcVldTrigDly1_s <= '1' when (PrSl_TdcVldDly1Clk_s = '0' and CpSl_EchoDVld_i = '1') else '0';
    
    -- 
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_TdcVldTrig_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_TdcVldTrig_s <= PrSl_TdcVldTrigDly1_s;
        end if;
    end process;
    
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_TdcTestD1_s <= "000" & x"07D0";
            PrSv_TdcTestD2_s <= "000" & x"2710";
            PrSv_TdcTestD3_s <= "000" & x"6D60";
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RomAddr_s = 0) then
                PrSv_TdcTestD1_s <= "000" & x"07D0";
                PrSv_TdcTestD2_s <= "000" & x"2710";
                PrSv_TdcTestD3_s <= "000" & x"6D60";
--            elsif (PrSl_TdcVldTrig_s = '1') then
            elsif (PrSl_TdcVldTrigDly1_s = '1') then 
                case CpSv_LdNum_i is
                    when "01" => 
                        if (PrSv_TdcTestD1_s = "000" & x"2EDF") then 
                            PrSv_TdcTestD1_s <= "000" & x"07D1";
                        else
                            PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s + 1;
                        end if;
                            PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s;
                            PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s;
                    
                    when "10" => 
                        if (PrSv_TdcTestD2_s = "000" & x"4E1F") then 
                            PrSv_TdcTestD2_s <= "000" & x"2711";
                        else
                            PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s + 1;
                        end if;
                            PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s;
                            PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s;
                        
                    when "00" => 
                        if (PrSv_TdcTestD3_s = "000" & x"946F") then 
                            PrSv_TdcTestD3_s <= "000" & x"6D61";
                        else
                            PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s + 1;
                        end if;
                            PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s;
                            PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s;
                        
                    when others => 
                        PrSv_TdcTestD1_s <= PrSv_TdcTestD1_s;
                        PrSv_TdcTestD2_s <= PrSv_TdcTestD2_s;
                        PrSv_TdcTestD3_s <= PrSv_TdcTestD3_s;

                end case;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_EochData_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            --PrSv_MemsData_s  <= (others => '0');
            PrSv_TdcTest_s   <= (others => '0');
            PrSv_Eoch1Data_s <= (others => '0');
            PrSv_Eoch2Data_s <= (others => '0');
            PrSv_Eoch3Data_s <= (others => '0');
            PrSv_FifoWrCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            case CpSv_EochCnt_i is 
                when "01" => -- Ecch_1
                    -- Test_Module
                    if (CpSl_UdpTest_i = '1') then 
                        --------------------------
                        -- FPGA_A6_TestSignal
                        --------------------------
--                        if (CpSl_EndTrig_i = '1') then
--                            PrSv_TdcTest_s(191 downto 144) <= CpSv_MemxData_i & CpSv_MemyData_i & CpSv_MemTemp_i;
--                        else
--                        end if;
--                        
--                        if (PrSl_TdcVldTrig_s = '1') then 
--                            PrSv_TdcTest_s(143 downto 0) <= CpSv_TdcData_i & CpSv_Tdc2Data_i & CpSv_Tdc3Data_i
--                                                         & CpSv_Tdc4Data_i & CpSv_Tdc5Data_i & CpSv_Tdc6Data_i
--                                                         & CpSv_Tdc7Data_i & CpSv_Tdc8Data_i & x"0000" ; 
--                        else -- hold
--                        end if;
--                        PrSv_FifoWrCnt_s <= x"5";
                        
                        --------------------------
                        -- FPGA_BA0_Signal
                        --------------------------
                        -- MemX&Y
                        --if (CpSl_EndTrig_i = '1') then
                        --    PrSv_MemsData_s <= CpSv_MemxData_i & CpSv_MemyData_i;
                        --else
                        --end if;
                        
--                        if (apd_slt_fifo_rdreq_d1 = '1') then 
--                            case apd_slt_Ld_cnt is
--                                when "00" => 
--                                    PrSv_TdcTest_s(76 downto 64) <= apd_slt_fifo_q(12 downto 0);
--                                    PrSv_TdcTest_s(44 downto 32) <= (others => '0');
--                                    PrSv_TdcTest_s(12 downto  0) <= (others => '0');
--                                when "01" => 
--                                    PrSv_TdcTest_s(76 downto 64) <= PrSv_TdcTest_s(76 downto 64);
--                                    PrSv_TdcTest_s(44 downto 32) <= apd_slt_fifo_q(12 downto 0);
--                                    PrSv_TdcTest_s(12 downto  0) <= (others => '0');
--                                when "10" => 
--                                    PrSv_TdcTest_s(76 downto 64) <= PrSv_TdcTest_s(76 downto 64);
--                                    PrSv_TdcTest_s(44 downto 32) <= PrSv_TdcTest_s(44 downto 32);
--                                    PrSv_TdcTest_s(12 downto  0) <= apd_slt_fifo_q(12 downto 0);
--
----                                when "01" => 
----                                    PrSv_TdcTest_s(95 downto 64) <= PrSv_TdcTestD1_s & CpSv_EchoGray_i(12 downto 0);
----                                    PrSv_TdcTest_s(63 downto 32) <= (others => '0');
----                                    PrSv_TdcTest_s(31 downto  0) <= (others => '0');
----                                when "10" => 
----                                    PrSv_TdcTest_s(95 downto 64) <= PrSv_TdcTest_s(95 downto 64);
----                                    PrSv_TdcTest_s(63 downto 32) <= PrSv_TdcTestD2_s & CpSv_EchoGray_i(12 downto 0);
----                                    PrSv_TdcTest_s(31 downto  0) <= (others => '0');
----                                when "00" => 
----                                    PrSv_TdcTest_s(95 downto 64) <= PrSv_TdcTest_s(95 downto 64);
----                                    PrSv_TdcTest_s(63 downto 32) <= PrSv_TdcTest_s(63 downto 32);
----                                    PrSv_TdcTest_s(31 downto  0) <= PrSv_TdcTestD3_s & CpSv_EchoGray_i(12 downto 0);    
--
--                                when others => 
--                                    PrSv_TdcTest_s(76 downto 64) <= (others => '0');
--                                    PrSv_TdcTest_s(44 downto 32) <= (others => '0');
--                                    PrSv_TdcTest_s(12 downto  0) <= (others => '0');
--                            end case;
--                        else -- hold
--                        end if;								
								
                        if (tdc_fifo_rdreq_d1 = '1') then 
                            
--                        if (PrSl_TdcVldTrig_s = '1') then
                            case Ld_cnt is
--                                when "00" => 
--                                    PrSv_TdcTest_s(95 downto 77) <= tdc_fifo_q(31 downto 13);
--                                    PrSv_TdcTest_s(63 downto 45) <= (others => '0');
--                                    PrSv_TdcTest_s(31 downto 13) <= (others => '0');
--                                when "01" => 
--                                    PrSv_TdcTest_s(95 downto 77) <= PrSv_TdcTest_s(95 downto 77);
--                                    PrSv_TdcTest_s(63 downto 45) <= tdc_fifo_q(31 downto 13);
--                                    PrSv_TdcTest_s(31 downto 13) <= (others => '0');
--                                when "10" => 
--                                    PrSv_TdcTest_s(95 downto 77) <= PrSv_TdcTest_s(95 downto 77);
--                                    PrSv_TdcTest_s(63 downto 45) <= PrSv_TdcTest_s(63 downto 45);
--                                    PrSv_TdcTest_s(31 downto 13) <= tdc_fifo_q(31 downto 13);
--                                when others => 
--                                    PrSv_TdcTest_s(95 downto 77) <= (others => '0');
--                                    PrSv_TdcTest_s(63 downto 45) <= (others => '0');
--                                    PrSv_TdcTest_s(31 downto 13) <= (others => '0');
                                when "00" => 
                                    PrSv_TdcTest_s(95 downto 64) <= tdc_fifo_q(31 downto 0);
                                    PrSv_TdcTest_s(63 downto 32) <= (others => '0');
                                    PrSv_TdcTest_s(31 downto  0) <= (others => '0');
                                when "01" => 
                                    PrSv_TdcTest_s(95 downto 64) <= PrSv_TdcTest_s(95 downto 64);
                                    PrSv_TdcTest_s(63 downto 32) <= tdc_fifo_q(31 downto 0);
                                    PrSv_TdcTest_s(31 downto  0) <= (others => '0');
                                when "10" => 
                                    PrSv_TdcTest_s(95 downto 64) <= PrSv_TdcTest_s(95 downto 64);
                                    PrSv_TdcTest_s(63 downto 32) <= PrSv_TdcTest_s(63 downto 32);
                                    PrSv_TdcTest_s(31 downto  0) <= tdc_fifo_q(31 downto 0);

                                when others => 
                                    PrSv_TdcTest_s(95 downto 64) <= (others => '0');
                                    PrSv_TdcTest_s(63 downto 32) <= (others => '0');
                                    PrSv_TdcTest_s(31 downto  0) <= (others => '0');
                            end case;
                        else -- hold
                        end if;
                        
                        PrSv_FifoWrCnt_s <= x"3";
                        
                    --Normal MOdule
                    else 
                        if (CpSl_EndTrig_i = '1') then 
                            PrSv_Eoch1Data_s(63 downto 16) <= CpSv_MemxData_i & CpSv_MemyData_i & x"0000";
                        else -- hold 
                        end if;
                        
                        if (PrSl_TdcVldTrig_s = '1') then
                            PrSv_Eoch1Data_s(15 downto 0) <= CpSv_TdcData_i;
                        else -- hold
                        end if;
                        
                        PrSv_FifoWrCnt_s <= x"1";
                        end if;
                    
                when "10" => -- Ecch_2
                    if (CpSl_EndTrig_i = '1') then 
                        PrSv_Eoch2Data_s(95 downto 64) <= CpSv_MemxData_i & CpSv_MemyData_i;
                        PrSv_Eoch2Data_s(63 downto 48) <= x"0000";
                        PrSv_Eoch2Data_s(31 downto 16) <= x"0000";
                    else -- hold 
                    end if;
                    
                    if (PrSl_TdcVldTrig_s = '1') then
                        PrSv_Eoch2Data_s(47 downto 32) <= CpSv_TdcData_i;
                        PrSv_Eoch2Data_s(15 downto  0) <= CpSv_TdcData_i;
                    else -- hold
                    end if;
                    
                    PrSv_FifoWrCnt_s <= x"2";

                when "11" => -- Ecch_3
                    if (CpSl_EndTrig_i = '1') then 
                        PrSv_Eoch3Data_s(127 downto 96) <= CpSv_MemxData_i & CpSv_MemyData_i;
                        PrSv_Eoch3Data_s( 95 downto 80) <= x"0000";
                        PrSv_Eoch3Data_s( 63 downto 48) <= x"0000";
                        PrSv_Eoch3Data_s( 31 downto 16) <= x"0000";
                    else -- hold 
                    end if;

                    if (PrSl_TdcVldTrig_s = '1') then
                        PrSv_Eoch3Data_s(79 downto 64) <= CpSv_TdcData_i;
                        PrSv_Eoch3Data_s(47 downto 32) <= CpSv_TdcData_i;
                        PrSv_Eoch3Data_s(15 downto  0) <= CpSv_TdcData_i;
                    else -- hold
                    end if;
                    
                    PrSv_FifoWrCnt_s <= x"3";
                    
                when others =>
                    --PrSv_MemsData_s  <= (others => '0');
                    PrSv_TdcTest_s   <= (others => '0');
                    PrSv_Eoch1Data_s <= (others => '0');
                    PrSv_Eoch2Data_s <= (others => '0');
                    PrSv_Eoch3Data_s <= (others => '0');
                    PrSv_FifoWrCnt_s <= (others => '0');
            end case;
        end if; 
    end process;
    
    ------------------------------------
    -- Write Data to Fifo
    ------------------------------------
    -- Delay CpSl_UdpCycleEnd_i 3 Clk
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_EndTrigDly1_s <= '0';
            PrSl_EndTrigDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_EndTrigDly1_s <= CpSl_UdpCycleEnd_i;
            PrSl_EndTrigDly2_s <= PrSl_EndTrigDly1_s;        
        end if; 
    end process;
    
    -- PrSl_CapEndTrig_s
    PrSl_CapEndTrig_s <= '1' when(PrSl_EndTrigDly2_s = '0' and PrSl_EndTrigDly1_s = '1') else '0';
    
	 
	 joint_tdc_vxvy_en <= '1' when ((trans_vxvy_data_ok_d = '0' and trans_vxvy_data_ok = '1'  and trans_tdc_data_ok = '1') or (trans_vxvy_data_ok = '1' and trans_tdc_data_ok_d = '0' and trans_tdc_data_ok = '1')) else '0';
    -- PrSv_FifoWrNum_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_FifoWrNum_s <= (others => '1');
        elsif rising_edge(CpSl_Clk_i) then 
            if (joint_tdc_vxvy_en = '1') then
                PrSv_FifoWrNum_s <= (others => '0');
            elsif (PrSv_FifoWrNum_s = PrSv_FifoWrCnt_s) then 
                PrSv_FifoWrNum_s <= (others => '1');
            elsif (PrSv_FifoWrNum_s = x"F") then 
                PrSv_FifoWrNum_s <= (others => '1');
            else
                PrSv_FifoWrNum_s <= PrSv_FifoWrNum_s + '1';
            end if;
        end if;
    end process;
    
    -- PrSl_FifoWr_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_FifoWr_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FifoWrNum_s = 0) then
                PrSl_FifoWr_s <= '1';
            elsif (PrSv_FifoWrNum_s = x"F") then 
                PrSl_FifoWr_s <= '0';
            else -- hold
            end if;
        end if;
    end process;

    -- PrSl_FifoWrDly1_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_FifoWrDly1_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_FifoWrDly1_s <= PrSl_FifoWr_s;
        end if;
    end process;

    -- PrSv_FifoWrData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_FifoWrData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case CpSv_EochCnt_i is
                when "01" => -- Ecch_1
                    if (CpSl_UdpTest_i = '1') then 
                        case PrSv_FifoWrNum_s is 
                            -- Memscan_Data
                            when x"0" => PrSv_FifoWrData_s <= PrSv_MemsData_s;
                            -- TDC_Data
                            when x"1" => PrSv_FifoWrData_s <= PrSv_TdcTest_s(95 downto 64);
                            when x"2" => PrSv_FifoWrData_s <= PrSv_TdcTest_s(63 downto 32);
                            when x"3" => PrSv_FifoWrData_s <= PrSv_TdcTest_s(31 downto  0);
                            when others => 
                                PrSv_FifoWrData_s <= (others => '0'); 
                        end case;
                   else
                        if (PrSv_FifoWrNum_s = 0) then
                            PrSv_FifoWrData_s <= PrSv_Eoch1Data_s(63 downto 32);
                        elsif (PrSv_FifoWrNum_s = 1) then 
                            PrSv_FifoWrData_s <= PrSv_Eoch1Data_s(31 downto  0);
                        else -- hold
                        end if;
                    end if;
               
                when "10" => -- Ecch_2
                    if (PrSv_FifoWrNum_s = 0) then
                        PrSv_FifoWrData_s <= PrSv_Eoch2Data_s(95 downto 64);
                    elsif (PrSv_FifoWrNum_s = 1) then 
                        PrSv_FifoWrData_s <= PrSv_Eoch2Data_s(63 downto 32);
                    elsif (PrSv_FifoWrNum_s = 2) then 
                        PrSv_FifoWrData_s <= PrSv_Eoch2Data_s(31 downto  0);
                    else -- hold
                    end if;
                
                when "11" => -- Ecch_3
                    if (PrSv_FifoWrNum_s = 0) then
                        PrSv_FifoWrData_s <= PrSv_Eoch3Data_s(127 downto 96);
                    elsif (PrSv_FifoWrNum_s = 1) then
                        PrSv_FifoWrData_s <= PrSv_Eoch3Data_s( 95 downto 64);
                    elsif (PrSv_FifoWrNum_s = 2) then 
                        PrSv_FifoWrData_s <= PrSv_Eoch3Data_s( 63 downto 32);
                    elsif (PrSv_FifoWrNum_s = 3) then 
                        PrSv_FifoWrData_s <= PrSv_Eoch3Data_s( 31 downto  0);
                    else -- hold
                    end if;
                    
                when others =>
                    PrSv_FifoWrData_s <= (others => '0');

            end case;
        end if;
    end process;
    
    -- PrSv_RdFifostate_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_RdFifostate_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_RdFifostate_s is 
                when "000" => -- Idle
                    if (CpSl_RdFifo_i = '1') then
                        PrSv_RdFifostate_s <= "001";
                    else -- hold
                    end if;

                when "001" => -- Fifo Data
                    if (PrSl_FifoEmpty_s = '0') then
                         PrSv_RdFifostate_s <= "010";
                    else -- hold
                    end if;
                
                when "010" => -- Fifo Read 
                    PrSv_RdFifostate_s <= "011";
                
                when "011" => -- Fifo Read Data
                    PrSv_RdFifostate_s <= "100";

                when "100" => 
                    PrSv_RdFifostate_s <= (others => '0'); 
                when others => PrSv_RdFifostate_s <= (others => '0');   
            end case;
        end if;
    end process;

    -- PrSl_RdFifo_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_RdFifo_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_RdFifostate_s = "010") then
                PrSl_RdFifo_s <= '1';
            else
                PrSl_RdFifo_s <= '0';
            end if;
        end if; 
    end process;

    -- CpSl_FifoDataVld_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_FifoDataVld_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RdFifostate_s = "100") then
                CpSl_FifoDataVld_o <= '1';
            else
                CpSl_FifoDataVld_o <= '0';
            end if;
        end if; 
    end process;

    -- CpSv_FifoData_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_FifoData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_RdFifostate_s = "100") then
                CpSv_FifoData_o <= PrSv_FifoData_s;
            else
            end if;
        end if; 
    end process;

----------------------------------------
-- End
----------------------------------------
end arch_M_RomCtrl;