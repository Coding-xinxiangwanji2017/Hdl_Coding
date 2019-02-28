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
-- Company      : ZVISION
-- Module_Name  : M_Top.vhd
-- Design_Name  : zhang wenjun
-- Emali        : wenjun.zhang@zvision.xyz
-- Create_Date  : 2019/01/30
-- Tool_Versions: Vivado_2018.3 
-- Description  : 
-- Revision     : 0.1
-- Revision     : 1. Initial, zhang wenjun, 2019/01/30
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity M_Top is
    Port ( 
        --------------------------------
		-- Clk & Reset
		--------------------------------
		CpSl_Rst_iN						: in  std_logic;						-- Reset,Active_low
		CpSl_Clk_i						: in  std_logic;						-- Clock,Single_100Mhz
        
        --------------------------------
		-- Test_IO
		--------------------------------
        CpSl_TestIO_o                   : out std_logic 						-- Test_IO
    );
end M_Top;

architecture arch_M_Top of M_Top is
    ----------------------------------------------------------------------------
    -- Constant_Describe
    ----------------------------------------------------------------------------
    
    ----------------------------------------------------------------------------
    -- Component_Describe
    ----------------------------------------------------------------------------
    component M_Jesd204bRx is
    port (
        --------------------------------
        -- Rx
        --------------------------------
        rx_reset                        : in  std_logic;
        rx_core_clk                     : in  std_logic;
        rx_sysref                       : in  std_logic;
        rx_sync                         : out std_logic;

        --  // Rx AXI-S interface for each lane
        rx_aresetn                      : out std_logic;
        rx_start_of_frame               : out std_logic_vector(  3 downto 0);
        rx_end_of_frame                 : out std_logic_vector(  3 downto 0);
        rx_start_of_multiframe          : out std_logic_vector(  3 downto 0);
        rx_end_of_multiframe            : out std_logic_vector(  3 downto 0);
        rx_frame_error                  : out std_logic_vector( 15 downto 0);
        rx_tvalid                       : out std_logic;
        rx_tdata                        : out std_logic_vector(127 downto 0);

        --------------------------------
        --  // Ports Required for GT
        --------------------------------
        rx_reset_gt                     : out std_logic;
        rxencommaalign_out              : out std_logic;
        rx_reset_done                   : in  std_logic;
        
        --  // Lane 0
        gt0_rxdata                      : in  std_logic(31 downto 0);
        gt0_rxcharisk                   : in  std_logic( 3 downto 0);
        gt0_rxdisperr                   : in  std_logic( 3 downto 0);
        gt0_rxnotintable                : in  std_logic( 3 downto 0);
        
        --  // Lane 1     
        gt1_rxdata                      : in  std_logic(31 downto 0);
        gt1_rxcharisk                   : in  std_logic( 3 downto 0);
        gt1_rxdisperr                   : in  std_logic( 3 downto 0);
        gt1_rxnotintable                : in  std_logic( 3 downto 0);
        
        --  // Lane 2
        gt2_rxdata                      : in  std_logic(31 downto 0);
        gt2_rxcharisk                   : in  std_logic( 3 downto 0);
        gt2_rxdisperr                   : in  std_logic( 3 downto 0);
        gt2_rxnotintable                : in  std_logic( 3 downto 0);

        --  // Lane 3
        gt3_rxdata                      : in  std_logic(31 downto 0);
        gt3_rxcharisk                   : in  std_logic( 3 downto 0);
        gt3_rxdisperr                   : in  std_logic( 3 downto 0);
        gt3_rxnotintable                : in  std_logic( 3 downto 0);

        --  // AXI-Lite Control/Status
        s_axi_aclk                     : in  std_logic;        
        s_axi_aresetn                  : in  std_logic;       
        s_axi_awaddr                   : in  std_logic_vector(11 downto 0);
        s_axi_awvalid                  : in  std_logic;        
        s_axi_awready                  : out std_logic;        
        s_axi_wdata                    : in  std_logic_vector(31 downto 0);
        s_axi_wstrb                    : in  std_logic_vector( 3 downto 0);
        s_axi_wvalid                   : in  std_logic;    
        s_axi_wready                   : out std_logic;       
        s_axi_bresp                    : out std_logic_vector( 1 downto 0);
        s_axi_bvalid                   : out std_logic;       
        s_axi_bready                   : in  std_logic;        
        s_axi_araddr                   : in  std_logic_vector(11 downto 0);  
        s_axi_arvalid                  : in  std_logic;        
        s_axi_arready                  : out std_logic;       
        s_axi_rdata                    : out std_logic_vector(31 downto 0);
        s_axi_rresp                    : out std_logic_vector( 1 downto 0);
        s_axi_rvalid                   : out std_logic;       
        s_axi_rready                   : in  std_logic
    );
    end component;
    
    
    ----------------------------------------------------------------------------
    -- Signal_Describe
    ----------------------------------------------------------------------------
    
    
begin
    ----------------------------------------------------------------------------
    -- Component_Map
    ----------------------------------------------------------------------------
    U_M_Jesd204bRx_0 : M_Jesd204bRx
    port map (
        --------------------------------
        -- Rx
        --------------------------------
        rx_reset                        =>    , -- in  std_logic;
        rx_core_clk                     =>    , -- in  std_logic;
        rx_sysref                       =>    , -- in  std_logic;
        rx_sync                         =>    , -- out std_logic;

        --  // Rx AXI-S interface for each lane
        rx_aresetn                      =>       , -- out std_logic;
        rx_start_of_frame               =>       , -- out std_logic_vector(  3 downto 0);
        rx_end_of_frame                 =>       , -- out std_logic_vector(  3 downto 0);
        rx_start_of_multiframe          =>       , -- out std_logic_vector(  3 downto 0);
        rx_end_of_multiframe            =>       , -- out std_logic_vector(  3 downto 0);
        rx_frame_error                  =>       , -- out std_logic_vector( 15 downto 0);
        rx_tvalid                       =>       , -- out std_logic;
        rx_tdata                        =>       , -- out std_logic_vector(127 downto 0);

        --------------------------------
        --  // Ports Required for GT
        --------------------------------
        rx_reset_gt                     =>  , -- out std_logic;
        rxencommaalign_out              =>  , -- out std_logic;
        rx_reset_done                   =>  , -- in  std_logic;

        --  // Lane 0                   
        gt0_rxdata                      =>  , -- in  std_logic(31 downto 0);
        gt0_rxcharisk                   =>  , -- in  std_logic( 3 downto 0);
        gt0_rxdisperr                   =>  , -- in  std_logic( 3 downto 0);
        gt0_rxnotintable                =>  , -- in  std_logic( 3 downto 0);

        --  // Lane 1                   
        gt1_rxdata                      =>  , -- in  std_logic(31 downto 0);
        gt1_rxcharisk                   =>  , -- in  std_logic( 3 downto 0);
        gt1_rxdisperr                   =>  , -- in  std_logic( 3 downto 0);
        gt1_rxnotintable                =>  , -- in  std_logic( 3 downto 0);

        --  // Lane 2                
        gt2_rxdata                      =>  , -- in  std_logic(31 downto 0);
        gt2_rxcharisk                   =>  , -- in  std_logic( 3 downto 0);
        gt2_rxdisperr                   =>  , -- in  std_logic( 3 downto 0);
        gt2_rxnotintable                =>  , -- in  std_logic( 3 downto 0);

        --  // Lane 3                
        gt3_rxdata                      =>  , -- in  std_logic(31 downto 0);
        gt3_rxcharisk                   =>  , -- in  std_logic( 3 downto 0);
        gt3_rxdisperr                   =>  , -- in  std_logic( 3 downto 0);
        gt3_rxnotintable                =>  , -- in  std_logic( 3 downto 0);

        --  // AXI-Lite Control/Status
        s_axi_aclk                      =>    ,-- in  std_logic;        
        s_axi_aresetn                   =>    ,-- in  std_logic;       
        s_axi_awaddr                    =>    ,-- in  std_logic_vector(11 downto 0);
        s_axi_awvalid                   =>    ,-- in  std_logic;        
        s_axi_awready                   =>    ,-- out std_logic;        
        s_axi_wdata                     =>    ,-- in  std_logic_vector(31 downto 0);
        s_axi_wstrb                     =>    ,-- in  std_logic_vector( 3 downto 0);
        s_axi_wvalid                    =>    ,-- in  std_logic;    
        s_axi_wready                    =>    ,-- out std_logic;       
        s_axi_bresp                     =>    ,-- out std_logic_vector( 1 downto 0);
        s_axi_bvalid                    =>    ,-- out std_logic;       
        s_axi_bready                    =>    ,-- in  std_logic;        
        s_axi_araddr                    =>    ,-- in  std_logic_vector(11 downto 0);  
        s_axi_arvalid                   =>    ,-- in  std_logic;        
        s_axi_arready                   =>    ,-- out std_logic;       
        s_axi_rdata                     =>    ,-- out std_logic_vector(31 downto 0);
        s_axi_rresp                     =>    ,-- out std_logic_vector( 1 downto 0);
        s_axi_rvalid                    =>    ,-- out std_logic;       
        s_axi_rready                    =>     -- in  std_logic        
    );
    
    ----------------------------------------------------------------------------
    -- Main_Coding
    ----------------------------------------------------------------------------
    
    
    
    
    
    ----------------------------------------------------------------------------
    -- End_Coding
    ----------------------------------------------------------------------------
end arch_M_Top;
