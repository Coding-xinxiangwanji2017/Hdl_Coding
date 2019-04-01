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
-- �ļ�����  :  M_Time_Gap_cal.vhd
-- ��    ��  :  zhang shuqiang
-- ��    ��  :  shuqiang.zhang@zvision.xyz
-- У    ��  :
-- ��������  :  2019/01/14
-- ���ܼ���  :  
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, zhang shuqiang, 2019/01/14
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity M_Time_Gap_cal is 
    port (
        --------------------------------
        -- Clock & Reset
        --------------------------------
        CpSl_Rst_i						: in  std_logic;						-- Reset,Active_low
        CpSl_Clk_i						: in  std_logic;						-- Clock,Single_40Mhz
        
		  
		  CpSl_Start1_i : in std_logic;
		  CpSl_Start2_i : in std_logic;
		  CpSl_Start3_i : in std_logic;
		  CpSl_Clk5M_i  : in std_logic;
		  CpSl_RstId_i  : in std_logic;
		  CpSl_RstId1_i : in std_logic;
        --------------------------------
        -- TDC_sample_Data
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
        
        CpSl_TdcDVld1_i			          : in  std_logic;						-- TDC_Recv_Data_Valid
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
        -- TDC_gap_time_Data
        --------------------------------
        CpSl_TdcDVld0_o                 : in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc1Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo1_Data
        CpSv_Tdc1Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo2_Data
        CpSv_Tdc1Echo3_o                : in  std_logic_vector(21 downto 0);    -- TDC1_Echo3_Data
        CpSv_Tdc2Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo1_Data
        CpSv_Tdc2Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo2_Data
        CpSv_Tdc2Echo3_o                : in  std_logic_vector(21 downto 0);    -- TDC2_Echo3_Data    
        CpSv_Tdc3Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo1_Data
        CpSv_Tdc3Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo2_Data
        CpSv_Tdc3Echo3_o                : in  std_logic_vector(21 downto 0);    -- TDC3_Echo3_Data    
        CpSv_Tdc4Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo1_Data
        CpSv_Tdc4Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo2_Data
        CpSv_Tdc4Echo3_o                : in  std_logic_vector(21 downto 0);    -- TDC4_Echo3_Data
        
        CpSl_TdcDVld1_o			          : in  std_logic;						-- TDC_Recv_Data_Valid
        CpSv_Tdc5Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo1_Data
        CpSv_Tdc5Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo2_Data
        CpSv_Tdc5Echo3_o                : in  std_logic_vector(21 downto 0);    -- TDC5_Echo3_Data
        CpSv_Tdc6Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo1_Data
        CpSv_Tdc6Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo2_Data
        CpSv_Tdc6Echo3_o                : in  std_logic_vector(21 downto 0);    -- TDC6_Echo3_Data    
        CpSv_Tdc7Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo1_Data
        CpSv_Tdc7Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo2_Data
        CpSv_Tdc7Echo3_o                : in  std_logic_vector(21 downto 0);    -- TDC7_Echo3_Data    
        CpSv_Tdc8Echo1_o                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo1_Data
        CpSv_Tdc8Echo2_o                : in  std_logic_vector(21 downto 0);    -- TDC8_Echo2_Data
        CpSv_Tdc8Echo3_o                : in  std_logic_vector(21 downto 0)     -- TDC8_Echo3_Data
    );
end M_Time_Gap_cal;

architecture arch_M_Time_Gap_cal of M_Time_Gap_cal is
    ------------------------------------
    -- Constant Describe
    ------------------------------------
    
    ------------------------------------
    -- Component Describe
    ------------------------------------
    
    ------------------------------------
    -- Signal Describe
    ------------------------------------
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
		signal  CpSl_RstId1_d1     : std_logic;
		signal  CpSl_RstId1_d2     : std_logic;		
		
		signal  CpSl_Start1_valid  : std_logic;
		signal  CpSl_Start2_valid  : std_logic;
		signal  CpSl_Start3_valid  : std_logic;
		signal  CpSl_Clk5M_valid   : std_logic;

    signal  ref_index_cnt            : std_logic_vector(7 downto 0);
    signal  ref_index_cnt_valid      : std_logic_vector(7 downto 0);
      
    
    
    ----------------------------------------------------------------------------
    -- Begin_Coding
    ----------------------------------------------------------------------------
begin
    ------------------------------------
    -- Main_Coding
    ------------------------------------    
    -- Delay PrSl_Start_s
    process (CpSl_Rst_i,CpSl_Clk_i) begin
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
            CpSl_RstId1_d1 <= '0';
            CpSl_RstId1_d2 <= '0';       
        elsif rising_edge(CpSl_Clk_i) then 
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
            CpSl_RstId1_d1 <= CpSl_RstId1_i;
            CpSl_RstId1_d2 <= CpSl_RstId1_d1;       
        end if;
    end process;
    
		CpSl_Start1_valid  <= '1' when(CpSl_Start1_d3 = '0' and CpSl_Start1_d2 = '1' ) else '0';
		CpSl_Start2_valid  <= '1' when(CpSl_Start2_d3 = '0' and CpSl_Start2_d2 = '1' ) else '0';
		CpSl_Start3_valid  <= '1' when(CpSl_Start3_d3 = '0' and CpSl_Start3_d2 = '1' ) else '0';
		CpSl_Clk5M_valid   <= '1' when(CpSl_Clk5M_d3  = '0' and CpSl_Clk5M_d3  = '1' ) else '0';


    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            ref_index_cnt <= (others => '0');
            ref_index_cnt_valid <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if(CpSl_Clk5M_valid = '1' and (CpSl_RstId_d2 = '1' or CpSl_RstId1_d2 = '1')) then
                ref_index_cnt <= (others => '0');
                ref_index_cnt_valid <= ref_index_cnt;
            elsif(CpSl_Clk5M_valid = '1') then
                ref_index_cnt <= ref_index_cnt + '1';
                ref_index_cnt_valid <= ref_index_cnt;
            end if;
        end if;
    end process;
                
    process (CpSl_Rst_i,CpSl_Clk_i) begin
        if (CpSl_Rst_i = '0') then
            ref_index_cnt_start <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
     		    if(CpSl_Clk5M_valid = '1' and (CpSl_Start1_d2 = '1' or CpSl_Start2_d2 = '1' or CpSl_Start3_d2 = '1')) then
                ref_index_cnt_start <= ref_index_cnt;
            end if;
        end if;
    end process;
    
    
    
    
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
                PrSv_Echo1D1_s <= PrSv_Tdc1Echo1_s;
                PrSv_Echo1D2_s <= PrSv_Tdc3Echo1_s;
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
end arch_M_Time_Gap_cal;