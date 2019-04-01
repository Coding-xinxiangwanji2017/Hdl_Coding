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
-- 文件名称  :  M_SeqData.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/05/17
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity M_SeqData is 
    port (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
        CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
        
        --------------------------------
        -- TDC_Data
        --------------------------------
        CpSl_TdcDVld0_i                 : in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc1Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo1_Data
        CpSv_Tdc1Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo2_Data
        CpSv_Tdc1Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo3_Data
        CpSv_Tdc2Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo1_Data
        CpSv_Tdc2Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo2_Data
        CpSv_Tdc2Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo3_Data    
        CpSv_Tdc3Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo1_Data
        CpSv_Tdc3Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo2_Data
        CpSv_Tdc3Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo3_Data    
        CpSv_Tdc4Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo1_Data
        CpSv_Tdc4Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo2_Data
        CpSv_Tdc4Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo3_Data
        
        CpSl_TdcDVld1_i			        : in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc5Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo1_Data
        CpSv_Tdc5Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo2_Data
        CpSv_Tdc5Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo3_Data
        CpSv_Tdc6Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo1_Data
        CpSv_Tdc6Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo2_Data
        CpSv_Tdc6Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo3_Data    
        CpSv_Tdc7Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo1_Data
        CpSv_Tdc7Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo2_Data
        CpSv_Tdc7Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo3_Data    
        CpSv_Tdc8Echo1_i                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo1_Data
        CpSv_Tdc8Echo2_i                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo2_Data
        CpSv_Tdc8Echo3_i                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo3_Data
            
        --------------------------------
        -- Seq_Data
        --------------------------------
        CpSl_DVld_o                     : out std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Echo1D1_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data1
        CpSv_Echo1D2_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data2
        CpSv_Echo1D3_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data3
        CpSv_Echo1D4_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data4
        CpSv_Echo1D5_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data5
        CpSv_Echo1D6_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data6
        CpSv_Echo1D7_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data7
        CpSv_Echo1D8_o                  : out std_logic_vector(18 downto 0);    -- Echo1_Data8
        CpSv_Echo1ID_o                  : out std_logic_vector( 2 downto 0);    -- Echo1_ID
        CpSv_Echo2D1_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data1
        CpSv_Echo2D2_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data2
        CpSv_Echo2D3_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data3
        CpSv_Echo2D4_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data4
        CpSv_Echo2D5_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data5
        CpSv_Echo2D6_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data6
        CpSv_Echo2D7_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data7
        CpSv_Echo2D8_o                  : out std_logic_vector(18 downto 0);    -- Echo2_Data8
        CpSv_Echo2ID_o                  : out std_logic_vector( 2 downto 0);    -- Echo2_ID
        CpSv_Echo3D1_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data1
        CpSv_Echo3D2_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data2
        CpSv_Echo3D3_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data3
        CpSv_Echo3D4_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data4
        CpSv_Echo3D5_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data5
        CpSv_Echo3D6_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data6
        CpSv_Echo3D7_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data7
        CpSv_Echo3D8_o                  : out std_logic_vector(18 downto 0);    -- Echo3_Data8
        CpSv_Echo3ID_o                  : out std_logic_vector( 2 downto 0)     -- Echo3_ID
    );
end M_SeqData;

architecture arch_M_SeqData of M_SeqData is
    ------------------------------------
    -- Constant Describe
    ------------------------------------
    
    ------------------------------------
    -- Component Describe
    ------------------------------------
    
    ------------------------------------
    -- Signal Describe
    ------------------------------------
    -- TDC_Valid
    signal PrSl_Start_s                 : std_logic;                            -- start
    signal PrSl_StartDly1_s             : std_logic;                            -- Delay 1 Clk
    signal PrSl_StartDly2_s             : std_logic;                            -- Delay 2 Clk
    signal PrSl_StartTrig_s             : std_logic;                            -- start_Trig
    signal PrSl_StartTrigDly1_s         : std_logic;                            -- start_Trig_Dly1
    signal PrSl_StartTrigDly2_s         : std_logic;                            -- start_Trig_Dly2
    signal PrSl_StartTrigDly3_s         : std_logic;                            -- start_Trig_Dly3
    
    -- TDC_Data
    signal PrSv_Tdc1Echo1_s             : std_logic_vector(18 downto 0);        -- TDC1Echo1
    signal PrSv_Tdc1Echo2_s             : std_logic_vector(18 downto 0);        -- TDC1Echo2
    signal PrSv_Tdc1Echo3_s             : std_logic_vector(18 downto 0);        -- TDC1Echo3
    signal PrSv_Tdc2Echo1_s             : std_logic_vector(18 downto 0);        -- TDC2Echo1
    signal PrSv_Tdc2Echo2_s             : std_logic_vector(18 downto 0);        -- TDC2Echo2
    signal PrSv_Tdc2Echo3_s             : std_logic_vector(18 downto 0);        -- TDC2Echo3
    signal PrSv_Tdc3Echo1_s             : std_logic_vector(18 downto 0);        -- TDC3Echo1
    signal PrSv_Tdc3Echo2_s             : std_logic_vector(18 downto 0);        -- TDC3Echo2
    signal PrSv_Tdc3Echo3_s             : std_logic_vector(18 downto 0);        -- TDC3Echo3ll
    signal PrSv_Tdc4Echo1_s             : std_logic_vector(18 downto 0);        -- TDC4Echo1
    signal PrSv_Tdc4Echo2_s             : std_logic_vector(18 downto 0);        -- TDC4Echo2
    signal PrSv_Tdc4Echo3_s             : std_logic_vector(18 downto 0);        -- TDC4Echo3
    signal PrSv_Tdc5Echo1_s             : std_logic_vector(18 downto 0);        -- TDC5Echo1
    signal PrSv_Tdc5Echo2_s             : std_logic_vector(18 downto 0);        -- TDC5Echo2
    signal PrSv_Tdc5Echo3_s             : std_logic_vector(18 downto 0);        -- TDC5Echo3
    signal PrSv_Tdc6Echo1_s             : std_logic_vector(18 downto 0);        -- TDC6Echo1
    signal PrSv_Tdc6Echo2_s             : std_logic_vector(18 downto 0);        -- TDC6Echo2
    signal PrSv_Tdc6Echo3_s             : std_logic_vector(18 downto 0);        -- TDC6Echo3
    signal PrSv_Tdc7Echo1_s             : std_logic_vector(18 downto 0);        -- TDC7Echo1
    signal PrSv_Tdc7Echo2_s             : std_logic_vector(18 downto 0);        -- TDC7Echo2
    signal PrSv_Tdc7Echo3_s             : std_logic_vector(18 downto 0);        -- TDC7Echo3
    signal PrSv_Tdc8Echo1_s             : std_logic_vector(18 downto 0);        -- TDC8Echo1
    signal PrSv_Tdc8Echo2_s             : std_logic_vector(18 downto 0);        -- TDC8Echo2
    signal PrSv_Tdc8Echo3_s             : std_logic_vector(18 downto 0);        -- TDC8Echo3

    -- EchoData
    signal PrSv_Echo1ID_s               : std_logic_vector( 2 downto 0);        -- Echo1ID
    signal PrSv_Echo1D1_s               : std_logic_vector(18 downto 0);        -- Echo1D1
    signal PrSv_Echo1D2_s               : std_logic_vector(18 downto 0);        -- Echo1D2
    signal PrSv_Echo1D3_s               : std_logic_vector(18 downto 0);        -- Echo1D3
    signal PrSv_Echo1D4_s               : std_logic_vector(18 downto 0);        -- Echo1D4
    signal PrSv_Echo1D5_s               : std_logic_vector(18 downto 0);        -- Echo1D5
    signal PrSv_Echo1D6_s               : std_logic_vector(18 downto 0);        -- Echo1D6

    signal PrSv_Echo2ID_s               : std_logic_vector( 2 downto 0);        -- Echo1ID
    signal PrSv_Echo2D1_s               : std_logic_vector(18 downto 0);        -- Echo2D1
    signal PrSv_Echo2D2_s               : std_logic_vector(18 downto 0);        -- Echo2D2
    signal PrSv_Echo2D3_s               : std_logic_vector(18 downto 0);        -- Echo2D3
    signal PrSv_Echo2D4_s               : std_logic_vector(18 downto 0);        -- Echo2D4
    signal PrSv_Echo2D5_s               : std_logic_vector(18 downto 0);        -- Echo2D5
    signal PrSv_Echo2D6_s               : std_logic_vector(18 downto 0);        -- Echo2D6

    signal PrSv_Echo3ID_s               : std_logic_vector( 2 downto 0);        -- Echo1ID
    signal PrSv_Echo3D1_s               : std_logic_vector(18 downto 0);        -- Echo3D1
    signal PrSv_Echo3D2_s               : std_logic_vector(18 downto 0);        -- Echo3D2
    signal PrSv_Echo3D3_s               : std_logic_vector(18 downto 0);        -- Echo3D3
    signal PrSv_Echo3D4_s               : std_logic_vector(18 downto 0);        -- Echo3D4
    signal PrSv_Echo3D5_s               : std_logic_vector(18 downto 0);        -- Echo3D5
    signal PrSv_Echo3D6_s               : std_logic_vector(18 downto 0);        -- Echo3D6
    
    
    ----------------------------------------------------------------------------
    -- Begin_Coding
    ----------------------------------------------------------------------------
begin
    ------------------------------------
    -- Main_Coding
    ------------------------------------
    PrSl_Start_s <= '1' when (CpSl_TdcDVld0_i = '1' and  CpSl_TdcDVld1_i = '1') 
                        else '0';
    
    -- Delay PrSl_Start_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSl_StartDly1_s <= '0';
            PrSl_StartDly2_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            PrSl_StartDly1_s <= PrSl_Start_s;
            PrSl_StartDly2_s <= PrSl_StartDly1_s; 
        end if;
    end process;
    
    -- PrSl_StartTrig_s 
    PrSl_StartTrig_s <= '1' when (PrSl_StartDly2_s = '0' and PrSl_StartDly1_s = '1') else '0';
    
    -- Delay PrSl_StartTrig_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSl_StartTrigDly1_s <= '0';
            PrSl_StartTrigDly2_s <= '0';
            PrSl_StartTrigDly3_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            PrSl_StartTrigDly1_s <= PrSl_StartTrig_s;
            PrSl_StartTrigDly2_s <= PrSl_StartTrigDly1_s;
            PrSl_StartTrigDly3_s <= PrSl_StartTrigDly2_s;
        end if;
    end process;
    
    -- TDC_Data
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then 
            PrSv_Tdc1Echo1_s <= (others => '0');
            PrSv_Tdc1Echo2_s <= (others => '0');
            PrSv_Tdc1Echo3_s <= (others => '0');
            PrSv_Tdc2Echo1_s <= (others => '0');
            PrSv_Tdc2Echo2_s <= (others => '0');
            PrSv_Tdc2Echo3_s <= (others => '0');
            PrSv_Tdc3Echo1_s <= (others => '0');
            PrSv_Tdc3Echo2_s <= (others => '0');
            PrSv_Tdc3Echo3_s <= (others => '0');
            PrSv_Tdc4Echo1_s <= (others => '0');
            PrSv_Tdc4Echo2_s <= (others => '0');
            PrSv_Tdc4Echo3_s <= (others => '0');
            PrSv_Tdc5Echo1_s <= (others => '0');
            PrSv_Tdc5Echo2_s <= (others => '0');
            PrSv_Tdc5Echo3_s <= (others => '0');
            PrSv_Tdc6Echo1_s <= (others => '0');
            PrSv_Tdc6Echo2_s <= (others => '0');
            PrSv_Tdc6Echo3_s <= (others => '0');
            PrSv_Tdc7Echo1_s <= (others => '0');
            PrSv_Tdc7Echo2_s <= (others => '0');
            PrSv_Tdc7Echo3_s <= (others => '0');
            PrSv_Tdc8Echo1_s <= (others => '0');
            PrSv_Tdc8Echo2_s <= (others => '0');
            PrSv_Tdc8Echo3_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_StartTrig_s = '1') then
                PrSv_Tdc1Echo1_s <= CpSv_Tdc1Echo1_i(18 downto 0);
                PrSv_Tdc1Echo2_s <= CpSv_Tdc1Echo2_i(18 downto 0);
                PrSv_Tdc1Echo3_s <= CpSv_Tdc1Echo3_i(18 downto 0);
                PrSv_Tdc2Echo1_s <= CpSv_Tdc2Echo1_i(18 downto 0);
                PrSv_Tdc2Echo2_s <= CpSv_Tdc2Echo2_i(18 downto 0);
                PrSv_Tdc2Echo3_s <= CpSv_Tdc2Echo3_i(18 downto 0);
                PrSv_Tdc3Echo1_s <= CpSv_Tdc3Echo1_i(18 downto 0);
                PrSv_Tdc3Echo2_s <= CpSv_Tdc3Echo2_i(18 downto 0);
                PrSv_Tdc3Echo3_s <= CpSv_Tdc3Echo3_i(18 downto 0);
                PrSv_Tdc4Echo1_s <= CpSv_Tdc4Echo1_i(18 downto 0);
                PrSv_Tdc4Echo2_s <= CpSv_Tdc4Echo2_i(18 downto 0);
                PrSv_Tdc4Echo3_s <= CpSv_Tdc4Echo3_i(18 downto 0);
                PrSv_Tdc5Echo1_s <= CpSv_Tdc5Echo1_i(18 downto 0);
                PrSv_Tdc5Echo2_s <= CpSv_Tdc5Echo2_i(18 downto 0);
                PrSv_Tdc5Echo3_s <= CpSv_Tdc5Echo3_i(18 downto 0);
                PrSv_Tdc6Echo1_s <= CpSv_Tdc6Echo1_i(18 downto 0);
                PrSv_Tdc6Echo2_s <= CpSv_Tdc6Echo2_i(18 downto 0);
                PrSv_Tdc6Echo3_s <= CpSv_Tdc6Echo3_i(18 downto 0);
                PrSv_Tdc7Echo1_s <= CpSv_Tdc7Echo1_i(18 downto 0);
                PrSv_Tdc7Echo2_s <= CpSv_Tdc7Echo2_i(18 downto 0);
                PrSv_Tdc7Echo3_s <= CpSv_Tdc7Echo3_i(18 downto 0);
                PrSv_Tdc8Echo1_s <= CpSv_Tdc8Echo1_i(18 downto 0);
                PrSv_Tdc8Echo2_s <= CpSv_Tdc8Echo2_i(18 downto 0);
                PrSv_Tdc8Echo3_s <= CpSv_Tdc8Echo3_i(18 downto 0);
            else  -- hold
            end if;
        end if;
    end process;
    
    -- Echo1Data
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_Echo1D1_s <= (others => '0');
            PrSv_Echo1D2_s <= (others => '0');
            PrSv_Echo1D3_s <= (others => '0');
            PrSv_Echo1D4_s <= (others => '0');
            PrSv_Echo1D5_s <= (others => '0');
            PrSv_Echo1D6_s <= (others => '0');
            PrSv_Echo1ID_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_StartTrig_s = '1') then 
                PrSv_Echo1D1_s <= (others => '0');
                PrSv_Echo1D2_s <= (others => '0');
                PrSv_Echo1D3_s <= (others => '0');
                PrSv_Echo1D4_s <= (others => '0');
                PrSv_Echo1D5_s <= (others => '0');
                PrSv_Echo1D6_s <= (others => '0');
                PrSv_Echo1ID_s <= (others => '0');
            elsif (PrSl_StartTrigDly1_s = '1') then

                if (PrSv_Tdc3Echo1_s > PrSv_Tdc1Echo1_s) then 
                    PrSv_Echo1D1_s <= PrSv_Tdc1Echo1_s;
                    PrSv_Echo1D2_s <= PrSv_Tdc3Echo1_s;
                else 
                    PrSv_Echo1D1_s <= (others => '0');
                    PrSv_Echo1D2_s <= (others => '0');
                end if;
                --PrSv_Echo1D1_s <= PrSv_Tdc1Echo1_s;
                --PrSv_Echo1D2_s <= PrSv_Tdc3Echo1_s;
                if (PrSv_Tdc1Echo1_s /= 0) then 
                    PrSv_Echo1ID_s(2) <= '1';
                else 
                    PrSv_Echo1ID_s(2) <= '0';
                end if;

--                if (PrSv_Tdc5Echo1_s > PrSv_Tdc1Echo1_s and PrSv_Tdc5Echo1_s < PrSv_Tdc3Echo1_s) then
                if (PrSv_Tdc5Echo1_s > 0 and PrSv_Tdc5Echo1_s < PrSv_Tdc3Echo1_s) then 
                    PrSv_Echo1D3_s <= PrSv_Tdc5Echo1_s;
                    PrSv_Echo1D4_s <= PrSv_Tdc7Echo1_s;
                    PrSv_Echo1ID_s(1) <= '1'; 
                else 
                    PrSv_Echo1D3_s <= (others => '0');
                    PrSv_Echo1D4_s <= (others => '0');
                    PrSv_Echo1ID_s(1) <= '0'; 
                end if;

                if (PrSv_Tdc6Echo1_s > 0 and PrSv_Tdc6Echo1_s < PrSv_Tdc3Echo1_s) then 
                    PrSv_Echo1D5_s <= PrSv_Tdc6Echo1_s;
                    PrSv_Echo1D6_s <= PrSv_Tdc8Echo1_s;
                    PrSv_Echo1ID_s(0) <= '1'; 
                else
                    PrSv_Echo1D5_s <= (others => '0');
                    PrSv_Echo1D6_s <= (others => '0');
                    PrSv_Echo1ID_s(0) <= '0'; 
                end if;
            end if;
        end if;
    end process;

    -- Echo2Data
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_Echo2D1_s <= (others => '0');
            PrSv_Echo2D2_s <= (others => '0');
            PrSv_Echo2D3_s <= (others => '0');
            PrSv_Echo2D4_s <= (others => '0');
            PrSv_Echo2D5_s <= (others => '0');
            PrSv_Echo2D6_s <= (others => '0');
            PrSv_Echo2ID_s <= (others => '0');    
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_StartTrig_s = '1') then 
                PrSv_Echo2D1_s <= (others => '0');
                PrSv_Echo2D2_s <= (others => '0');
                PrSv_Echo2D3_s <= (others => '0');
                PrSv_Echo2D4_s <= (others => '0');
                PrSv_Echo2D5_s <= (others => '0');
                PrSv_Echo2D6_s <= (others => '0');
                PrSv_Echo2ID_s <= (others => '0');
            elsif (PrSl_StartTrigDly1_s = '1') then
                PrSv_Echo2D1_s <= PrSv_Tdc1Echo2_s;
                PrSv_Echo2D2_s <= PrSv_Tdc3Echo2_s;
                
                if (PrSv_Tdc1Echo2_s /= 0) then 
                    PrSv_Echo2ID_s(2) <= '1';
                else 
                    PrSv_Echo2ID_s(2) <= '0';
                end if;
                                         
--                if (PrSv_Tdc5Echo1_s > PrSv_Tdc1Echo2_s and PrSv_Tdc5Echo1_s < PrSv_Tdc3Echo2_s) then
                if (PrSv_Tdc5Echo1_s > PrSv_Tdc3Echo1_s and PrSv_Tdc5Echo1_s < PrSv_Tdc3Echo2_s) then
                    PrSv_Echo2D3_s <= PrSv_Tdc5Echo1_s;
                    PrSv_Echo2D4_s <= PrSv_Tdc7Echo1_s;
                    PrSv_Echo2ID_s(1) <= '1';
                elsif (PrSv_Tdc5Echo2_s > PrSv_Tdc3Echo1_s and PrSv_Tdc5Echo2_s < PrSv_Tdc3Echo2_s) then 
                    PrSv_Echo2D3_s <= PrSv_Tdc5Echo2_s;
                    PrSv_Echo2D4_s <= PrSv_Tdc7Echo2_s;
                    PrSv_Echo2ID_s(1) <= '1';
                else
                    PrSv_Echo2D3_s <= (others => '0');
                    PrSv_Echo2D4_s <= (others => '0');
                    PrSv_Echo2ID_s(1) <= '0';
                end if;

                if (PrSv_Tdc6Echo1_s > PrSv_Tdc3Echo1_s and PrSv_Tdc6Echo1_s < PrSv_Tdc3Echo2_s) then 
                    PrSv_Echo2D5_s <= PrSv_Tdc6Echo1_s;
                    PrSv_Echo2D6_s <= PrSv_Tdc8Echo1_s;
                    PrSv_Echo2ID_s(0) <= '1';
                elsif (PrSv_Tdc6Echo2_s > PrSv_Tdc3Echo1_s and PrSv_Tdc6Echo2_s < PrSv_Tdc3Echo2_s) then 
                    PrSv_Echo2D5_s <= PrSv_Tdc6Echo2_s;
                    PrSv_Echo2D6_s <= PrSv_Tdc8Echo2_s;
                    PrSv_Echo2ID_s(0) <= '1';
                else
                    PrSv_Echo2D5_s <= (others => '0');
                    PrSv_Echo2D6_s <= (others => '0');
                    PrSv_Echo2ID_s(0) <= '0';
                end if;
            end if;
        end if;
    end process;

    -- Echo3Data
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            PrSv_Echo3D1_s <= (others => '0');
            PrSv_Echo3D2_s <= (others => '0');
            PrSv_Echo3D3_s <= (others => '0');
            PrSv_Echo3D4_s <= (others => '0');
            PrSv_Echo3D5_s <= (others => '0');
            PrSv_Echo3D6_s <= (others => '0');
            PrSv_Echo3ID_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSl_StartTrig_s = '1') then 
                PrSv_Echo3D1_s <= (others => '0');
                PrSv_Echo3D2_s <= (others => '0');
                PrSv_Echo3D3_s <= (others => '0');
                PrSv_Echo3D4_s <= (others => '0');
                PrSv_Echo3D5_s <= (others => '0');
                PrSv_Echo3D6_s <= (others => '0');
                PrSv_Echo3ID_s <= (others => '0');
            elsif (PrSl_StartTrigDly1_s = '1') then
                PrSv_Echo3D1_s <= PrSv_Tdc1Echo3_s;
                PrSv_Echo3D2_s <= PrSv_Tdc3Echo3_s;
                
                if (PrSv_Tdc2Echo3_s /= 0) then 
                    PrSv_Echo3ID_s(2) <= '1';
                else 
                    PrSv_Echo3ID_s(2) <= '0';
                end if;
                
--                if (PrSv_Tdc5Echo1_s > PrSv_Tdc1Echo3_s and PrSv_Tdc5Echo1_s < PrSv_Tdc3Echo3_s) then
                if (PrSv_Tdc5Echo1_s > PrSv_Tdc3Echo2_s and PrSv_Tdc5Echo1_s < PrSv_Tdc3Echo3_s) then 
                    PrSv_Echo3D3_s <= PrSv_Tdc5Echo1_s;
                    PrSv_Echo3D4_s <= PrSv_Tdc7Echo1_s;
                    PrSv_Echo3ID_s(1) <= '1';
                elsif (PrSv_Tdc5Echo2_s > PrSv_Tdc3Echo2_s and PrSv_Tdc5Echo2_s < PrSv_Tdc3Echo3_s) then
                    PrSv_Echo3D3_s <= PrSv_Tdc5Echo2_s;
                    PrSv_Echo3D4_s <= PrSv_Tdc7Echo2_s;
                    PrSv_Echo3ID_s(1) <= '1';
                elsif (PrSv_Tdc5Echo3_s > PrSv_Tdc3Echo2_s and PrSv_Tdc5Echo3_s < PrSv_Tdc3Echo3_s) then
                    PrSv_Echo3D3_s <= PrSv_Tdc5Echo3_s;
                    PrSv_Echo3D4_s <= PrSv_Tdc7Echo3_s;
                    PrSv_Echo3ID_s(1) <= '1';
                else 
                    PrSv_Echo3D3_s <= (others => '0');
                    PrSv_Echo3D4_s <= (others => '0');
                    PrSv_Echo3ID_s(1) <= '0';
                end if;

                if (PrSv_Tdc6Echo1_s > PrSv_Tdc3Echo2_s and PrSv_Tdc6Echo1_s < PrSv_Tdc3Echo3_s) then 
                    PrSv_Echo3D5_s <= PrSv_Tdc6Echo1_s;
                    PrSv_Echo3D6_s <= PrSv_Tdc8Echo1_s;
                    PrSv_Echo3ID_s(0) <= '1';
                elsif (PrSv_Tdc6Echo2_s > PrSv_Tdc3Echo2_s and PrSv_Tdc6Echo2_s < PrSv_Tdc3Echo3_s) then 
                    PrSv_Echo3D5_s <= PrSv_Tdc6Echo2_s;
                    PrSv_Echo3D6_s <= PrSv_Tdc8Echo2_s;
                    PrSv_Echo3ID_s(0) <= '1';
                elsif (PrSv_Tdc6Echo3_s > PrSv_Tdc3Echo2_s and PrSv_Tdc6Echo3_s < PrSv_Tdc3Echo3_s) then
                    PrSv_Echo3D5_s <= PrSv_Tdc6Echo3_s;
                    PrSv_Echo3D6_s <= PrSv_Tdc8Echo3_s;
                    PrSv_Echo3ID_s(0) <= '1';
                else
                    PrSv_Echo3D5_s <= (others => '0');
                    PrSv_Echo3D6_s <= (others => '0');
                    PrSv_Echo3ID_s(0) <= '0';
                end if;
            end if;
        end if;
    end process;

    ------------------------------------
    -- Seq_Data
    ------------------------------------
    -- Valid
    CpSl_DVld_o <= PrSl_StartTrigDly3_s;
    
    -- Echo1
    CpSv_Echo1D1_o <= PrSv_Echo1D1_s;
    CpSv_Echo1D2_o <= PrSv_Echo1D2_s;
    CpSv_Echo1D3_o <= PrSv_Echo1D3_s;
    CpSv_Echo1D4_o <= PrSv_Echo1D4_s;
    CpSv_Echo1D5_o <= PrSv_Echo1D5_s;
    CpSv_Echo1D6_o <= PrSv_Echo1D6_s;
    CpSv_Echo1D7_o <= (others => '0');
    CpSv_Echo1D8_o <= (others => '0');
    CpSv_Echo1ID_o <= PrSv_Echo1ID_s;

    -- Echo2
    CpSv_Echo2D1_o <= PrSv_Echo2D1_s;
    CpSv_Echo2D2_o <= PrSv_Echo2D2_s;
    CpSv_Echo2D3_o <= PrSv_Echo2D3_s;
    CpSv_Echo2D4_o <= PrSv_Echo2D4_s;
    CpSv_Echo2D5_o <= PrSv_Echo2D5_s;
    CpSv_Echo2D6_o <= PrSv_Echo2D6_s;
    CpSv_Echo2D7_o <= (others => '0');
    CpSv_Echo2D8_o <= (others => '0');
    CpSv_Echo2ID_o <= PrSv_Echo2ID_s;
    
    --Echo3
    CpSv_Echo3D1_o <= PrSv_Echo3D1_s;
    CpSv_Echo3D2_o <= PrSv_Echo3D2_s;
    CpSv_Echo3D3_o <= PrSv_Echo3D3_s;
    CpSv_Echo3D4_o <= PrSv_Echo3D4_s;
    CpSv_Echo3D5_o <= PrSv_Echo3D5_s;
    CpSv_Echo3D6_o <= PrSv_Echo3D6_s;
    CpSv_Echo3D7_o <= (others => '0');
    CpSv_Echo3D8_o <= (others => '0');
    CpSv_Echo3ID_o <= PrSv_Echo3ID_s;


--------------------------------------------------------------------------------
-- End_Coding
--------------------------------------------------------------------------------
end arch_M_SeqData;