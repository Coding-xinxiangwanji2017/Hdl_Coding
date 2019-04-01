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
-- 功能简述  :  Ocntrol Agc,Normal Voltage : 300 - 1200mv;
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
--library altera_mf;
--use altera_mf.all;

----------------------------------------
-- library work
----------------------------------------

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
        
        -------------------------------
        -- Simulation Data
        --------------------------------
        CpSv_VolAgcData_s               : out std_logic_vector(11 downto 0);    -- Data
        
        --------------------------------
        -- Voltage
        --------------------------------
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
    constant PrSv_Gray100mv_c           : std_logic_vector(15 downto 0) := x"0640"; -- 100mv
    constant PrSv_Gray200mv_c           : std_logic_vector(15 downto 0) := x"0C80"; -- 200mv
    constant PrSv_Gray300mv_c           : std_logic_vector(15 downto 0) := x"12C0"; -- 300mv
    constant PrSv_Gray450mv_c           : std_logic_vector(15 downto 0) := x"1C20"; -- 450mv
    constant PrSv_Gray600mv_c           : std_logic_vector(15 downto 0) := x"2580"; -- 600mv
    constant PrSv_Gray800mv_c           : std_logic_vector(15 downto 0) := x"3200"; -- 800mv
    constant PrSv_Gray1000mv_c          : std_logic_vector(15 downto 0) := x"3E80"; -- 1000mv
    constant PrSv_Gray1200mv_c          : std_logic_vector(15 downto 0) := x"4B00"; -- 1200mv
    constant PrSv_Gray1500mv_c          : std_logic_vector(15 downto 0) := x"5DC0"; -- 1500mv
    constant PrSv_Gray2048mv_c          : std_logic_vector(15 downto 0) := x"7FFF"; -- 2048mv

    ------------------------------------
    -- AD7547_Voltage_Ref(4V)
    ------------------------------------
    -- 1.2*Gain
    constant PrSv_Apd50mv_c             : std_logic_vector(11 downto 0) := x"019";  -- 50mv
    -- 1.4*Gain
    constant PrSv_Apd90mv_c             : std_logic_vector(11 downto 0) := x"02E";  -- 90mv
    -- 1.6*Gain
    constant PrSv_Apd120mv_c            : std_logic_vector(11 downto 0) := x"03D";  -- 120mv
    -- 2*Gain
    constant PrSv_Apd180mv_c            : std_logic_vector(11 downto 0) := x"05C";  -- 180mv
    -- 4*Gain
    constant PrSv_Apd360mv_c            : std_logic_vector(11 downto 0) := x"0B8";  -- 360mv
    -- 6*Gain
--    constant PrSv_Apd480mv_c            : std_logic_vector(11 downto 0) := x"0F5";  -- 480mv
    -- 8*Gain
    constant PrSv_Apd540mv_c            : std_logic_vector(11 downto 0) := x"114";  -- 540mv
    constant PrSv_ApdIdle_c             : std_logic_vector(11 downto 0) := x"200";  -- 1000mv
    constant PrSv_Tot1500mv_c           : std_logic_vector(11 downto 0) := x"300";  -- 1500mv
    
    ------------------------------------
    -- Frame Init
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

    ------------------------------------
    -- Frame Init
    ------------------------------------
    constant PrSv_HStart_c              : std_logic_vector( 7 downto 0) := x"04";   -- 4
    constant PrSv_HCnt_c                : std_logic_vector( 7 downto 0) := x"63";   -- 100
    constant PrSv_VCnt_c                : std_logic_vector( 7 downto 0) := x"C7";   -- 200
    
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    -- M_RomAgc
--    component M_RomAgc is 
--    port (
--        address		                    : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
--		clock		                    : IN STD_LOGIC  := '1';
--		q		                        : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
--    );
--    end component;
    
    component M_AgcDiv is
    port (
		denom	                        : IN  STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		numer	                        : IN  STD_LOGIC_VECTOR (19 DOWNTO 0);
		quotient                        : OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
		remain	                        : OUT STD_LOGIC_VECTOR ( 3 DOWNTO 0)
    );
    end component;
    
    ----------------------------------------------------------------------------
    -- signal describe
    ----------------------------------------------------------------------------
    -- Rom
    signal PrSv_RomAgcAddr_s            : std_logic_vector( 2 downto 0);        -- Rom Address
    signal PrSv_RomAddr_s               : std_logic_vector( 2 downto 0);        -- Rom Address
    signal PrSv_RomAgcData_s            : std_logic_vector(11 downto 0);        -- Rom Data  
    signal PrSv_RomData_s               : std_logic_vector(11 downto 0);        -- Rom Data 
    
    -- Div
    signal PrSv_Quotient_s              : STD_LOGIC_VECTOR(19 DOWNTO 0);
    
    -- First Apd
    signal PrSl_FirstApd_s              : std_logic;                            -- First Apd
    
    -- LTC2324_Trig
    signal PrSl_EndTrigDly1_s           : std_logic;                            -- CpSl_EndTrig_c Delay 1 Clk
    signal PrSl_AdcTrig_s               : std_logic;                            -- CpSl_EndTrig_c Trig
    signal PrSl_AdcTrigDly1_s           : std_logic;                            -- CpSl_EndTrig_c Trig Delay 1Clk
    signal PrSl_AdcTrigDly2_s           : std_logic;                            -- CpSl_EndTrig_c Trig Delay 2Clk
    signal PrSl_AdcTrigDly3_s           : std_logic;                            -- CpSl_EndTrig_c Trig Delay 3Clk
    signal PrSv_GrayDataDly1_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly1
    signal PrSv_GrayDataDly2_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly2
    signal PrSv_GrayDataDly3_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly3
    signal PrSv_GrayDataDly4_s          : std_logic_vector(15 downto 0);        -- CpSv_GrayData_i Dly4
    signal PrSv_GrayCnt4_s              : std_logic_vector(17 downto 0);        -- Cnt4
    signal PrSv_GrayCnt3_s              : std_logic_vector(17 downto 0);        -- Cnt3 
    signal PrSv_GrayCnt2_s              : std_logic_vector(17 downto 0);        -- Cnt2
    signal PrSv_GrayCnt1_s              : std_logic_vector(17 downto 0);        -- Cnt1   
    signal PrSv_SumGrayData_s           : std_logic_vector(19 downto 0);        -- ADC Gray Sum Data 
    signal PrSv_CmpGrayData_s           : std_logic_vector(15 downto 0);        -- ADC Compare Data
    signal PrSv_AgcState_s              : std_logic_vector( 3 downto 0);        -- AGC State
    signal PrSv_VolAgcData_s            : std_logic_vector(11 downto 0);        -- Vol_Agc
    signal PrSv_CfgVolAgc_s             : std_logic_vector(11 downto 0);        -- Config_Vol_Agc
    
    -- MemScan
    signal PrSv_HCnt_s                  : std_logic_vector( 7 downto 0);        -- HCnt
    signal PrSv_VCnt_s                  : std_logic_vector( 7 downto 0);        -- VCnt
    signal PrSl_HVld_s                  : std_logic;                            -- Image H Valid
    
    -- sim
    signal PrSv_GrayData_s              : std_logic_vector(15 downto 0);        -- Gray Data

begin
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
--    Real_RomAgcData : if (PrSl_Sim_c = 1) generate
--    U_M_RomAgc_0 : M_RomAgc
--    port map (
--        address		                    => PrSv_RomAgcAddr_s                    , -- IN STD_LOGIC_VECTOR (2 DOWNTO 0);
--		clock		                    => CpSl_Clk_i                           , -- IN STD_LOGIC  := '1';
--		q		                        => PrSv_RomAgcData_s                      -- OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
--    );
--    end generate Real_RomAgcData;
    
    U_M_AgcDiv_0 : M_AgcDiv
    port map(
		denom	                        => "1010"                               , -- IN  STD_LOGIC_VECTOR ( 3 DOWNTO 0);
		numer	                        => PrSv_SumGrayData_s                   , -- IN  STD_LOGIC_VECTOR (19 DOWNTO 0);
		quotient                        => PrSv_Quotient_s                      , -- OUT STD_LOGIC_VECTOR (19 DOWNTO 0);
		remain	                        => open                                   -- OUT STD_LOGIC_VECTOR ( 3 DOWNTO 0)
    );
    
    Real_RomAgcData : if (PrSl_Sim_c = 1) generate
        PrSv_GrayData_s <= CpSv_GrayData_i;
    end generate Real_RomAgcData;
    
    Sim_RomAgcData : if (PrSl_Sim_c = 0) generate
        process (CpSl_Rst_iN,CpSl_Clk_i) begin
            if (CpSl_Rst_iN = '0') then 
                PrSv_GrayData_s <= (others => '0');
            elsif rising_edge(CpSl_Clk_i) then 
                if (CpSl_EndTrig_i = '1') then 
                    PrSv_GrayData_s <= PrSv_GrayData_s + 50;
                else
                end if;
            end if;
        end process;
    end generate Sim_RomAgcData;

    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
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

    -- PrSl_HVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_HVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
--            if (PrSv_HCnt_s = PrSv_HStart_c) then 
            if (PrSv_HCnt_s = PrSv_PointCnt_c) then
                PrSl_HVld_s <= '1';
            elsif (PrSv_HCnt_s = PrSv_HCnt_c) then
                PrSl_HVld_s <= '0';
            else -- hold
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
    
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_GrayCnt4_s <= (others => '0');
            PrSv_GrayCnt3_s <= (others => '0');
            PrSv_GrayCnt2_s <= (others => '0');
            PrSv_GrayCnt1_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            PrSv_GrayCnt4_s(17 downto 2) <= PrSv_GrayDataDly1_s;
            PrSv_GrayCnt3_s(16 downto 1) <= PrSv_GrayDataDly2_s;
            PrSv_GrayCnt2_s(16 downto 1) <= PrSv_GrayDataDly3_s;
            PrSv_GrayCnt1_s(15 downto 0) <= PrSv_GrayDataDly4_s;
        end if;
    end process;
    
    -- PrSv_SumGrayData_s
--    PrSv_SumGrayData_s <= PrSv_GrayDataDly1_s & "00" + PrSv_GrayDataDly2_s & '0' + PrSv_GrayDataDly2_s
--                            + PrSv_GrayDataDly3_s & '0' + PrSv_GrayDataDly4_s;
    
    PrSv_SumGrayData_s <= "00" & PrSv_GrayCnt4_s + PrSv_GrayCnt3_s + PrSv_GrayDataDly2_s
                            + PrSv_GrayCnt2_s + PrSv_GrayCnt1_s;
    
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

                when PrSv_StateAdd_c => -- Compare Gray Data
                    -- 0~100mv/-2048~0
                    if (PrSv_CmpGrayData_s <= PrSv_Gray100mv_c) then
                        PrSv_AgcState_s <= PrSv_State100mv_c;
                    -- 100~200mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray100mv_c and PrSv_CmpGrayData_s <= PrSv_Gray200mv_c) then 
                        PrSv_AgcState_s <= PrSv_State200mv_c;
                    -- 200~300mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray200mv_c and PrSv_CmpGrayData_s <= PrSv_Gray300mv_c) then 
                        PrSv_AgcState_s <= PrSv_State300mv_c;
                    -- 300~450mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray300mv_c and PrSv_CmpGrayData_s <= PrSv_Gray450mv_c) then 
                        PrSv_AgcState_s <= PrSv_State450mv_c;
                    -- 450~600mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray450mv_c and PrSv_CmpGrayData_s <= PrSv_Gray600mv_c) then 
                        PrSv_AgcState_s <= PrSv_State600mv_c;
                    
                    -- 600~800mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray600mv_c and PrSv_CmpGrayData_s <= PrSv_Gray800mv_c) then 
                        PrSv_AgcState_s <= PrSv_State1000mv_c;
                    
--                    -- 800~1000mv
--                    elsif (PrSv_CmpGrayData_s > PrSv_Gray800mv_c and PrSv_CmpGrayData_s <= PrSv_Gray1000mv_c) then 
--                        PrSv_AgcState_s <= PrSv_State1000mv_c;
                    -- 1000~1200mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray1000mv_c and PrSv_CmpGrayData_s <= PrSv_Gray1200mv_c) then 
                        PrSv_AgcState_s <= PrSv_State1200mv_c;
                    -- 1200~1500mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray1200mv_c and PrSv_CmpGrayData_s <= PrSv_Gray1500mv_c) then 
                        PrSv_AgcState_s <= PrSv_State1500mv_c;
                    -- 1500~2000mv
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray1500mv_c and PrSv_CmpGrayData_s <= PrSv_Gray2048mv_c) then 
                        PrSv_AgcState_s <= PrSv_State2000mv_c;
                    elsif (PrSv_CmpGrayData_s > PrSv_Gray2048mv_c) then
                        PrSv_AgcState_s <= PrSv_State100mv_c;
                    else
                        PrSv_AgcState_s <= PrSv_StateTrig_c;
                    end if;

                when PrSv_State100mv_c => -- 0~100mv/-2048~0
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                    
                when PrSv_State200mv_c => -- 100~200mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State300mv_c => -- 200~300mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State450mv_c => -- 300~450mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State600mv_c => -- 450~600mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;

                when PrSv_State1000mv_c => -- 800~1000mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State1200mv_c => -- 1000~1200mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;

                when PrSv_State1500mv_c => -- 1200~1500mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_State2000mv_c => -- 1500~2000mv
                    PrSv_AgcState_s <= PrSv_StateComVol_c;
                
                when PrSv_StateComVol_c => -- Compare_Voltage
                    PrSv_AgcState_s <= PrSv_StateCopEnd_c;

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
                if (PrSl_HVld_s = '1') then
                    PrSv_CmpGrayData_s <= PrSv_Quotient_s(15 downto 0);
--                    PrSv_CmpGrayData_s <= PrSv_SumGrayData_s(17 downto 2);
                else
                    PrSv_CmpGrayData_s <= PrSv_GrayDataDly1_s; 
                end if;
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
            -- 0~100mV
            elsif (PrSv_AgcState_s = PrSv_State100mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd540mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd540mv_c;
                else
                    PrSv_VolAgcData_s <= x"000";
                end if;
            
            -- 100~200mV
            elsif (PrSv_AgcState_s = PrSv_State200mv_c) then 
                if (PrSv_VolAgcData_s > PrSv_Apd360mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd360mv_c;
                else
                    PrSv_VolAgcData_s <= x"000";
                end if;
                
            -- 200~300mv
            elsif (PrSv_AgcState_s = PrSv_State300mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd180mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd180mv_c;
                else
                    PrSv_VolAgcData_s <= x"000";
                end if;

            -- 300~450mv       
            elsif (PrSv_AgcState_s = PrSv_State450mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd90mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd90mv_c;
                else
                    PrSv_VolAgcData_s <= x"000";
                end if;
            
            -- 450~600mv
            elsif (PrSv_AgcState_s = PrSv_State600mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd120mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd120mv_c;
                else
                    PrSv_VolAgcData_s <= x"000";
                end if;      
            
            -- 600~800mv
            elsif (PrSv_AgcState_s = PrSv_State1000mv_c) then
                if (PrSv_VolAgcData_s > PrSv_Apd50mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s - PrSv_Apd50mv_c;
                else
                    PrSv_VolAgcData_s <= x"000";
                end if; 
            
            -- 800~1000mv
--            elsif (PrSv_AgcState_s = PrSv_State1000mv_c) then
--                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd90mv_c) then
--                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd90mv_c;
--                else
--                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
--                end if;
            
            -- 1000~1200mv
            elsif (PrSv_AgcState_s = PrSv_State1200mv_c) then
                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd50mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd50mv_c;
                else
                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
                end if; 

            -- 1200~1500mv
            elsif (PrSv_AgcState_s = PrSv_State1500mv_c) then
                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd180mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd180mv_c;
                else
                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
                end if;
            
            -- 1500~2000mv
            elsif (PrSv_AgcState_s = PrSv_State2000mv_c) then
                if (PrSv_VolAgcData_s < PrSv_Tot1500mv_c - PrSv_Apd360mv_c) then
                    PrSv_VolAgcData_s <= PrSv_VolAgcData_s + PrSv_Apd360mv_c;
                else
                    PrSv_VolAgcData_s <= PrSv_Tot1500mv_c;
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    CpSv_VolAgcData_s <= PrSv_VolAgcData_s;
    
    -- PrSv_CfgVolAgc_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_CfgVolAgc_s <= PrSv_ApdIdle_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateComVol_c) then
--                PrSv_CfgVolAgc_s <= PrSv_ApdIdle_c;
                PrSv_CfgVolAgc_s <= PrSv_VolAgcData_s;
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
            CpSv_VolAgcData_o <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_AgcState_s = PrSv_StateCopEnd_c) then
                CpSl_VolAgcTrig_o <= '1';
                CpSv_VolAgcData_o <= '1' & PrSv_CfgVolAgc_s(10 downto 0);
--            elsif (PrSv_AgcState_s = PrSv_StateFinish_c) then
            elsif (PrSl_FirstApd_s = '0' and CpSl_StartTrig_i = '1') then 
                CpSl_VolAgcTrig_o <= '1';
                CpSv_VolAgcData_o <= '1' & PrSv_CfgVolAgc_s(10 downto 0);
            else
                CpSl_VolAgcTrig_o <= '0';
            end if;
        end if;
    end process;

--    -- PrSv_RomAddr_s
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_RomAddr_s <= "011";
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_AgcState_s = "001") then 
--                if (PrSv_GrayData_s < PrSv_Gray200mv_c) then
--                    PrSv_RomAddr_s <= PrSv_RomAddr_s + '1';
--                elsif (PrSv_GrayData_s > PrSv_Gray600mv_c) then
--                    PrSv_RomAddr_s <= PrSv_RomAddr_s - '1';
--                else -- hold 
--                end if;
--            else -- hold
--            end if;
--        end if;
--    end process;
--
--    -- PrSv_RomAgcAddr_s
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_RomAgcAddr_s <= "011";
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_AgcState_s = "010") then 
--                if (PrSv_RomAddr_s = "000") then
--                    PrSv_RomAgcAddr_s <= "001";
--                elsif (PrSv_RomAddr_s = "111") then
--                    PrSv_RomAgcAddr_s <= "110";
--                else
--                    PrSv_RomAgcAddr_s <= PrSv_RomAddr_s;
--                end if;
--            else -- hold
--            end if;
--        end if;
--    end process;
--    
--    -- PrSv_RomData_s
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then
--            PrSv_RomData_s <= x"2CD";
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_AgcState_s = "011") then
--                PrSv_RomData_s <= PrSv_RomAgcData_s;
--            else -- hold
--            end if;
--        end if;
--    end process;
    
    -- CpSl_VolAgcTrig_o
    -- CpSv_VolAgcData_o
--    process (CpSl_Rst_iN,CpSl_Clk_i) begin
--        if (CpSl_Rst_iN = '0') then 
--            CpSl_VolAgcTrig_o <= '0';
--            CpSv_VolAgcData_o <= (others => '0');
--        elsif rising_edge(CpSl_Clk_i) then
--            if (PrSv_AgcState_s = "100") then
--                CpSl_VolAgcTrig_o <= '1';
--                CpSv_VolAgcData_o <= PrSv_RomData_s;
--            else
--                CpSl_VolAgcTrig_o <= '0';
--                CpSv_VolAgcData_o <= PrSv_RomData_s;
--            end if;
--        end if;
--    end process;

----------------------------------------
-- End
----------------------------------------
end arch_M_VolAgc;