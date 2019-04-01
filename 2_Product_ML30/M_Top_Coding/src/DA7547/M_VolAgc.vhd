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
-- 文件名称  :  M_VolAgc.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/05/17
-- 功能简述  :  Ocntrol Agc,Normal Voltage : 900 - 1200mv;
--              weighting_number : 0.4/0.3/0.2/0.1
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/07/04
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
library altera_mf;
use altera_mf.all;

----------------------------------------
-- library work
----------------------------------------

-----------
--20190324 CpSv_VolAgcData_o信号暂时输出为0，此信号输出给DAC模块
------------

entity M_VolAgc is
    generic (
        PrSl_Sim_c                      : integer := 1;                         -- Simulation
        PrSv_PointCnt_c                 : std_logic_vector(7 downto 0) := x"04" -- 4
    );
    port (
        --------------------------------
        -- Clock & Reset                
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- active,low
        CpSl_Clk_i                      : in  std_logic;                        -- single 40MHz.clock
        
        --------------------------------
        -- Rom_Start_Trig
        --------------------------------
        CpSl_StartTrig_i                : in  std_logic;                        -- Config AD7547
        
        --------------------------------
        -- Gray
        --------------------------------
        CpSl_EndTrig_i                  : in  std_logic;                        -- LTC2324 Capture End
        CpSv_GrayData_i                 : in  std_logic_vector(15 downto 0);    -- Gray Data

        --------------------------------
        -- Voltage
        --------------------------------
        CpSv_Gain_o                     : out std_logic_vector(15 downto 0);    -- Real Gain      
        CpSl_ImageVld_o                 : out std_logic;                        -- Image Valid
        CpSl_FrameVld_o                 : out std_logic;                        -- Frame Valid
        CpSl_VolAgcTrig_o               : out std_logic;                        -- Voltaga Agc Valid
        CpSv_VolAgcData_o               : out std_logic_vector(11 downto 0)     -- Voltage Agc Data
    );
end M_VolAgc;

architecture arch_M_VolAgc of M_VolAgc is
    ----------------------------------------------------------------------------
    -- Formula Describe
    ----------------------------------------------------------------------------
    -- 
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    -- LTC2324_Capture_Voltage
    --constant PrSv_Gray100mv_c           : std_logic_vector(15 downto 0) := x"0640"; -- 100mv
    --constant PrSv_Gray200mv_c           : std_logic_vector(15 downto 0) := x"0C80"; -- 200mv
    --constant PrSv_Gray300mv_c           : std_logic_vector(15 downto 0) := x"12C0"; -- 300mv
    --constant PrSv_Gray450mv_c           : std_logic_vector(15 downto 0) := x"1C20"; -- 450mv
    --constant PrSv_Gray500mv_c           : std_logic_vector(15 downto 0) := x"1F40"; -- 500mv
    --constant PrSv_Gray600mv_c           : std_logic_vector(15 downto 0) := x"2580"; -- 600mv
    --constant PrSv_Gray700mv_c           : std_logic_vector(15 downto 0) := x"2BC0"; -- 700mv
    --constant PrSv_Gray800mv_c           : std_logic_vector(15 downto 0) := x"3200"; -- 800mv
    --constant PrSv_Gray850mv_c           : std_logic_vector(15 downto 0) := x"3520"; -- 850mv
    --constant PrSv_Gray900mv_c           : std_logic_vector(15 downto 0) := x"3840"; -- 900mv
    --constant PrSv_Gray1000mv_c          : std_logic_vector(15 downto 0) := x"3E80"; -- 1000mv
    --constant PrSv_Gray1200mv_c          : std_logic_vector(15 downto 0) := x"4B00"; -- 1200mv
    --constant PrSv_Gray1400mv_c          : std_logic_vector(15 downto 0) := x"5780"; -- 1400mv
    --constant PrSv_Gray1500mv_c          : std_logic_vector(15 downto 0) := x"5DC0"; -- 1500mv
    --constant PrSv_Gray1700mv_c          : std_logic_vector(15 downto 0) := x"6A40"; -- 1700mv
    --constant PrSv_Gray1900mv_c          : std_logic_vector(15 downto 0) := x"76C0"; -- 1900mv
    --constant PrSv_Gray2047mv_c          : std_logic_vector(15 downto 0) := x"7FF0"; -- 2047mv

    constant PrSv_Gray100mv_c           : std_logic_vector(15 downto 0) := x"0320"; -- 100mv
    constant PrSv_Gray200mv_c           : std_logic_vector(15 downto 0) := x"0640"; -- 200mv
    constant PrSv_Gray300mv_c           : std_logic_vector(15 downto 0) := x"0960"; -- 300mv
    constant PrSv_Gray450mv_c           : std_logic_vector(15 downto 0) := x"0E10"; -- 450mv
    constant PrSv_Gray500mv_c           : std_logic_vector(15 downto 0) := x"0FA0"; -- 500mv
    constant PrSv_Gray600mv_c           : std_logic_vector(15 downto 0) := x"12C0"; -- 600mv
    constant PrSv_Gray700mv_c           : std_logic_vector(15 downto 0) := x"15E0"; -- 700mv
    constant PrSv_Gray800mv_c           : std_logic_vector(15 downto 0) := x"1900"; -- 800mv
    constant PrSv_Gray850mv_c           : std_logic_vector(15 downto 0) := x"1A90"; -- 850mv
    constant PrSv_Gray900mv_c           : std_logic_vector(15 downto 0) := x"1C20"; -- 900mv
    constant PrSv_Gray1000mv_c          : std_logic_vector(15 downto 0) := x"1F40"; -- 1000mv
    constant PrSv_Gray1200mv_c          : std_logic_vector(15 downto 0) := x"2580"; -- 1200mv
    constant PrSv_Gray1400mv_c          : std_logic_vector(15 downto 0) := x"2BC0"; -- 1400mv
    constant PrSv_Gray1500mv_c          : std_logic_vector(15 downto 0) := x"2EE0"; -- 1500mv
    constant PrSv_Gray1700mv_c          : std_logic_vector(15 downto 0) := x"3520"; -- 1700mv
    constant PrSv_Gray1900mv_c          : std_logic_vector(15 downto 0) := x"3B60"; -- 1900mv
    constant PrSv_Gray2047mv_c          : std_logic_vector(15 downto 0) := x"3FF8"; -- 2047mv

    ------------------------------------
    -- AD7547_Voltage_Ref(4V)
    ------------------------------------
    ---- 0.4*Gain
    --constant PrSv_Apd240mv_c            : std_logic_vector(11 downto 0) := x"07A";  -- 240mv
    ---- 0.45*Gain
    --constant PrSv_Apd210mv_c            : std_logic_vector(11 downto 0) := x"06B";  -- 210mv
    ---- 0.55*Gain
    --constant PrSv_Apd150mv_c            : std_logic_vector(11 downto 0) := x"04C";  -- 150mv
    ---- 0.7*Gain
    --constant PrSv_Apd90mv_c             : std_logic_vector(11 downto 0) := x"02E";  -- 90mv
    ---- 0.8*Gain
    --constant PrSv_Apd60mv_c             : std_logic_vector(11 downto 0) := x"01E";  -- 60mv
    ---- 1.2*Gain
    --constant PrSv_Apd50mv_c             : std_logic_vector(11 downto 0) := x"019";  -- 50mv
    ---- 1.3*Gain
    --constant PrSv_Apd80mv_c             : std_logic_vector(11 downto 0) := x"028";  -- 80mv
    ---- 1.5*Gain
    --constant PrSv_Apd100mv_c            : std_logic_vector(11 downto 0) := x"033";  -- 100mv
    ---- 1.6*Gain
    --constant PrSv_Apd130mv_c            : std_logic_vector(11 downto 0) := x"042";  -- 130mv
    ---- 2*Gain
    --constant PrSv_Apd190mv_c            : std_logic_vector(11 downto 0) := x"061";  -- 190mv
    ---- 200mv Volatge
    --constant PrSv_Apd200mv_c            : std_logic_vector(11 downto 0) := x"066";  -- 200mv
    ---- 3*Gain
    --constant PrSv_Apd280mv_c            : std_logic_vector(11 downto 0) := x"08F";  -- 280mv
    ---- 300mv Volatge
    --constant PrSv_Apd300mv_c            : std_logic_vector(11 downto 0) := x"099";  -- 300mv
    ---- 4*Gain
    --constant PrSv_Apd360mv_c            : std_logic_vector(11 downto 0) := x"0B8";  -- 360mv
    ---- 5*Gain
    --constant PrSv_Apd420mv_c            : std_logic_vector(11 downto 0) := x"0D7";  -- 420mv
    ---- 6*Gain
    --constant PrSv_Apd480mv_c            : std_logic_vector(11 downto 0) := x"0F5";  -- 480mv
    ---- 8*Gain
    --constant PrSv_Apd540mv_c            : std_logic_vector(11 downto 0) := x"114";  -- 540mv
    ---- Idle
    --constant PrSv_ApdIdle_c             : std_logic_vector(11 downto 0) := x"200";  -- 1000mv
    --constant PrSv_Tot1500mv_c           : std_logic_vector(11 downto 0) := x"300";  -- 1500mv
    
    -- 0.4*Gain
    constant PrSv_Apd240mv_c            : std_logic_vector(11 downto 0) := x"0F0";  -- 240mv
    -- 0.45*Gain
    constant PrSv_Apd210mv_c            : std_logic_vector(11 downto 0) := x"0D2";  -- 210mv
    -- 0.55*Gain
    constant PrSv_Apd150mv_c            : std_logic_vector(11 downto 0) := x"096";  -- 150mv
    -- 0.7*Gain
    constant PrSv_Apd90mv_c             : std_logic_vector(11 downto 0) := x"05A";  -- 90mv
    -- 0.8*Gain
    constant PrSv_Apd60mv_c             : std_logic_vector(11 downto 0) := x"03C";  -- 60mv
    -- 1.2*Gain
    constant PrSv_Apd50mv_c             : std_logic_vector(11 downto 0) := x"032";  -- 50mv
    -- 1.3*Gain
    constant PrSv_Apd80mv_c             : std_logic_vector(11 downto 0) := x"050";  -- 80mv
    -- 1.5*Gain
    constant PrSv_Apd100mv_c            : std_logic_vector(11 downto 0) := x"064";  -- 100mv
    -- 1.6*Gain
    constant PrSv_Apd130mv_c            : std_logic_vector(11 downto 0) := x"082";  -- 130mv
    -- 2*Gain
    constant PrSv_Apd190mv_c            : std_logic_vector(11 downto 0) := x"0BE";  -- 190mv
    -- 200mv Volatge
    constant PrSv_Apd200mv_c            : std_logic_vector(11 downto 0) := x"0C8";  -- 200mv
    -- 3*Gain
    constant PrSv_Apd280mv_c            : std_logic_vector(11 downto 0) := x"118";  -- 280mv
    -- 300mv Volatge
    constant PrSv_Apd300mv_c            : std_logic_vector(11 downto 0) := x"12C";  -- 300mv
    -- 4*Gain
    constant PrSv_Apd360mv_c            : std_logic_vector(11 downto 0) := x"168";  -- 360mv
    -- 5*Gain
    constant PrSv_Apd420mv_c            : std_logic_vector(11 downto 0) := x"1A4";  -- 420mv
    -- 6*Gain
    constant PrSv_Apd480mv_c            : std_logic_vector(11 downto 0) := x"1E0";  -- 480mv
    -- 8*Gain
    constant PrSv_Apd540mv_c            : std_logic_vector(11 downto 0) := x"21C";  -- 540mv
    -- Idle
    constant PrSv_Apd400_c              : std_logic_vector(11 downto 0) := x"190";  -- 400mv
    constant PrSv_Apd600_c              : std_logic_vector(11 downto 0) := x"258";  -- 600mv
    constant PrSv_ApdIdle_c             : std_logic_vector(11 downto 0) := x"3E8";  -- 1000mv
    constant PrSv_Tot1500mv_c           : std_logic_vector(11 downto 0) := x"5DC";  -- 1500mv

    ------------------------------------
    -- Image State
    ------------------------------------
    constant PrSv_StateIdle_c           : std_logic_vector( 3 downto 0) := x"0";    -- Apd_State_Idel
    constant PrSv_StateTrig_c           : std_logic_vector( 3 downto 0) := x"1";    -- Apd_State_Trig
    constant PrSv_StateAdd_c            : std_logic_vector( 3 downto 0) := x"2";    -- Apd_State_Addition
    constant PrSv_State100mv_c          : std_logic_vector( 3 downto 0) := x"3";    -- Apd_State_100mv
    constant PrSv_State200mv_c          : std_logic_vector( 3 downto 0) := x"4";    -- Apd_State_200mv
    constant PrSv_State300mv_c          : std_logic_vector( 3 downto 0) := x"5";    -- Apd_State_300mv
    constant PrSv_State450mv_c          : std_logic_vector( 3 downto 0) := x"6";    -- Apd_State_450mv
    constant PrSv_State600mv_c          : std_logic_vector( 3 downto 0) := x"7";    -- Apd_State_600mv
    constant PrSv_State1000mv_c         : std_logic_vector( 3 downto 0) := x"8";    -- Apd_State_1000mv
    constant PrSv_State1200mv_c         : std_logic_vector( 3 downto 0) := x"9";    -- Apd_State_1200mv
    constant PrSv_State1500mv_c         : std_logic_vector( 3 downto 0) := x"A";    -- Apd_State_1200~1500mv
    constant PrSv_State2000mv_c         : std_logic_vector( 3 downto 0) := x"B";    -- Apd_State_1500~2000mv
    constant PrSv_StateComVol_c         : std_logic_vector( 3 downto 0) := x"C";    -- Apd_State_Compare
    constant PrSv_StateCopEnd_c         : std_logic_vector( 3 downto 0) := x"D";    -- Apd_State_Compare_End
    constant PrSv_StateFinish_c         : std_logic_vector( 3 downto 0) := x"E";    -- Apd_State_Compare
    constant PrSv_CmpCnt_c              : std_logic_vector( 3 downto 0) := x"5";    -- Compare Data wait time

    ------------------------------------
    -- Frame Init
    ------------------------------------
    constant PrSv_AgcCnt_c              : std_logic_vector( 3 downto 0) := x"4";    -- AGC Cnt
    constant PrSv_HStart_c              : std_logic_vector( 7 downto 0) := x"04";   -- 4
    constant PrSv_HCnt_c                : std_logic_vector( 7 downto 0) := x"63";   -- 100
    constant PrSv_VCnt_c                : std_logic_vector( 7 downto 0) := x"63";   -- 100
    --constant PrSv_VCnt_c                : std_logic_vector( 7 downto 0) := x"C7";   -- 200
    constant PrSv_ImageNum_c            : std_logic_vector(13 downto 0) := "10"&x"70F"; -- 9999
    --constant PrSv_ImageNum_c            : std_logic_vector(13 downto 0) := "00"&x"010"; -- 16
    
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    -- Rom_AGC
    -- Real_Gain => M_RomAgc_q/16
    component M_RomAgc is 
    port (
        address                         : IN  STD_LOGIC_VECTOR (10 DOWNTO 0);
        clock                           : IN  STD_LOGIC  := '1';
        q                               : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    end component;
    
    -- AD7547_Voltage
    component M_AgcDiv is
    port (
        denom                           : IN  STD_LOGIC_VECTOR( 6 DOWNTO 0);
        numer                           : IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
        quotient                        : OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
        remain                          : OUT STD_LOGIC_VECTOR( 6 DOWNTO 0)
    );
    end component;

    -- Gray_Data
    component M_GrayDiv is
    port (
        denom                           : IN  STD_LOGIC_VECTOR (12 DOWNTO 0);
        numer                           : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        quotient                        : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        remain                          : OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
    );
    end component;

    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    -- Rom_AGC
    signal PrSv_RomAgcAddr_s            : std_logic_vector(10 downto 0);        -- Rom Address
--    signal PrSv_RomAddr_s               : std_logic_vector(10 downto 0);        -- Rom Address
    signal PrSv_RomAgcData_s            : std_logic_vector(15 downto 0);        -- Rom Data 
--    signal PrSv_RomData_s               : std_logic_vector(15 downto 0);        -- Rom Data 
    
    -- AD7547_Data
    signal PrSv_VolData_s               : std_logic_vector(16 downto 0);        -- AD7547_Volatge
    signal PrSv_Quit_s                  : std_logic_vector(16 downto 0);        -- AD7547_Data

    -- Gray_Data
    signal PrSv_GrayDenom_s             : std_logic_vector(12 downto 0);        -- Image Gray Denom
    signal PrSv_GrayNumer_s             : std_logic_vector(15 downto 0);        -- Image Gray Number
    signal PrSv_RealGray_s              : std_logic_vector(15 downto 0);        -- Image Real Gray

    -- First Apd
    signal PrSl_FirstApd_s              : std_logic;                            -- First Apd
    
    -- LTC2324_Trig
    signal PrSv_GrayData_s              : std_logic_vector(15 downto 0);        -- Gray Data
    signal PrSl_EndTrigDly1_s           : std_logic;                            -- CpSl_EndTrig_c Delay 1 Clk
    signal PrSl_AdcTrig_s               : std_logic;                            -- CpSl_EndTrig_c Trig
    signal PrSl_AdcTrigDly1_s           : std_logic;                            -- CpSl_EndTrig_c Trig Delay 1Clk
    signal PrSl_AdcTrigDly2_s           : std_logic;                            -- CpSl_EndTrig_c Trig Delay 2Clk
    signal PrSl_AdcTrigDly3_s           : std_logic;                            -- CpSl_EndTrig_c Trig Delay 3Clk
    signal PrSv_GrayDataDly1_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly1
    signal PrSv_GrayDataDly2_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly2
    signal PrSv_GrayDataDly3_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly3
    signal PrSv_GrayDataDly4_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly4
    signal PrSv_SumGrayData_s           : std_logic_vector(17 downto 0);        -- ADC Gray Sum Data 
    signal PrSv_CmpGrayData_s           : std_logic_vector(15 downto 0);        -- ADC Compare Data
    signal PrSv_AgcState_s              : std_logic_vector( 3 downto 0);        -- AGC State
    signal PrSv_VolAgcData_s            : std_logic_vector(11 downto 0);        -- Vol_Agc
    signal PrSv_CfgVolAgc_s             : std_logic_vector(11 downto 0);        -- Config_Vol_Agc
    signal PrSv_CmpCnt_s                : std_logic_vector( 3 downto 0);        -- Comnpare Vol Wait time
    
    -- MemScan
    signal PrSv_HCnt_s                  : std_logic_vector( 7 downto 0);        -- HCnt
    signal PrSv_VCnt_s                  : std_logic_vector( 7 downto 0);        -- VCnt
    signal PrSl_HVld_s                  : std_logic;                            -- Image H Valid
    signal PrSl_VInit_s                 : std_logic;                            -- Image V Init
    signal PrSl_ImageVld_s              : std_logic;                            -- Image Valid
    signal PrSv_ImageState_s            : std_logic_vector( 1 downto 0);        -- Image State
    signal PrSl_Flage_s                 : std_logic;                            -- Image Flage
    signal PrSv_AgcCnt_s                : std_logic_vector( 3 downto 0);        -- AGC Cnt
    signal PrSl_AgcVld_s                : std_logic;                            -- AGC Valid    
  
begin
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
    -- AD7547_Gain
    Real_RomAgcData : if (PrSl_Sim_c = 1) generate
    U_M_RomAgc_0 : M_RomAgc
    port map (
        address		                    => PrSv_RomAgcAddr_s                    , -- IN  STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock		                    => CpSl_Clk_i                           , -- IN  STD_LOGIC  := '1';
		q		                        => PrSv_RomAgcData_s                      -- OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
    end generate Real_RomAgcData;
    
    -- AD7547_Voltage
    U_M_AgcDiv_0 : M_AgcDiv
    port map (
        denom                           => "1111101"                            , -- IN  STD_LOGIC_VECTOR( 6 DOWNTO 0);
        numer                           => (others => '0'), -- PrSv_VolData_s                       , -- IN  STD_LOGIC_VECTOR(16 DOWNTO 0);
        quotient                        => PrSv_Quit_s                          , -- OUT STD_LOGIC_VECTOR(16 DOWNTO 0);
        remain                          => open                                   -- OUT STD_LOGIC_VECTOR( 6 DOWNTO 0)
    );
CpSv_Gain_o <= (others => '0');
--    CpSv_Gain_o <= PrSv_RomAgcData_s;
    PrSv_GrayDenom_s <= PrSv_RomAgcData_s(12 downto 0);
    PrSv_GrayNumer_s <= PrSv_GrayData_s(14 downto 0) & '0';
    
    U_M_GrayDiv_0 : M_GrayDiv
    port map (
        denom                           => PrSv_GrayDenom_s                     , -- IN  STD_LOGIC_VECTOR (12 DOWNTO 0);
        numer                           => PrSv_GrayNumer_s                     , -- IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
        quotient                        => PrSv_RealGray_s                      , -- OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        remain                          => open                                   -- OUT STD_LOGIC_VECTOR (12 DOWNTO 0)
    );
    -- CpSv_RealGray_o
--    CpSv_RealGray_o <= PrSv_RealGray_s;

    ----------------------------------------------------------------------------
    -- Real_RomAgcData Simulation
    ----------------------------------------------------------------------------
    Real_GrayData : if (PrSl_Sim_c = 1) generate
        PrSv_GrayData_s <= CpSv_GrayData_i;
    end generate Real_GrayData;
    
    Sim_RomAgcData : if (PrSl_Sim_c = 0) generate
        process (CpSl_Rst_iN,CpSl_Clk_i) begin
            if (CpSl_Rst_iN = '0') then 
                PrSv_GrayData_s <= (others => '0');
            elsif rising_edge(CpSl_Clk_i) then 
                if (PrSl_AdcTrig_s = '1') then 
                    PrSv_GrayData_s <= PrSv_GrayData_s + 50;
                else
                end if;
            end if;
        end process;
    end generate Sim_RomAgcData;

    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Image Data
    ------------------------------------
    -- Delay CpSl_EndTrig_i 1 Clock
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_EndTrigDly1_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_EndTrigDly1_s <= CpSl_EndTrig_i;
        end if;
    end process;
    -- PrSl_AdcTrig_s
    PrSl_AdcTrig_s <= '1' when (PrSl_EndTrigDly1_s = '0' and CpSl_EndTrig_i = '1') else '0';

    -- PrSv_HCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_HCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_AdcTrig_s = '1') then
                if (PrSv_HCnt_s = PrSv_HCnt_c) then 
                    PrSv_HCnt_s <= (others => '0');
                else
                    PrSv_HCnt_s <= PrSv_HCnt_s + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_VCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_VCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_AdcTrig_s = '1' and PrSv_HCnt_s = PrSv_HCnt_c) then 
                if (PrSv_VCnt_s = PrSv_VCnt_c) then 
                    PrSv_VCnt_s <= (others => '0');
                else
                    PrSv_VCnt_s <= PrSv_VCnt_s + '1';
                end if;
            else  -- hold
            end if;
        end if;
    end process;

    -- PrSl_HVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_HVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_HCnt_s = 1) then
                PrSl_HVld_s <= '1';
            elsif (PrSv_HCnt_s = PrSv_HCnt_c) then
                PrSl_HVld_s <= '0';
            else
            end if;

            --if (PrSv_HCnt_s = PrSv_HCnt_c - 19) then
            --    PrSl_HVld_s <= '0';
            --elsif (PrSv_HCnt_s = PrSv_HCnt_c) then
            --    PrSl_HVld_s <= '1';
            --else -- hold
            --end if;
        end if;
    end process;
    --CpSl_ImageVld_o <= PrSl_HVld_s;

    -- VInit
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            --PrSl_VInit_s <= '1';
            PrSl_VInit_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_VCnt_s = 1) then
                PrSl_VInit_s <= '1';
            elsif (PrSv_VCnt_s = PrSv_VCnt_c) then 
                PrSl_VInit_s <= '0';
            else
            end if;

            --if (PrSv_VCnt_s = PrSv_VCnt_c - 1) then
            --    PrSl_VInit_s <= '0';
            --elsif (PrSv_VCnt_s = PrSv_VCnt_c) then 
            --    PrSl_VInit_s <= '1';
            --else 
            --end if;
        end if;
    end process;
--    CpSl_ImageVld_o <= PrSl_VInit_s;

    -- PrSl_ImageVld_s
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
--        if (CpSl_Rst_iN = '0') then
--            PrSl_ImageVld_s <= '0';
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSl_HVld_s = '0' and PrSl_VInit_s = '0') then 
--                PrSl_ImageVld_s <= '0';
--            else 
--                PrSl_ImageVld_s <= '1';
--            end if;
--        end if;
--    end process;
    -- CpSl_ImageVld_o
--    CpSl_ImageVld_o <= PrSl_ImageVld_s;
	
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_ImageVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_HCnt_s = 1 and PrSv_VCnt_s = 0) then 
                PrSl_ImageVld_s <= '0';
            else 
                PrSl_ImageVld_s <= '1';
            end if;
        end if;
    end process;
    -- CpSl_ImageVld_o
    CpSl_ImageVld_o <= PrSl_ImageVld_s;
	
	
	-- PrSl_Flage_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_Flage_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_HCnt_s = PrSv_HCnt_c and PrSv_VCnt_s = PrSv_VCnt_c) then
                PrSl_Flage_s <= '1';
            else -- hold
            end if;
        end if;
    end process;
	
	-- CpSl_FrameVld_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_FrameVld_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_Flage_s = '1') then
                if (PrSv_HCnt_s = 0 and PrSv_VCnt_s = 0) then 
                    CpSl_FrameVld_o <= '1';
                else
                    CpSl_FrameVld_o <= '0';
                end if;
            else
                CpSl_FrameVld_o <= '0';
            end if;
        end if;
    end process;
	
	
    -- PrSv_AgcCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_AgcCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_AdcTrig_s = '1') then 
        	    if (PrSv_AgcCnt_s = PrSv_AgcCnt_c) then
        	    	PrSv_AgcCnt_s <= (others => '0');
        	    else
        	    	PrSv_AgcCnt_s <= PrSv_AgcCnt_s + '1';
        	    end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSl_AgcVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_AgcVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_AgcCnt_s = PrSv_AgcCnt_c) then
                PrSl_AgcVld_s <= '1';
            else
                PrSl_AgcVld_s <= '0';
            end if;
        end if;
    end process;    
    
    -- PrSl_AdcTrig_s Delay 2 Clk
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_AdcTrigDly1_s <= '0';
            PrSl_AdcTrigDly2_s <= '0';
            PrSl_AdcTrigDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_AdcTrigDly1_s <= PrSl_AdcTrig_s;
            PrSl_AdcTrigDly2_s <= PrSl_AdcTrigDly1_s;
            PrSl_AdcTrigDly3_s <= PrSl_AdcTrigDly2_s;
        end if;
    end process;
    
    -- CpSv_GrayData_i Delay 3 Clk
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_GrayDataDly1_s <= (others => '0');
            PrSv_GrayDataDly2_s <= (others => '0');
            PrSv_GrayDataDly3_s <= (others => '0');
            PrSv_GrayDataDly4_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_AdcTrig_s = '1') then
                PrSv_GrayDataDly1_s <= PrSv_GrayData_s;
                PrSv_GrayDataDly2_s <= PrSv_GrayDataDly1_s;
                PrSv_GrayDataDly3_s <= PrSv_GrayDataDly2_s;
                PrSv_GrayDataDly4_s <= PrSv_GrayDataDly3_s;
            else -- hold
            end if;
        end if;
    end process;
    -- PrSv_SumGrayData_s
    PrSv_SumGrayData_s <= "00" & PrSv_GrayDataDly1_s + PrSv_GrayDataDly2_s + PrSv_GrayDataDly3_s + PrSv_GrayDataDly4_s;

    -- PrSv_AgcState_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_AgcState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            case PrSv_AgcState_s is
                when PrSv_StateIdle_c => -- Idle
                    if (CpSl_StartTrig_i = '1') then 
                        PrSv_AgcState_s <= PrSv_StateFinish_c;
                    else
                    end if;

                when PrSv_StateTrig_c => -- LTC2324_Capture_End
                    if (PrSl_AdcTrigDly3_s = '1') then
                        PrSv_AgcState_s <= PrSv_StateAdd_c;
                    else -- hold
                    end if;
--                    if (PrSv_MeanCnt_s = 12) then
--                        PrSv_AgcState_s <= PrSv_StateAdd_c;
--                    else  -- hold
--                    end if;

                when PrSv_StateAdd_c => -- Compare Gray Data
                    -- 0~300mv/-2048~0
                    if (PrSv_CmpGrayData_s <= PrSv_Gray300mv_c) then
                        PrSv_AgcState_s <= PrSv_State100mv_c;
                    -- 300~500mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray300mv_c and PrSv_CmpGrayData_s <= PrSv_Gray500mv_c) then 
                        PrSv_AgcState_s <= PrSv_State200mv_c;
                    -- 500mv~700mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray500mv_c and PrSv_CmpGrayData_s <= PrSv_Gray700mv_c) then 
                        PrSv_AgcState_s <= PrSv_State300mv_c;
                    -- 700mv~900mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray700mv_c and PrSv_CmpGrayData_s <= PrSv_Gray900mv_c) then 
                        PrSv_AgcState_s <= PrSv_State450mv_c;
                    -- 900mv~1200mv
--                    elsif (PrSv_CmpGrayData_s > PrSv_Gray900mv_c and PrSv_CmpGrayData_s <= PrSv_Gray1200mv_c) then 
--                        PrSv_AgcState_s <= PrSv_State600mv_c;
                    -- 1200mv~1500mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray1200mv_c and PrSv_CmpGrayData_s <= PrSv_Gray1500mv_c) then 
                        PrSv_AgcState_s <= PrSv_State1000mv_c;
                    -- 1500mv~1700mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray1500mv_c and PrSv_CmpGrayData_s <= PrSv_Gray1700mv_c) then 
                        PrSv_AgcState_s <= PrSv_State1200mv_c;
                    -- 1700~2047mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray1700mv_c and PrSv_CmpGrayData_s <= PrSv_Gray2047mv_c) then 
                        PrSv_AgcState_s <= PrSv_State1500mv_c;
--                    -- 1500~2000mv
--                    elsif (PrSv_CmpGrayData_s > PrSv_Gray1500mv_c and PrSv_CmpGrayData_s <= PrSv_Gray2047mv_c) then 
--                        PrSv_AgcState_s <= PrSv_State2000mv_c;
                    
                    -- > 2047mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray2047mv_c and PrSv_CmpGrayData_s <= x"7FFF") then
                        PrSv_AgcState_s <= PrSv_State2000mv_c;
                    else
                        PrSv_AgcState_s <= PrSv_StateTrig_c;
                    end if;

                when PrSv_State100mv_c => -- 0~300mv/-2048~0
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                    
                when PrSv_State200mv_c => -- 300~500mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State300mv_c => -- 500mv~700mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State450mv_c => -- 700mv~900mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
--                when PrSv_State600mv_c => -- 900mv~1200mv
--                    PrSv_AgcState_s <= PrSv_StateComVol_c;

                when PrSv_State1000mv_c => -- 1200mv~1500mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State1200mv_c => -- 1500mv~1700mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;

                when PrSv_State1500mv_c => -- 1700~2047mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
--                
                when PrSv_State2000mv_c => -- > 2047mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_StateComVol_c => -- Compare_Voltage
                    if (PrSv_CmpCnt_s = PrSv_CmpCnt_c) then
                        PrSv_AgcState_s <= PrSv_StateCopEnd_c;
                    else -- hold
                    end if;
                    
                when PrSv_StateCopEnd_c => -- Config_End
                    PrSv_AgcState_s <= PrSv_StateTrig_c;
                
                when PrSv_StateFinish_c => -- Finish
                    PrSv_AgcState_s <= PrSv_StateTrig_c;
                when others => PrSv_AgcState_s <= (others => '0');
            end case;
        end if;
    end process;
    
    -- PrSv_CmpGrayData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_CmpGrayData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateTrig_c and PrSl_AdcTrigDly2_s = '1') then
                --PrSv_CmpGrayData_s <= PrSv_GrayDataDly1_s; 
				
				--if (PrSl_AgcVld_s = '1' and PrSl_ImageVld_s = '1') then
    --                PrSv_CmpGrayData_s <= PrSv_SumGrayData_s(17 downto 2); 
    --                --PrSv_CmpGrayData_s <= PrSv_GrayDataDly1_s; 
    --            else -- hold
    --            end if;                

                if (PrSl_HVld_s = '1') then
                    PrSv_CmpGrayData_s <= PrSv_GrayDataDly1_s; 
                else -- hold
                end if;   

                --if (PrSl_ImageVld_s = '1') then
                --    PrSv_CmpGrayData_s <= PrSv_GrayDataDly1_s; 
                --else -- hold
                --end if;   

                --if (PrSl_AgcVld_s = '1') then
                --    PrSv_CmpGrayData_s <= PrSv_SumGrayData_s(17 downto 2);
                --else
                --    PrSv_CmpGrayData_s <= PrSv_GrayDataDly1_s; 
                --end if;
            else
            end if;
        end if;
    end process;

    -- PrSv_VolAgcData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_VolAgcData_s <= PrSv_ApdIdle_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateIdle_c) then
                PrSv_VolAgcData_s <= PrSv_ApdIdle_c;
            -- 0~300mv/-2048~0
            elsif (PrSv_AgcState_s = PrSv_State100mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd280mv_c + PrSv_Apd400_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd280mv_c;
                else
--                    PrSv_VolAgcData_s <= x"000";
                    PrSv_VolAgcData_s <= PrSv_Apd400_c;
                end if;
            
            -- 300~500mv
            elsif (PrSv_AgcState_s = PrSv_State200mv_c) then 
                if (PrSv_VolAgcData_s > PrSv_Apd190mv_c + PrSv_Apd400_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd190mv_c;
                else
--                    PrSv_VolAgcData_s <= x"000";
                    PrSv_VolAgcData_s <= PrSv_Apd400_c;
                end if;
                
            -- 500mv~700mv
            elsif (PrSv_AgcState_s = PrSv_State300mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd130mv_c + PrSv_Apd400_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd130mv_c;
                else
--                    PrSv_VolAgcData_s <= x"000";
                    PrSv_VolAgcData_s <= PrSv_Apd400_c;
                end if;

            -- 700mv~900mv
            elsif (PrSv_AgcState_s = PrSv_State450mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd80mv_c + PrSv_Apd400_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd80mv_c;
                else
--                    PrSv_VolAgcData_s <= x"000";
                    PrSv_VolAgcData_s <= PrSv_Apd400_c;
                end if;
            
            -- 900mv~1200mv
--            elsif (PrSv_AgcState_s = PrSv_State600mv_c) then
--                if (PrSv_VolAgcData_s > PrSv_Apd50mv_c) then
--                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd50mv_c;
--                else
--                    PrSv_VolAgcData_s <= x"000";
--                end if;        
            
            -- 1200mv~1500mv
            elsif (PrSv_AgcState_s = PrSv_State1000mv_c) then
                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd60mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd60mv_c;
                else
                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
                end if;
            
            -- 1500mv~1700mv
            elsif (PrSv_AgcState_s = PrSv_State1200mv_c) then
                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd90mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd90mv_c;
                else
                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
                end if; 

            -- 1700~2047mv
            elsif (PrSv_AgcState_s = PrSv_State1500mv_c) then
                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd150mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd150mv_c;
                else
                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
                end if;
            
            -- 2047mv~2048mv
            elsif (PrSv_AgcState_s = PrSv_State2000mv_c) then
                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd210mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd210mv_c;
                else
                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
                end if;
            else -- hold
            end if;
        end if;
    end process;
    -- PrSv_RomAgcAddr_s
    PrSv_RomAgcAddr_s <= (others => '0');
--    PrSv_RomAgcAddr_s <= PrSv_VolAgcData_s(10 downto 0);
    --PrSv_RomAgcAddr_s <= PrSv_Apd600_c(10 downto 0);

    -- PrSv_VolData_s
    PrSv_VolData_s <= (others => '0');
--    PrSv_VolData_s <= PrSv_VolAgcData_s(10 downto 0) & "000000";
    --PrSv_VolData_s <= PrSv_Apd600_c(10 downto 0) & "000000";
    
    -- PrSv_CmpCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_CmpCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateComVol_c) then
                PrSv_CmpCnt_s <= PrSv_CmpCnt_s + '1';
            else
                PrSv_CmpCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_CfgVolAgc_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_CfgVolAgc_s <= (others => '0');
            --PrSv_CfgVolAgc_s <= PrSv_Quit_s(11 downto 0);
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateComVol_c and PrSv_CmpCnt_s = PrSv_CmpCnt_c - 1) then
                PrSv_CfgVolAgc_s <= (others => '1');
                --PrSv_CfgVolAgc_s <= PrSv_Quit_s(11 downto 0);
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSl_FirstApd_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSl_FirstApd_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateIdle_c) then
                PrSl_FirstApd_s <= '0';
            elsif (PrSv_AgcState_s = PrSv_StateFinish_c) then 
                PrSl_FirstApd_s <= '1';
            else
            end if;
        end if;
    end process;
    
    -- CpSl_VolAgcTrig_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            CpSl_VolAgcTrig_o <= '0';
--            CpSv_VolAgcData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateCopEnd_c) then
                CpSl_VolAgcTrig_o <= '1';
--                CpSv_VolAgcData_o <= '1' & PrSv_CfgVolAgc_s(10 downto 0);
            elsif (PrSl_FirstApd_s = '0' and CpSl_StartTrig_i = '1') then 
                CpSl_VolAgcTrig_o <= '1';
--                CpSv_VolAgcData_o <= '1' & PrSv_CfgVolAgc_s(10 downto 0);
            else
                CpSl_VolAgcTrig_o <= '0';
            end if;
        end if;
    end process;
    
    CpSv_VolAgcData_o <= (others => '0');

----------------------------------------
-- End
----------------------------------------
end arch_M_VolAgc;