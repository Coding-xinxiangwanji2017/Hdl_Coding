-- M_NCO.vhd

-- Generated using ACDS version 17.1 590

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity M_NCO is
	port (
		clk       : in  std_logic                     := '0';             -- clk.clk
		clken     : in  std_logic                     := '0';             --  in.clken
		phi_inc_i : in  std_logic_vector(31 downto 0) := (others => '0'); --    .phi_inc_i
		fsin_o    : out std_logic_vector(17 downto 0);                    -- out.fsin_o
		fcos_o    : out std_logic_vector(17 downto 0);                    --    .fcos_o
		out_valid : out std_logic;                                        --    .out_valid
		reset_n   : in  std_logic                     := '0'              -- rst.reset_n
	);
end entity M_NCO;

architecture rtl of M_NCO is
	component M_NCO_nco_ii_0 is
		port (
			clk       : in  std_logic                     := 'X';             -- clk
			reset_n   : in  std_logic                     := 'X';             -- reset_n
			clken     : in  std_logic                     := 'X';             -- clken
			phi_inc_i : in  std_logic_vector(31 downto 0) := (others => 'X'); -- phi_inc_i
			fsin_o    : out std_logic_vector(17 downto 0);                    -- fsin_o
			fcos_o    : out std_logic_vector(17 downto 0);                    -- fcos_o
			out_valid : out std_logic                                         -- out_valid
		);
	end component M_NCO_nco_ii_0;

begin

	nco_ii_0 : component M_NCO_nco_ii_0
		port map (
			clk       => clk,       -- clk.clk
			reset_n   => reset_n,   -- rst.reset_n
			clken     => clken,     --  in.clken
			phi_inc_i => phi_inc_i, --    .phi_inc_i
			fsin_o    => fsin_o,    -- out.fsin_o
			fcos_o    => fcos_o,    --    .fcos_o
			out_valid => out_valid  --    .out_valid
		);

end architecture rtl; -- of M_NCO
