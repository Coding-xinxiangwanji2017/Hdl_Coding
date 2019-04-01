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
-- �ļ�����  :  M_W5300If.vhd
-- ��    ��  :  xx
-- ��    ��  :  Email
-- У    ��  :
-- ��������  :  2018/05/17
-- ���ܼ���  :  
-- �汾����  :  0.1
-- �޸���ʷ  :  1. Initial, xx, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity M_W5300If is
    port(
		------------------------------------ 
        -- Clock & Reset                
        ------------------------------------ 
        clk                                 : in    std_logic;                      -- Clock,Sigl 40MHz
        nrst                                : in    std_logic;                      -- active,low

		inter_wr                            : in    std_logic;	                    -- Write_Trig
		inter_rd                            : in    std_logic;	                    -- Read_Trig
		inter_addr                          : in    std_logic_vector( 9 downto 0);	-- �ڲ���ַ 
		inter_data_in                       : in    std_logic_vector(15 downto 0);	-- �ڲ��������� 
		inter_data_out                      : out   std_logic_vector(15 downto 0);	-- �ڲ��������� 
		
		------------------------------------ 
        -- W5300 Interface
        ------------------------------------ 
		nwr                                 : out   std_logic;	                    -- ����д�ź� 
		nrd                                 : out   std_logic;	                    -- ���ڶ��ź� 
		ncs                                 : out   std_logic;	                    -- ����Ƭѡ�ź�
		addr                                : out   std_logic_vector( 9 downto 0);  -- ���ڵ�ַ�ź� 
		data                                : inout std_logic_vector(15 downto 0)   -- ���������ź� 
	);
end M_W5300If;

architecture arch_M_W5300If of M_W5300If is
    ------------------------------------ 
    -- constant describe        
    ------------------------------------    
    constant PrSv_WrWaitCnt_c           : std_logic_vector( 2 downto 0) := "100";   -- Write Cnt
    constant PrSv_RdWaitCnt_c           : std_logic_vector( 2 downto 0) := "101";   -- Read Cnt
    constant PrSv_RdEndCnt_c            : std_logic_vector( 2 downto 0) := "100";   -- CS/Rd End
    ------------------------------------ 
    -- signal describe
    ------------------------------------ 
    signal s_wr_flag                    : std_logic;
    signal s_data_wr                    : std_logic_vector(15 downto 0);
    signal PrSv_AddrDly1Clk_s           : std_logic_vector( 9 downto 0);        -- Delay inter_addr 1Clk
    signal PrSv_WrWaitCnt_s             : std_logic_vector( 2 downto 0);        -- Write Cnt
    signal PrSv_RdWaitCnt_s             : std_logic_vector( 2 downto 0);        -- Read Cnt
    signal PrSl_DataTrig_s              : std_logic;                            -- Read Data Trig

begin
    ------------------------------------
    -- Main Area
    ------------------------------------
    -- Delay inter_addr 1Clk
    process (clk, nrst) begin 
        if (nrst = '0') then 
            PrSv_AddrDly1Clk_s <= (others => '0');
        elsif rising_edge(clk) then
            PrSv_AddrDly1Clk_s <= inter_addr;
        end if;
    end process;

    -- PrSv_WrWaitCnt_s
    process (clk, nrst) begin --
        if (nrst = '0') then 
            PrSv_WrWaitCnt_s <= (others => '1');
        elsif rising_edge(clk) then
            if (inter_wr = '1') then
                PrSv_WrWaitCnt_s <= (others => '0');
            elsif (PrSv_WrWaitCnt_s = PrSv_WrWaitCnt_c) then 
                PrSv_WrWaitCnt_s <= (others => '1');
            elsif (PrSv_WrWaitCnt_s = "111") then 
                PrSv_WrWaitCnt_s <= (others => '1');
            else
                PrSv_WrWaitCnt_s <= PrSv_WrWaitCnt_s + '1';
            end if;
        end if;
    end process;
    
    -- PrSv_RdWaitCnt_s
    process (clk, nrst) begin ----PrSv_RdWaitCnt_s信号用来计算读有效数据的时间(2拍)
        if (nrst = '0') then 
            PrSv_RdWaitCnt_s <= (others => '1');
        elsif rising_edge(clk) then
            if (inter_rd = '1') then
                PrSv_RdWaitCnt_s <= (others => '0');
            elsif (PrSv_RdWaitCnt_s = PrSv_RdWaitCnt_c) then 
                PrSv_RdWaitCnt_s <= (others => '1');
            elsif (PrSv_RdWaitCnt_s = "111") then 
                PrSv_RdWaitCnt_s <= (others => '1');
            else
                PrSv_RdWaitCnt_s <= PrSv_RdWaitCnt_s + '1';
            end if;
        end if;
    end process;
    
    -- ncs
    process (clk, nrst) begin
        if (nrst = '0') then
            ncs <= '1';
        elsif rising_edge(clk) then
            if (PrSv_WrWaitCnt_s = 0) then 
                ncs <= '0';
            elsif (PrSv_WrWaitCnt_s = 2) then---让写是能期间产生的片选信号低电平保持2个clk
                ncs <= '1';
            else -- hold
            end if;
            
            if (PrSv_RdWaitCnt_s = 0) then 
                ncs <= '0';
            elsif (PrSv_RdWaitCnt_s = PrSv_RdEndCnt_c) then--在读是能期间片选信号低电平保持4个clk
                ncs <= '1';
            else -- hold
            end if;
        end if;
    end process;
    
    -- nwr
    process (clk, nrst) begin 
        if (nrst = '0') then 
            nwr <= '1';
        elsif rising_edge(clk) then
            if (PrSv_WrWaitCnt_s = 0) then 
                nwr <= '0';
            elsif (PrSv_WrWaitCnt_s = 2) then ---输出的写使能信号低电平保持2个clk
                nwr <= '1';
            else -- hold
            end if;
        end if;
    end process;
    
    -- nrd
    process (clk, nrst) begin 
        if (nrst = '0') then 
            nrd <= '1';
        elsif rising_edge(clk) then
            if (PrSv_RdWaitCnt_s = 0) then 
                nrd <= '0';
            elsif (PrSv_RdWaitCnt_s = PrSv_RdEndCnt_c) then ---让nrd信号的低电平保持4个clk
                nrd <= '1';
            else -- hold
            end if;
        end if;
    end process;
    
    -- addr
    process (clk, nrst) begin
        if (nrst = '0') then
            addr <= (others => '1');
        elsif rising_edge(clk) then
            if (inter_wr = '1') then 
                addr <= inter_addr;
            elsif (inter_rd = '1') then 
                addr <= inter_addr;
            else -- hold
            end if;
        end if;
    end process;
    
    -- W5300_InterfaceData_Input
    process (clk, nrst) begin --读使能信号发出后延迟2个clk收到有效数据
        if (nrst = '0') then 
            inter_data_out <= (others => '0');
        elsif rising_edge(clk) then
            if (PrSv_RdWaitCnt_s = 2) then ---读信号与地址发出以后延迟2拍收到有效数据
               inter_data_out <= data;
            else -- hold
            end if;
        end if;
    end process;
    
    -- Read_DataTrig-----PrSl_DataTrig_s信号未起作用
    process (clk, nrst) begin
        if (nrst = '0') then 
            PrSl_DataTrig_s <= '0';
        elsif rising_edge(clk) then
            if (PrSv_RdWaitCnt_s = 3) then 
                PrSl_DataTrig_s <= '1';
            else
                PrSl_DataTrig_s <= '0';
            end if;
        end if; 
    end process;
    
    ------------------------------------
    -- W5300_InterfaceData_Output
    ------------------------------------
    -- s_wr_flag
    process (clk, nrst) begin ---产生3态开关信号，高电平有效，保持4个clk的高电平
        if (nrst = '0') then
            s_wr_flag <= '0';
        elsif rising_edge(clk) then
            if (inter_wr = '1') then
                s_wr_flag <= '1';
            elsif (PrSv_WrWaitCnt_s = 3) then 
                s_wr_flag <= '0';
            else -- hold
            end if;
        end if;
    end process;
    
    -- s_data_wr
    process (clk, nrst) begin 
        if (nrst = '0') then
            s_data_wr <= (others => '0');
        elsif rising_edge(clk) then
            if (inter_wr = '1') then 
                s_data_wr <= inter_data_in;
            else -- hold
            end if;
        end if;
    end process; 
	-- Data
	data <= s_data_wr when (s_wr_flag = '1') else (others => 'Z');

--------------------------------------------------------------------------------
-- End
--------------------------------------------------------------------------------
end arch_M_W5300If;