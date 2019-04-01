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
-- �ļ�����  :  M_CtrlTime.vhd
-- ��    ��  :  zhang wenjun
-- ��    ��  :  wenjun.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2018/05/17
-- ���ܼ���  :
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all; 

entity M_CtrlTime is
    port (
        --------------------------------
        -- Reset & Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset, active low
        CpSl_Clk_i                      : in  std_logic;                        -- 40MHz Clock,single

        --------------------------------
        -- GPS_Time
        --------------------------------
        CpSl_TimeDvld_i                 : in  std_logic;                        -- Parallel Time data valid
        CpSv_YmdHmsData_i               : in  std_logic_vector(79 downto 0);    -- Parallel YmdHms data
        CpSl_GpsPPS_i                   : in  std_logic;                        -- GPS_PPS

        --------------------------------
        -- Out_Time
        --------------------------------
        CpSv_Lock_o                     : out std_logic_vector( 1 downto 0);    -- GPS Locked State
        CpSv_UdpTimeData_o              : out std_logic_vector(79 downto 0)     -- UDP Time Data
    );
end M_CtrlTime;

architecture arch_M_CtrlTime of M_CtrlTime is
    ----------------------------------------------------------------------------
    -- constant describe
    ----------------------------------------------------------------------------
    --Init_Time_1970_1_1_00_00_00
    constant PrSv_UTCYmdHms_c           : std_logic_vector(47 downto 0) := x"460101000000";
    constant PrSv_IdleYear_c            : std_logic_vector( 7 downto 0) := x"46";   -- Year
    constant PrSv_IdleMonth_c           : std_logic_vector( 7 downto 0) := x"01";   -- Month
    constant PrSv_IdleDay_c             : std_logic_vector( 7 downto 0) := x"01";   -- Day
    constant PrSv_IdleHour_c            : std_logic_vector( 7 downto 0) := x"00";   -- Hour
    constant PrSv_IdleMin_c             : std_logic_vector( 7 downto 0) := x"00";   -- Min
    constant PrSv_IdleSec_c             : std_logic_vector( 7 downto 0) := x"00";   -- Sec
    constant PrSv_IdleMs_c              : std_logic_vector(15 downto 0) := x"0000"; -- Ms_0000
    constant PrSv_IdleUs_c              : std_logic_vector(15 downto 0) := x"0000"; -- us_0000
    constant PrSv_NcoCnt_c              : std_logic_vector(26 downto 0) := "110"& x"666666";    -- 107374182
    constant PrSv_40MHzCnt_c            : std_logic_vector(25 downto 0) := "10" & x"6259FF";    -- 40000000
    constant PrSv_40MDlyCnt_c           : std_logic_vector(25 downto 0) := "10" & x"625A0A";    -- 40000010
    constant PrSv_999Cnt_c              : std_logic_vector(15 downto 0) := x"03E7";         -- 999

    -- Init Year
    constant PrSv_InitTime_c            : std_logic_vector(79 downto 0) := x"46010100000000000000"; -- 70010100000000
    ----------------------------------------------------------------------------
    -- component describe
    ----------------------------------------------------------------------------
    component M_Mult is
    port (
		dataa		                    : IN  STD_LOGIC_VECTOR (26 DOWNTO 0);
		datab		                    : IN  STD_LOGIC_VECTOR (25 DOWNTO 0);
		result		                    : OUT STD_LOGIC_VECTOR (52 DOWNTO 0)
	);
    end component;

    component M_DivClk is
    port (
		denom		                    : IN  STD_LOGIC_VECTOR (25 DOWNTO 0);
		numer		                    : IN  STD_LOGIC_VECTOR (55 DOWNTO 0);
		quotient	                    : OUT STD_LOGIC_VECTOR (55 DOWNTO 0);
		remain		                    : OUT STD_LOGIC_VECTOR (25 DOWNTO 0)
	);
    end component;

    component M_NCO is
    port (
        clk                             : in  std_logic                     := 'X';             -- clk
        reset_n                         : in  std_logic                     := 'X';             -- reset_n
        clken                           : in  std_logic                     := 'X';             -- clken
        phi_inc_i                       : in  std_logic_vector(31 downto 0) := (others => 'X'); -- phi_inc_i
        fsin_o                          : out std_logic_vector(17 downto 0);                    -- fsin_o
        out_valid                       : out std_logic                                         -- out_valid
    );
    end component;

    ----------------------------------------------------------------------------
    -- singal describe
    ----------------------------------------------------------------------------
    signal PrSv_TotalNum_s              : std_logic_vector(52 downto 0);        -- Total Number
    signal PrSv_40MCnt_s                : std_logic_vector(25 downto 0);        -- 40MHz 1s Cnt
    signal PrSv_NCONum_s                : std_logic_vector(25 downto 0);        -- NCO_Cnt
    signal PrSv_DivNcoCnt_s             : std_logic_vector(55 downto 0);        -- NCO_Time
    signal PrSv_Fsin_s                  : std_logic_vector(17 downto 0);        -- NCO_Fsin
    signal PrSv_FsinVld_s               : std_logic;                            -- NCO_Fsin_Valid
    signal PrSl_PPSDly1_s               : std_logic;                            -- CpSl_GpsPPS_i Delay 1 Clk
    signal PrSl_PPSDly2_s               : std_logic;                            -- CpSl_GpsPPS_i Delay 2 Clk
    signal PrSl_PPSTrigvld_s            : std_logic;                            -- PPS_Trig_Valid
    signal PrSl_PPSTrig_s               : std_logic;                            -- PPS Trig
    signal PrSv_LockTime_s              : std_logic_vector(79 downto 0);        -- GPS Locked Time
    signal PrSv_UtcTime_s               : std_logic_vector(79 downto 0);        -- Utc Time(Ymd_Hms_ms_us)
    signal PrSv_UdpTimeData_s           : std_logic_vector(79 downto 0);        -- UDP_TimeData
    signal PrSv_UtcUs_s                 : std_logic_vector(15 downto 0);        -- Utc_Us
    signal PrSv_SimTotalNum             : std_logic_vector(55 downto 0);        -- Sim Tota Number

    -- GPS State
    signal PrSv_GpsState_s              : std_logic_vector( 2 downto 0);        -- GPS State
    signal PrSl_SinDly1_s               : std_logic;                            -- Delay Sin 1Clk
    signal PrSv_SinDly2_s               : std_logic;                            -- Delay Sin 2Clk
    signal PrSl_SinTrig_s               : std_logic;                            -- Sin_Trig
    signal PrSl_SinVld_s                : std_logic;                            -- Sin_Valid
    signal PrSv_UtcYear_s               : std_logic_vector( 7 downto 0);        -- Year
    signal PrSv_UtcMonth_s              : std_logic_vector( 7 downto 0);        -- Month
    signal PrSv_MonthVld_s              : std_logic;                            -- Month_Valid
    signal PrSv_UtcDay_s                : std_logic_vector( 7 downto 0);        -- Day
    signal PrSv_DayVld_s                : std_logic;                            -- Day_Valid
    signal PrSv_UtcHour_s               : std_logic_vector( 7 downto 0);        -- Hour
    signal PrSv_HourVld_s               : std_logic;                            -- Hour_Valid
    signal PrSv_UtcMin_s                : std_logic_vector( 7 downto 0);        -- Min
    signal PrSl_MinVld_s                : std_logic;                            -- Min_Valid
    signal PrSv_UtcSec_s                : std_logic_vector( 7 downto 0);        -- Sec
    signal PrSl_SecVld_s                : std_logic;                            -- Sec_Valid
    signal PrSv_UtcMs_s                 : std_logic_vector(15 downto 0);        -- Ms_0000
    signal PrSl_MsVld_s                 : std_logic;                            -- ms_Valid

    -- Simulation
    signal PrSv_SimCnt_s                : std_logic_vector( 5 downto 0);        -- simulation
    signal PrSl_SimWave_s               : std_logic;                            -- Simulation_Wave

begin
    ----------------------------------------------------------------------------
    -- component map
    ----------------------------------------------------------------------------
    U_M_Mult_0 : M_Mult
    port map (
		dataa		                    => PrSv_NcoCnt_c                        , -- IN  STD_LOGIC_VECTOR (26 DOWNTO 0);
		datab		                    => PrSv_40MHzCnt_c                      , -- IN  STD_LOGIC_VECTOR (25 DOWNTO 0);
		result		                    => PrSv_TotalNum_s                        -- OUT STD_LOGIC_VECTOR (52 DOWNTO 0)
	);

    PrSv_SimTotalNum <= "000" & PrSv_TotalNum_s;
    U_M_DivClk_0 : M_DivClk
    port map (
		denom		                    => PrSv_NCONum_s                        , -- IN  STD_LOGIC_VECTOR (25 DOWNTO 0);
		numer		                    => PrSv_SimTotalNum                     , -- IN  STD_LOGIC_VECTOR (55 DOWNTO 0);
		quotient	                    => PrSv_DivNcoCnt_s                     , -- OUT STD_LOGIC_VECTOR (55 DOWNTO 0);
		remain		                    => open                                   -- OUT STD_LOGIC_VECTOR (25 DOWNTO 0)
	);

    U_M_NCO_0 : M_NCO
    port map (
        clk                             => CpSl_Clk_i                           , -- clk.clk
        reset_n                         => CpSl_Rst_iN                          , -- rst.reset_n
        clken                           => '1'                                  , -- in.clken  -- '1'
        phi_inc_i                       => PrSv_DivNcoCnt_s(31 downto 0)        , -- .phi_inc_i
        fsin_o                          => open,    -- PrSv_Fsin_s                          , -- out.fsin_o
        out_valid                       => open     -- PrSv_FsinVld_s                         -- .out_valid
    );

    ----------------------------------------------------------------------------
    -- Main describe
    ----------------------------------------------------------------------------
    -- simulation
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_SimCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_SimCnt_s = 39) then
                PrSv_SimCnt_s <= (others => '0');
            else
                PrSv_SimCnt_s <= PrSv_SimCnt_s + '1';
            end if;
        end if;
    end process;

    -- PrSl_SimWave_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_SimWave_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_SimCnt_s = 1) then
                PrSl_SimWave_s <= '0';
            elsif (PrSv_SimCnt_s = 20) then
                PrSl_SimWave_s <= '0';
            else -- hold
            end if;
        end if;
    end process;

    PrSv_Fsin_s(17) <= PrSl_SimWave_s;
    PrSv_Fsin_s(16 downto 0) <= (others => '0');
    PrSv_FsinVld_s  <= '1';

    -- CpSl_TimeDvld_i
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_LockTime_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_TimeDvld_i = '1') then
                PrSv_LockTime_s <= CpSv_YmdHmsData_i;
            else -- hold
            end if;
        end if;
    end process;

    -- CpSl_GpsPPS_i Delay 2 Clk
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_PPSDly1_s <= '0';
            PrSl_PPSDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_PPSDly1_s <= CpSl_GpsPPS_i;
            PrSl_PPSDly2_s <= PrSl_PPSDly1_s;
        end if;
    end process;
    -- PrSl_PPSTrigvld_s
    PrSl_PPSTrigvld_s <= '1' when(PrSl_PPSDly1_s = '0' and CpSl_GpsPPS_i = '1') else '0';
        
    -- PrSl_PPSTrig_s
    PrSl_PPSTrig_s <= '1' when(PrSl_PPSDly2_s = '0' and PrSl_PPSDly1_s = '1') else '0';

    -- PrSv_GpsState_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_GpsState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_GpsState_s is
                when "000" => -- Idle
                    if (PrSl_PPSTrig_s = '1') then
                        PrSv_GpsState_s <= "001";
                    else -- hold
                    end if;
                when "001" => -- PPS_Trig
                    if (PrSv_40MCnt_s = PrSv_40MDlyCnt_c) then
                        PrSv_GpsState_s <= "010";
                    else -- hold
                    end if;

                when "010" => -- Unlock
                    if (PrSl_PPSTrig_s = '1') then
                        PrSv_GpsState_s <= "001";
                    else -- hold
                    end if;
                when others => PrSv_GpsState_s <= (others => '0');
            end case;
        end if;
    end process;

    -- CpSv_Lock_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_Lock_o <= "00";
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_GpsState_s = "000") then
                CpSv_Lock_o <= "00";
            elsif (PrSv_GpsState_s = "001") then
                CpSv_Lock_o <= "01";
            elsif (PrSv_GpsState_s = "010") then
                CpSv_Lock_o <= "10";
            else
                CpSv_Lock_o <= "00";
            end if;
        end if;
    end process;

    -- PrSv_40MCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_40MCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_PPSTrig_s = '1') then
                PrSv_40MCnt_s <= (others => '0');
            elsif (PrSv_GpsState_s = "001") then
                PrSv_40MCnt_s <= PrSv_40MCnt_s + '1';
            else
                PrSv_40MCnt_s <= (others => '0');
            end if;
        end if;
    end process;

    -- PrSv_NCONum_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_NCONum_s <= PrSv_40MHzCnt_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_GpsState_s = "001") then
                if (PrSl_PPSTrigvld_s = '1') then
                    PrSv_NCONum_s <= PrSv_40MCnt_s;
                else -- hold
                end if;
            else
                PrSv_NCONum_s <= PrSv_40MHzCnt_c;
            end if;
        end if;
    end process;

    ------------------------------------
    -- GPS_Time
    ------------------------------------
    -- PrSl_SinDly1_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_SinDly1_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_SinDly1_s <= PrSv_Fsin_s(17);
        end if;
    end process;
    -- PrSl_SinTrig_s
    PrSl_SinTrig_s <= '1' when (PrSl_SinDly1_s = '0' and PrSv_Fsin_s(17) = '1') else '0';

    -- PrSl_SinVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_SinVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_FsinVld_s = '1') then
                if (PrSl_SinTrig_s = '1') then
                    PrSl_SinVld_s <= '1';
                else
                    PrSl_SinVld_s <= '0';
                end if;
            else  -- hold
            end if;
        end if;
    end process;

    -- PrSv_UtcTime_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcTime_s <= PrSv_UTCYmdHms_c & PrSv_IdleMs_c & PrSv_UtcUs_s;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_PPSTrig_s = '1') then
                PrSv_UtcTime_s <= PrSv_LockTime_s;
--                PrSv_UtcTime_s <= PrSv_UTCYmdHms_c & PrSv_IdleMs_c & PrSv_UtcUs_s;
            else
                PrSv_UtcTime_s <= PrSv_UdpTimeData_s;
            end if;
        end if;
    end process;

    -- PrSv_UtcUs_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
--            PrSv_UtcUs_s <= PrSv_999Cnt_c - 1;
            PrSv_UtcUs_s <= PrSv_IdleUs_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_SinVld_s = '1') then
                if (PrSv_UtcUs_s = PrSv_999Cnt_c) then
--                    PrSv_UtcUs_s <= PrSv_999Cnt_c - 1;
                    PrSv_UtcUs_s <= (others => '0');
                else
                    PrSv_UtcUs_s <= PrSv_UtcUs_s + '1';
                end if;
            else  -- hold
            end if;
        end if;
    end process;

    -- PrSv_UtcMs_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcMs_s <= PrSv_IdleMs_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_SinVld_s = '1') then
                if (PrSv_UtcUs_s = PrSv_999Cnt_c) then
                    if (PrSv_UtcTime_s(31 downto 16) = PrSv_999Cnt_c) then
--                        PrSv_UtcMs_s <= PrSv_999Cnt_c;
                        PrSv_UtcMs_s <= (others => '0');
                    else
                        PrSv_UtcMs_s <= PrSv_UtcTime_s(31 downto 16) + '1';
                    end if;
                else -- hold
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSl_MsVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_MsVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_UtcUs_s = PrSv_999Cnt_c and PrSv_UtcTime_s(31 downto 16) = PrSv_999Cnt_c) then
                PrSl_MsVld_s <= '1';
            else
                PrSl_MsVld_s <= '0';
            end if;
        end if;
    end process;

    -- PrSv_UtcSec_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcSec_s <= PrSv_IdleSec_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_SinVld_s = '1' and PrSl_MsVld_s = '1') then
                if (PrSv_UtcTime_s(39 downto 32) = 59) then
--                    PrSv_UtcSec_s <= x"3A";
                    PrSv_UtcSec_s <= (others => '0');
                else
                    PrSv_UtcSec_s <= PrSv_UtcTime_s(39 downto 32) + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSl_SecVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_SecVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_MsVld_s = '1' and PrSv_UtcTime_s(39 downto 32) = 59) then
                PrSl_SecVld_s <= '1';
            else
                PrSl_SecVld_s <= '0';
            end if;
        end if;
    end process;

    -- PrSv_UtcMin_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcMin_s <= PrSv_IdleMin_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_SinVld_s = '1' and PrSl_SecVld_s = '1') then
                if (PrSv_UtcTime_s(47 downto 40) = 59) then
--                    PrSv_UtcMin_s <= x"3A";
                    PrSv_UtcMin_s <= (others => '0');
                else
                    PrSv_UtcMin_s <= PrSv_UtcTime_s(47 downto 40) + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSl_MinVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_MinVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_SecVld_s = '1' and PrSv_UtcTime_s(47 downto 40) = 59) then
                PrSl_MinVld_s <= '1';
            else
                PrSl_MinVld_s <= '0';
            end if;
        end if;
    end process;

    -- PrSv_UtcHour_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcHour_s <= PrSv_IdleHour_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_SinVld_s = '1' and PrSl_MinVld_s = '1') then
                if (PrSv_UtcTime_s(55 downto 48) = 23) then
--                    PrSv_UtcHour_s <= x"16";
                    PrSv_UtcHour_s <= (others => '0');
                else
                    PrSv_UtcHour_s <= PrSv_UtcTime_s(55 downto 48) + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_HourVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_HourVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_MinVld_s = '1' and PrSv_UtcTime_s(55 downto 48) = 23) then
                PrSv_HourVld_s <= '1';
            else
                PrSv_HourVld_s <= '0';
            end if;
        end if;
    end process;

    -- PrSv_UtcDay_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcDay_s <= PrSv_IdleDay_c;
        elsif rising_edge(CpSl_Clk_i) then
        if (PrSl_SinVld_s = '1' and PrSv_HourVld_s = '1') then 
            if (PrSv_UtcTime_s(71 downto 64) = 2) then 
                if (PrSv_UtcTime_s(73 downto 72) = "00") then 
                    if (PrSv_UtcTime_s(63 downto 56) = 29) then
                        PrSv_UtcDay_s <= x"01";
                    else
                        PrSv_UtcDay_s <= PrSv_UtcTime_s(63 downto 56) + '1';
                    end if;
                else
                    if (PrSv_UtcTime_s(63 downto 56) = 28) then
                        PrSv_UtcDay_s <= x"01";
                    else 
                        PrSv_UtcDay_s <= PrSv_UtcTime_s(63 downto 56) + '1';
                    end if;
                end if;
            elsif (PrSv_UtcTime_s(71 downto 64) = 4 or PrSv_UtcTime_s(71 downto 64) = 6 or PrSv_UtcTime_s(71 downto 64) = 9
                        or PrSv_UtcTime_s(71 downto 64) = 11) then
                if (PrSv_UtcTime_s(63 downto 56) = 30) then
                    PrSv_UtcDay_s <= x"01";
                else 
                    PrSv_UtcDay_s <= PrSv_UtcTime_s(63 downto 56) + '1';
                end if;
            else
                if (PrSv_UtcTime_s(63 downto 56) = 31) then
                    PrSv_UtcDay_s <= x"01";
                else 
                    PrSv_UtcDay_s <= PrSv_UtcTime_s(63 downto 56) + '1';
                end if;
            end if;
        end if;
        else -- hold
        end if;
    end process;

    -- PrSv_DayVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_DayVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
        if (PrSv_HourVld_s = '1') then 
            if (PrSv_UtcTime_s(71 downto 64) = 2) then 
                if (PrSv_UtcTime_s(73 downto 72) = "00") then 
                    if (PrSv_UtcTime_s(63 downto 56) = 29) then
                        PrSv_DayVld_s <= '1';
                    else 
                        PrSv_DayVld_s <= '0';
                    end if;
                else
                    if (PrSv_UtcTime_s(63 downto 56) = 28) then
                        PrSv_DayVld_s <= '1';
                    else 
                        PrSv_DayVld_s <= '0';
                    end if;
                end if;
            elsif (PrSv_UtcTime_s(71 downto 64) = 4 or PrSv_UtcTime_s(71 downto 64) = 6 or PrSv_UtcTime_s(71 downto 64) = 9
                        or PrSv_UtcTime_s(71 downto 64) = 11) then
                if (PrSv_UtcTime_s(63 downto 56) = 30) then
                    PrSv_DayVld_s <= '1';
                else 
                    PrSv_DayVld_s <= '0';
                end if;
            else
                if (PrSv_UtcTime_s(63 downto 56) = 31) then
                    PrSv_DayVld_s <= '1';
                else 
                    PrSv_DayVld_s <= '0';
                end if;
            end if;
          else
            PrSv_DayVld_s <= '0';
        end if;
        else -- hold
        end if;
    end process;

    -- PrSv_UtcMonth_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_UtcMonth_s <= PrSv_IdleMonth_c;
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_SinVld_s = '1' and PrSv_DayVld_s = '1') then
                if (PrSv_UtcTime_s(71 downto 64) = 12) then
--                    PrSv_UtcMonth_s <= x"0B";
                    PrSv_UtcMonth_s <= x"01";
                else
                    PrSv_UtcMonth_s <= PrSv_UtcTime_s(71 downto 64) + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;

    -- PrSv_MonthVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
            PrSv_MonthVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_DayVld_s = '1' and PrSv_UtcTime_s(71 downto 64) = 12) then
                PrSv_MonthVld_s <= '1';
            else
                PrSv_MonthVld_s <= '0';
            end if;
        end if;
    end process;

    -- PrSv_UtcYear_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_UtcYear_s <= PrSv_IdleYear_c;
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_SinVld_s = '1' and PrSv_MonthVld_s = '1') then 
                if (PrSv_UtcTime_s(79 downto 72) = 99) then 
                    PrSv_UtcYear_s <= (others => '0');
                else
                    PrSv_UtcYear_s <= PrSv_UtcYear_s + '1';
                end if;
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSv_UdpTimeData_s
--    PrSv_UdpTimeData_s <= PrSv_UTCYmdHms_c & PrSv_IdleMs_c & PrSv_IdleUs_c;
    PrSv_UdpTimeData_s <= PrSv_UtcYear_s & PrSv_UtcMonth_s & PrSv_UtcDay_s & PrSv_UtcHour_s
                         & PrSv_UtcMin_s & PrSv_UtcSec_s & PrSv_UtcMs_s & PrSv_UtcUs_s;


    ------------------------------------
    -- OutPut_UDP_Time
    ------------------------------------
    CpSv_UdpTimeData_o <= PrSv_UdpTimeData_s;

----------------------------------------------------------------------------
-- End
----------------------------------------------------------------------------
end arch_M_CtrlTime;