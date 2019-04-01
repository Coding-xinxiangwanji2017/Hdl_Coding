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
-- 文件名称  :  M_I2C.vhd
-- 设    计  :  zhang wenjun
-- 邮    件  :  wenjun.zhang@zvision.xyz
-- 校    对  :
-- 设计日期  :  2018/10/24
-- 功能简述  :  
-- 版本序号  :  0.1
-- 修改历史  :  1. Initial, zhang wenjun, 2018/10/24
--------------------------------------------------------------------------------
----------------------------------------
-- library ieee
----------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity M_I2C is
    port (
        --------------------------------
        -- Reset&Clock
        --------------------------------
        CpSl_Rst_iN                     : in  std_logic;                        -- Reset,low active
        CpSl_Clk_i                      : in  std_logic;                        -- Clock,Single 40M

        --------------------------------
        -- APD/Vth_Rd/Wr_Trig
        --------------------------------
        CpSl_ApdRdTrig_i                : in  std_logic;                        -- APD_Read_Trig
        CpSl_ApdWrTrig_i                : in  std_logic;                        -- APD_Write_Trig
        CpSl_VthRdTrig_i                : in  std_logic;                        -- Vth_Read_Trig
        CpSl_VthWrTrig_i                : in  std_logic;                        -- Vth_Write_Trig
        
        --------------------------------
        -- LTC2631
        --------------------------------
        CpSl_WrTrig1_i                  : in  std_logic;                        -- Wr_Trig1
        CpSl_WrTrig2_i                  : in  std_logic;                        -- Wr_Trig2
        
        --------------------------------
        -- Vth/APD_Interface
        --------------------------------
        CpSl_ApdChannel_i               : in  std_logic;                        -- AD5242_ApdChannnel
        CpSv_ApdWrData_i                : in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
        CpSv_ApdRdData_o                : out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
        CpSl_VthChannel_i               : in  std_logic;                        -- AD5242_VthChannnel
        CpSv_VthWrData_i                : in  std_logic_vector(7 downto 0);     -- AD5242_ApdWriteData
        CpSv_VthRdData_o                : out std_logic_vector(7 downto 0);     -- AD5242_ApdReadData
        CpSl_Finish_o                   : out std_logic;                        -- I2C_Finish
        
        --------------------------------
        -- LTC2631_Interface
        --------------------------------
        CpSv_WrVthData_i                : in  std_logic_vector(11 downto 0);    -- Write_VthData
        CpSv_WrTrigData_i               : in  std_logic_vector(11 downto 0);    -- Write_ApdData
        
        --------------------------------
        -- I2C_Interface
        --------------------------------
        CpSl_Scl_o                      : out std_logic;                        -- AD5242_Scl
        CpSl_Sda_io                     : inout std_logic                       -- AD5242_Sda
    );
end M_I2C;

architecture arch_M_I2C of M_I2C is
    ----------------------------------------------------------------------------
    -- constant_describe
    ----------------------------------------------------------------------------
    -- I2C_Address
    constant PrSv_ApdWrAdd_c            : std_logic_vector( 7 downto 0) := x"58"; -- APD_I2CWrite_Address
    constant PrSv_ApdRdAdd_c            : std_logic_vector( 7 downto 0) := x"59"; -- APD_I2CRead_Address
    constant PrSv_VthWrAdd_c            : std_logic_vector( 7 downto 0) := x"5A"; -- Vth_I2CWrite_Address
    constant PrSv_VthRdAdd_c            : std_logic_vector( 7 downto 0) := x"5B"; -- Vth_I2CRead_Address
    constant PrSv_Inst_c                : std_logic_vector( 6 downto 0) := "0000000"; -- AD5242_instruction
    
    -- LTC2631
    constant PrSv_WrAdd1_c              : std_logic_vector( 7 downto 0) := x"20"; -- LTC2631_I2CWrite_Address
    constant PrSv_WrAdd2_c              : std_logic_vector( 7 downto 0) := x"24"; -- LTC2631_I2CWrite_Address
    constant PrSv_WrCmd_c               : std_logic_vector( 7 downto 0) := x"30"; -- LTC2631_Cmd
    
    -- I2C_State
    constant PrSv_Idle_c                : std_logic_vector( 3 downto 0) := x"0";  -- State_Idle
    constant PrSv_Start_c               : std_logic_vector( 3 downto 0) := x"1";  -- State_Start
    constant PrSv_State1us_c            : std_logic_vector( 3 downto 0) := x"2";  -- State_1us
    constant PrSv_StateWord_c           : std_logic_vector( 3 downto 0) := x"3";  -- Send_WordCnt
    constant PrSv_SendData_c            : std_logic_vector( 3 downto 0) := x"4";  -- State_SendData
    constant PrSv_Ack_c                 : std_logic_vector( 3 downto 0) := x"5";  -- State_Ack
    constant PrSv_Stop_c                : std_logic_vector( 3 downto 0) := x"6";  -- State_Stop
    constant PrSv_Finish_c              : std_logic_vector( 3 downto 0) := x"7";  -- State_Finish
    
    -- Cnt
    constant PrSv_1usCnt_c              : std_logic_vector( 7 downto 0) := x"27"; -- 1us
    constant PrSv_2usCnt_c              : std_logic_vector( 7 downto 0) := x"4F"; -- 2us
    constant PrSv_3usCnt_c              : std_logic_vector( 7 downto 0) := x"77"; -- 3us
    
    
    ----------------------------------------------------------------------------
    -- signal_describe
    ----------------------------------------------------------------------------
    signal PrSv_I2CState_s              : std_logic_vector( 3 downto 0);        -- I2C_State
    signal PrSl_ApdWrVld_s              : std_logic;                            -- Apd_Write_Valid
    signal PrSl_ApdRdVld_s              : std_logic;                            -- Apd_Read_Valid
    signal PrSl_VthWrVld_s              : std_logic;                            -- Vth_Write_Valid
    signal PrSl_VthRdVld_s              : std_logic;                            -- Vth_Read_Valid
    signal PrSl_WrTrig1Vld_s            : std_logic;                            -- WrTrig1_Valid
    signal PrSl_WrTrig2Vld_s            : std_logic;                            -- WrTrig1_Valid

    signal PrSv_WaitCnt_s               : std_logic_vector( 7 downto 0);        -- wait 1us
    signal PrSv_WordCnt_s               : std_logic_vector( 2 downto 0);        -- WordCnt
    signal PrSv_ApdWrCnt_s              : std_logic_vector( 2 downto 0);        -- ApdWrCnt
    signal PrSv_ApdRdCnt_s              : std_logic_vector( 2 downto 0);        -- ApdRdCnt
    signal PrSv_VthWrCnt_s              : std_logic_vector( 2 downto 0);        -- VthWrCnt
    signal PrSv_VthRdCnt_s              : std_logic_vector( 2 downto 0);        -- VthRdCnt
    signal PrSv_WrTrig1Cnt_s            : std_logic_vector( 2 downto 0);        -- VthWrCnt
    signal PrSv_WrTrig2Cnt_s            : std_logic_vector( 2 downto 0);        -- VthRdCnt
    signal PrSv_ClkCnt_s                : std_logic_vector( 7 downto 0);        -- I2C_ClkCnt
    signal PrSv_bitCnt_s                : std_logic_vector( 3 downto 0);        -- bit_Cnt
    signal PrSv_StopCnt_s               : std_logic_vector( 7 downto 0);        -- StopCnt
    signal PrSv_SendData_s              : std_logic_vector( 7 downto 0);        -- SendData
    signal PrSl_SendVld_s               : std_logic;                            -- SendData_Valid
    signal PrSl_Sendbit_s               : std_logic;                            -- SendData_bit
    signal PrSl_SdaData_s               : std_logic;                            -- Sda_Data
    signal PrSl_SdaVld_s                : std_logic;                            -- Sda_Valid
    signal PrSv_WrCnt_s                 : std_logic_vector( 2 downto 0);        -- WrCnt
begin
    ----------------------------------------------------------------------------
    -- main Coding
    ----------------------------------------------------------------------------
    -- PrSv_WrCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSv_WrCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s <= PrSv_Idle_c) then 
                PrSv_WrCnt_s <= (others => '0');
            elsif (CpSl_ApdWrTrig_i = '1' or CpSl_VthWrTrig_i = '1') then 
                PrSv_WrCnt_s <= "011";
            elsif (CpSl_WrTrig1_i = '1' or CpSl_WrTrig2_i = '1') then
                PrSv_WrCnt_s <= "100";
            else -- hold
            end if;
        end if;
    end process;
    
    ------------------------------------
    -- I2C_State
    ------------------------------------
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_I2CState_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_I2CState_s is
                when PrSv_Idle_c => -- Idle
                    if (PrSl_ApdWrVld_s = '1') then
                        PrSv_I2CState_s <= PrSv_Start_c;
                    elsif (PrSl_ApdRdVld_s = '1') then 
                        PrSv_I2CState_s <= PrSv_Start_c;
                    elsif (PrSl_VthWrVld_s = '1') then
                        PrSv_I2CState_s <= PrSv_Start_c;
                    elsif (PrSl_VthRdVld_s = '1') then 
                        PrSv_I2CState_s <= PrSv_Start_c;    
                    elsif (PrSl_WrTrig1Vld_s = '1') then
                        PrSv_I2CState_s <= PrSv_Start_c;
                    elsif (PrSl_WrTrig2Vld_s = '1') then 
                        PrSv_I2CState_s <= PrSv_Start_c;
                    else -- hold
                    end if;

                when PrSv_Start_c => -- I2C_Start
                    PrSv_I2CState_s <= PrSv_State1us_c;
                
                when PrSv_State1us_c => -- wait 1us
                    if (PrSv_WaitCnt_s = PrSv_1usCnt_c) then
                        PrSv_I2CState_s <= PrSv_StateWord_c; 
                    else -- hold
                    end if;
                
                when PrSv_StateWord_c => -- Word_Cnt
                    PrSv_I2CState_s <= PrSv_SendData_c;
                    
                when PrSv_SendData_c => -- Send_Data
                    if (PrSv_bitCnt_s = 8 and PrSv_ClkCnt_s = PrSv_3usCnt_c) then 
                        PrSv_I2CState_s <= PrSv_Ack_c;
                    else -- hold
                    end if;
                
                when PrSv_Ack_c => -- wait_Ack
                    if (PrSv_ClkCnt_s = PrSv_3usCnt_c) then
                        if (CpSl_Sda_io = '0') then 
                            if (PrSv_WordCnt_s = PrSv_WrCnt_s) then 
                                PrSv_I2CState_s <= PrSv_Stop_c;
                            else 
                                PrSv_I2CState_s <= PrSv_StateWord_c;
                            end if;
                        else
                            PrSv_I2CState_s <= PrSv_Stop_c;
                        end if;
                    else -- hold
                    end if;

                when PrSv_Stop_c => -- I2C_Stop
                    if (PrSv_StopCnt_s = PrSv_2usCnt_c) then 
                        PrSv_I2CState_s <= PrSv_Finish_c;
                    else -- hold
                    end if;
                
                when PrSv_Finish_c => -- Finish
                    PrSv_I2CState_s <= PrSv_Idle_c;
                
                when others => 
                    PrSv_I2CState_s <= (others => '0');
            end case;
        end if;
    end process;
    
    ------------------------------------
    -- APD/Vth_Valid
    ------------------------------------
    -- PrSl_ApdWrVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_ApdWrVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSl_ApdWrTrig_i = '1') then
                PrSl_ApdWrVld_s <= '1';
            elsif (PrSv_ApdWrCnt_s = 3) then
                PrSl_ApdWrVld_s <= '0';
            else -- hold
            end if; 
        end if;
    end process;
    
    -- PrSl_ApdRdVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_ApdRdVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (CpSl_ApdRdTrig_i = '1') then
                PrSl_ApdRdVld_s <= '1';
            elsif (PrSv_ApdRdCnt_s = 3) then
                PrSl_ApdRdVld_s <= '0';
            else -- hold
            end if; 
        end if;
    end process;
    
    -- PrSl_VthWrVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_VthWrVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSl_VthWrTrig_i = '1') then 
                PrSl_VthWrVld_s <= '1';
            elsif (PrSv_I2CState_s = PrSv_Finish_c and PrSv_VthWrCnt_s = 3) then
                PrSl_VthWrVld_s <= '0';
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSl_VthRdVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_VthRdVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSl_VthRdTrig_i = '1') then
                PrSl_VthRdVld_s <= '1';
            elsif (PrSv_I2CState_s = PrSv_Finish_c and PrSv_VthRdCnt_s = 3) then
                PrSl_VthRdVld_s <= '0';
            else -- hold
            end if; 
        end if;
    end process;
    
    -- PrSl_WrTrig1Vld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_WrTrig1Vld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSl_WrTrig1_i = '1') then
                PrSl_WrTrig1Vld_s <= '1';
            elsif (PrSv_WrTrig1Cnt_s = 4 or PrSv_I2CState_s = PrSv_Stop_c) then
                PrSl_WrTrig1Vld_s <= '0';
            else -- hold
            end if; 
        end if;
    end process;
    
    -- PrSl_WrTrig2Vld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then 
            PrSl_WrTrig2Vld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (CpSl_WrTrig2_i = '1') then
                PrSl_WrTrig2Vld_s <= '1';
            elsif (PrSv_WrTrig2Cnt_s = 4) then
                PrSl_WrTrig2Vld_s <= '0';
            else -- hold
            end if; 
        end if;
    end process;
    
    -- PrSv_WaitCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_WaitCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_State1us_c) then
                PrSv_WaitCnt_s <= PrSv_WaitCnt_s + '1';
            else
                PrSv_WaitCnt_s <= (others => '0');
            end if;
        end if;
    end process;
        
    -- PrSv_WordCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then
             PrSv_WordCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_Idle_c) then
                PrSv_WordCnt_s <= (others => '0');
            elsif (PrSv_I2CState_s = PrSv_StateWord_c) then
                PrSv_WordCnt_s <= PrSv_WordCnt_s + '1';
            else -- hold 
            end if;
        end if;
    end process;
    
    -- PrSv_ApdWrCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_ApdWrCnt_s <= (others => '0');
            PrSv_ApdRdCnt_s <= (others => '0');
            PrSv_VthWrCnt_s <= (others => '0');
            PrSv_VthRdCnt_s <= (others => '0');
            PrSv_WrTrig1Cnt_s <= (others => '0');
            PrSv_WrTrig2Cnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSl_ApdWrVld_s = '1') then
                PrSv_ApdWrCnt_s <= PrSv_WordCnt_s;
                PrSv_ApdRdCnt_s <= (others => '0');
                PrSv_VthWrCnt_s <= (others => '0');
                PrSv_VthRdCnt_s <= (others => '0');
                PrSv_WrTrig1Cnt_s <= (others => '0');
                PrSv_WrTrig2Cnt_s <= (others => '0');
            
            elsif (PrSl_ApdRdVld_s = '1') then 
                PrSv_ApdWrCnt_s <= (others => '0');
                PrSv_ApdRdCnt_s <= PrSv_WordCnt_s;
                PrSv_VthWrCnt_s <= (others => '0');
                PrSv_VthRdCnt_s <= (others => '0');
                PrSv_WrTrig1Cnt_s <= (others => '0');
                PrSv_WrTrig2Cnt_s <= (others => '0');
            
            elsif (PrSl_VthWrVld_s = '1') then
                PrSv_ApdWrCnt_s <= (others => '0');
                PrSv_ApdRdCnt_s <= (others => '0');
                PrSv_VthWrCnt_s <= PrSv_WordCnt_s;
                PrSv_VthRdCnt_s <= (others => '0');
                PrSv_WrTrig1Cnt_s <= (others => '0');
                PrSv_WrTrig2Cnt_s <= (others => '0');
                
            elsif (PrSl_VthRdVld_s = '1') then 
                PrSv_ApdWrCnt_s <= (others => '0');
                PrSv_ApdRdCnt_s <= (others => '0');
                PrSv_VthWrCnt_s <= (others => '0');
                PrSv_VthRdCnt_s <= PrSv_WordCnt_s;
                PrSv_WrTrig1Cnt_s <= (others => '0');
                PrSv_WrTrig2Cnt_s <= (others => '0');
            
            elsif (PrSl_WrTrig1Vld_s = '1') then 
                PrSv_ApdWrCnt_s <= (others => '0');
                PrSv_ApdRdCnt_s <= (others => '0');
                PrSv_VthWrCnt_s <= (others => '0');
                PrSv_VthRdCnt_s <= (others => '0');
                PrSv_WrTrig1Cnt_s <= PrSv_WordCnt_s;
                PrSv_WrTrig2Cnt_s <= (others => '0');
            
            elsif (PrSl_WrTrig2Vld_s = '1') then 
                PrSv_ApdWrCnt_s <= (others => '0');
                PrSv_ApdRdCnt_s <= (others => '0');
                PrSv_VthWrCnt_s <= (others => '0');
                PrSv_VthRdCnt_s <= (others => '0');
                PrSv_WrTrig1Cnt_s <= (others => '0');
                PrSv_WrTrig2Cnt_s <= PrSv_WordCnt_s;
                
            else
                PrSv_ApdWrCnt_s <= (others => '0');
                PrSv_ApdRdCnt_s <= (others => '0');
                PrSv_VthWrCnt_s <= (others => '0');
                PrSv_VthRdCnt_s <= (others => '0'); 
                PrSv_WrTrig1Cnt_s <= (others => '0');
                PrSv_WrTrig2Cnt_s <= (others => '0');           
            end if;
        end if;
    end process;
    
    -- PrSv_ClkCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSv_ClkCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_SendData_c) then
                if (PrSv_ClkCnt_s = PrSv_3usCnt_c) then
                    PrSv_ClkCnt_s <= (others => '0');
                else
                    PrSv_ClkCnt_s <= PrSv_ClkCnt_s + '1';
                end if;
            elsif (PrSv_I2CState_s = PrSv_Ack_c) then 
                if (PrSv_ClkCnt_s = PrSv_3usCnt_c) then
                    PrSv_ClkCnt_s <= (others => '0');
                else
                    PrSv_ClkCnt_s <= PrSv_ClkCnt_s + '1';
                end if;
            else
                PrSv_ClkCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_bitCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_bitCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_I2CState_s = PrSv_SendData_c) then
                if (PrSv_ClkCnt_s = 1) then
                    PrSv_bitCnt_s <= PrSv_bitCnt_s + '1';
                else  -- hold
                end if;
            else 
                PrSv_bitCnt_s <= (others => '0');
            end if;
        end if;
    end process;
    
    -- PrSv_SendData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_SendData_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            case PrSv_WordCnt_s is 
                when "000" => -- Ad5242_Address
                    if (PrSv_I2CState_s = PrSv_StateWord_c) then
                        if (PrSl_ApdWrVld_s = '1') then
                            PrSv_SendData_s <= PrSv_ApdWrAdd_c;
                        elsif (PrSl_ApdRdVld_s = '1') then
                            PrSv_SendData_s <= PrSv_ApdRdAdd_c;
                        elsif (PrSl_VthWrVld_s = '1') then 
                            PrSv_SendData_s <= PrSv_VthWrAdd_c;
                        elsif (PrSl_VthRdVld_s = '1') then 
                            PrSv_SendData_s <= PrSv_VthRdAdd_c;
                        elsif (PrSl_WrTrig1Vld_s = '1') then 
                            PrSv_SendData_s <= PrSv_WrAdd1_c;
                        elsif (PrSl_WrTrig2Vld_s = '1') then 
                            PrSv_SendData_s <= PrSv_WrAdd2_c;
                        else -- hold
                        end if;
                    else -- hold
                    end if;
                
                when "001" => -- Ad5242_Instruction
                    if (PrSv_I2CState_s = PrSv_StateWord_c) then
                        if (PrSl_ApdWrVld_s = '1') then
                            PrSv_SendData_s <= CpSl_ApdChannel_i & PrSv_Inst_c;
                        elsif (PrSl_ApdRdVld_s = '1') then
                            PrSv_SendData_s <= CpSl_ApdChannel_i & PrSv_Inst_c;
                        elsif (PrSl_VthWrVld_s = '1') then 
                            PrSv_SendData_s <= CpSl_VthChannel_i & PrSv_Inst_c;
                        elsif (PrSl_VthRdVld_s = '1') then 
                            PrSv_SendData_s <= CpSl_VthChannel_i & PrSv_Inst_c;
                        elsif (PrSl_WrTrig1Vld_s = '1') then 
                            PrSv_SendData_s <= PrSv_WrCmd_c;
                        elsif (PrSl_WrTrig2Vld_s = '1') then 
                            PrSv_SendData_s <= PrSv_WrCmd_c;
                        else -- hold
                        end if;
                    else -- hold
                    end if;
                    
                when "010" => -- Ad5242_Data
                    if (PrSv_I2CState_s = PrSv_StateWord_c) then
                        if (PrSl_ApdWrVld_s = '1') then
                            PrSv_SendData_s <= CpSv_ApdWrData_i;
                        elsif (PrSl_VthWrVld_s = '1') then 
                            PrSv_SendData_s <= CpSv_VthWrData_i;
                        elsif (PrSl_WrTrig1Vld_s = '1') then 
                            PrSv_SendData_s <= CpSv_WrVthData_i(11 downto 4);
                        elsif (PrSl_WrTrig2Vld_s = '1') then 
                            PrSv_SendData_s <= CpSv_WrTrigData_i(11 downto 4);
                        else -- hold
                        end if;
                    else -- hold
                    end if;
                
                when "011" => -- LTC2631
                    if (PrSv_I2CState_s = PrSv_StateWord_c) then
                        if (PrSl_WrTrig1Vld_s = '1') then 
                            PrSv_SendData_s <= CpSv_WrVthData_i(3 downto 0) & x"0";
                        elsif (PrSl_WrTrig2Vld_s = '1') then 
                            PrSv_SendData_s <= CpSv_WrTrigData_i(3 downto 0) & x"0";
                        else -- hold
                        end if;
                    else -- hold
                    end if;

                when others =>
                    PrSv_SendData_s <= PrSv_SendData_s;
            end case;
        end if;
    end process;
    
    -- PrSl_SendVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_SendVld_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_I2CState_s = PrSv_SendData_c) then
                if (PrSv_ClkCnt_s = 1) then
                    PrSl_SendVld_s <= '1';
                else
                    PrSl_SendVld_s <= '0';
                end if;
            else
                PrSl_SendVld_s <= '0';
            end if;
        end if;
    end process;
    
    -- PrSl_Sendbit_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin 
        if (CpSl_Rst_iN = '0') then 
            PrSl_Sendbit_s <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_SendData_c) then 
                case PrSv_bitCnt_s is 
                    when x"0" => 
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(7);
                        else
                        end if;
                    
                    when x"1" => 
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(6);
                        else
                        end if;
                    
                    when x"2" => 
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(5);
                        else
                        end if;
                    
                    when x"3" => 
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(4);
                        else
                        end if;
                    
                    when x"4" => 
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(3);
                        else
                        end if;
                    
                    when x"5" => 
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(2);
                        else
                        end if;
                    
                    when x"6" =>
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(1);
                        else
                        end if;
                    
                    when x"7" => 
                        if (PrSv_ClkCnt_s = 1) then
                            PrSl_Sendbit_s <= PrSv_SendData_s(0);
                        else
                        end if;        
                    when others => 
                        PrSl_Sendbit_s <= PrSl_Sendbit_s;
                end case;
            else
                PrSl_Sendbit_s <= '0';
            end if;
        end if;
    end process;
    
    -- PrSl_SdaData_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_SdaData_s <= '1';
        elsif rising_edge(CpSl_Clk_i) then 
            if (PrSv_I2CState_s = PrSv_Start_c) then
                PrSl_SdaData_s <= '0';
            elsif (PrSv_I2CState_s = PrSv_SendData_c) then 
                PrSl_SdaData_s <= PrSl_Sendbit_s;
            elsif (PrSv_I2CState_s = PrSv_Stop_c) then
                PrSl_SdaData_s <= '1';
            else -- hold
            end if;
        end if;
    end process;
    
    -- PrSl_SdaVld_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSl_SdaVld_s <= '1';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_Ack_c) then
                PrSl_SdaVld_s <= '0';
            else
                PrSl_SdaVld_s <= '1';
            end if;
        end if;
    end process;
    
    -- PrSv_StopCnt_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            PrSv_StopCnt_s <= (others => '0');
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_Stop_c) then
                if (PrSv_StopCnt_s = PrSv_2usCnt_c) then
                    PrSv_StopCnt_s <= (others => '0');
                else
                    PrSv_StopCnt_s <= PrSv_StopCnt_s + '1';
                end if;
            else
                PrSv_StopCnt_s <= (others => '0');
            end if;                
        end if;
    end process;
    
    -- CpSl_Finish_s
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_Finish_o <= '0';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_Finish_c and PrSv_VthWrCnt_s = 3) then
                CpSl_Finish_o <= '1';
            else
                CpSl_Finish_o <= '0';
            end if;                
        end if;
    end process;
    
    ------------------------------------
    -- I2C_Time
    ------------------------------------
    -- CpSl_Scl_o
    process (CpSl_Rst_iN,CpSl_Clk_i) begin
        if (CpSl_Rst_iN = '0') then
            CpSl_Scl_o <= '1';
        elsif rising_edge(CpSl_Clk_i) then
            if (PrSv_I2CState_s = PrSv_SendData_c or PrSv_I2CState_s = PrSv_Ack_c) then
                if (PrSv_ClkCnt_s = 0) then
                    CpSl_Scl_o <= '0';
                elsif (PrSv_ClkCnt_s = PrSv_2usCnt_c) then
                    CpSl_Scl_o <= '1';
                else -- hold
                end if;
            else
                CpSl_Scl_o <= '1';
            end if;
        end if;
    end process;

    -- CpSl_Sda_io
    CpSl_Sda_io <= PrSl_SdaData_s when PrSl_SdaVld_s = '1' else 'Z';


--------------------------------------------------------------------------------
-- End Coding
--------------------------------------------------------------------------------
end arch_M_I2C;