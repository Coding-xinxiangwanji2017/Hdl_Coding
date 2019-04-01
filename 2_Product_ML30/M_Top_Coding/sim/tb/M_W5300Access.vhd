--------------------------------------------------------------------------------
-- ��    Ȩ  :  ZVISION
-- �ļ�����  :  M_W5300Access.vhd
-- ��    ��  :  zhang wenjun
-- ��    ��  :  wenjun.zhang@zvision.xyz
-- У    ��  :
-- �������  :  2018/05/17
-- ���ܼ���  :  
-- �汾���  :  0.1
-- �޸���ʷ  :  1. Initial, zhang wenjun, 2018/05/17
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

--library unisim;
--use unisim.vcomponents.all;

--library altera_mf;
--use altera_mf.all; 

entity M_W5300Access is 
end M_W5300Access;

architecture arch_M_W5300Access of M_W5300Access is 
    ----------------------------------------------------------------------------
    -- Constant declaration
    ----------------------------------------------------------------------------
    constant Refresh_Rate               : integer := 150;
    constant Simulation                 : integer := 0;
    constant Use_ChipScope              : integer := 0;

    ----------------------------------------------------------------------------
    -- Component declaration
    ----------------------------------------------------------------------------
    component w5300_access
    port (
        ------------------------------------ 
        -- Clock & Reset                
        ------------------------------------ 
        clk                                 : in    std_logic;                      -- Clock,Sigl 40MHz
        nrst                                : in    std_logic;                      -- active,low

		inter_wr                            : in    std_logic;	                    -- �ڲ�д��tick 
		inter_rd                            : in    std_logic;	                    -- �ڲ�����tick 
		inter_addr                          : in    std_logic_vector( 9 downto 0);	-- �ڲ���ַ 
		inter_data_in                       : in    std_logic_vector(15 downto 0);	-- �ڲ��������� 
		inter_data_out                      : out   std_logic_vector(15 downto 0);	-- �ڲ�������� 
		
		------------------------------------ 
        -- W5300 Interface
        ------------------------------------ 
		nwr                                 : out   std_logic;	                    -- ����д�ź� 
		nrd                                 : out   std_logic;	                    -- ���ڶ��ź� 
		ncs                                 : out   std_logic;	                    -- ����Ƭѡ�ź�
		addr                                : out   std_logic_vector( 9 downto 0);  -- ���ڵ�ַ�ź� 
		data                                : inout std_logic_vector(15 downto 0)   -- ���������ź� 
    );
    end component;
    
    ----------------------------------------------------------------------------
    -- signal declaration
    ----------------------------------------------------------------------------
    signal clk                                 : std_logic;                       -- Clock,Sigl 40MHz
    signal nrst                                : std_logic;                       -- active,low
    signal inter_wr                            : std_logic;	                    -- �ڲ�д��tick 
    signal inter_rd                            : std_logic;	                    -- �ڲ�����tick 
    signal inter_addr                          : std_logic_vector( 9 downto 0);   -- �ڲ���ַ 
    signal inter_data_in                       : std_logic_vector(15 downto 0);   -- �ڲ��������� 
    signal inter_data_out                      : std_logic_vector(15 downto 0);   -- �ڲ�������� 
    
    signal nwr                                 : std_logic;	                    -- ����д�ź� 
    signal nrd                                 : std_logic;	                    -- ���ڶ��ź� 
    signal ncs                                 : std_logic;	                    -- ����Ƭѡ�ź�
    signal addr                                : std_logic_vector( 9 downto 0);   -- ���ڵ�ַ�ź� 
    signal data                                : std_logic_vector(15 downto 0);   -- ���������ź� 
    
begin
    ------------------------------------
    -- Compoonent map
    ------------------------------------
    U_w5300_access_0 : w5300_access 
    port map (
        ------------------------------------ 
        -- Clock & Reset                
        ------------------------------------ 
        clk                                 => clk                              , -- Clock,Sigl 40MHz
        nrst                                => nrst                             , -- active,low
                                                                                
		inter_wr                            => inter_wr                         ,-- �ڲ�д��tick 
		inter_rd                            => inter_rd                         ,-- �ڲ�����tick 
		inter_addr                          => inter_addr                       ,-- �ڲ���ַ 
		inter_data_in                       => inter_data_in                    ,-- �ڲ��������� 
		inter_data_out                      => inter_data_out                   ,-- �ڲ�������� 
		
		------------------------------------ 
        -- W5300 Interface
        ------------------------------------ 
		nwr                                 => nwr                              , -- ����д�ź� 
		nrd                                 => nrd                              , -- ���ڶ��ź� 
		ncs                                 => ncs                              , -- ����Ƭѡ�ź�
		addr                                => addr                             , -- ���ڵ�ַ�ź� 
		data                                => data                               -- ���������ź� 
	
    ); 

    ------------------------------------
    -- Sim Reset & Clock
    ------------------------------------
    process
    begin 
        nrst <= '0';
        wait for 25 ns;
        nrst <= '1';
        wait;
    end process;
    
    process
    begin 
        clk <= '1';
        wait for 12.5 ns;
        clk <= '0';
        wait for 12.5 ns;
    end process;
    
    
    ------------------------------------
    -- Wr/Rd/Add/Data
    ------------------------------------
    -- Wr
    process
    begin 
        inter_wr <= '0';
        wait for 50 ns;
        inter_wr <= '1';
        wait for 25 ns;
        inter_wr <= '0';
        wait for 75 ns;
        inter_wr <= '1';
        wait for 25 ns;
        inter_wr <= '0';
        wait;
    end process;

    -- Rd
    process
    begin 
        inter_rd <= '0';
        wait for 300 ns;
        inter_rd <= '1';
        wait for 25 ns;
        inter_rd <= '0';
        wait;
    end process;
    
    -- inter_addr
    process
    begin 
        inter_addr <= (others => '0');
        wait for 50 ns;
        inter_addr <= "00"&x"55";
        wait for 25 ns;
        inter_addr <= "00"&x"66";
        wait for 25 ns;
        inter_addr <= "00"&x"77";
        wait for 200 ns;
        inter_addr <= "11"&x"AA";
        wait for 25 ns;
        inter_addr <= "11"&x"BB";
        wait for 25 ns;
        inter_addr <= "11"&x"00";
        wait;
    end process;

    -- inter_data_in(Write Data)
    process 
    begin 
        inter_data_in <= (others => '0');
        wait for 50 ns;
        inter_data_in <= x"A5B4";
        wait for 25 ns;
        inter_data_in <= x"A5C4";
        wait for 25 ns;
        inter_data_in <= x"A5D4";
        wait;
    end process;
    
    process 
    begin
        data <= (others => 'Z');
        wait for 325 ns;
        data <= x"EB90";
        wait for 25 ns;
        data <= (others => 'Z');
        wait;
    end process;

end arch_M_W5300Access;