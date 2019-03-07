`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/08/29 11:12:05
// Design Name: 
// Module Name: format_9234
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


module format_9234(
    input clk,
    input clk_2x,
    input rst_n,
    input trig,
    output reg o_ps_irq,
    input [63:0] in_0,
    input [63:0] in_1,
    output reg [63:0] out_0,
    output reg [63:0] out_1,
    input i_adc_valid_0,
    input i_adc_valid_1,
    output o_adc_valid_0,
    output o_adc_valid_1,
    input i_adc_enable_0,
    input i_adc_enable_1,
    output o_adc_enable_0,
    output o_adc_enable_1,
    output reg [11:0] waveform_0,
    output reg [11:0] waveform_1
    );
    
  parameter RECV64_CNT = 'd250;  //4ns period, 1000ns total
  parameter TRIGtoRECV_DELAY = 0;
  parameter TRIGtoPSIRQ_DELAY = 0;
  
  `define TRIGtoTRANS_DELAY     (TRIGtoRECV_DELAY + 'd5)
  `define TRIGtoWAVE_DELAY      TRIGtoRECV_DELAY + 'd4 - TRIGtoRECV_DELAY % 'd4
  `define TRANS64_CNT           RECV64_CNT<<1
  `define WAVEFORM_CNT          RECV64_CNT<<2


    reg [63:0] data_0[RECV64_CNT-1:0],
                data_1[RECV64_CNT-1:0],
                stamp_0[RECV64_CNT-1:0],
                stamp_1[RECV64_CNT-1:0];
    //reg [63:0] out_0,out_1;
    //reg o_ps_irq;

    reg [31:0] m_counter;
    reg trig_dly;
    reg recv_en;
    reg trans_en;
    reg waveform_en;
   // reg [11:0] waveform_0,waveform_1;


    always @(posedge clk)
        trig_dly <= trig;

    always @(posedge clk or negedge rst_n)
        if(rst_n == 1'b0)
            m_counter <= 'd0;
        else if(trig == 1'b1 && trig_dly == 1'b0)
            m_counter <= 'd0;
        else
            m_counter <= m_counter + 'd1;

    //recv_en, control recevie data from 9680_core in_0 and in_1 to array
    always @(posedge clk or negedge rst_n)
        if(rst_n == 1'b0)
            recv_en <= 'd0;
        else if(m_counter == TRIGtoRECV_DELAY)
            recv_en <= 1'b1;
        else if(m_counter == TRIGtoRECV_DELAY + RECV64_CNT|| m_counter == 'd0)
            recv_en <= 1'b0;
        else
            recv_en <= recv_en;
            
    always @(posedge clk or negedge rst_n)
        if(rst_n == 1'b0)
            ;
        else if(recv_en == 1) begin
            data_0[m_counter - TRIGtoRECV_DELAY -1] <= ~in_0;//EVAL-AD9680 board CH-A analog input reverse
            data_1[m_counter - TRIGtoRECV_DELAY -1] <= in_1; //CH-B
            stamp_0[m_counter - TRIGtoRECV_DELAY -1] <= m_counter;  //CH-A time stamp
            stamp_1[m_counter - TRIGtoRECV_DELAY -1] <= m_counter;  //CH-B time stamp
        end else
            ;

    //trans_en, used for trans 'data' and 'time stamp' to out_0 and out_1, double length of recv_en
    always @(posedge clk or negedge rst_n)
        if(rst_n == 1'b0)
            trans_en <= 'd0;
        else if(m_counter == `TRIGtoTRANS_DELAY )
            trans_en <= 1'b1;
        else if(m_counter == `TRIGtoTRANS_DELAY + `TRANS64_CNT || m_counter == 'd0)
            trans_en <= 1'b0;
        else
            trans_en <= trans_en;
			
			
    always @(posedge clk or negedge rst_n)
        if(rst_n == 1'b0) begin
            out_0 <= 'd0;
			out_1 <= 'd0;
        end else if (trans_en == 1) begin
		    case (m_counter[0])	//interleave recv data and time stamp
				1'b0   :	begin
							out_0 <= data_0[ (m_counter - `TRIGtoTRANS_DELAY) >> 1];
							out_1 <= data_1[ (m_counter - `TRIGtoTRANS_DELAY) >> 1];
							end
                1'b1   :	begin
							out_0 <= stamp_0[ (m_counter - `TRIGtoTRANS_DELAY -1) >> 1];
							out_1 <= stamp_1[ (m_counter - `TRIGtoTRANS_DELAY -1) >> 1]; 
							end
            endcase
        end else begin
            out_0 <= 'd0;
			out_1 <= 'd0;
        end
		
		/*
	assign out_0 = rst_n
					& trans_en 
					& ( m_counter[0] == 1'b1 ) ? ( data_0[ (m_counter - TRIG_DELAY - 2) >> 1] ) : ( stamp_0[ (m_counter - TRIG_DELAY - 2) >> 1] );
					
	assign out_1 = rst_n 
					& trans_en 
					& ( m_counter[0] == 1'b1 ) ? ( data_1[ (m_counter - TRIG_DELAY - 2) >> 1] ) : ( stamp_1[ (m_counter - TRIG_DELAY - 2) >> 1] );*/

    //adc_valid
    assign o_adc_valid_0 = i_adc_valid_0 & trans_en;
    assign o_adc_valid_1 = i_adc_valid_1 & trans_en;

    //adc_enable
    assign o_adc_enable_0 = i_adc_enable_0;
    assign o_adc_enable_1 = i_adc_enable_1;
    
    //o_ps_irq
    always @(posedge clk or negedge rst_n)
        if(rst_n == 1'b0)
            o_ps_irq <= 'd0;
        else if(m_counter == TRIGtoPSIRQ_DELAY)
            o_ps_irq <= 1'b1;
        else if(m_counter == TRIGtoPSIRQ_DELAY + 'd50)
            o_ps_irq <= 1'b0;
        else
            o_ps_irq <= o_ps_irq;

    //waveform_en, transform 64bit sample data to 12/14bit for human look at ila, fourth greater than recv_en
    always @(posedge clk or negedge rst_n)
        if(rst_n == 1'b0)
            waveform_en <= 'd0;
        else if(m_counter == `TRIGtoWAVE_DELAY)
            waveform_en <= 1'b1;
        else if(m_counter == `TRIGtoWAVE_DELAY + `WAVEFORM_CNT || m_counter == 'd0)
            waveform_en <= 1'b0;
        else
            waveform_en <= waveform_en;

    always @(posedge clk or negedge rst_n)
        if (rst_n == 1'b0) begin
            waveform_0 <= 0;
        end else if (waveform_en == 1'b1) begin
            case (m_counter[1:0])
                2'b00   :   waveform_0 <= {data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][15],data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][12:2]};
                2'b01   :   waveform_0 <= {data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][31],data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][28:18]};
                2'b10   :   waveform_0 <= {data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][47],data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][44:34]};
                2'b11   :   waveform_0 <= {data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][63],data_0[(m_counter - `TRIGtoWAVE_DELAY)>>2][60:50]};
            endcase
        end else begin
            waveform_0 <= 0;
        end
        
    always @(posedge clk or negedge rst_n)
        if (rst_n == 1'b0) begin
            waveform_1 <= 0;
        end else if (waveform_en == 1'b1) begin
            case (m_counter[1:0])
                2'b00   :   waveform_1 <= {data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][15],data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][12:2]};
                2'b01   :   waveform_1 <= {data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][31],data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][28:18]};
                2'b10   :   waveform_1 <= {data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][47],data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][44:34]};
                2'b11   :   waveform_1 <= {data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][63],data_1[(m_counter - `TRIGtoWAVE_DELAY)>>2][60:50]};
            endcase
        end else begin
            waveform_1 <= 0;
        end

endmodule
