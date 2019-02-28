--------------------------------------------------------------------------------
--           *****************          *****************
--                           **        **
--               ***          **      **           **
--              *   *          **    **           * *
--             *     *          **  **              *
--             *     *           ****               *
--             *     *          **  **              *
--              *   *          **    **             *
--               ***          **      **          *****
--                           **        **
--           *****************          *****************
--------------------------------------------------------------------------------
-- 版    权  :  BiXing Tech
-- 文件名称  :  M_ProcCtrlCell.vhd
-- 设    计  :  Wu Xiaopeng
-- 邮    件  :  zheng-jianfeng@139.com
-- 校    对  :
-- 设计日期  :  2017/01/27
-- 功能简述  :
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, Wu Xiaopeng, 2017/01/27
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_1164.all;
use work.M_Package.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity M_ProcCtrlCell is
port (
    ------------------------------------
    -- Clock, Reset
    ------------------------------------
    CpSl_Clk65M_i                       : in  std_logic;
    CpSl_Rst65M_iN                      : in  std_logic;

    ------------------------------------
    -- Parameters
    ------------------------------------
    CpSv_RisingTimeL_i                  : in  std_logic_vector( 7 downto 0);
    CpSv_RisingTimeH_i                  : in  std_logic_vector( 7 downto 0);
    CpSv_ThreholdL_i                    : in  std_logic_vector(15 downto 0);
    CpSv_ThreholdH_i                    : in  std_logic_vector(15 downto 0);
    CpSv_ThreholdT_i                    : in  std_logic_vector(15 downto 0);

    ------------------------------------
    -- Refer pulse
    ------------------------------------
    CpSv_RefPulseAddr_o                 : out std_logic_vector( 8 downto 0);
    CpSv_RefPulseData_i                 : in  std_logic_vector(15 downto 0);
    CpSv_RefPulseRisingNum_i            : in  std_logic_vector( 8 downto 0);

    CpSv_RefPeak_i                      : in  std_logic_vector(15 downto 0);

    ------------------------------------
    -- Data
    ------------------------------------
    CpSv_DataE_i                        : in  std_logic_vector(15 downto 0);
    CpSv_DataENext_o                    : out std_logic_vector(15 downto 0);

    ------------------------------------
    -- Control
    ------------------------------------
    CpSl_LoadCapResult_i                : in  std_logic;

    ------------------------------------
    -- Control output
    ------------------------------------
    CpSl_SepRisingTick_o                : out std_logic;
    CpSl_SeparateFlag_o                 : out std_logic;
    CpSl_SeparateFlagDly1_o             : out std_logic;
    CpSl_SeparateFlagDly2_o             : out std_logic;
    CpSl_SeparateFlagDly3_o             : out std_logic;
    CpSl_EventDiscard_o                 : out std_logic;
    CpSl_EventStack_o                   : out std_logic;                        -- Event stack
    CpSv_RisingTimeCnt_o                : out std_logic_vector( 7 downto 0);
    
    CpSv_PeaKData_o                     : out std_logic_vector(15 downto 0);
    CpSl_PeakValid_o                    : out std_logic

    );
end M_ProcCtrlCell;

architecture Behavioral of M_ProcCtrlCell is
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- component declaration
    ----------------------------------------------------------------------------

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------

    signal PrAr_DataEAry_s              : std_logic_vector_DlyNum_16;
    signal PrAr_ProcState_s             : std_logic_vector_DlyNum_6 := (others => (others => '0'));                             --
    signal PrSv_PeakData_s              : std_logic_vector(15 downto 0);                            --
    signal PrSv_PeakDataReg_s           : std_logic_vector(15 downto 0) := (others => '0');
    signal PrSl_PeakValid_s             : std_logic;
    signal PrSl_RisingDiscard_s         : std_logic;
    signal PrSl_PeakDiscard_s           : std_logic;
    signal PrSl_FaillingStack_s         : std_logic;
    signal PrSl_FaillBackT_s            : std_logic;
    signal PrSv_RisingFlags_s           : std_logic_vector((PrIn_DataDlyNum_c-1) downto 0);
    signal PrSl_RisingFlagRising_s      : std_logic := '0';
    signal PrSl_RisingFlagFaill_s       : std_logic := '0';
    signal PrSl_RisingEdge_s            : std_logic := '0';
--    signal PrSl_RisingFlagDly1Faill_s   : std_logic;
    signal PrSv_RisingTimeCnt_s         : std_logic_vector( 7 downto 0) := x"08";                                       -- Because of Continuously rising 8 times, start at 8
    signal PrSl_SeparateFlag_s          : std_logic;
    signal PrSl_SeparateFlagDly1_s      : std_logic;
    signal PrSl_SeparateFlagDly2_s      : std_logic;
    signal PrSl_SeparateFlagDly3_s      : std_logic;
    signal PrSv_RefPulseAddr_s          : std_logic_vector( 8 downto 0);                                                --
    signal PrSl_SepRisingTick_s         : std_logic;
    signal PrSv_AdjustData_s            : std_logic_vector(15 downto 0);

    signal PrIn_RefPeakTemp_s           : integer := 0;
    signal PrIn_RefDataTemp_s           : integer := 0;
    signal PrIn_PeakTemp_s              : integer := 0;
    signal PrIn_DataTemp_s              : integer := 0;
    signal PrIn_AdjustDataTemp_s        : integer := 0;



begin
    ----------------------------------------------------------------------------
    -- Code
    ----------------------------------------------------------------------------

    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrAr_DataEAry_s(0) <= (others => '0');
        elsif rising_edge(CpSl_Clk65M_i) then
            PrAr_DataEAry_s(0)  <= CpSv_DataE_i;
        else
        end if;
    end process;

    DataShift : for i in (PrIn_DataDlyNum_c - 2) downto 0 generate
        process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
            if (CpSl_Rst65M_iN = '0') then
                PrAr_DataEAry_s(i+1) <= (others => '0');
            elsif rising_edge(CpSl_Clk65M_i) then
                PrAr_DataEAry_s(i+1) <= PrAr_DataEAry_s(i);
            else
            end if;
        end process;

        process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
            if (CpSl_Rst65M_iN = '0') then
                PrSv_RisingFlags_s(i+1) <= '0';
            elsif rising_edge(CpSl_Clk65M_i) then
                PrSv_RisingFlags_s(i+1) <= PrSv_RisingFlags_s(i);
            else
            end if;
        end process;

        process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
            if (CpSl_Rst65M_iN = '0') then
                PrAr_ProcState_s(i+1) <= (others => '0');
            elsif rising_edge(CpSl_Clk65M_i) then
                PrAr_ProcState_s(i+1) <= PrAr_ProcState_s(i);
            else
            end if;
        end process;

    end generate;

    ------------------------------------
    -- State machine
    ------------------------------------
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrAr_ProcState_s(0) <= (others => '0');
        elsif rising_edge(CpSl_Clk65M_i) then
            case PrAr_ProcState_s(0) is
                when b"00_0000" => -- idle
                    if (CpSl_LoadCapResult_i = '1') then
                        PrAr_ProcState_s(0) <= b"00_0001";
                    else
                    end if;
                when b"00_0001" => -- Rising edge
                    if (PrSl_RisingFlagFaill_s = '1') then
                        PrAr_ProcState_s(0) <= b"00_0010";
                    elsif (PrSl_RisingDiscard_s = '1') then
                        PrAr_ProcState_s(0) <= b"00_1000";
                    else
                    end if;
                when b"00_0010" => -- Peak
                    if (PrSl_PeakDiscard_s = '1') then
                        PrAr_ProcState_s(0) <= b"00_1000";
                    else
                        PrAr_ProcState_s(0) <= b"00_0100";
                    end if;
                when b"00_0100" => -- Failling edge
                    if (PrSl_FaillingStack_s = '1') then
                        PrAr_ProcState_s(0) <= b"01_0000";
                    elsif (PrSl_FaillBackT_s = '1') then
                        PrAr_ProcState_s(0) <= b"10_0000";
                    else
                    end if;
                when b"00_1000" => -- Discard the event for dismatch condition of rising
                    if (PrSl_FaillBackT_s = '1') then
                        PrAr_ProcState_s(0) <= b"10_0000";
                    else
                    end if;
                when b"01_0000" => -- Stacking in the failling edge
                    if (PrSl_FaillBackT_s = '1') then
                        PrAr_ProcState_s(0) <= b"10_0000";
                    else
                    end if;
                when b"10_0000" => -- End
                    if (CpSl_LoadCapResult_i = '1') then
                        PrAr_ProcState_s(0) <= b"00_0001";
                    else
                        PrAr_ProcState_s(0) <= b"00_0000";
                    end if;
                when others =>
            end case;
        else
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Processor of rising edge
    ----------------------------------------------------------------------------
    ------------------------------------
    -- Check rising edge
    ------------------------------------
    -- Continuously rise 8 times
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSv_RisingFlags_s(0) <= '0';
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrAr_ProcState_s(0)(0) = '1') then
                if (CpSv_ThreholdT_i < PrAr_DataEAry_s(7) and
                    PrAr_DataEAry_s(0) < CpSv_DataE_i and
                    PrAr_DataEAry_s(1) < PrAr_DataEAry_s(0) and
                    PrAr_DataEAry_s(2) < PrAr_DataEAry_s(1) and
                    PrAr_DataEAry_s(3) < PrAr_DataEAry_s(2) and
                    PrAr_DataEAry_s(4) < PrAr_DataEAry_s(3) and
                    PrAr_DataEAry_s(5) < PrAr_DataEAry_s(4) and
                    PrAr_DataEAry_s(6) < PrAr_DataEAry_s(5) and
                    PrAr_DataEAry_s(7) < PrAr_DataEAry_s(6)
                        ) then
                    PrSv_RisingFlags_s(0) <= '1';
                else
                    PrSv_RisingFlags_s(0) <= '0';
                end if;
            else
                PrSv_RisingFlags_s(0) <= '0';
            end if;
        else
        end if;
    end process;

    ------------------------------------
    -- Check peak
    ------------------------------------
    --Rising edge Failling edge of PrSv_RisingFlags_s
    PrSl_RisingFlagRising_s     <= PrSv_RisingFlags_s(0) and (not PrSv_RisingFlags_s(1));
    PrSl_RisingFlagFaill_s      <= (not PrSv_RisingFlags_s(0)) and PrSv_RisingFlags_s(1);
    PrSl_RisingEdge_s           <= '1' when PrSl_RisingFlagRising_s = '1' else
                                   '0' when PrSl_RisingFlagFaill_s = '1';
--    PrSl_RisingFlagDly1Faill_s  <= (not PrSv_RisingFlags_s(1)) and PrSv_RisingFlags_s(2);

    -- Catch the peak
--    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
--        if (CpSl_Rst65M_iN = '0') then
--            PrSl_PeakValid_s <= '0';
--            PrSv_PeaKData_s  <= (others => '0');
--        elsif rising_edge(CpSl_Clk65M_i) then
--            if (PrSl_RisingFlagFaill_s = '1') then
--                PrSl_PeakValid_s <= '1';
--                PrSv_PeaKData_s  <= PrAr_DataEAry_s(1);
--            elsif (PrAr_ProcState_s(0)(5) = '1') then
--                PrSl_PeakValid_s <= '0';
--                PrSv_PeaKData_s  <= (others => '0');
--            else
--            end if;
--        else
--        end if;
--    end process;

    process (CpSl_Rst65M_iN, PrSl_RisingFlagFaill_s, PrAr_ProcState_s(0)(5)) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSl_PeakValid_s <= '0';
            PrSv_PeaKData_s  <= (others => '0');
        elsif (PrSl_RisingFlagFaill_s = '1') then
            PrSl_PeakValid_s <= '1';
            PrSv_PeaKData_s  <= PrAr_DataEAry_s(0);
        else
            PrSl_PeakValid_s <= '0';
            PrSv_PeaKData_s  <= (others => '0');
        end if;
    end process;
    ------------------------------------
    -- Check if it is to be discarded or not
    ------------------------------------
    -- Rising time
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSv_RisingTimeCnt_s <= x"08";
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrSl_RisingEdge_s = '1') then
                PrSv_RisingTimeCnt_s <= PrSv_RisingTimeCnt_s + '1';
            elsif (PrAr_ProcState_s(0)(5) = '1') then
                PrSv_RisingTimeCnt_s <= x"08";
            else
            end if;
        else
        end if;
    end process;

    --
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSl_RisingDiscard_s <= '0';
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrSl_RisingEdge_s = '1') then
                if (PrSv_PeaKData_s > CpSv_ThreholdH_i or PrSv_RisingTimeCnt_s > CpSv_RisingTimeH_i) then
                    PrSl_RisingDiscard_s <= '1';
                else
                    PrSl_RisingDiscard_s <= '0';
                end if;
            else
                PrSl_RisingDiscard_s <= '0';
            end if;
        else
        end if;
    end process;

    --
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSl_PeakDiscard_s <= '0';
        elsif rising_edge(CpSl_Clk65M_i) then
--            if (PrSl_RisingFlagDly1Faill_s = '1') then
            if (PrSl_RisingFlagFaill_s = '1') then
                if (PrSv_PeaKData_s < CpSv_ThreholdL_i or PrSv_RisingTimeCnt_s < CpSv_RisingTimeL_i) then
                    PrSl_PeakDiscard_s <= '1';
                else
                    PrSl_PeakDiscard_s <= '0';
                end if;
            else
                PrSl_PeakDiscard_s <= '0';
            end if;
        else
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Processor of failling edge
    ----------------------------------------------------------------------------
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSl_FaillingStack_s <= '0';
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrAr_ProcState_s(0)(2) = '1') then
                if (CpSv_ThreholdT_i < CpSv_DataE_i and
                    PrAr_DataEAry_s(0) < CpSv_DataE_i
                    ) then
                    PrSl_FaillingStack_s <= '1';
                else
                end if;
            else
                PrSl_FaillingStack_s <= '0';
            end if;
        else
        end if;
    end process;

    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSl_FaillBackT_s <= '0';
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrAr_ProcState_s(0)(2) = '1' or
                PrAr_ProcState_s(0)(3) = '1' or
                PrAr_ProcState_s(0)(4) = '1'
                ) then
                if (CpSv_DataE_i < CpSv_ThreholdT_i) then
                    PrSl_FaillBackT_s <= '1';
                else
                end if;
            else
                PrSl_FaillBackT_s <= '0';
            end if;
        else
        end if;
    end process;

    ----------------------------------------------------------------------------
    -- Separating signal for data outputting
    ----------------------------------------------------------------------------
    -- Flag when to separate signal
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSl_SeparateFlag_s <= '0';
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrSl_SepRisingTick_s = '1') then
                if (PrAr_ProcState_s(0)(3) /= '1') then -- Don't discard
                    PrSl_SeparateFlag_s <= '1';
                else
                end if;
            elsif (PrSv_RefPulseAddr_s = PrSv_RefPulseDeep_c) then
                PrSl_SeparateFlag_s <= '0';
            else
            end if;
        else
        end if;
    end process;

    PrSl_SepRisingTick_s <= PrSv_RisingFlags_s(PrIn_DataDlyNum_c - 12) and (not PrSv_RisingFlags_s(PrIn_DataDlyNum_c - 11));

    -- Address of refer pulse ram
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSv_RefPulseAddr_s <= (others => '0');
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrSl_SepRisingTick_s = '1') then
                if (PrSv_RisingTimeCnt_s < CpSv_RefPulseRisingNum_i) then
                    PrSv_RefPulseAddr_s <= CpSv_RefPulseRisingNum_i - PrSv_RisingTimeCnt_s;
                else
                    PrSv_RefPulseAddr_s <= (others => '0');
                end if;
            elsif (PrSv_RefPulseAddr_s /= PrSv_RefPulseDeep_c) then
                PrSv_RefPulseAddr_s <= PrSv_RefPulseAddr_s + '1';
            else
            end if;
        else
        end if;
    end process;

    CpSv_RefPulseAddr_o <= PrSv_RefPulseAddr_s;

    -- Peak register
    PrSv_PeakDataReg_s <= PrSv_PeakData_s   when PrSl_PeakValid_s = '1' else
                          PrSv_PeakDataReg_s;

    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSl_SeparateFlagDly1_s <= '0';
            PrSl_SeparateFlagDly2_s <= '0';
            PrSl_SeparateFlagDly3_s <= '0';
        elsif rising_edge(CpSl_Clk65M_i) then
            PrSl_SeparateFlagDly1_s <= PrSl_SeparateFlag_s;
            PrSl_SeparateFlagDly2_s <= PrSl_SeparateFlagDly1_s;
            PrSl_SeparateFlagDly3_s <= PrSl_SeparateFlagDly2_s;
        else
        end if;
    end process;

    -- Signal minus pulse
--    process (CpSl_Clk65M_i, CpSl_Rst65M_iN)
--        variable PrIn_RefPeakTemp_v     : integer := 0;
--        variable PrIn_RefDataTemp_v     : integer := 0;
--        variable PrIn_PeakTemp_v        : integer := 0;
--        variable PrIn_DataTemp_v        : integer := 0;
--        variable PrIn_AdjustDataTemp_v  : integer := 0;
--    begin
--        if (CpSl_Rst65M_iN = '0') then
--            PrSv_AdjustData_s     <= (others => '0');
--            PrIn_RefPeakTemp_s    <= 1;
--            PrIn_RefDataTemp_s    <= 0;
--            PrIn_PeakTemp_s       <= 0;
--            PrIn_DataTemp_s       <= 0;
--            PrIn_AdjustDataTemp_s <= 0;
--        elsif rising_edge(CpSl_Clk65M_i) then
--            if (PrSl_SeparateFlag_s = '1') then
--                PrIn_RefPeakTemp_s      <= CONV_INTEGER(CpSv_RefPeak_i);
--                PrIn_RefDataTemp_s      <= CONV_INTEGER(CpSv_RefPulseData_i);
--                PrIn_PeakTemp_s         <= CONV_INTEGER(PrSv_PeakDataReg_s);
--                PrIn_DataTemp_s         <= CONV_INTEGER(PrAr_DataEAry_s(PrIn_DataDlyNum_c-4));
--
--                if (PrIn_AdjustDataTemp_s > 0) then
--                    PrSv_AdjustData_s   <= CONV_STD_LOGIC_VECTOR(PrIn_AdjustDataTemp_s,16);
--                else
--                    PrSv_AdjustData_s   <= (others => '0');
--                end if;
--
--            else
--                PrSv_AdjustData_s       <= (others => '0');
--            end if;
--        else
--        end if;
--    end process;

    process (CpSl_Clk65M_i, CpSl_Rst65M_iN)
    begin
        if (CpSl_Rst65M_iN = '0') then
            PrIn_RefPeakTemp_s    <= 1;
            PrIn_RefDataTemp_s    <= 0;
            PrIn_PeakTemp_s       <= 0;
            PrIn_DataTemp_s       <= 0;
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrSl_SeparateFlag_s = '1') then
                PrIn_RefPeakTemp_s      <= CONV_INTEGER(CpSv_RefPeak_i);
                PrIn_RefDataTemp_s      <= CONV_INTEGER(CpSv_RefPulseData_i);
                PrIn_PeakTemp_s         <= CONV_INTEGER(PrSv_PeakDataReg_s);
                PrIn_DataTemp_s         <= CONV_INTEGER(PrAr_DataEAry_s(PrIn_DataDlyNum_c-3));
            else
                PrIn_RefPeakTemp_s    <= 1;
                PrIn_RefDataTemp_s    <= 0;
                PrIn_PeakTemp_s       <= 0;
                PrIn_DataTemp_s       <= 0;
            end if;
        else
        end if;
    end process;

    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrIn_AdjustDataTemp_s <= 0;
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrSl_SeparateFlagDly1_s = '1') then
                PrIn_AdjustDataTemp_s   <= PrIn_DataTemp_s - ((PrIn_RefDataTemp_s * PrIn_PeakTemp_s) / PrIn_RefPeakTemp_s);
            else
                PrIn_AdjustDataTemp_s <= 0;
            end if;
        else
        end if;
    end process;

    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            PrSv_AdjustData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrSl_SeparateFlagDly2_s = '1') then
                if (PrIn_AdjustDataTemp_s > 0) then
                    PrSv_AdjustData_s   <= CONV_STD_LOGIC_VECTOR(PrIn_AdjustDataTemp_s,16);
                else
                    PrSv_AdjustData_s   <= (others => '0');
                end if;
            else
                PrSv_AdjustData_s <= (others => '0');
            end if;
        else
        end if;
    end process;

    -- Data output for next cell
    process (CpSl_Clk65M_i, CpSl_Rst65M_iN) begin
        if (CpSl_Rst65M_iN = '0') then
            CpSv_DataENext_o <= (others => '0');
        elsif rising_edge(CpSl_Clk65M_i) then
            if (PrAr_ProcState_s(0)(3) = '1' or PrAr_ProcState_s(PrIn_DataDlyNum_c-1)(3) = '1') then
                CpSv_DataENext_o <= (others => '0');
            else
                if (PrSl_SeparateFlagDly3_s = '1') then
                    CpSv_DataENext_o <= PrSv_AdjustData_s;
                else
                    CpSv_DataENext_o <= PrAr_DataEAry_s(PrIn_DataDlyNum_c-1);
                end if;
            end if;
        else
        end if;
    end process;
    
    -- Control output
    CpSl_SepRisingTick_o    <= PrSl_SepRisingTick_s   ;
    CpSl_SeparateFlag_o     <= PrSl_SeparateFlag_s    ;
    CpSl_SeparateFlagDly1_o <= PrSl_SeparateFlagDly1_s;
    CpSl_SeparateFlagDly2_o <= PrSl_SeparateFlagDly2_s;
    CpSl_SeparateFlagDly3_o <= PrSl_SeparateFlagDly3_s;
    CpSl_EventDiscard_o     <= PrAr_ProcState_s(0)(3) or PrAr_ProcState_s(PrIn_DataDlyNum_c-1)(3);
    CpSl_EventStack_o       <= PrAr_ProcState_s(PrIn_DataDlyNum_c-2)(4);
    CpSv_RisingTimeCnt_o    <= PrSv_RisingTimeCnt_s   ;

    CpSl_PeakValid_o    <= PrSl_PeakValid_s;
    CpSv_PeaKData_o     <= PrSv_PeaKData_s;

end Behavioral;
