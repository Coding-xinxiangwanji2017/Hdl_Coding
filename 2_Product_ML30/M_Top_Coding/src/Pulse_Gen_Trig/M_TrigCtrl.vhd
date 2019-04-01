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
-- �ļ�����  :  M_TrigCtrl.vhd
-- ��    ��  :  zhang wenjun
-- ��    ��  :  wenjun.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2018/05/17
-- ���ܼ���  :  Generate Trig for ADC & Control Memory;
--              Frame Integrity;
--              StartTrig : 2 CLk
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

entity M_TrigCtrl is
    generic (
        PrSl_DebugApd_c                 : integer := 1                          -- Debug_APD
    );
    port (
        -------------------------------- 
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 200MHz
        
        --------------------------------
        -- Enther Start/Stop Trig
        --------------------------------
        CpSl_StartTrig_i                : in  std_logic;                        -- Start Trig
        CpSl_StopTrig_i                 : in  std_logic;                        -- Stop Trig
        CpSv_PointStyle_i               : in  std_logic_vector(1 downto 0);     -- Point Number Style
        CpSl_NetStopTrig_o              : out std_logic;                        -- Net Stop Trig


        -------------------------------- 
        -- TDC_RefClk
        --------------------------------
        CpSl_Clk5M_o                    : out std_logic;                        -- 5MHz
        CpSl_1usTrig_o                  : out std_logic;                        -- ius
        
        --------------------------------
        -- Start1/Start2/RPI Trig
        --------------------------------
        start1_close_en_i               : in  std_logic;    -- start1 enable
        start2_close_en_i               : in  std_logic;    -- start2 enable
        start3_close_en_i               : in  std_logic;    -- start3 enable
        CpSl_CapTrig_o                  : out std_logic;                        -- ADLink Capture Trig
        CpSl_Start1_o                   : out std_logic;                        -- Start1 Trig
        CpSl_Start2_o                   : out std_logic;                        -- Start2 Trig
        CpSl_Start3_o                   : out std_logic;                        -- Start3 Trig
        CpSl_LadarTrig_o                : out std_logic;                        -- Ladar Start Trig
        CpSl_Rpi_o                      : out std_logic;                        -- PRI
        CpSl_GainRst_o                  : out std_logic;                        -- Gain Control
        
        --------------------------------
        -- Apd/LD_Num
        -- TDC_CapEnd
        --------------------------------
        CpSl_apd_slt_en_o               : out std_logic;                        -- APD_Enable
        ld_num_o                        : out std_logic_vector(1 downto 0);     -- LD_Num
        CpSl_TdcLdnum_o                 : out std_logic_vector(1 downto 0);     -- Ctrl_Tdc_LD_Num
        CpSl_TdcCapEnd_o                : out std_logic;                        -- TdcCapEnd_Trig
        CpSl_ApdVld_o                   : out std_logic;                        -- APD_Valid
        CpSl_MemXYVld_i                 : in  std_logic;

        --------------------------------
        -- TDC_RstId/Disable
        --------------------------------
        CpSl_TdcDisable_o               : out std_logic;                        -- TDC_GPX2_Disable
        CpSl_RstId_o                    : out std_logic;                        -- TDC_RstId
        CpSl_RstId1_o                   : out std_logic;                        -- TDC_RstId1

        --------------------------------
        -- Start Trig
        --------------------------------
        CpSl_UdpCycleEnd_o              : out std_logic;                        -- UDP Cycle End
        CpSl_Ltc2324Trig_o              : out std_logic;                        -- ADC Start Trig
        CpSl_Ltc2324EndTrig_i           : in  std_logic;                        -- ADC End Trig
        CpSl_FrameEndTrig_i             : in  std_logic;                        -- Frame End Trig
        CpSl_MemoryRdTrig_o             : out std_logic;                        -- Memory start Trig
        CpSl_MemoryAddTrig_o            : out std_logic                         -- Memory Add Trig 
    );
end M_TrigCtrl;

architecture arch_M_TrigCtrl of M_TrigCtrl is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    -- Generate 5MHz
    constant PrSv_5MCnt_c               : std_logic_vector( 7 downto 0) := x"13";   -- 20
    constant PrSv_5MRis_c               : std_logic_vector( 7 downto 0) := x"05";   -- 5
    constant PrSv_1usCnt_c              : std_logic_vector(11 downto 0) := x"063";  -- 100

    -- Head Indication
    constant PrSv_500nsCnt_c            : std_logic_vector(19 downto 0) := x"00031";  -- 50(500ns)
    constant PrSv_530nsCnt_c            : std_logic_vector(19 downto 0) := x"00034";  -- 53(530ns)
    constant PrSv_2usCnt_c              : std_logic_vector(19 downto 0) := x"000C7";  -- 200(2us)
    constant PrSv_2_5usCnt_c            : std_logic_vector(19 downto 0) := x"000F9";  -- 250(2.5us)
    constant PrSv_5usCnt_c              : std_logic_vector(19 downto 0) := x"001F3";  -- 500(5us)
--    constant PrSv_5usCnt_c              : std_logic_vector(19 downto 0) := x"003E7";  -- 1000(10us)
--    constant PrSv_5usCnt_c              : std_logic_vector(19 downto 0) := x"0270F";  -- 10000(0.1ms)
--    constant PrSv_5usCnt_c              : std_logic_vector(19 downto 0) := x"0270F";  -- 10000(0.1ms)
    constant PrSv_Point20K_c            : std_logic_vector( 1 downto 0) := "01";     -- Poit 20K
    constant PrSv_Point40K_c            : std_logic_vector( 1 downto 0) := "10";     -- Point 40K
    constant PrSv_StateIdle_c           : std_logic_vector( 2 downto 0) := "000";    -- State Idle
    constant PrSv_StateGenTrig_c        : std_logic_vector( 2 downto 0) := "001";    -- State Trig
    constant PrSv_StateStop_c           : std_logic_vector( 2 downto 0) := "010";    -- Stop  Trig
    constant PrSv_RstTdc_c              : std_logic_vector( 2 downto 0) := "100";    -- Rst_Tdc

    ----------------------------------------------------------------------------
    -- APD_Address
    -- Start1/2/3
    ----------------------------------------------------------------------------
    ------------------------------------
    -- 200K_Point
    ------------------------------------
--    -- RstID
--    constant PrSv_RstID1_c              : std_logic_vector(19 downto 0) := x"00028";    -- Start1
--    constant PrSv_RstID2_c              : std_logic_vector(19 downto 0) := x"000C8";    -- Start2
--    constant PrSv_RstID3_c              : std_logic_vector(19 downto 0) := x"00168";    -- Start3
--    
--    -- Start_Trig
--    constant PrSv_Start1_c              : std_logic_vector(19 downto 0) := x"00041";    -- Start1
--    constant PrSv_Start2_c              : std_logic_vector(19 downto 0) := x"000E1";    -- Start2
--    constant PrSv_Start3_c              : std_logic_vector(19 downto 0) := x"00181";    -- Start3
--
--    -- CapEnd_APD/CaptureBegin_Trig
----    constant PrSv_CapBgn1_c             : std_logic_vector(19 downto 0) := x"0008F";    -- CapEnd1
----    constant PrSv_CapBgn2_c             : std_logic_vector(19 downto 0) := x"0012F";    -- CapEnd2
----    constant PrSv_CapBgn3_c             : std_logic_vector(19 downto 0) := x"001CF";    -- CapEnd3
--        
--    constant PrSv_CapBgn1_c             : std_logic_vector(19 downto 0) := x"0004B";    -- CapEnd1
--    constant PrSv_CapBgn2_c             : std_logic_vector(19 downto 0) := x"000EB";    -- CapEnd2
--    constant PrSv_CapBgn3_c             : std_logic_vector(19 downto 0) := x"0018B";    -- CapEnd3    
--    
--    constant PrSv_CapEnd1_c             : std_logic_vector(19 downto 0) := x"0009A";    -- CapEnd1
--    constant PrSv_CapEnd2_c             : std_logic_vector(19 downto 0) := x"0013A";    -- CapEnd2
--    constant PrSv_CapEnd3_c             : std_logic_vector(19 downto 0) := x"001DA";    -- CapEnd3
        
    -- RstID
    constant PrSv_RstID1_c              : std_logic_vector(19 downto 0) := x"0003C";    -- RstId1
    constant PrSv_RstID2_c              : std_logic_vector(19 downto 0) := x"000DC";    -- RstId2
    constant PrSv_RstID3_c              : std_logic_vector(19 downto 0) := x"0017C";    -- RstId3
    
    -- Start_Trig
    constant PrSv_Start1_c              : std_logic_vector(19 downto 0) := x"00055";    -- Start1
    constant PrSv_Start2_c              : std_logic_vector(19 downto 0) := x"000F5";    -- Start2
    constant PrSv_Start3_c              : std_logic_vector(19 downto 0) := x"00195";    -- Start3

    -- CapEnd_APD/CaptureBegin_Trig        
    constant PrSv_CapBgn1_c             : std_logic_vector(19 downto 0) := x"0009B";    -- CapEnd1
    constant PrSv_CapBgn2_c             : std_logic_vector(19 downto 0) := x"0013B";    -- CapEnd2
    constant PrSv_CapBgn3_c             : std_logic_vector(19 downto 0) := x"001DB";    -- CapEnd3    
    
    constant PrSv_CapEnd1_c             : std_logic_vector(19 downto 0) := x"000A5";    -- CapEnd1
    constant PrSv_CapEnd2_c             : std_logic_vector(19 downto 0) := x"00145";    -- CapEnd2
    constant PrSv_CapEnd3_c             : std_logic_vector(19 downto 0) := x"001E5";    -- CapEnd3    

    constant PrSv_UdpDVld_c             : std_logic_vector(19 downto 0) := x"001DA";    -- UdpSend_Valid

    ------------------------------------
    -- 100K_Point
    ------------------------------------
    -- RstID
--    constant PrSv_RstID1_c              : std_logic_vector(19 downto 0) := x"00028";    -- Start1
--    constant PrSv_RstID2_c              : std_logic_vector(19 downto 0) := x"00168";    -- Start2
--    constant PrSv_RstID3_c              : std_logic_vector(19 downto 0) := x"002A8";    -- Start3
--    
--    -- Start_Trig
--    constant PrSv_Start1_c              : std_logic_vector(19 downto 0) := x"00041";    -- Start1
--    constant PrSv_Start2_c              : std_logic_vector(19 downto 0) := x"00181";    -- Start2
--    constant PrSv_Start3_c              : std_logic_vector(19 downto 0) := x"002C1";    -- Start3
--
--    -- CapEnd_APD/CaptureBegin_Trig
--    constant PrSv_CapBgn1_c             : std_logic_vector(19 downto 0) := x"0005A";    -- CapEnd1
--    constant PrSv_CapBgn2_c             : std_logic_vector(19 downto 0) := x"0019A";    -- CapEnd2
--    constant PrSv_CapBgn3_c             : std_logic_vector(19 downto 0) := x"002DA";    -- CapEnd3    
--    
--    constant PrSv_CapEnd1_c             : std_logic_vector(19 downto 0) := x"00091";    -- CapEnd1
--    constant PrSv_CapEnd2_c             : std_logic_vector(19 downto 0) := x"001D1";    -- CapEnd2
--    constant PrSv_CapEnd3_c             : std_logic_vector(19 downto 0) := x"00311";    -- CapEnd3

    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    signal PrSl_StartDly1Trig_s         : std_logic;                            -- Start_Trig_Delay1
    signal PrSl_StartDly2Trig_s         : std_logic;                            -- Start_Trig_Delay2
    signal PrSl_StartTrig_s             : std_logic;                            -- Start_Trig
    signal PrSv_5MCnt_s                 : std_logic_vector( 7 downto 0);        -- 5MHz_Cnt
    signal PrSl_5MClk_s                 : std_logic;                            -- 5MHz_Clk
    signal PrSl_ClkVld_s                : std_logic;                            -- 5MHzClk_Valid
    
    signal PrSv_StateTrig_s             : std_logic_vector( 2 downto 0);        -- State
    signal PrSv_CycleCnt_c              : std_logic_vector(19 downto 0);        -- Cycle Constant
    signal PrSv_CycleCnt_s              : std_logic_vector(19 downto 0);        -- Cycle Cnt
    signal PrSv_EndCnt_s                : std_logic_vector( 7 downto 0);        -- EndCnt
    signal PrSv_2usCnt_s                : std_logic_vector(19 downto 0);        -- Delay 2us
    signal PrSl_1usVld_s                : std_logic;                            -- Delay 1us Valid
    signal PrSl_2usVld_s                : std_logic;                            -- Delay 2us Valid
    signal PrSv_TrigCnt_s               : std_logic_vector(1 downto 0);         -- Trig Cnt
    
    -- UDP_Valid
    signal PrSl_UdpVld_s                : std_logic;                            -- UDP_Valid
    
    -- Debug_APD
    signal PrSl_Start1_s                : std_logic;                            -- Start2 Trig
    signal PrSl_Start2_s                : std_logic;                            -- Start2 Trig
    signal PrSl_Start3_s                : std_logic;                            -- Start2 Trig

    -- RstTdc/Disable
    signal PrSv_RstTdc_s                : std_logic_vector(19 downto 0);        -- RstTdc
    signal PrSv_RstTdcNum_s             : std_logic_vector( 4 downto 0);        -- Wait_Time

    signal PrSl_TdcDisable_s            : std_logic;
    signal RstId_done                   : std_logic;
	 
	 
    signal send_laser_cnt               : std_logic_vector(15 downto 0);       
	
    signal start1_close_en_d1           : std_logic                    ; 
    signal start1_close_en_d2           : std_logic                    ;
    signal start2_close_en_d1           : std_logic                    ;
    signal start2_close_en_d2           : std_logic                    ;
    signal start3_close_en_d1           : std_logic                    ;
    signal start3_close_en_d2           : std_logic                    ;
	

	 
begin
    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    -- PrSv_CycleCnt_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_CycleCnt_c <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSv_PointStyle_i = PrSv_Point20K_c) then
                PrSv_CycleCnt_c <= PrSv_5usCnt_c;
            elsif (CpSv_PointStyle_i = PrSv_Point40K_c) then
                PrSv_CycleCnt_c <= PrSv_2_5usCnt_c;
            else -- hold
            end if;
        end if; 
    end process;
    
    -- Delay CpSl_StartTrig_i
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_StartDly1Trig_s <= '0';
            PrSl_StartDly2Trig_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_StartDly1Trig_s <= CpSl_StartTrig_i;
            PrSl_StartDly2Trig_s <= PrSl_StartDly1Trig_s;
        end if; 
    end process;
    
    -- PrSl_StartDly1Trig_s
    PrSl_StartTrig_s <= '1' when (PrSl_StartDly2Trig_s = '0' and PrSl_StartDly1Trig_s = '1') else '0';
    
    -- Delay 2us
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_2usCnt_s <= PrSv_2usCnt_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_StartTrig_s = '1') then
                PrSv_2usCnt_s <= (others => '0');
            elsif (PrSv_2usCnt_s = PrSv_2usCnt_c) then 
                PrSv_2usCnt_s <= PrSv_2usCnt_c;
            else
                PrSv_2usCnt_s <= PrSv_2usCnt_s + '1';
            end if;
        end if;
    end process;
    
    -- PrSl_1usVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_1usVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_2usCnt_s = PrSv_1usCnt_c) then 
                PrSl_1usVld_s <= '1';
            elsif (PrSv_2usCnt_s = PrSv_1usCnt_c + 4) then
                PrSl_1usVld_s <= '0';
            else -- hold
            end if;
        end if;
    end process;
    
    -- CpSl_1usTrig_o
    CpSl_1usTrig_o <= PrSl_1usVld_s;
    
    
    -- PrSl_2usVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_2usVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_2usCnt_s = PrSv_2usCnt_c - 1) then 
                PrSl_2usVld_s <= '1';
            else
                PrSl_2usVld_s <= '0';
            end if;
        end if;
    end process;
    
    -- PrSv_StateTrig_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_StateTrig_s <= PrSv_StateIdle_c;
        elsif rising_edge(CpSl_Clk_i) then 
            case PrSv_StateTrig_s is 
                when PrSv_StateIdle_c => -- Idle
                    if (PrSl_2usVld_s = '1') then
--                        PrSv_StateTrig_s <= PrSv_StateGenTrig_c;
                        PrSv_StateTrig_s <= PrSv_RstTdc_c;
                    else -- hold
                    end if;
                
                when PrSv_RstTdc_c => -- RstTdc
                    if (PrSv_RstTdcNum_s = 20) then 
                        PrSv_StateTrig_s <= PrSv_StateGenTrig_c;
                    else -- hold
                    end if;
                
                when PrSv_StateGenTrig_c => -- Begin Trig
                    if (CpSl_StopTrig_i = '1') then
                        if (CpSl_FrameEndTrig_i = '1') then 
                            PrSv_StateTrig_s <= PrSv_StateStop_c;
                        else -- hold
                        end if;
                    else -- hold
                    end if;

                when PrSv_StateStop_c => 
                    if (PrSv_EndCnt_s = 5) then 
                        PrSv_StateTrig_s <= PrSv_StateIdle_c;
                    else 
                    end if;

                when others => PrSv_StateTrig_s <= PrSv_StateIdle_c;
                    
            end case;
        end if;
    end process;

    -- PrSv_RstTdc_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_RstTdc_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_RstTdc_c) then 
                if (PrSv_RstTdc_s = PrSv_5usCnt_c) then
                    PrSv_RstTdc_s <= (others => '0');
                else
                    PrSv_RstTdc_s <= PrSv_RstTdc_s + '1';
                end if;
            else
                PrSv_RstTdc_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_RstTdcNum_s = 10
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_RstTdcNum_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_RstTdc_c) then 
                if (PrSv_RstTdc_s = PrSv_5usCnt_c) then
                    PrSv_RstTdcNum_s <= PrSv_RstTdcNum_s + '1';
                else -- hold
                end if;
            else
                PrSv_RstTdcNum_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_CycleCnt_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_CycleCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_CycleCnt_c) then
                    PrSv_CycleCnt_s <= (others => '0');
                else 
                    PrSv_CycleCnt_s <= PrSv_CycleCnt_s + '1';
                end if;
            else
            end if;
        end if; 
    end process;
    
    -- CpSl_MemoryRdTrig_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_MemoryRdTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = 0) then
                    CpSl_MemoryRdTrig_o <= '1';
                elsif (PrSv_CycleCnt_s = 4) then
                    CpSl_MemoryRdTrig_o <= '0';
                else -- hold
                end if;
            else
            end if;
        end if; 
    end process;
    
    -- CpSl_MemoryAddTrig_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_MemoryAddTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = 6) then
                    CpSl_MemoryAddTrig_o <= '1';
                elsif (PrSv_CycleCnt_s = 11) then 
                    CpSl_MemoryAddTrig_o <= '0';
                else -- hold
                end if;
            else
            end if;
        end if;
    end process;

    -- CpSl_Ltc2324Trig_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_Ltc2324Trig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
                -- PrSv_1usCnt_c
                if (PrSv_CycleCnt_s = PrSv_1usCnt_c) then
                    CpSl_Ltc2324Trig_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_1usCnt_c + 4) then 
                     CpSl_Ltc2324Trig_o <= '0';
                else -- hold
                end if;
            else
            end if;
        end if;
    end process;
    
    -- PrSv_EndCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_EndCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateStop_c) then 
                PrSv_EndCnt_s <= PrSv_EndCnt_s + '1';
            else
                PrSv_EndCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- CpSl_NetStopTrig_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_NetStopTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateStop_c) then 
                CpSl_NetStopTrig_o <= '1';
            else
                CpSl_NetStopTrig_o <= '0';
            end if;
        end if;
    end process;

    ------------------------------------
    -- Generate 5MHz Clk
    ------------------------------------
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_5MCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_5MCnt_s = PrSv_5MCnt_c) then 
                    PrSv_5MCnt_s <= (others => '0');
                else
                    PrSv_5MCnt_s <= PrSv_5MCnt_s + '1';
                end if;
            else
                PrSv_5MCnt_s <= (others => '0');
            end if;
        end if;
    end process;
        
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
--        if (CpSl_Rst_iN = '0') then
--            CpSl_Clk5M_o <= '0';
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
--                if (PrSv_5MCnt_s = 0) then
--                    CpSl_Clk5M_o <= '0';
--                elsif (PrSv_5MCnt_s = PrSv_5MRis_c) then
--                    CpSl_Clk5M_o <= '1';
--                elsif (PrSv_5MCnt_s = PrSv_5MRis_c + 3) then 
--                    CpSl_Clk5M_o <= '0';
--                else -- hold 
--                end if;
--            else
--                CpSl_Clk5M_o <= '0';
--            end if;
--        end if;
--    end process;

    -- PrSl_5MClk_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_5MClk_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_5MCnt_s = 0) then
                    PrSl_5MClk_s <= '0';
                elsif (PrSv_5MCnt_s = PrSv_5MRis_c) then
                    PrSl_5MClk_s <= '1';
                elsif (PrSv_5MCnt_s = PrSv_5MRis_c + 3) then 
                    PrSl_5MClk_s <= '0';
                else -- hold 
                end if;
            else
                PrSl_5MClk_s <= '0';
            end if;
        end if;
    end process;
    
    CpSl_Clk5M_o <= PrSl_5MClk_s;

    ------------------------------------
    -- CpSl_CapTrig_o
    -- CpSl_Start1/2/3_o
    -- CpSl_Rpi_o
    -- CpSl_GainRst_o
    ------------------------------------
    -- CpSl_CapTrig_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_CapTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_500nsCnt_c) then
                    CpSl_CapTrig_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_500nsCnt_c + 200) then 
                    CpSl_CapTrig_o <= '0';
                end if;
            else
                CpSl_CapTrig_o <= '0';
            end if;
        end if; 
    end process;


    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_Start1_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_Start1_c) then
                    PrSl_Start1_s <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start1_c + 2) then 
                    PrSl_Start1_s <= '0';
                end if;
            else
                PrSl_Start1_s <= '0';
            end if;
        end if; 
    end process;
    
    -- PrSl_Start2_s
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_Start2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_Start2_c) then
                    PrSl_Start2_s <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start2_c + 2) then 
                    PrSl_Start2_s <= '0';
                end if;
            else
                PrSl_Start2_s <= '0';
            end if;
        end if; 
    end process;
    
    -- CpSl_Start3_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_Start3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_Start3_c) then
                    PrSl_Start3_s <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start3_c + 2) then 
                    PrSl_Start3_s <= '0';
                end if;
            else
                PrSl_Start3_s <= '0';
            end if;
        end if; 
    end process;
    
--    Normal_APD : if (PrSl_DebugApd_c = 1) generate
--        CpSl_Start1_o <= PrSl_Start1_s;
--        CpSl_Start2_o <= '0'; -- PrSl_Start2_s;
--        CpSl_Start3_o <= PrSl_Start3_s;
--    end generate Normal_APD;

    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            start1_close_en_d1 <= '0';
            start1_close_en_d2 <= '0';
            start2_close_en_d1 <= '0';
            start2_close_en_d2 <= '0';
            start3_close_en_d1 <= '0';
            start3_close_en_d2 <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            start1_close_en_d1 <= start1_close_en_i;
            start1_close_en_d2 <= start1_close_en_d1;
            start2_close_en_d1 <= start2_close_en_i;
            start2_close_en_d2 <= start2_close_en_d1;
            start3_close_en_d1 <= start3_close_en_i;
            start3_close_en_d2 <= start3_close_en_d1;
        end if; 
    end process;
    

    Normal_APD : if (PrSl_DebugApd_c = 1) generate
        CpSl_Start1_o <= PrSl_Start1_s when start1_close_en_d2 = '0' else '0';
        CpSl_Start2_o <= PrSl_Start2_s when start2_close_en_d2 = '0' else '0';
        CpSl_Start3_o <= PrSl_Start3_s when start3_close_en_d2 = '0' else '0';
    end generate Normal_APD;
    
    Debug_APD : if (PrSl_DebugApd_c = 0) generate
        CpSl_Start1_o <= PrSl_Start1_s when start1_close_en_d2 = '0' else '0';
        CpSl_Start2_o <= PrSl_Start2_s when start2_close_en_d2 = '0' else '0';
        CpSl_Start3_o <= PrSl_Start3_s when start3_close_en_d2 = '0' else '0';
    end generate Debug_APD;

    ------------------------------------
    -- CpSl_RstId_o
    -- CpSl_RstId1_o
    ------------------------------------
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_TrigCnt_s <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
--                if (PrSv_TrigCnt_s = 3) then
--                    PrSv_TrigCnt_s <= "11";
--                elsif (PrSv_CycleCnt_s = PrSv_500nsCnt_c) then
--                    PrSv_TrigCnt_s <= PrSv_TrigCnt_s + '1';
--                else -- hold
--                end if;
--            else
--                PrSv_TrigCnt_s <= (others => '0');
--            end if;
--        end if;
--    end process;

    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            send_laser_cnt  <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c and PrSv_CycleCnt_s = PrSv_5usCnt_c) then 
                if (send_laser_cnt = 9999) then
                    send_laser_cnt  <= (others => '0');
				    else
					     send_laser_cnt  <= send_laser_cnt + '1';
					 end if;
			   end if;
		  end if;
	 end process;

    
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_RstId_o  <= '1';
            CpSl_RstId1_o <= '1';
				RstId_done    <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_RstID1_c and RstId_done = '0') then
                    CpSl_RstId_o  <= '1';
                    CpSl_RstId1_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_RstID1_c + 20) then 
                    CpSl_RstId_o  <= '0';
                    CpSl_RstId1_o <= '0';
						  RstId_done    <= '1';
--                elsif (PrSv_CycleCnt_s = PrSv_RstID2_c) then
--                    CpSl_RstId_o  <= '0';
--                    CpSl_RstId1_o <= '0';
--                elsif (PrSv_CycleCnt_s = PrSv_RstID2_c + 20) then 
--                    CpSl_RstId_o  <= '0';
--                    CpSl_RstId1_o <= '0';
--                elsif (PrSv_CycleCnt_s = PrSv_RstID3_c) then
--                    CpSl_RstId_o  <= '0';
--                    CpSl_RstId1_o <= '0';
--                elsif (PrSv_CycleCnt_s = PrSv_RstID3_c + 20) then 
--                    CpSl_RstId_o  <= '0';
--                    CpSl_RstId1_o <= '0';
                end if;
            else
                CpSl_RstId_o  <= '1';
                CpSl_RstId1_o <= '1';
            end if;
        end if; 
    end process;
    
    ------------------------------------
    -- PrSl_TdcDisable_s
    ------------------------------------
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_TdcDisable_s <= '1';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
                if (PrSv_CycleCnt_s = PrSv_Start1_c) then 
                    PrSl_TdcDisable_s <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_CapBgn1_c) then 
                    PrSl_TdcDisable_s <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start2_c) then
                    PrSl_TdcDisable_s <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_CapBgn2_c) then 
                    PrSl_TdcDisable_s <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start3_c) then
                    PrSl_TdcDisable_s <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_CapBgn3_c) then 
                    PrSl_TdcDisable_s <= '1';
                else -- hold
                end if;
            else
                PrSl_TdcDisable_s <= '1';
            end if;
        end if; 
    end process;
    
    -- CpSl_TdcDisable_o
    CpSl_TdcDisable_o <= PrSl_TdcDisable_s;
    
    -- CpSl_ApdVld_o
    CpSl_ApdVld_o <= PrSl_TdcDisable_s;
    
    ------------------------------------
    -- CpSl_Rpi_o
    ------------------------------------
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_Rpi_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = 0) then
                    CpSl_Rpi_o <= '1';
                elsif (PrSv_CycleCnt_s = 2) then 
                    CpSl_Rpi_o <= '0';
                end if;
            else
            end if;
        end if; 
    end process;
    
    -- CpSl_GainRst_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_GainRst_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_StartTrig_s = '1') then 
                CpSl_GainRst_o <= '1';
            elsif (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_500nsCnt_c) then
                    CpSl_GainRst_o <= '0';
                elsif (CpSl_Ltc2324EndTrig_i = '1') then
                    CpSl_GainRst_o <= '1';
                else -- end 
                end if;
            else
            end if;
        end if; 
    end process;

    -- CpSl_LadarTrig_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_LadarTrig_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_Start1_c) then
                    CpSl_LadarTrig_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start1_c + 10) then 
                    CpSl_LadarTrig_o <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_Start2_c) then
                    CpSl_LadarTrig_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start2_c + 10) then 
                    CpSl_LadarTrig_o <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_Start3_c) then
                    CpSl_LadarTrig_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_Start3_c + 10) then 
                    CpSl_LadarTrig_o <= '0';
                else -- hold
                end if;
            else
                CpSl_LadarTrig_o <= '0';
            end if;
        end if; 
    end process;
    
    -- CpSl_apd_slt_en_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_apd_slt_en_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = 0) then
                    CpSl_apd_slt_en_o <= '1';
                elsif (PrSv_CycleCnt_s = 10) then 
                    CpSl_apd_slt_en_o <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_CapBgn1_c) then
                    CpSl_apd_slt_en_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_CapEnd1_c) then 
                    CpSl_apd_slt_en_o <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_CapBgn2_c) then
                    CpSl_apd_slt_en_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_CapEnd2_c) then 
                    CpSl_apd_slt_en_o <= '0';
                else -- hold
                end if;
            else
                CpSl_apd_slt_en_o <= '0';
            end if;
        end if; 
    end process;
    
    -- ld_num_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            ld_num_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
                if (PrSv_CycleCnt_s = PrSv_CapBgn1_c) then
                    ld_num_o <= "01";
                elsif (PrSv_CycleCnt_s = PrSv_CapBgn2_c) then 
                    ld_num_o <= "10";
                elsif (PrSv_CycleCnt_s = PrSv_CapBgn3_c) then 
                    ld_num_o <= "00";
                else -- hold
                end if;
            else
                ld_num_o <= (others => '0');
            end if;
        end if; 
    end process;
    
   -- CpSl_TdcLdnum_o
--   process(CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            CpSl_TdcLdnum_o <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then 
--            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
--                if (PrSv_CycleCnt_s = PrSv_CapBgn1_c) then
--                    CpSl_TdcLdnum_o <= "01";
--                elsif (PrSv_CycleCnt_s = PrSv_CapBgn2_c) then 
--                    CpSl_TdcLdnum_o <= "10";
--                elsif (PrSv_CycleCnt_s = PrSv_CapBgn3_c) then 
--                    CpSl_TdcLdnum_o <= "11";
--                else -- hold
--                end if;
--            else
--                CpSl_TdcLdnum_o <= (others => '0');
--            end if;
--        end if; 
--    end process;
        
      process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_TdcLdnum_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
                if (PrSv_CycleCnt_s = PrSv_Start1_c) then
                    CpSl_TdcLdnum_o <= "01";
                elsif (PrSv_CycleCnt_s = PrSv_Start2_c) then 
                    CpSl_TdcLdnum_o <= "10";
                elsif (PrSv_CycleCnt_s = PrSv_Start3_c) then 
                    CpSl_TdcLdnum_o <= "11";
                else -- hold
                end if;
            else
                CpSl_TdcLdnum_o <= (others => '0');
            end if;
        end if; 
    end process;  


    -- CpSl_TdcCapEnd_o 
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_TdcCapEnd_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then 
                if (PrSv_CycleCnt_s = PrSv_CapEnd1_c) then
                    CpSl_TdcCapEnd_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_CapEnd1_c + 2) then 
                    CpSl_TdcCapEnd_o <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_CapEnd2_c) then
                    CpSl_TdcCapEnd_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_CapEnd2_c + 2) then 
                    CpSl_TdcCapEnd_o <= '0';
                elsif (PrSv_CycleCnt_s = PrSv_CapEnd3_c) then
                    CpSl_TdcCapEnd_o <= '1';
                elsif (PrSv_CycleCnt_s = PrSv_CapEnd3_c + 2) then 
                    CpSl_TdcCapEnd_o <= '0';
                else -- hold
                end if;
            else
                CpSl_TdcCapEnd_o <= '0';
            end if;
        end if; 
    end process;
    
    -- UDP_Valid
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_UdpVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
                if (PrSv_CycleCnt_s = PrSv_Start1_c) then 
                    PrSl_UdpVld_s <= '1';
                else -- hold
                end if;
            else
                PrSl_UdpVld_s <= '0';
            end if;
        end if;
    end process;
    
    -- CpSl_UdpCycleEnd_o
    process(CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_UdpCycleEnd_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_StateTrig_s = PrSv_StateGenTrig_c) then
                if (PrSl_UdpVld_s = '1') then 
                    if (PrSv_CycleCnt_s = PrSv_Start1_c) then
                        CpSl_UdpCycleEnd_o <= '1';
                    elsif (PrSv_CycleCnt_s = PrSv_Start1_c + 11) then 
                        CpSl_UdpCycleEnd_o <= '0';
                    else -- hold
                    end if;
                else
                    CpSl_UdpCycleEnd_o <= '0';
                end if;
            else
            end if;
        end if;
    end process;   
    
    
----------------------------------------
-- End
----------------------------------------
end arch_M_TrigCtrl;