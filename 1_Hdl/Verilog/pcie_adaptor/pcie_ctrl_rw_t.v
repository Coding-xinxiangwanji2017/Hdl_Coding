//-----------------------------------------------------------------------------
//
// (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//-----------------------------------------------------------------------------
// Project    : Series-7 Integrated Block for PCI Express
// File       : PIO_EP.v
// Version    : 1.11
//
// Description: Endpoint Programmed I/O module.
//              Consists of Receive and Transmit modules and a Memory Aperture
//
//------------------------------------------------------------------------------

`timescale 1ps/1ps

module pcie_ctrl_rw_t #(
  parameter C_DATA_WIDTH = 64,            // RX/TX interface data width

  // Do not override parameters below this line
  parameter KEEP_WIDTH = C_DATA_WIDTH / 8,              // TSTRB width
  parameter TCQ        = 0
) (

  input                         clk,
  input                         rst_n,

    // AXIS local---->pcie core
  input                         i_s_axis_tx_tready,
  output  [C_DATA_WIDTH-1:0]    o64_s_axis_tx_tdata,
  output  [KEEP_WIDTH-1:0]      o8_s_axis_tx_tkeep,
  output                        o_s_axis_tx_tlast,
  output                        o_s_axis_tx_tvalid,
  output                        o_tx_src_dsc,

 // AXIS pcie core---->local
  input  [C_DATA_WIDTH-1:0]     i64_m_axis_rx_tdata,
  input  [KEEP_WIDTH-1:0]       i8_m_axis_rx_tkeep,
  input                         i_m_axis_rx_tlast,
  input                         i_m_axis_rx_tvalid,
  output                        o_m_axis_rx_tready,
  input    [21:0]               i22_m_axis_rx_tuser,
  
  input [15:0]                  i16_cfg_completer_id,

  output                        o_req_compl,
  output                        o_compl_done,

  input                 i_irq_link_change ,
  input                 i_sync_state_strict    ,  
  input                 i_irq_us_start ,
  output                o_irq_ack_link_change,
  output                o_irq_ack_sync_state_change,
  output                o_irq_ack_us_start,
  input  [31:0]         i_irq_link_change_flag   ,
  input  [31:0]         i_irq_us_start_flag   ,

  //pcie	transaction cpci
  input					i_pcie_wr_rdy,
  output					o_pcie_rd_wl_l, //1:rd 0:wr
  output					o_pcie_req,
  output		[26:0]	o27_pcie_addr,
  output		[31:0]	o32_pcie_wr_data,
  input		[31:0]	i32_pcie_rd_data,
  input					i_pcie_rd_valid,   
    
	output         o_us_done          ,
  output         o_rd_eth_fifo_en   ,
  input  [35:0]  i_rd_eth_fifo_data ,
  input          i_ds_rdy           ,
  output         o_wr_eth_fifo_en   ,
  output [35:0]  o_wr_eth_fifo_data ,
  
  output                        cfg_interrupt,
  input                         cfg_interrupt_rdy,
  output                        cfg_interrupt_assert,
  output    [7:0]               cfg_interrupt_di,
  input     [7:0]               cfg_interrupt_do,
  input     [2:0]               cfg_interrupt_mmenable,
  input                         cfg_interrupt_msienable,
  input                         cfg_interrupt_msixenable,
  input                         cfg_interrupt_msixfm,
  output                        cfg_interrupt_stat,
  output    [4:0]               cfg_pciecap_interrupt_msgnum

  


);

    // Local wires

    wire  [26:0]      w27_rd_addr;
    wire  [3:0]       w4_rd_be;

    wire  [26:0]      w27_wr_addr;
//    wire  [7:0]       w8_wr_be;
    wire  [31:0]      w32_wr_data;
    wire              w_wr_busy;

    wire              w_req_compl_int;
    wire              w_req_compl_wd;
    wire              w_compl_done_int;

    wire  [2:0]       w3_req_tc;
    wire              w_req_td;
    wire              w_req_ep;
    wire  [1:0]       w2_req_attr;
    wire  [9:0]       w10_req_len;
    wire  [15:0]      w16_req_rid;
    wire  [7:0]       w8_req_tag;
    wire  [7:0]       w8_req_be;
    wire  [26:0]      w27_req_addr;
	 
	 wire					w_pcie_wr_req;
	 wire					w_pcie_rd_req;
     
     
     wire             eth_flag_rd_req;
          wire             eth_flag_wr_req;
     reg              eth_data_rd_req;
     wire             eth_data_rd_ack;
	   wire             rd_eth_flag_en;
     reg  [31:0]      eth_flag_data;
     
     wire [31:0]      interrupt_type_reg;
      reg  [31:0]      interrupt_mask_reg;
     reg  [31:0]      link_status_reg;
     reg  [31:0]      dma_wr_address_reg;
     reg  [31:0]      dma_wr_mem_len_reg;
     reg  [31:0]      dma_wr_data_len_reg;
     reg  [31:0]      dma_ctrl_reg;
     reg  [31:0]      dma_rd_address_reg;
     reg  [31:0]      dma_rd_data_len_reg;
     
     reg              eth_data_wr_req;
     wire             eth_data_wr_ack;
     wire             dma_rd_cmpl_done;
     wire             dma_wr_done;
     reg              cpu_interrupt_ack;
     reg              irq_link_change_d1;
     reg              irq_us_start_d1;
     
      reg              cpu_rd_interrupt_type_en;
      reg              cpu_enable_mask_en;
      reg              cpu_release_mask_en;
      reg  [31:0]      cpu_enable_mask_bit;
      reg  [31:0]      cpu_release_mask_bit;
      reg  [31:0]      cpu_obtain_interrupt_type;
     
  pcie_ctrl_recive #(
    .C_DATA_WIDTH( C_DATA_WIDTH ),
    .KEEP_WIDTH( KEEP_WIDTH ),
    .TCQ( TCQ )

  ) pcie_ctrl_recive_inst (

    .clk(clk),                              
    .rst_n(rst_n),                          

    // AXIS RX
    .i64_m_axis_rx_tdata( i64_m_axis_rx_tdata ),      
    .i8_m_axis_rx_tkeep( i8_m_axis_rx_tkeep ),        
    .i_m_axis_rx_tlast( i_m_axis_rx_tlast ),         
    .i_m_axis_rx_tvalid( i_m_axis_rx_tvalid ),        
    .o_m_axis_rx_tready( o_m_axis_rx_tready ),        
    .i22_m_axis_rx_tuser ( i22_m_axis_rx_tuser ),       

    // Handshake with Tx engine
    .o_req_compl(w_req_compl_int),              
    .o_req_compl_wd(w_req_compl_wd),            
    .i_compl_done(w_compl_done_int),

    .o3_req_tc(w3_req_tc),                        
    .o_req_td(w_req_td),                        
    .o_req_ep(w_req_ep),                        
    .o2_req_attr(w2_req_attr),                    
    .o10_req_len(w10_req_len),                      
    .o16_req_rid(w16_req_rid),                      
    .o8_req_tag(w8_req_tag),                      
    .o8_req_be(w8_req_be),                        
    .o27_req_addr(w27_req_addr),                    
                                            
    // Memory Write Port                    
    .o27_wr_addr(w27_wr_addr),                // O [26:0]
    .o8_wr_be(),                      // O [7:0]
    .o32_wr_data(w32_wr_data),                // O [31:0]
//    .o_wr_en(wr_en),                          // O
    .i_wr_busy(w_wr_busy),                    // I
    
	 .o_pcie_rd_req(w_pcie_rd_req),
    .i_pcie_wr_rdy(i_pcie_wr_rdy),
	 .o_pcie_wr_req(w_pcie_wr_req), 
   
   .o_eth_flag_rd_req   (eth_flag_rd_req),
   .o_eth_flag_wr_req   (eth_flag_wr_req),
   .o_rd_eth_flag_en    (rd_eth_flag_en),
   .o_dma_rd_cmpl_done  (dma_rd_cmpl_done),
   .i_eth_data_rd_len           (dma_rd_data_len_reg),
   .i_ds_rdy            (i_ds_rdy          ),
	 .o_wr_eth_fifo_en    (o_wr_eth_fifo_en  ),
	 .o_wr_eth_fifo_data  (o_wr_eth_fifo_data)
	 
  );

    //
    // Local-Link Transmit Controller
    //
	wire rd_eth_fifo_en;
  pcie_ctrl_tx #(
    .C_DATA_WIDTH( C_DATA_WIDTH ),
    .KEEP_WIDTH( KEEP_WIDTH ),
    .TCQ( TCQ )
  )pcie_ctrl_tx_inst(

    .clk(clk),                                  // I
    .rst_n(rst_n),                              // I

    // AXIS Tx
    .i_s_axis_tx_tready( i_s_axis_tx_tready ),        
    .o64_s_axis_tx_tdata( o64_s_axis_tx_tdata ),          
    .o8_s_axis_tx_tkeep( o8_s_axis_tx_tkeep ),          
    .o_s_axis_tx_tlast( o_s_axis_tx_tlast ),          
    .o_s_axis_tx_tvalid( o_s_axis_tx_tvalid ),        
    .o_tx_src_dsc( o_tx_src_dsc ),                    

    // Handshake with Rx engine
    .i_req_compl(w_req_compl_int),                
    .i_req_compl_wd(w_req_compl_wd),             
    .o_compl_done(w_compl_done_int),                

    .i3_req_tc(w3_req_tc),                          
    .i_req_td(w_req_td),                         
    .i_req_ep(w_req_ep),                         
    .i2_req_attr(w2_req_attr),                      
    .i10_req_len(w10_req_len),                       
    .i16_req_rid(w16_req_rid),                        
    .i8_req_tag(w8_req_tag),                        
    .i8_req_be(w8_req_be),                          
    .i27_req_addr(w27_req_addr),                
    

    // Read Port

    .o27_rd_addr(w27_rd_addr),                        // O [26:0]
    .o4_rd_be(w4_rd_be),                            // O [3:0]
    .o32_rd_data(i32_pcie_rd_data),                        // I [31:0]

    .i16_completer_id(i16_cfg_completer_id) ,          // I [15:0]
	 
	 //.o_pcie_rd_req(w_pcie_rd_req),
	 .i_pcie_rd_valid(i_pcie_rd_valid),

   .i_eth_flag_data             (eth_flag_data),
   .i_eth_flag_rd_req           (eth_flag_rd_req),
   .i_rd_eth_flag_en            (rd_eth_flag_en),
   
   .i_eth_data_rd_req           (eth_data_rd_req),
   .o_eth_data_rd_ack           (eth_data_rd_ack),
   .i_eth_data_rd_len           (dma_rd_data_len_reg),
   .i_dma_rd_cmpl_done          (dma_rd_cmpl_done),
   
   .o_rd_eth_fifo_en   (o_rd_eth_fifo_en),
   .i_rd_eth_fifo_data (i_rd_eth_fifo_data),
   
   .i_eth_data_wr_req  (eth_data_wr_req),
   .o_eth_data_wr_ack  (eth_data_wr_ack),
   .i_eth_data_wr_len  ({dma_wr_data_len_reg[30:0],1'b0}    ),//multiply 2
   .i_dma_wr_address_reg  (dma_wr_address_reg),
   .i_dma_rd_address_reg  (dma_rd_address_reg),
   
   .o_dma_wr_done      (dma_wr_done)

   


    );
    
    
/***************************** rt switch core ***********************************************/
interrupt_ctrl u_interrupt_ctrl(
    .clk( clk ),                       // I
    .rst_n( rst_n ),                  // I 

    .cfg_interrupt                             ( cfg_interrupt                ),
    .cfg_interrupt_rdy                         ( cfg_interrupt_rdy            ),
    .cfg_interrupt_assert                      ( cfg_interrupt_assert         ),
    .cfg_interrupt_di                          ( cfg_interrupt_di             ),
    .cfg_interrupt_do                          ( cfg_interrupt_do             ),
    .cfg_interrupt_mmenable                    ( cfg_interrupt_mmenable       ),
    .cfg_interrupt_msienable                   ( cfg_interrupt_msienable      ),
    .cfg_interrupt_msixenable                  ( cfg_interrupt_msixenable     ),
    .cfg_interrupt_msixfm                      ( cfg_interrupt_msixfm         ),
    .cfg_interrupt_stat                        ( cfg_interrupt_stat           ),
    .cfg_pciecap_interrupt_msgnum              ( cfg_pciecap_interrupt_msgnum ),

    .i_irq_link_change     (i_irq_link_change     ),
    .i_sync_state_strict   (i_sync_state_strict),
    .i_irq_us_start        (i_irq_us_start        ),
    .o_irq_ack_link_change (o_irq_ack_link_change ),
    .o_irq_ack_sync_state_change (o_irq_ack_sync_state_change ),
    .o_irq_ack_us_start    (o_irq_ack_us_start    ),
    .i_irq_link_change_flag(i_irq_link_change_flag),
    .i_irq_us_start_flag   (i_irq_us_start_flag   ),  
    .i_interrupt_mask_reg(interrupt_mask_reg),
    .o_interrupt_type_reg(interrupt_type_reg),
    .i_dma_wr_done      (dma_wr_done),
	.o_us_done          (),
    .i_dma_rd_cmpl_done (dma_rd_cmpl_done),
    
    .i_eth_data_rd_req           (eth_data_rd_req),
    .i_cpu_rd_interrupt_type_en (cpu_rd_interrupt_type_en),
    .i_cpu_enable_mask_en(cpu_enable_mask_en),
    .i_cpu_release_mask_en(cpu_release_mask_en),
    .i_cpu_enable_mask_bit(cpu_enable_mask_bit),
	.i_cpu_release_mask_bit(cpu_release_mask_bit),
    .i_cpu_interrupt_ack  (cpu_interrupt_ack)

);

assign o_us_done = dma_wr_done;     

     always @ ( posedge clk ) begin
         if (!rst_n )
             cpu_interrupt_ack <= 0;
         else if(eth_flag_rd_req && w27_rd_addr[23:0] == 24'h0)
             cpu_interrupt_ack <= 1;
         else
             cpu_interrupt_ack <= 0;
     end
     
     always @ ( posedge clk ) begin
         if (!rst_n ) begin
         	   irq_link_change_d1 <= 0;
         	   irq_us_start_d1    <= 0;
         end
	       else begin 
	           irq_link_change_d1 <= i_irq_link_change;
         	   irq_us_start_d1    <= i_irq_us_start;
	       end
	   end
	   
  assign o_req_compl  = w_req_compl_int;
  assign o_compl_done = w_compl_done_int;
  
  assign 	w_wr_busy = w_pcie_wr_req || eth_flag_wr_req;
  assign		o27_pcie_addr = 	w_pcie_wr_req ? w27_wr_addr : w_pcie_rd_req ? w27_rd_addr : 27'd0;
  assign		o_pcie_req = 	(w_pcie_wr_req || w_pcie_rd_req);
  assign		o_pcie_rd_wl_l = 	w_pcie_wr_req ? 1'b0 :  1'b1 ; 
  assign		o32_pcie_wr_data = w32_wr_data;
  
  
      always @ ( posedge clk ) begin
          if (!rst_n )begin
              eth_flag_data <= 0;
          end
          else if(eth_flag_rd_req) begin
              case(w27_rd_addr[23:0])
              24'h0:
                  eth_flag_data <= interrupt_type_reg;
              24'h1:
                  eth_flag_data <= interrupt_mask_reg;
              24'h2:
                  eth_flag_data <= link_status_reg;
              24'h3:
                  eth_flag_data <= dma_wr_address_reg;
              24'h4:
                  eth_flag_data <= dma_wr_mem_len_reg;
              24'h5:
                  eth_flag_data <= {dma_wr_data_len_reg[30:0],1'b0};//multiply 2
              24'h6:
                  eth_flag_data <= dma_ctrl_reg;
              24'h7:
                  eth_flag_data <= dma_rd_address_reg;
              24'h8:
                  eth_flag_data <= dma_rd_data_len_reg;
              default:eth_flag_data <= 0;
              endcase
          end
      end    

          
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_obtain_interrupt_type <= 0;
          else if(eth_flag_rd_req && w27_rd_addr[23:0] == 24'h0)
              cpu_obtain_interrupt_type <= interrupt_type_reg;
          else
              cpu_obtain_interrupt_type <= cpu_obtain_interrupt_type;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              interrupt_mask_reg <= 0;          
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1) 
              interrupt_mask_reg <= w32_wr_data;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              link_status_reg <= 0;          
          else if(i_irq_link_change && !irq_link_change_d1) 
              link_status_reg <= i_irq_link_change_flag;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              dma_wr_address_reg <= 0;          
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h3) 
              dma_wr_address_reg <= w32_wr_data;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              dma_wr_mem_len_reg <= 0;          
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h4) 
              dma_wr_mem_len_reg <= w32_wr_data;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              dma_wr_data_len_reg <= 0;          
          else if(i_irq_us_start && irq_us_start_d1) 
              dma_wr_data_len_reg <= i_irq_us_start_flag;   
      end    
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              eth_data_wr_req <= 0;    
          else if(eth_data_wr_ack)
              eth_data_wr_req <= 1'b0;      
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h6 && w32_wr_data == 32'h1) 
              eth_data_wr_req <= 1'b1;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              eth_data_rd_req <= 0;    
          else if(eth_data_rd_ack)
              eth_data_rd_req <= 1'b0;      
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h6 && w32_wr_data == 32'h2) 
              eth_data_rd_req <= 1'b1;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              dma_rd_address_reg <= 0;          
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h7) 
              dma_rd_address_reg <= w32_wr_data;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              dma_rd_data_len_reg <= 0;          
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h8) 
              dma_rd_data_len_reg <= w32_wr_data;   
      end    

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_rd_interrupt_type_en <= 0;
          else if(eth_flag_rd_req && w27_rd_addr[23:0] == 24'h0)
              cpu_rd_interrupt_type_en <= 1;
          else
              cpu_rd_interrupt_type_en <= 0;
      end
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_enable_mask_en <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                ((w32_wr_data[0] == 1'b0 && interrupt_mask_reg[0] == 1'b1 && cpu_obtain_interrupt_type[0] == 1'b1) ||
                 (w32_wr_data[1] == 1'b0 && interrupt_mask_reg[1] == 1'b1 && cpu_obtain_interrupt_type[1] == 1'b1) ||
                 (w32_wr_data[2] == 1'b0 && interrupt_mask_reg[2] == 1'b1 && cpu_obtain_interrupt_type[2] == 1'b1) ||
                 (w32_wr_data[3] == 1'b0 && interrupt_mask_reg[3] == 1'b1 && cpu_obtain_interrupt_type[3] == 1'b1) ||
                 (w32_wr_data[4] == 1'b0 && interrupt_mask_reg[4] == 1'b1 && cpu_obtain_interrupt_type[4] == 1'b1)))
              cpu_enable_mask_en <= 1;
          else
              cpu_enable_mask_en <= 0;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_enable_mask_bit[0] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[0] == 1'b0 && interrupt_mask_reg[0] == 1'b1 && cpu_obtain_interrupt_type[0] == 1'b1))
              cpu_enable_mask_bit[0] <= 1;
          else
              cpu_enable_mask_bit[0] <= 0;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_enable_mask_bit[1] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[1] == 1'b0 && interrupt_mask_reg[1] == 1'b1 && cpu_obtain_interrupt_type[1] == 1'b1))
              cpu_enable_mask_bit[1] <= 1;
          else
              cpu_enable_mask_bit[1] <= 0;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_enable_mask_bit[2] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[2] == 1'b0 && interrupt_mask_reg[2] == 1'b1 && cpu_obtain_interrupt_type[2] == 1'b1))
              cpu_enable_mask_bit[2] <= 1;
          else
              cpu_enable_mask_bit[2] <= 0;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_enable_mask_bit[3] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[3] == 1'b0 && interrupt_mask_reg[3] == 1'b1 && cpu_obtain_interrupt_type[3] == 1'b1))
              cpu_enable_mask_bit[3] <= 1;
          else
              cpu_enable_mask_bit[3] <= 0;
      end
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_enable_mask_bit[4] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[4] == 1'b0 && interrupt_mask_reg[4] == 1'b1 && cpu_obtain_interrupt_type[4] == 1'b1))
              cpu_enable_mask_bit[4] <= 1;
          else
              cpu_enable_mask_bit[4] <= 0;
      end
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_enable_mask_bit[31:5] <= 0;
          else 
              cpu_enable_mask_bit[31:5] <= cpu_enable_mask_bit[31:5];
      end
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_release_mask_bit[0] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[0] == 1'b1 && interrupt_mask_reg[0] == 1'b0 && cpu_obtain_interrupt_type[0] == 1'b1))
              cpu_release_mask_bit[0] <= 1;
          else
              cpu_release_mask_bit[0] <= 0;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_release_mask_bit[1] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[1] == 1'b1 && interrupt_mask_reg[1] == 1'b0 && cpu_obtain_interrupt_type[1] == 1'b1))
              cpu_release_mask_bit[1] <= 1;
          else
              cpu_release_mask_bit[1] <= 0;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_release_mask_bit[2] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[2] == 1'b1 && interrupt_mask_reg[2] == 1'b0 && cpu_obtain_interrupt_type[2] == 1'b1))
              cpu_release_mask_bit[2] <= 1;
          else
              cpu_release_mask_bit[2] <= 0;
      end

      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_release_mask_bit[3] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[3] == 1'b1 && interrupt_mask_reg[3] == 1'b0 && cpu_obtain_interrupt_type[3] == 1'b1))
              cpu_release_mask_bit[3] <= 1;
          else
              cpu_release_mask_bit[3] <= 0;
      end
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_release_mask_bit[4] <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                 (w32_wr_data[4] == 1'b1 && interrupt_mask_reg[4] == 1'b0 && cpu_obtain_interrupt_type[4] == 1'b1))
              cpu_release_mask_bit[4] <= 1;
          else
              cpu_release_mask_bit[4] <= 0;
      end
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_release_mask_bit[31:5] <= 0;
          else 
              cpu_release_mask_bit[31:5] <= cpu_release_mask_bit[31:5];
      end
      
      always @ ( posedge clk ) begin
          if (!rst_n )
              cpu_release_mask_en <= 0;
          else if(eth_flag_wr_req && w27_wr_addr[23:0] == 24'h1 && 
                ((w32_wr_data[0] == 1'b1 && interrupt_mask_reg[0] == 1'b0 && cpu_obtain_interrupt_type[0] == 1'b1) ||
                 (w32_wr_data[1] == 1'b1 && interrupt_mask_reg[1] == 1'b0 && cpu_obtain_interrupt_type[1] == 1'b1) ||
                 (w32_wr_data[2] == 1'b1 && interrupt_mask_reg[2] == 1'b0 && cpu_obtain_interrupt_type[2] == 1'b1) ||
                 (w32_wr_data[3] == 1'b1 && interrupt_mask_reg[3] == 1'b0 && cpu_obtain_interrupt_type[3] == 1'b1) ||
                 (w32_wr_data[4] == 1'b1 && interrupt_mask_reg[4] == 1'b0 && cpu_obtain_interrupt_type[4] == 1'b1)))
              cpu_release_mask_en <= 1;
          else
              cpu_release_mask_en <= 0;
      end
      

endmodule 

