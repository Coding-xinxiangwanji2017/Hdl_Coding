`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/03/24 15:46:20
// Design Name: 
// Module Name: interrupt_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module interrupt_ctrl(
  input             clk,
  input             rst_n,

  output    reg                cfg_interrupt,
  input                         cfg_interrupt_rdy,
  output    reg                cfg_interrupt_assert,//msi interrupt mode,this signal is unused.
  output    [7:0]               cfg_interrupt_di,
  input     [7:0]               cfg_interrupt_do,
  input     [2:0]               cfg_interrupt_mmenable,
  input                         cfg_interrupt_msienable,
  input                         cfg_interrupt_msixenable,
  input                         cfg_interrupt_msixfm,
  output                        cfg_interrupt_stat,
  output    [4:0]               cfg_pciecap_interrupt_msgnum,

    input                 i_irq_link_change ,
    input                 i_sync_state_strict    ,  
    input                 i_irq_us_start ,
    output                o_irq_ack_link_change,
    output                o_irq_ack_sync_state_change,
    output                o_irq_ack_us_start,
    input  [31:0]         i_irq_link_change_flag   ,
    input  [31:0]         i_irq_us_start_flag   ,
    input                 i_dma_wr_done,
	output  reg           o_us_done,
	  input                 i_dma_rd_cmpl_done,
    input      [31:0]     i_interrupt_mask_reg,
    output reg [31:0]     o_interrupt_type_reg,
    
	input                 i_eth_data_rd_req,
    input                 i_cpu_rd_interrupt_type_en,
    input                 i_cpu_enable_mask_en,
    input                 i_cpu_release_mask_en,
    input      [31:0]     i_cpu_enable_mask_bit,              
    input      [31:0]     i_cpu_release_mask_bit,	
    input                 i_cpu_interrupt_ack

    );
    
    
    parameter STATE_IDLE              = 4'b0000;
    parameter STATE_SEND_MSI          = 4'b0001;
    parameter STATE_WAIT_INT_ACK      = 4'b0011;
    parameter STATE_INT_TIMEOUT       = 4'b0010;
    parameter STATE_WAIT_MASK         = 4'b0110;
    parameter STATE_WAIT_RELEASE_MASK = 4'b0111;
    parameter STATE_WAIT              = 4'b0101;

    parameter PARA_TIMEOUT_NUM        = 32'h80000000;
    
     reg [3:0]  state;
    reg [3:0]  state_d1;
    // msi logic begin
    reg    cfg_interrupt_rdy_d1;
    reg    cfg_interrupt_rdy_d2;
    reg    start_send_msi;
     wire [31:0]  interrupt_req_permit;
    
    wire       state_change;
    reg [31:0] state_keep_cnt;
    
     reg [31:0] interrupt_cnt;
     reg [31:0] cpu_rd_interrupt_type_en_cnt;
     reg [31:0] cpu_enable_mask_en_cnt;
     reg [31:0] cpu_release_mask_en_cnt;
     reg [31:0] irq_us_start_cnt;
     reg [31:0] irq_ack_us_start_cnt;
     reg irq_us_start_d1;
		
		reg       sync_state_strict_d1,sync_state_strict_d2,sync_state_strict_d3;
		reg       irq_sync_state_change;
		
    reg [7:0] interrupt_assert_cnt;
    wire [31:0] interrupt_req;
    reg       interrupt_req_d1;
    reg       interrupt_req_link_change;
    reg       interrupt_req_us_start;
    reg       interrupt_req_dma_wr_done;
    reg       interrupt_req_dma_rd_done;
    reg       interrupt_req_sync_state_change;
    /////////
    reg  irq_x10;
    reg [31:0] irq_ack_cnt;
    reg [63:0] time_cnt;
    
    reg  irq_ack_us_start;
    reg  irq_ack_us_start_d1;
    reg  irq_ack_link_change;
    reg  irq_ack_link_change_d1;
    reg  irq_ack_sync_state_change;
    reg  irq_ack_sync_state_change_d1;
	reg  proc_us_en_d1;
	reg  proc_us_en_d2;
     reg  proc_us_en;
     reg  proc_ds_en;
/*    always @ (posedge clk) begin
        if(!rst_n)
            irq_x10 <= 0;
        else if(irq_ack_cnt >= 32'd100000)
            irq_x10 <= 1'b0;
//        else if(cnt_test == 24'hbeb000)
        else if(cnt_test == 24'h100)
            irq_x10 <= 1'b1;
    end
    
    always @ (posedge clk) begin
        if(!rst_n)
            irq_ack_cnt <= 0;
        else if(i_cpu_rd_interrupt_type_en && state == STATE_WAIT_INT_ACK)
            irq_ack_cnt <= irq_ack_cnt + 1'b1;
    end
    always @ (posedge clk) begin
        if(!rst_n)
            time_cnt <= 0;
        else if(irq_x10)
            time_cnt <= time_cnt + 1'b1;
    end
*/    
//////////
    always @ (posedge clk) begin
        if(!rst_n)
            proc_us_en <= 0;
        else if(state == STATE_WAIT_RELEASE_MASK && i_cpu_release_mask_en && i_cpu_release_mask_bit[2])
            proc_us_en <= 1'b0;
        else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en && i_cpu_enable_mask_bit[1])
            proc_us_en <= 1'b1;
    end
	
    always @ (posedge clk) begin
        if(!rst_n)
            proc_ds_en <= 0;
        else if(state == STATE_WAIT_RELEASE_MASK && i_cpu_release_mask_en && i_cpu_release_mask_bit[3])
            proc_ds_en <= 1'b0;
        else if(i_eth_data_rd_req)
            proc_ds_en <= 1'b1;
    end


    assign interrupt_req = {27'h0                           ,
                            interrupt_req_sync_state_change ,
                            interrupt_req_dma_rd_done       ,
                            interrupt_req_dma_wr_done       ,
                            interrupt_req_us_start          ,
                            interrupt_req_link_change       };
                            
    assign interrupt_req_permit[31:5] = interrupt_req[31:5] & i_interrupt_mask_reg[31:5];
    assign interrupt_req_permit[4] = interrupt_req[4] & i_interrupt_mask_reg[4];//sync state change irq
    assign interrupt_req_permit[3] = interrupt_req[3] & i_interrupt_mask_reg[3] & ~proc_us_en;//dma read end
    assign interrupt_req_permit[2] = interrupt_req[2] & i_interrupt_mask_reg[2];//dma write end
    assign interrupt_req_permit[1] = interrupt_req[1] & i_interrupt_mask_reg[1] & ~proc_us_en  & ~proc_ds_en;//dma write start
    assign interrupt_req_permit[0] = interrupt_req[0] & i_interrupt_mask_reg[0];//link change irq
    
	
	
     always @ ( posedge clk ) begin
         if (!rst_n ) begin
             state <= STATE_IDLE;
             o_interrupt_type_reg <= 0;
         end
         else case(state)
             STATE_IDLE: begin
                 if(interrupt_req_permit[0] || interrupt_req_permit[1] || interrupt_req_permit[2] || interrupt_req_permit[3] || interrupt_req_permit[4]) begin
                     state <= STATE_SEND_MSI;
                     o_interrupt_type_reg <= interrupt_req_permit;
                 end
                 else if(i_cpu_rd_interrupt_type_en)begin
                     state <= STATE_WAIT_MASK;
                 end
                 else begin
                     state <= STATE_IDLE;
                 end

             end
             
             STATE_SEND_MSI: begin
                 state <= STATE_WAIT_INT_ACK;
                 
             end
             
             STATE_WAIT_INT_ACK: begin
                 if(!state_change && state_keep_cnt >= PARA_TIMEOUT_NUM)
                     state <= STATE_IDLE;
                 else if(i_cpu_rd_interrupt_type_en)
                     state <= STATE_WAIT_MASK;
                 else
                     state <= STATE_WAIT_INT_ACK;
             end
             
             STATE_INT_TIMEOUT: begin
                 state <= STATE_SEND_MSI;

             end
             
             STATE_WAIT_MASK: begin
                 if(i_cpu_enable_mask_en)
                     state <= STATE_WAIT_RELEASE_MASK;
                 else
                     state <= STATE_WAIT_MASK;
             end
             
             STATE_WAIT_RELEASE_MASK: begin
                 if(i_cpu_release_mask_en)
                     state <= STATE_WAIT;
                 else
                     state <= STATE_WAIT_RELEASE_MASK;
             end
             
             STATE_WAIT :begin
                 if(!state_change && state_keep_cnt >= 32'h3)
                     state <= STATE_IDLE;
                 else
                     state <= STATE_WAIT;
             end
             default : state <= STATE_IDLE;
         endcase                 
     end

      always @ ( posedge clk ) begin
          if (!rst_n )
              state_d1 <= 0;
          else
              state_d1 <= state;
      end

assign state_change = state_d1 != state;

always @ ( posedge clk ) begin
    if (!rst_n ) 
        state_keep_cnt <= 0;
    else if(state_change)
        state_keep_cnt <= 0;
    else 
        state_keep_cnt <= state_keep_cnt + 1'b1;
end

always @ ( posedge clk ) begin
    if (!rst_n )
        interrupt_req_link_change <= 0;
    else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en && i_cpu_enable_mask_bit[0])
        interrupt_req_link_change <= 0;
    else if(i_irq_link_change)
        interrupt_req_link_change <= 1;
end

always @ ( posedge clk ) begin
    if (!rst_n )
        interrupt_req_us_start <= 0;
    else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en && i_cpu_enable_mask_bit[1])
        interrupt_req_us_start <= 0;
    else if(i_irq_us_start)
        interrupt_req_us_start <= 1;
end

always @ ( posedge clk ) begin
    if (!rst_n )
        interrupt_req_dma_wr_done <= 0;
    else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en && i_cpu_enable_mask_bit[2])
        interrupt_req_dma_wr_done <= 0;
    else if(i_dma_wr_done)
        interrupt_req_dma_wr_done <= 1;
end

 always @ ( posedge clk ) begin
     if (!rst_n )
         interrupt_req_dma_rd_done <= 0;
     else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en && i_cpu_enable_mask_bit[3])
         interrupt_req_dma_rd_done <= 0;
     else if(i_dma_rd_cmpl_done)
         interrupt_req_dma_rd_done <= 1;
 end
 
 always @ ( posedge clk ) begin
     if (!rst_n ) begin
         sync_state_strict_d1 <= 1'b0;
         sync_state_strict_d2 <= 1'b0;
         sync_state_strict_d3 <= 1'b0;
     end
     else begin
         sync_state_strict_d1 <= i_sync_state_strict;
         sync_state_strict_d2 <= sync_state_strict_d1;
         sync_state_strict_d3 <= sync_state_strict_d2;
     end
 end
              
 always @ ( posedge clk ) begin
     if (!rst_n ) 
         irq_sync_state_change <= 1'b0;
     else if(sync_state_strict_d3 != sync_state_strict_d2)
         irq_sync_state_change <= 1'b1;
     else 
         irq_sync_state_change <= 1'b0;
 end     
         
 always @ ( posedge clk ) begin
    if (!rst_n )
        interrupt_req_sync_state_change <= 0;
    else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en && i_cpu_enable_mask_bit[4])
        interrupt_req_sync_state_change <= 0;
    else if(irq_sync_state_change)
        interrupt_req_sync_state_change <= 1;
end

always @ ( posedge clk ) begin
    if (!rst_n )
        irq_ack_link_change <= 0;
    else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en)
        irq_ack_link_change <= i_cpu_enable_mask_bit[0];
    else
        irq_ack_link_change <= 0;
end



always @ ( posedge clk ) begin
    if (!rst_n )
        irq_ack_us_start <= 0;
    else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en)
        irq_ack_us_start <= i_cpu_enable_mask_bit[1];
    else
        irq_ack_us_start <= 0;
end

always @ ( posedge clk ) begin
    if (!rst_n )
        irq_ack_sync_state_change <= 0;
    else if(state == STATE_WAIT_MASK && i_cpu_enable_mask_en)
        irq_ack_sync_state_change <= i_cpu_enable_mask_bit[4];
    else
        irq_ack_sync_state_change <= 0;
end

always @ ( posedge clk ) begin
    if (!rst_n ) begin
        irq_ack_link_change_d1 <= 0;
        irq_ack_us_start_d1    <= 0;
        irq_ack_sync_state_change_d1 <= 0;
    end    
    else begin
        irq_ack_link_change_d1 <= irq_ack_link_change;
        irq_ack_us_start_d1    <= irq_ack_us_start;
        irq_ack_sync_state_change_d1 <= irq_ack_sync_state_change;
    end
end

assign o_irq_ack_link_change       = irq_ack_link_change       || irq_ack_link_change_d1       ;
assign o_irq_ack_us_start          = irq_ack_us_start          || irq_ack_us_start_d1          ;
assign o_irq_ack_sync_state_change = irq_ack_sync_state_change || irq_ack_sync_state_change_d1 ;

always @ (posedge clk) begin
    if(!rst_n) begin
        cfg_interrupt_rdy_d1<= 0;
        cfg_interrupt_rdy_d2<= 0;
    end
    else begin
        cfg_interrupt_rdy_d1<= cfg_interrupt_rdy;
        cfg_interrupt_rdy_d2<= cfg_interrupt_rdy_d1;
    end
end

always @ (posedge clk) begin
    if(!rst_n)
        interrupt_assert_cnt <= 0;
    else if(cfg_interrupt_rdy_d2 && cfg_interrupt_assert)
        interrupt_assert_cnt <= 8'd200;    
    else if(interrupt_assert_cnt == 8'd0)
        interrupt_assert_cnt <= interrupt_assert_cnt;
    else
        interrupt_assert_cnt <= interrupt_assert_cnt - 1'b1;
end
        
always @ (posedge clk) begin
    if(!rst_n)
        start_send_msi <= 0;
    else if(state != STATE_IDLE && state_d1 == STATE_IDLE)
        start_send_msi <= 1'b1;
    else
        start_send_msi <= 1'b0;
end

always @ (posedge clk) begin
    if(!rst_n)
        interrupt_cnt <= 0;
    else if(start_send_msi)
        interrupt_cnt <= interrupt_cnt + 1'b1;
end


//debug code begin

always @ (posedge clk) begin
    if(!rst_n)
        cpu_rd_interrupt_type_en_cnt <= 0;
    else if(i_cpu_rd_interrupt_type_en)
        cpu_rd_interrupt_type_en_cnt <= cpu_rd_interrupt_type_en_cnt + 1'b1;
end
always @ (posedge clk) begin
    if(!rst_n)
        cpu_enable_mask_en_cnt <= 0;
    else if(i_cpu_enable_mask_en)
        cpu_enable_mask_en_cnt <= cpu_enable_mask_en_cnt + 1'b1;
end
always @ (posedge clk) begin
    if(!rst_n)
        cpu_release_mask_en_cnt <= 0;
    else if(i_cpu_release_mask_en)
        cpu_release_mask_en_cnt <= cpu_release_mask_en_cnt + 1'b1;
end
always @ (posedge clk) begin
    if(!rst_n) begin
	    irq_us_start_d1 <= 0;
		proc_us_en_d1   <= 0;
		proc_us_en_d2   <= 0;
	end
    else begin
	    irq_us_start_d1 <= i_irq_us_start;
		proc_us_en_d1   <= proc_us_en;
		proc_us_en_d2   <= proc_us_en_d1;
	end  
end	
	 
	always @ (posedge clk) begin
    if(!rst_n)
        o_us_done <= 0;
    else if((proc_us_en_d1 && !proc_us_en) || (proc_us_en_d2 && !proc_us_en_d1))
        o_us_done <= 1'b1;
    else
	    o_us_done <= 1'b0;
    end
	//assign o_us_done =  (proc_us_en_d1 && !proc_us_en) ? 1'b1 : 1'b0;
	always @ (posedge clk) begin
    if(!rst_n)
        irq_us_start_cnt <= 0;
    else if(i_irq_us_start && !irq_us_start_d1)
        irq_us_start_cnt <= irq_us_start_cnt + 1'b1;
    end
	always @ (posedge clk) begin
    if(!rst_n)
        irq_ack_us_start_cnt <= 0;
    else if(irq_ack_us_start)
        irq_ack_us_start_cnt <= irq_ack_us_start_cnt + 1'b1;
    end
	
	

//debug code end
     assign cfg_interrupt_di = 0;
     
     always @ (posedge clk) begin
         if(!rst_n)
             cfg_interrupt <= 0;
         else if(cfg_interrupt_rdy)
             cfg_interrupt <= 0;
         else if(start_send_msi || (interrupt_assert_cnt == 8'd1 && cfg_interrupt_assert && !cfg_interrupt_msienable))
             cfg_interrupt <= 1'b1;
     end
    
     always @ (posedge clk) begin
         if(!rst_n)
             cfg_interrupt_assert <= 0;
         else if(interrupt_assert_cnt == 8'd1)
             cfg_interrupt_assert <= 0;
         else if(start_send_msi && !cfg_interrupt_msienable)//cfg_interrupt_assert is used in legacy mode.
             cfg_interrupt_assert <= 1'b1;
     end
         
         
         
         assign cfg_interrupt_stat = 1'b0;
         assign cfg_pciecap_interrupt_msgnum = 5'h05;
         
         
    
    
    
    // msi logic end
    ////////////////////////////////////////////////////////////////

    
    
    
    
    
    
    
endmodule
