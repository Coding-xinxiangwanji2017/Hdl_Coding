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
-- 文件名称  :  M_vhdl_coding_guideline.vhd
-- 设    计  :  LIU Hai 
-- 邮    件  :  zheng-jianfeng@139.com
-- 校    对  :
-- 设计日期  :  2006年5月16日
-- 功能简述  :  vhdl coding guidelin  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial ，修改者LIU Hai，修改日期2012年 5月16日
--              2. 修改内容，修改者LIU Hai，修改日期2012年 8月 1日 
--              3. 修改内容，修改者LIU Hai，修改日期2012年 8月 1日 
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity M_vhdl_coding_guideline is
    port 
    (
        ------------------------------------------------------------------------
        -- CpSl_TmpRst_s_i and clock
        ------------------------------------------------------------------------
        CpSl_Clk125M_i                  : in  std_logic;                        -- 125 MHz clock
        CpSl_Clk100M_i                  : in  std_logic;                        -- 100 MHz clock
        CpSl_Clkdiv3_i                  : in  std_logic;                        -- 125/3 MHz clock
        CpSl_Rst_iN                     : in  std_logic;                        -- active low        

        ------------------------------------------------------------------------
        -- VLAN access interface
        ------------------------------------------------------------------------
        CpSv_VlanAddr_i                 : in  std_logic_vector(11 downto 0);    -- hold for read         -- VLAN Adress
        CpSl_VlanWreq_i                 : in  std_logic;                        -- one 100MHz clock      -- VLAN Write request
        CpSv_VlanWdata_i                : in  std_logic_vector( 3 downto 0);    --                       -- VLAN Write data
        CpSl_VlanRreg_i                 : in  std_logic;                        -- one 100MHz clock      -- VLAN Read request
        CpSv_VlanRdata_o                : out std_logic_vector( 3 downto 0);    -- hold                  -- VLAN Read data
        CpSl_VlanRdone_o                : out std_logic;                        -- hold                  -- VLAN Read done

        ------------------------------------------------------------------------
        -- Port access interface
        ------------------------------------------------------------------------
        CpSl_P0Req_i                    : in  std_logic;                        -- one 125MHz clock      
        CpSl_P1Req_i                    : in  std_logic;                        -- one 125MHz clock
        CpSl_P2Req_i                    : in  std_logic;                        -- one 125MHz clock
        CpSl_P3Req_i                    : in  std_logic;                        -- one 125MHz clock      
        CpSv_P0Dmac_i                   : in  std_logic_vector(47 downto 0);    -- hold                  
        CpSv_P1Dmac_i                   : in  std_logic_vector(47 downto 0);    -- hold
        CpSv_P2Dmac_i                   : in  std_logic_vector(47 downto 0);    -- hold
        CpSv_P3Dmac_i                   : in  std_logic_vector(47 downto 0);    -- hold
        CpSv_P0Smac_i                   : in  std_logic_vector(47 downto 0);    -- hold
        CpSv_P1Smac_i                   : in  std_logic_vector(47 downto 0);    -- hold
        CpSv_P2Smac_i                   : in  std_logic_vector(47 downto 0);    -- hold
        CpSv_P3Smac_i                   : in  std_logic_vector(47 downto 0);    -- hold
        CpSl_P0VInd_i                   : in  std_logic;                        -- hold
        CpSl_P1VInd_i                   : in  std_logic;                        -- hold
        CpSl_P2VInd_i                   : in  std_logic;                        -- hold
        CpSl_P3VInd_i                   : in  std_logic;                        -- hold
        CpSv_P0Vlan_i                   : in  std_logic_vector(11 downto 0);    -- hold
        CpSv_P1Vlan_i                   : in  std_logic_vector(11 downto 0);    -- hold
        CpSv_P2Vlan_i                   : in  std_logic_vector(11 downto 0);    -- hold
        CpSv_P3Vlan_i                   : in  std_logic_vector(11 downto 0);    -- hold
        CpSv_TimeReg_i                  : in  std_logic_vector(31 downto 0)     -- time register              
        CpSl_P0Ack_o                    : out std_logic;                        -- one 125 clock
        CpSl_P1Ack_o                    : out std_logic;                        -- one 125 clock
        CpSl_P2Ack_o                    : out std_logic;                        -- one 125 clock
        CpSl_P3Ack_o                    : out std_logic;                        -- one 125 clock
        CpSv_P0Vec_o                    : out std_logic_vector( 3 downto 0);    -- hold
        CpSv_P1Vec_o                    : out std_logic_vector( 3 downto 0);    -- hold
        CpSv_P2Vec_o                    : out std_logic_vector( 3 downto 0);    -- hold
        CpSv_P3Vec_o                    : out std_logic_vector( 3 downto 0);    -- hold                             
    );
end M_vhdl_coding_guideline;

                

architecture arch_M_vhdl_coding_guideline of M_vhdl_coding_guideline is
  
    ----------------------------------------------------------------------------
    -- constant declaration
    ----------------------------------------------------------------------------
    constant PrSv_Time1s_c              : std_logic_vector(25 downto 0) := "10011110111100100001101001"; -- 10^9/24-1
    constant PrSv_P0Numb_c              : std_logic_vector( 3 downto 0) := "0001";                       -- P0 Number
    constant PrSv_P1Numb_c              : std_logic_vector( 3 downto 0) := "0010";
    constant PrSv_P2Numb_c              : std_logic_vector( 3 downto 0) := "0100";
    constant PrSv_P3Numb_c              : std_logic_vector( 3 downto 0) := "1000";

    ----------------------------------------------------------------------------
    -- component declaration
    ----------------------------------------------------------------------------
    component cam 
        generic 
        (
            FAMILY                      : string := "Cyclone IV";
            ENTRIES                     : integer:= 1024;
            KEY                         : integer:= 48
        );
        port
        ( -- 1024x48
            CpSl_Rst_i                  : in  std_logic;                        -- Async CpSl_Rst_i
            CpSl_WrClk_i                : in  std_logic;                        -- Port A - Write Clock
            CpSl_WrEn_i                 : in  std_logic;                        -- Port A - Write Enable
            CpSv_WrKey_i                : in  std_logic_vector(  47 downto 0);  -- Port A - Upper Write Address (CAM Key)
            CpSv_WrIndex_i              : in  std_logic_vector(   9 downto 0);  -- Port A - Lower Write Address (CAM Entry)
            CpSl_WrErase_iN             : in  std_logic;                        -- Port A - Write Data (1=add, 0=erase)
            CpSl_RdClk_i                : in  std_logic;                        -- Port B - Read Clock
            CpSl_RdEn_i                 : in  std_logic;                        -- Port B - Read Enable
            CpSv_RdKey_i                : in  std_logic_vector(  47 downto 0);  -- Port B - Read Address (CAM Key)
            CpSv_OneHotAddr_o           : out std_logic_vector(1023 downto 0);  -- One-hot data output (CAM Entry)
            CpSv_MatchAddr_o            : out std_logic_vector(   9 downto 0);  -- Encoded data output (CAM Entry)
            CpSl_Match_o                : out std_logic;                        -- Indicator for CAM Entry Match
            CpSl_MultiMatch_o           : out std_logic;                        -- Indicator for multiple CAM Entry Match
            CpSv_IndexReg_o             : out std_logic_vector(1023 downto 0);  -- CAM Entry scorecard register output
            CpSl_CamFull_o              : out std_logic;                        -- CAM Full (exceeded # of ENTRIES) indicator
            CpSl_MultiIndex_o           : out std_logic                         -- Indicator for multiple keys at same index
        );
    end component;

    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    -- CAM initial
    signal CpSl_TmpRst_s                 : std_logic;                            -- CpSl_Rst_i signal
                                                                          
    -- CAM request                                                        
    signal PrSv_CamRdyCnt_s             : std_logic_vector(25 downto 0);        -- CAM request signal
    signal PrSl_CamRdy_s                : std_logic;                            -- CAM request signal
    signal PrSl_CamIniDone_s            : std_logic;                            -- CAM request signal
    signal PrSv_CamIniCnt_s             : std_logic_vector( 9 downto 0);        -- CAM request signal
    signal CpSl_TmpCamWen_s             : std_logic;                            -- CAM request signal
    signal CpSv_TmpCamWaddr_s           : std_logic_vector( 9 downto 0);        -- CAM request signal
    signal CpSv_TmpCamWdata_s           : std_logic_vector(47 downto 0);        -- CAM request signal
    signal CpSl_TmpCamRaddr_s           : std_logic;                            -- CAM request signal
    signal CpSl_TmpCamRen_s             : std_logic;                            -- CAM request signal
    signal CpSv_TmpCamRaddr_s           : std_logic_vector( 9 downto 0);        -- CAM request signal
    signal CpSv_TmpCamRaddrDly1_s       : std_logic_vector( 9 downto 0);        -- CAM request signal
    signal CpSv_TmpCamRaddrDly2_s       : std_logic_vector( 9 downto 0);        -- CAM request signal
    signal CpSv_TmpCamRdata_s           : std_logic_vector(47 downto 0);        -- CAM request signal
    signal CpSl_TmpCamRmach_s           : std_logic;                            -- CAM read match
    signal CpSl_TmpCamRmachDly1_s       : std_logic;                            -- CAM read match

    -- VLAN request
    signal PrSv_VlanRregCnt_s           : std_logic_vector( 2 downto 0);        -- VLAN read request
    signal PrSl_VlanRreg_s              : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregDly1_s          : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregDly2_s          : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregHold_s          : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregSlot_s          : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregSlotDly1_s      : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregSlotDly2_s      : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregdoneDly1_s      : std_logic;                            -- VLAN read request
    signal PrSl_VlanRregDoneDly2_s      : std_logic;                            -- VLAN read request
    signal PrSl_VlanSch_s               : std_logic;                            -- VLAN read request
    signal PrSv_VlanSchAddr_s           : std_logic_vector(11 downto 0);        -- VLAN read request
                              
    -- Port request               
    signal PrSv_P0ReqCnt_s              : std_logic_vector( 5 downto 0);        -- Port 0 request
    signal PrSv_P1ReqCnt_s              : std_logic_vector( 5 downto 0);        -- Port 1 request
  

begin
    ----------------------------------------------------------------------------
    -- CAM initial by all 0
    ----------------------------------------------------------------------------
    -- CpSl_Rst_s_i for CAM
    CpSl_TmpRst_s <= not CpSl_Rst_iN;

    -- CAM ready after CpSl_Rst_s_i counter
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_CamRdyCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clkdiv3_i) then
            if (CpSv_CamRdyCnt_s = CpSv_Time1s_c) then
                CpSv_CamRdyCnt_s <= CpSv_CamRdyCnt_s;
            else
                CpSv_CamRdyCnt_s <= CpSv_CamRdyCnt_s + '1';
            end if;  
        end if;
    end process;

    -- CAM ready after CpSl_Rst_s_i
    PrSl_CamRdy_s <= '1' when CpSv_CamRdyCnt_s = CpSv_Time1s_c else '0';

    -- Gen CAM initial done
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_CamIniDone_s <=  '0';
        elsif rising_edge(CpSl_Clkdiv3_i) then
            if (PrSv_CamIniCnt_s = "1111111111") then
                PrSl_CamIniDone_s <= '1';
            else -- hold
            end if;
        end if;
    end process;                    

    -- Gen CAM initial counter
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin                                 
        if (CpSl_Rst_iN = '0') then
            PrSv_CamIniCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clkdiv3_i) then
            if (PrSl_CamRdy_s = '1') then
                if (PrSl_CamIniDone_s = '0') then
                    PrSv_CamIniCnt_s <= PrSv_CamIniCnt_s + '1';
                else
                    PrSv_CamIniCnt_s <= (others => '0');
                end if;
            else
                PrSv_CamIniCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    ----------------------------------------------------------------------------
    -- CAM instant
    ----------------------------------------------------------------------------
    U_cam_0 : cam 
        generic map 
        (
            FAMILY                    => "Cyclone IV",               -- string := "Cyclone IV";
            ENTRIES                   => 1024        ,               -- integer:= 1024;
            KEY                       => 48                          -- integer:= 48
        )
        port map 
        ( -- 1024x48
            CpSl_Rst_i                       => CpSl_TmpRst_s      , -- in  std_logic;                       -- Async CpSl_CpSl_TmpRst_s_i
            CpSl_WrClk_i                     => CpSl_Clkdiv3_i     , -- in  std_logic;                       -- Port A - Write Clock
            CpSl_WrEn_i                      => CpSl_TmpCamWen_s   , -- in  std_logic;                       -- Port A - Write Enable
            CpSv_WrKey_i                     => CpSv_TmpCamWdata_s , -- in  std_logic_vector(  47 downto 0); -- Port A - Upper Write Address (CAM Key)
            CpSv_WrIndex_i                   => CpSv_TmpCamWaddr_s , -- in  std_logic_vector(   9 downto 0); -- Port A - Lower Write Address (CAM Entry)
            CpSl_WrErase_iN                  => CpSl_TmpCamRaddr_s , -- in  std_logic;                       -- Port A - Write Data (1=add, 0=erase)
            CpSl_RdClk_i                     => CpSl_Clkdiv3_i     , -- in  std_logic;                       -- Port B - Read Clock
            CpSl_RdEn_i                      => CpSl_TmpCamRen_s   , -- in  std_logic;                       -- Port B - Read Enable
            CpSv_RdKey_i                     => CpSv_TmpCamRdata_s , -- in  std_logic_vector(  47 downto 0); -- Port B - Read Address (CAM Key)
            CpSv_OneHotAddr_o                => open               , -- out std_logic_vector(1023 downto 0); -- One-hot data output (CAM Entry)
            CpSv_MatchAddr_o                 => CpSv_TmpCamRaddr_s , -- out std_logic_vector(   9 downto 0); -- Encoded data output (CAM Entry)
            CpSl_Match_o                     => CpSl_TmpCamRmach_s , -- out std_logic;                       -- Indicator for CAM Entry Match
            CpSl_MultiMatch_o                => open               , -- out std_logic;                       -- Indicator for multiple CAM Entry Match
            CpSv_IndexReg_o                  => open               , -- out std_logic_vector(1023 downto 0); -- CAM Entry scorecard register output
            CpSl_CamFull_o                   => open               , -- out std_logic;                       -- CAM Full (exceeded # of ENTRIES) indicator
            CpSl_MultiIndex_o                => open                 -- out std_logic                        -- Indicator for multiple keys at same index
        );

    CpSl_TmpCamWen_s   <= PrSl_CamRdy_s         when PrSl_CamIniDone_s = '0' else p_cam_wen   ;
    CpSv_TmpCamWaddr_s <= PrSv_CamIniCnt_s      when PrSl_CamIniDone_s = '0' else p_cam_waddr ;
    CpSv_TmpCamWdata_s <= (others => '0')       when PrSl_CamIniDone_s = '0' else p_cam_wdata ;
    CpSl_TmpCamRaddr_s <= PrSl_CamRdy_s         when PrSl_CamIniDone_s = '0' else p_cam_raddr ;

    CpSl_TmpCamRen_s   <= p_sch      ;
    CpSv_TmpCamRdata_s <= p_sch_addr ;

    -- Delay
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_CpSlRst_iN = '0') then
            CpSl_TmpCamRmachDly1_s <= '0';
            CpSl_CamRmachDly2_s <= '0';

            CpSv_TmpCamRaddrDly1_s <= (others => '0');
            CpSv_TmpCamRaddrDly2_s <= (others => '0');
        elsif rising_edge(CpSl_Clkdiv3_i) then
            CpSl_TmpCamRmachDly1_s <= CpSl_TmpCamRmach_s   ;
            CpSl_CamRmachDly2_s <= CpSl_TmpCamRmachDly1_s;

            CpSv_TmpCamRaddrDly1_s <= CpSl_TmpCamRen_s   ;
            CpSv_TmpCamRaddrDly2_s <= CpSv_TmpCamRaddrDly1_s;
        end if;
    end process;
    
    CpSl_Rst_i <= CpSl_TmpRst_s;

    ----------------------------------------------------------------------------
    -- CAM RAM instant
    ----------------------------------------------------------------------------
    U_ram_1024x16_0 : ram_1024x16 
        port map 
        (
            clock                     => CpSl_Clkdiv3_i , -- in  std_logic := '1';
            wren                      => c_ram_wen      , -- in  std_logic := '0';
            wraddress                 => c_ram_waddr    , -- in  std_logic_vector( 9 downto 0);
            data                      => c_ram_wdata    , -- in  std_logic_vector(15 downto 0);
            rden                      => c_ram_ren      , -- in  std_logic := '1';
            rdaddress                 => c_ram_raddr    , -- in  std_logic_vector( 9 downto 0);
            q                         => c_ram_rdata      -- out std_logic_vector(15 downto 0)
        );

        c_ram_wen   <= p_c_ram_wen   ;
        c_ram_waddr <= p_c_ram_waddr ;
        c_ram_wdata <= p_c_ram_wdata ;
        c_ram_ren   <= '1'                     when a_req_slot_d5 = '1' else CpSl_TmpCamRmach_s;
        c_ram_raddr <= ageing_cnt( 9 downto 0) when a_req_slot_d5 = '1' else CpSl_TmpCamRen_s;

        -- Delay
        Cpocess (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
            if (CpSl_Rst_iN = '0') then
                c_ram_rdata_dly1 <= (others => '0');
            elsif rising_edge(CpSl_Clkdiv3_i) then
                c_ram_rdata_dly1 <= c_ram_rdata;
            end if;
        end Cpocess;
        

    ----------------------------------------------------------------------------
    -- VLAN Ram request
    ----------------------------------------------------------------------------
    -----------------------------------------
    -- CpSl_Clk100M_i
    -----------------------------------------
    -- VLAN read request
    process (CpSl_Rst_iN, CpSl_Clk100M_i) begin
        if (CpSl_Rst_iN = '0') then
            v_rreq_cnt <= (others => '1');
        elsif rising_edge(CpSl_Clk100M_i) then
            if (CpSl_Vlan_Rreg_i = '1') then
                v_rreq_cnt <= "000";
            elsif (v_rreq_cnt = "111") then
                v_rreq_cnt <= v_rreq_cnt;
            else
                v_rreq_cnt <= v_rreq_cnt + '1';
            end if;
        end if;
    end process;

    -- VLAN read request extend
    v_rreq_out <= '1' when v_rreq_cnt /= "111" else '0';

    -- Differ clock domain
    process (CpSl_Rst_iN, CpSl_Clk100M_i) begin
        if (CpSl_Rst_iN = '0') then
            v_rreq_done_dly1 <= '0';
            v_rreq_done_dly2 <= '0';
            v_rreq_done_d3   <= '0';
        elsif rising_edge(CpSl_Clk100M_i) then
            v_rreq_done_dly1 <= v_rreq_slot_d2;
            v_rreq_done_dly2 <= v_rreq_done_dly1;
            v_rreq_done_d3   <= v_rreq_done_d2;
        end if;
    end process;

    -- VLAN read result and done
    process (CpSl_Rst_iN, CpSl_Clk100M_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSv_Vlan_Rdata_o <= (others => '0');
            CpSl_Vlan_Rdone_o <= '0';
        elsif rising_edge(CpSl_Clk100M_i) then
            if (v_rreq_done_dly2= '1' and v_rreq_done_d3 = '0') then
                CpSv_Vlan_Rdata_o <= v_ram_rdata;
                CpSl_Vlan_Rdone_o <= '1';
            elsif (CpSl_Vlan_Rreg_i = '1') then
                CpSv_Vlan_Rdata_o <= (others => '0');
                CpSl_Vlan_Rdone_o <= '0';
            else -- hold
            end if;
        end if;
    end process;

    -----------------------------------------
    -- CpSl_Clkdiv3_i
    -----------------------------------------
    -- Differ clock domain
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_Rst_iN = '0') then
            v_rreq_out_dly1 <= '0';
            v_rreq_out_dly2 <= '0';
            v_rreq_out_d3   <= '0';
        elsif rising_edge(CpSl_Clkdiv3_i) then
            v_rreq_out_dly1 <= v_rreq_out   ;
            v_rreq_out_dly2 <= v_rreq_out_dly1;
            v_rreq_out_dly3 <= v_rreq_out_dly2;
        end if;
    end process;

    -- VLAN read request hold
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_Rst_iN = '0') then
            v_rreq_hold <= '0';
        elsif rising_edge(CpSl_Clkdiv3_i) then
            if (v_rreq_out_dly2= '1' and v_rreq_out_d3 = '0') then
                v_rreq_hold <= '1';
            elsif (slot_cnt = "0001") then
                v_rreq_hold <= '0';
            else -- hold
            end if;
        end if;
    end process;

    -- Request in slot
    v_rreq_slot <= v_rreq_hold when slot_cnt = "0001" else '0';

    -- Delay
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_Rst_iN = '0') then
            v_rreq_slot_dly1 <= '0';
            v_rreq_slot_dly2<= '0';
        elsif rising_edge(CpSl_Clkdiv3_i) then
            v_rreq_slot_dly1 <= v_rreq_slot   ;
            v_rreq_slot_dly2<= v_rreq_slot_dly1;
        end if;
    end process;

    -- Port and VLAN search
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_Rst_iN = '0') then
            v_sch <= '0';
        elsif rising_edge(CpSl_Clkdiv3_i) then
            if (p0_req_slot = '1' or 
                CpSl_P1_Req_i_slot = '1' or
                p2_req_slot = '1' or
                CpSl_P3_Req_i_slot = '1' or
                v_rreq_slot = '1') then
                v_sch <= '1';
            else
                v_sch <= '0';
            end if;
        end if;
    end process;

    -- VLAN search address
    process (CpSl_Rst_iN, CpSl_Clkdiv3_i) begin
        if (CpSl_Rst_iN = '0') then
            v_sch_addr <= (others => '0');
        elsif rising_edge(CpSl_Clkdiv3_i) then
            if (p0_req_slot = '1') then
                v_sch_addr <= CpSv_P0_Vlan_i;
            elsif (CpSl_P1_Req_i_slot = '1') then
                v_sch_addr <= CpSv_P1_Vlan_i;
            elsif (p2_req_slot = '1') then
                v_sch_addr <= CpSv_P2_Vlan_i;
            elsif (CpSl_P3_Req_i_slot = '1') then
                v_sch_addr <= CpSv_P3_Vlan_i;
            elsif (v_rreq_slot = '1') then
                v_sch_addr <= CpSv_Vlan_Addr_i;
            else
                v_sch_addr <= (others => '0');
            end if;
        end if;
    end process;

end arch_M_vhdl_coding_guideline;