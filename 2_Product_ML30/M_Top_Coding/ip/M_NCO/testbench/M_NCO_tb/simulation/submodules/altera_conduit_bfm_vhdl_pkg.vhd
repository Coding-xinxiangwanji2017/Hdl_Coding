-- (C) 2001-2017 Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions and other 
-- software and tools, and its AMPP partner logic functions, and any output 
-- files from any of the foregoing (including device programming or simulation 
-- files), and any associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License Subscription 
-- Agreement, Intel FPGA IP License Agreement, or other applicable 
-- license agreement, including, without limitation, that your use is for the 
-- sole purpose of programming logic devices manufactured by Intel and sold by 
-- Intel or its authorized distributors.  Please refer to the applicable 
-- agreement for further details.


-- $Id: //acds/main/ip/sopc/components/verification/altera_tristate_conduit_bfm/altera_tristate_conduit_bfm.sv.terp#7 $
-- $Revision: #7 $
-- $Date: 2010/08/05 $
-- $Author: klong $
-------------------------------------------------------------------------------
-- =head1 NAME
-- altera_conduit_bfm
-- =head1 SYNOPSIS
-- Bus Functional Model (BFM) for a Standard Conduit BFM
-------------------------------------------------------------------------------
-- =head1 DESCRIPTION
-- This is a Bus Functional Model (BFM) VHDL package for a Standard Conduit Master.
-- This package provides the API that will be used to get the value of the sampled
-- input/bidirection port or set the value to be driven to the output ports.
-- This BFM's HDL is been generated through terp file in Qsys/SOPC Builder.
-- Generation parameters:
-- output_name:                  altera_conduit_bfm
-- role:width:direction:         clken:1:output,phi_inc_i:32:output
-- clocked                       1
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.all;



package altera_conduit_bfm_vhdl_pkg is

   -- output signal register
   type altera_conduit_bfm_out_trans_t is record
      sig_clken_out         : std_logic_vector(0 downto 0);
      sig_phi_inc_i_out     : std_logic_vector(31 downto 0);
   end record;
   
   shared variable out_trans        : altera_conduit_bfm_out_trans_t;

   -- input signal register
   signal reset_in              : std_logic;

   -- VHDL Procedure API
   
   -- set clken value
   procedure set_clken                 (signal_value : in std_logic_vector(0 downto 0));
   
   -- set phi_inc_i value
   procedure set_phi_inc_i             (signal_value : in std_logic_vector(31 downto 0));
   
   -- VHDL Event API
   procedure event_reset_asserted;

end altera_conduit_bfm_vhdl_pkg;

package body altera_conduit_bfm_vhdl_pkg is
   
   procedure set_clken                 (signal_value : in std_logic_vector(0 downto 0)) is
   begin
      
      out_trans.sig_clken_out := signal_value;
      
   end procedure set_clken;
   
   procedure set_phi_inc_i             (signal_value : in std_logic_vector(31 downto 0)) is
   begin
      
      out_trans.sig_phi_inc_i_out := signal_value;
      
   end procedure set_phi_inc_i;
   
   procedure event_reset_asserted is
   begin
   
      wait until (reset_in'event and reset_in = '1');
      
   end event_reset_asserted;

end altera_conduit_bfm_vhdl_pkg;

