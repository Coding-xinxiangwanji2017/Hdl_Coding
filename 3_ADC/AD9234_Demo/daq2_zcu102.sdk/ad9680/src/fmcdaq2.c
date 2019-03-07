/***************************************************************************//**
 *   @file   ad_fmcdaq2_ebz.c
 *   @brief  Implementation of Main Function.
 *   @author DBogdan (dragos.bogdan@analog.com)
 *******************************************************************************
 * Copyright 2014-2016(c) Analog Devices, Inc.
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *  - Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *  - Neither the name of Analog Devices, Inc. nor the names of its
 *    contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *  - The use of this software may or may not infringe the patent rights
 *    of one or more patent holders.  This license does not release you
 *    from the requirement that you obtain separate licenses from these
 *    patent holders to use this software.
 *  - Use of the software either in source or binary form, must be run
 *    on or directly connected to an Analog Devices Inc. component.
 *
 * THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 ******************************************************************************/

/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/

#include "platform_drivers.h"
//#include "ad9144.h"
//#include "ad9523.h"
#include "ad9680.h"
#include "adc_core.h"
//#include "dac_core.h"
#include "dmac_core.h"
//#include "dac_buffer.h"
#include "xcvr_core.h"
#include "jesd_core.h"
#include "lmk04610.h"

/******************************************************************************/
/********************** Macros and Constants Definitions **********************/
/******************************************************************************/

//#define LITE_DISPLAY	1

#define GPIO_TRIG		43
#define GPIO_ADC_PD		42
//#define GPIO_DAC_TXEN		41
//#define GPIO_DAC_RESET		40
#define	GPIO_CLK_RESET	41
//#define GPIO_O1			40
#define GPIO_CLKD_SYNC		38
#define GPIO_ADC_FDB		36
#define GPIO_ADC_FDA		35
#define GPIO_DAC_IRQ		34
#define GPIO_CLKD_STATUS_1	33
#define GPIO_CLKD_STATUS_0	32

#define DMA_BUFFER		 0

enum ad9523_channels {
	DAC_DEVICE_CLK,
	DAC_DEVICE_SYSREF,
	DAC_FPGA_CLK,
	DAC_FPGA_SYSREF,
	ADC_DEVICE_CLK,
	ADC_DEVICE_SYSREF,
	ADC_FPGA_CLK,
	ADC_FPGA_SYSREF,
};

/***************************************************************************//**
 * @brief main
 ******************************************************************************/
/*int fmcdaq2_reconfig(struct ad9144_init_param *p_ad9144_param,
					 xcvr_core *p_ad9144_xcvr,
					 struct ad9680_init_param *p_ad9680_param,
			 	 	 xcvr_core *p_ad9680_xcvr,
					 struct ad9523_platform_data *p_ad9523_param)
{

	uint8_t mode = 0;

	printf ("Available sampling rates:\n");
	printf ("\t1 - ADC 1000 MSPS; DAC 1000 MSPS\n");
	printf ("\t2 - ADC  500 MSPS; DAC 1000 MSPS\n");
	printf ("\t3 - ADC  500 MSPS; DAC  500 MSPS\n");
	printf ("\t4 - ADC  600 MSPS; DAC  600 MSPS\n");
	printf ("choose an option [default 1]:\n");

	mode = ad_uart_read();

	switch (mode) {
		case '4':
			printf ("4 - ADC  600 MSPS; DAC  600 MSPS\n");
			p_ad9523_param->pll2_vco_diff_m1 = 5;
			(&p_ad9523_param->channels[DAC_FPGA_CLK])->
					channel_divider = 2;
			(&p_ad9523_param->channels[DAC_DEVICE_CLK])->
					channel_divider = 1;
			(&p_ad9523_param->channels[DAC_DEVICE_SYSREF])->
					channel_divider = 128;
			(&p_ad9523_param->channels[DAC_FPGA_SYSREF])->
					channel_divider = 128;
			(&p_ad9523_param->channels[ADC_FPGA_CLK])->
					channel_divider = 2;
			(&p_ad9523_param->channels[ADC_DEVICE_CLK])->
					channel_divider = 1;
			(&p_ad9523_param->channels[ADC_DEVICE_SYSREF])->
					channel_divider = 128;
			(&p_ad9523_param->channels[ADC_FPGA_SYSREF])->
					channel_divider = 128;
			p_ad9144_xcvr->reconfig_bypass = 0;
			p_ad9144_param->lane_rate_kbps = 6000000;
			p_ad9144_xcvr->lane_rate_kbps = 6000000;
			p_ad9144_xcvr->ref_clock_khz = 300000;
			p_ad9680_xcvr->reconfig_bypass = 0;
			p_ad9680_param->lane_rate_kbps = 6000000;
			p_ad9680_xcvr->lane_rate_kbps = 6000000;
			p_ad9680_xcvr->ref_clock_khz = 300000;
#ifdef XILINX
			p_ad9144_xcvr->dev.lpm_enable = 0;
			p_ad9144_xcvr->dev.qpll_enable = 0;
			p_ad9144_xcvr->dev.out_clk_sel = 4;

			p_ad9680_xcvr->dev.lpm_enable = 1;
			p_ad9680_xcvr->dev.qpll_enable = 0;
			p_ad9680_xcvr->dev.out_clk_sel = 4;
#endif
			break;
		case '3':
			printf ("3 - ADC  500 MSPS; DAC  500 MSPS\n");
			p_ad9523_param->pll2_vco_diff_m1 = 3;
			(&p_ad9523_param->channels[DAC_FPGA_CLK])->
					channel_divider = 4;
			(&p_ad9523_param->channels[DAC_DEVICE_CLK])->
					channel_divider = 2;
			(&p_ad9523_param->channels[DAC_DEVICE_SYSREF])->
					channel_divider = 256;
			(&p_ad9523_param->channels[DAC_FPGA_SYSREF])->
					channel_divider = 256;
			(&p_ad9523_param->channels[ADC_FPGA_CLK])->
					channel_divider = 4;
			(&p_ad9523_param->channels[ADC_DEVICE_CLK])->
					channel_divider = 2;
			(&p_ad9523_param->channels[ADC_DEVICE_SYSREF])->
					channel_divider = 256;
			(&p_ad9523_param->channels[ADC_FPGA_SYSREF])->
					channel_divider = 256;
			p_ad9144_xcvr->reconfig_bypass = 0;
			p_ad9144_param->lane_rate_kbps = 5000000;
			p_ad9144_xcvr->lane_rate_kbps = 5000000;
			p_ad9144_xcvr->ref_clock_khz = 250000;
			p_ad9680_xcvr->reconfig_bypass = 0;
			p_ad9680_param->lane_rate_kbps = 5000000;
			p_ad9680_xcvr->lane_rate_kbps = 5000000;
			p_ad9680_xcvr->ref_clock_khz = 250000;
#ifdef XILINX
			p_ad9144_xcvr->dev.lpm_enable = 1;
			p_ad9144_xcvr->dev.qpll_enable = 0;
			p_ad9144_xcvr->dev.out_clk_sel = 4;

			p_ad9680_xcvr->dev.lpm_enable = 1;
			p_ad9680_xcvr->dev.qpll_enable = 0;
			p_ad9680_xcvr->dev.out_clk_sel = 4;
#endif
			break;
		case '2':
			printf ("2 - ADC  500 MSPS; DAC 1000 MSPS\n");
			p_ad9523_param->pll2_vco_diff_m1 = 3;
			(&p_ad9523_param->channels[DAC_FPGA_CLK])->
					channel_divider = 2;
			(&p_ad9523_param->channels[DAC_DEVICE_CLK])->
					channel_divider = 1;
			(&p_ad9523_param->channels[DAC_DEVICE_SYSREF])->
					channel_divider = 128;
			(&p_ad9523_param->channels[DAC_FPGA_SYSREF])->
					channel_divider = 128;
			(&p_ad9523_param->channels[ADC_FPGA_CLK])->
					channel_divider = 4;
			(&p_ad9523_param->channels[ADC_DEVICE_CLK])->
					channel_divider = 2;
			(&p_ad9523_param->channels[ADC_DEVICE_SYSREF])->
					channel_divider = 256;
			(&p_ad9523_param->channels[ADC_FPGA_SYSREF])->
					channel_divider = 256;
			p_ad9144_xcvr->reconfig_bypass = 0;
			p_ad9144_param->lane_rate_kbps = 10000000;
			p_ad9144_xcvr->lane_rate_kbps = 10000000;
			p_ad9144_xcvr->ref_clock_khz = 500000;
			p_ad9680_xcvr->reconfig_bypass = 0;
			p_ad9680_param->lane_rate_kbps = 5000000;
			p_ad9680_xcvr->lane_rate_kbps = 5000000;
			p_ad9680_xcvr->ref_clock_khz = 250000;
#ifdef XILINX
			p_ad9144_xcvr->dev.lpm_enable = 0;
			p_ad9144_xcvr->dev.qpll_enable = 1;
			p_ad9144_xcvr->dev.out_clk_sel = 4;

			p_ad9680_xcvr->dev.lpm_enable = 1;
			p_ad9680_xcvr->dev.qpll_enable = 0;
			p_ad9680_xcvr->dev.out_clk_sel = 4;
#endif
			break;
		default:
			printf ("1 - ADC 1000 MSPS; DAC 1000 MSPS\n");
			p_ad9144_xcvr->ref_clock_khz = 500000;
			p_ad9680_xcvr->ref_clock_khz = 500000;
			break;
	}

	return(0);
}
*/
/***************************************************************************//**
 * @brief main
 ******************************************************************************/
int main(void)
{
	printf("\n\n### AD9680 TIME DELAY TEST 2018-09-27###\n");
	//spi_init_param	ad9523_spi_param;
	//spi_init_param	ad9144_spi_param;

	spi_init_param	ad9680_spi_param;

#ifdef ALTERA
	ad9523_spi_param.type = NIOS_II_SPI;
	ad9144_spi_param.type = NIOS_II_SPI;
	ad9680_spi_param.type = NIOS_II_SPI;
#endif
#ifdef ZYNQ_PS7
	ad9523_spi_param.type = ZYNQ_PS7_SPI;
	ad9144_spi_param.type = ZYNQ_PS7_SPI;
	ad9680_spi_param.type = ZYNQ_PS7_SPI;
#endif
#ifdef ZYNQ_PSU
	//ad9523_spi_param.type = ZYNQ_PSU_SPI;
	//ad9144_spi_param.type = ZYNQ_PSU_SPI;
	ad9680_spi_param.type = ZYNQ_PSU_SPI;
#endif
#ifdef MICROBLAZE
	ad9523_spi_param.type = MICROBLAZE_SPI;
	ad9144_spi_param.type = MICROBLAZE_SPI;
	ad9680_spi_param.type = MICROBLAZE_SPI;
#endif
	//ad9523_spi_param.chip_select = 0x6;
	//ad9144_spi_param.chip_select = 0x5;
	ad9680_spi_param.chip_select = 0x3;
	//ad9523_spi_param.cpha = 0;
	//ad9144_spi_param.cpha = 0;
	ad9680_spi_param.cpha = 0;
	//ad9523_spi_param.cpol = 0;
	//ad9144_spi_param.cpol = 0;
	ad9680_spi_param.cpol = 0;

	//struct ad9523_channel_spec	ad9523_channels[8];
	//struct ad9523_platform_data	ad9523_pdata;
	//struct ad9523_init_param	ad9523_param;
	//struct ad9144_init_param	ad9144_param;
	struct ad9680_init_param	ad9680_param;

	//ad9523_param.spi_init = ad9523_spi_param;
	//ad9144_param.spi_init = ad9144_spi_param;
	ad9680_param.spi_init = ad9680_spi_param;

	//struct ad9523_dev *ad9523_device;
	//struct ad9144_dev *ad9144_device;
	struct ad9680_dev *ad9680_device;

	//dac_core		ad9144_core;
	//dac_channel		ad9144_channels[2];
	//jesd_core		ad9144_jesd;
	//dmac_core		ad9144_dma;
	//xcvr_core		ad9144_xcvr;
	adc_core		ad9680_core;
	jesd_core		ad9680_jesd;
	xcvr_core		ad9680_xcvr;
	dmac_core               ad9680_dma;
	dmac_xfer               rx_xfer;
	//dmac_xfer               tx_xfer;



	spi_init_param	lmk04610_spi_param;
	lmk04610_spi_param.type = ZYNQ_PSU_SPI;
	lmk04610_spi_param.chip_select = 0x2;	//???
	lmk04610_spi_param.cpha = 0;
	lmk04610_spi_param.cpol = 0;

	struct lmk04610_init_param	lmk04610_param;
	lmk04610_param.spi_init = lmk04610_spi_param;

	struct lmk04610_dev *lmk04610_device;

//******************************************************************************
// setup the base addresses
//******************************************************************************

#ifdef XILINX
	//ad9144_xcvr.base_address = XPAR_AXI_AD9144_XCVR_BASEADDR;
	//ad9144_core.base_address = XPAR_AXI_AD9144_CORE_BASEADDR;
	//ad9144_jesd.base_address = XPAR_AXI_AD9144_JESD_TX_AXI_BASEADDR;
	//ad9144_dma.base_address = XPAR_AXI_AD9144_DMA_BASEADDR;
	ad9680_xcvr.base_address = XPAR_AXI_AD9680_XCVR_BASEADDR;
	ad9680_core.base_address = XPAR_AXI_AD9680_CORE_BASEADDR;
	ad9680_jesd.base_address = XPAR_AXI_AD9680_JESD_RX_AXI_BASEADDR;
	ad9680_dma.base_address = XPAR_AXI_AD9680_DMA_BASEADDR;
#endif

#ifdef ZYNQ
	rx_xfer.start_address = XPAR_DDR_MEM_BASEADDR + 0x800000;
	//tx_xfer.start_address = XPAR_DDR_MEM_BASEADDR + 0x900000;
#endif

#ifdef MICROBLAZE
	rx_xfer.start_address = XPAR_AXI_DDR_CNTRL_BASEADDR + 0x800000;
	tx_xfer.start_address = XPAR_AXI_DDR_CNTRL_BASEADDR + 0x900000;
#endif

#ifdef ALTERA
	ad9144_xcvr.base_address =
			AD9144_JESD204_LINK_MANAGEMENT_BASE;
	ad9144_xcvr.dev.link_pll.base_address =
			AD9144_JESD204_LINK_PLL_RECONFIG_BASE;
	ad9144_xcvr.dev.atx_pll.base_address =
			AD9144_JESD204_LANE_PLL_RECONFIG_BASE;
	ad9144_core.base_address =
			AXI_AD9144_CORE_BASE;
	ad9680_xcvr.base_address =
			AD9680_JESD204_LINK_MANAGEMENT_BASE;
	ad9680_xcvr.dev.link_pll.base_address =
			AD9680_JESD204_LINK_PLL_RECONFIG_BASE;
	ad9680_core.base_address =
			AXI_AD9680_CORE_BASE;
	ad9144_jesd.base_address =
			AD9144_JESD204_LINK_RECONFIG_BASE;
	ad9680_jesd.base_address =
			AD9680_JESD204_LINK_RECONFIG_BASE;

	ad9144_xcvr.dev.channel_pll[0].type = cmu_tx_type;
	ad9680_xcvr.dev.channel_pll[0].type = cmu_cdr_type;
	ad9144_xcvr.dev.channel_pll[0].base_address = AVL_ADXCFG_0_RCFG_S0_BASE;
	ad9680_xcvr.dev.channel_pll[0].base_address = AVL_ADXCFG_0_RCFG_S1_BASE;

	ad9680_dma.base_address = AXI_AD9680_DMA_BASE;
	ad9144_dma.base_address = AXI_AD9144_DMA_BASE;
	rx_xfer.start_address =  0x800000;
	tx_xfer.start_address =  0x900000;

#endif

//******************************************************************************
// clock distribution device (AD9523) configuration
//******************************************************************************
/*
	ad9523_pdata.num_channels = 8;
	ad9523_pdata.channels = &ad9523_channels[0];
	ad9523_param.pdata = &ad9523_pdata;
	ad9523_init(&ad9523_param);

	// dac device-clk-sysref, fpga-clk-sysref

	ad9523_channels[DAC_DEVICE_CLK].channel_num = 1;
	ad9523_channels[DAC_DEVICE_CLK].channel_divider = 1;
	ad9523_channels[DAC_DEVICE_SYSREF].channel_num = 7;
	ad9523_channels[DAC_DEVICE_SYSREF].channel_divider = 128;
	ad9523_channels[DAC_FPGA_CLK].channel_num = 9;
	ad9523_channels[DAC_FPGA_CLK].channel_divider = 2;
	ad9523_channels[DAC_FPGA_SYSREF].channel_num = 8;
	ad9523_channels[DAC_FPGA_SYSREF].channel_divider = 128;

	// adc device-clk-sysref, fpga-clk-sysref

	ad9523_channels[ADC_DEVICE_CLK].channel_num = 13;
	ad9523_channels[ADC_DEVICE_CLK].channel_divider = 1;
	ad9523_channels[ADC_DEVICE_SYSREF].channel_num = 6;
	ad9523_channels[ADC_DEVICE_SYSREF].channel_divider = 128;
	ad9523_channels[ADC_FPGA_CLK].channel_num = 4;
	ad9523_channels[ADC_FPGA_CLK].channel_divider = 2;
	ad9523_channels[ADC_FPGA_SYSREF].channel_num = 5;
	ad9523_channels[ADC_FPGA_SYSREF].channel_divider = 128;

	// VCXO 125MHz

	ad9523_pdata.vcxo_freq = 125000000;
	ad9523_pdata.spi3wire = 1;
	ad9523_pdata.osc_in_diff_en = 1;
	ad9523_pdata.pll2_charge_pump_current_nA = 413000;
	ad9523_pdata.pll2_freq_doubler_en = 0;
	ad9523_pdata.pll2_r2_div = 1;
	ad9523_pdata.pll2_ndiv_a_cnt = 0;
	ad9523_pdata.pll2_ndiv_b_cnt = 6;
	ad9523_pdata.pll2_vco_diff_m1 = 3;
	ad9523_pdata.pll2_vco_diff_m2 = 0;
	ad9523_pdata.rpole2 = 0;
	ad9523_pdata.rzero = 7;
	ad9523_pdata.cpole1 = 2;
*/
	//ad9144_xcvr.ref_clock_khz = 500000;

	//ad9680_xcvr.ref_clock_khz = 500000;//xiehb 20180921
	ad9680_xcvr.ref_clock_khz = 250000;

//******************************************************************************
// DAC (AD9144) and the transmit path (AXI_ADXCVR,
//	JESD204, AXI_AD9144, TX DMAC) configuration
//******************************************************************************
/*
	xcvr_getconfig(&ad9144_xcvr);
	ad9144_xcvr.reconfig_bypass = 1;
	//ad9144_xcvr.reconfig_bypass = 0;	//xiehb
#ifdef XILINX
	ad9144_xcvr.dev.qpll_enable = 1;
#endif
	ad9144_xcvr.lane_rate_kbps = 10000000;

	ad9144_jesd.rx_tx_n = 0;
	ad9144_jesd.scramble_enable = 1;
	ad9144_jesd.octets_per_frame = 1;
	ad9144_jesd.frames_per_multiframe = 32;
	ad9144_jesd.subclass_mode = 1;

	ad9144_channels[0].dds_dual_tone = 0;
	ad9144_channels[0].dds_frequency_0 = 33*1000*1000;
	ad9144_channels[0].dds_phase_0 = 0;
	ad9144_channels[0].dds_scale_0 = 500000;
	ad9144_channels[0].pat_data = 0xb1b0a1a0;
	ad9144_channels[1].dds_dual_tone = 0;
	ad9144_channels[1].dds_frequency_0 = 11*1000*1000;
	ad9144_channels[1].dds_phase_0 = 0;
	ad9144_channels[1].dds_scale_0 = 500000;
	ad9144_channels[1].pat_data = 0xd1d0c1c0;
	ad9144_channels[0].sel = DAC_SRC_DDS;
	ad9144_channels[1].sel = DAC_SRC_DDS;

	ad9144_param.lane_rate_kbps = 10000000;
	ad9144_param.spi3wire = 1;
	ad9144_param.jesd204_subclass = 1;
	ad9144_param.jesd204_scrambling = 1;
	ad9144_param.jesd204_mode = 4;
	ad9144_param.jesd204_lane_xbar[0] = 0;
	ad9144_param.jesd204_lane_xbar[1] = 1;
	ad9144_param.jesd204_lane_xbar[2] = 2;
	ad9144_param.jesd204_lane_xbar[3] = 3;

	ad9144_core.no_of_channels = 2;
	ad9144_core.resolution = 16;
	ad9144_core.channels = &ad9144_channels[0];

	ad9144_param.stpl_samples[0][0] =
			(ad9144_channels[0].pat_data >> 0)  & 0xffff;
	ad9144_param.stpl_samples[0][1] =
			(ad9144_channels[0].pat_data >> 16) & 0xffff;
	ad9144_param.stpl_samples[0][2] =
			(ad9144_channels[0].pat_data >> 0)  & 0xffff;
	ad9144_param.stpl_samples[0][3] =
			(ad9144_channels[0].pat_data >> 16) & 0xffff;
	ad9144_param.stpl_samples[1][0] =
			(ad9144_channels[1].pat_data >> 0)  & 0xffff;
	ad9144_param.stpl_samples[1][1] =
			(ad9144_channels[1].pat_data >> 16) & 0xffff;
	ad9144_param.stpl_samples[1][2] =
			(ad9144_channels[1].pat_data >> 0)  & 0xffff;
	ad9144_param.stpl_samples[1][3] =
			(ad9144_channels[1].pat_data >> 16) & 0xffff;
*/
//******************************************************************************
// ADC (AD9680) and the receive path ( AXI_ADXCVR,
//	JESD204, AXI_AD9680, TX DMAC) configuration
//******************************************************************************

	ad9680_param.lane_rate_kbps = 10000000;

	xcvr_getconfig(&ad9680_xcvr);
	ad9680_xcvr.reconfig_bypass = 1;
	//ad9680_xcvr.reconfig_bypass = 0;	//xiehb
#ifdef XILINX
	ad9680_xcvr.dev.qpll_enable = 1;
#endif
	ad9680_xcvr.rx_tx_n = 1;
	ad9680_xcvr.lane_rate_kbps = ad9680_param.lane_rate_kbps;

	ad9680_jesd.scramble_enable = 1;
	ad9680_jesd.octets_per_frame = 1;
	ad9680_jesd.frames_per_multiframe = 32;
	ad9680_jesd.subclass_mode = 1;

	ad9680_core.no_of_channels = 2;
	ad9680_core.resolution = 14;
	//ad9680_core.resolution = 12;	//xiehb

//******************************************************************************
// configure the receiver DMA
//******************************************************************************

	ad9680_dma.type = DMAC_RX;
	ad9680_dma.transfer = &rx_xfer;
	rx_xfer.id = 0;
	rx_xfer.no_of_samples = 32768;
/*
	ad9144_dma.type = DMAC_TX;
	ad9144_dma.transfer = &tx_xfer;
	ad9144_dma.flags = DMAC_FLAGS_TLAST;
	tx_xfer.id = 0;
	tx_xfer.no_of_samples = dac_buffer_load(ad9144_core, tx_xfer.start_address);

	// change the default JESD configurations, if required
	fmcdaq2_reconfig(&ad9144_param,
					 &ad9144_xcvr,
					 &ad9680_param,
					 &ad9680_xcvr,
					 ad9523_param.pdata);
*/
//******************************************************************************
// bring up the system
//******************************************************************************
	gpio_desc *clk_reset;
	gpio_get(&clk_reset, GPIO_CLK_RESET);
	gpio_set_value(clk_reset,  0);
	mdelay(30);
	gpio_set_value(clk_reset,  1);
	mdelay(200);

	//xiehb
	lmk04610_setup(&lmk04610_device, &lmk04610_param);
	mdelay(5);
	lmk04610_dev_start(lmk04610_device);
	mdelay(1000);

	// setup GPIOs

	//gpio_desc *clkd_sync;
	//gpio_desc *dac_reset;
	//gpio_desc *dac_txen;
	gpio_desc *adc_pd;

	//gpio_get(&clkd_sync, GPIO_CLKD_SYNC);
	//gpio_get(&dac_reset, GPIO_DAC_RESET);
	//gpio_get(&dac_txen,  GPIO_DAC_TXEN);
	gpio_get(&adc_pd,    GPIO_ADC_PD);

	//gpio_set_value(clkd_sync, 0);
	//gpio_set_value(dac_reset, 0);
	//gpio_set_value(dac_txen,  0);
	gpio_set_value(adc_pd,    1);
	mdelay(5);

	//gpio_set_value(clkd_sync, 1);
	//gpio_set_value(dac_reset, 1);
	//gpio_set_value(dac_txen,  1);
	gpio_set_value(adc_pd,    0);

	//gpio_desc *gpio_o1;
	//gpio_get(&gpio_o1, GPIO_O1);
	//gpio_set_value(GPIO_O1,  0);

	// setup clocks

	//ad9523_setup(&ad9523_device, &ad9523_param);

	// set up the devices
	ad9680_setup(&ad9680_device, &ad9680_param);
	//ad9144_setup(&ad9144_device, &ad9144_param);




	jesd_setup(&ad9680_jesd);
	//jesd_setup(&ad9144_jesd);

	// set up the XCVRs
#ifdef ALTERA
	xcvr_setup(&ad9144_xcvr);
	xcvr_setup(&ad9680_xcvr);
#endif
#ifdef XILINX
	// set up the XCVRs
	//if (ad9144_xcvr.dev.qpll_enable) {	// DAC_XCVR controls the QPLL reset
	//	xcvr_setup(&ad9144_xcvr);
		xcvr_setup(&ad9680_xcvr);
	//} else {				// ADC_XCVR controls the CPLL reset
	//	xcvr_setup(&ad9680_xcvr);
	//	xcvr_setup(&ad9144_xcvr);
	//}
#endif

	// JESD core status
	//axi_jesd204_tx_status_read(&ad9144_jesd);
	axi_jesd204_rx_status_read(&ad9680_jesd);

	//axi_jesd204_rx_laneinfo_read(&ad9680_jesd,0x0);//xiehb add
	//axi_jesd204_rx_laneinfo_read(&ad9680_jesd,0x1);//xiehb add
	//axi_jesd204_rx_laneinfo_read(&ad9680_jesd,0x2);//xiehb add
	//axi_jesd204_rx_laneinfo_read(&ad9680_jesd,0x3);//xiehb add

	// interface core set up
	adc_setup(ad9680_core);
	//dac_setup(&ad9144_core);

	//ad9144_status(ad9144_device);

	//jesd_status(&ad9680_jesd);//xiehb add

	//xiehb add
	//jesd_setup(&ad9680_jesd);
	//axi_jesd204_rx_status_read(&ad9680_jesd);


	//xiehb
	lmk04610_global_sysref(lmk04610_device);
	mdelay(100);



//******************************************************************************
// transport path testing
//******************************************************************************
/*
	ad9144_channels[0].sel = DAC_SRC_SED;
	ad9144_channels[1].sel = DAC_SRC_SED;
	dac_data_setup(&ad9144_core);
	ad9144_short_pattern_test(ad9144_device, &ad9144_param);

	// PN7 data path test

	ad9144_channels[0].sel = DAC_SRC_PN23;
	ad9144_channels[1].sel = DAC_SRC_PN23;
	dac_data_setup(&ad9144_core);
	ad9144_param.prbs_type = AD9144_PRBS7;
	ad9144_datapath_prbs_test(ad9144_device, &ad9144_param);

	// PN15 data path test

	ad9144_channels[0].sel = DAC_SRC_PN31;
	ad9144_channels[1].sel = DAC_SRC_PN31;
	dac_data_setup(&ad9144_core);
	ad9144_param.prbs_type = AD9144_PRBS15;
	ad9144_datapath_prbs_test(ad9144_device, &ad9144_param);
*/
//******************************************************************************
// receive path testing
//******************************************************************************

	ad9680_test(ad9680_device, AD9680_TEST_PN9);
	if(adc_pn_mon(ad9680_core, ADC_PN9) == -1) {
		printf("%s ad9680 - PN9 sequence mismatch!\n", __func__);
	};
	ad9680_test(ad9680_device, AD9680_TEST_PN23);
	if(adc_pn_mon(ad9680_core, ADC_PN23A) == -1) {
		printf("%s ad9680 - PN23 sequence mismatch!\n", __func__);
	};

	// default data

#if DMA_BUFFER
	ad9144_channels[0].sel = DAC_SRC_DMA;
	ad9144_channels[1].sel = DAC_SRC_DMA;
	dac_data_setup(&ad9144_core);

	if(!dmac_start_transaction(ad9144_dma)){
		printf("daq2: transmit data from memory\n");
	};
#else
	//ad9144_channels[0].sel = DAC_SRC_DDS;
	//ad9144_channels[1].sel = DAC_SRC_DDS;
	//dac_data_setup(&ad9144_core);

	//printf("daq2: setup and configuration is done\n");
#endif
//******************************************************************************
// external loopback - capture data with DMA
//******************************************************************************

	ad9680_test(ad9680_device, AD9680_TEST_OFF);//xiehb modify
/*
	ad9680_spi_write(ad9680_device,
			 AD9680_REG_OUTPUT_MODE,
			 AD9680_FORMAT_OFFSET_BINARY);//xiehb add
*/
	//xiehb add
	/*ad9680_spi_write(ad9680_device,
			 0x573,
			 0x001);*/
	//

	//ad9680_test(ad9680_device, 0x004);//xiehb add

	/*
		ad9680_spi_write(ad9680_device,
					 AD9680_REG_ADC_TEST_MODE,
					 0x004);*/

	/*uint8_t output;
	ad9680_spi_read(ad9680_device,
				AD9680_REG_OUTPUT_MODE,
				&output);
	printf("REG 9680_output: 0x%02x \n",output);
	*/



	//2018-09-27
/*	if(!dmac_start_transaction(ad9680_dma)){
		printf("daq2: RX capture done.\n");
	};

	//xiehb
	uint32_t read_data[10];
	for(int count = 0;count<10;count++)
	{
		read_data[count] = ad_reg_read((0x00800000+count*4));
		printf("read_data0x%08x 0x%016x\n",(0x00800000+count*4),read_data[count]);
	}*/





	//


/*
	uint8_t uart_readwrite = 0;
	uint8_t uart_address = 0;
	while(1)
	{
		printf ("AD9234 Reg Read(1) or Write(2):\n");
		uart_readwrite = ad_uart_read();
		if (uart_readwrite == '1')
				printf("Read Adress:");
		else if (uart_readwrite == '2')
				printf("Write Adress:");
		else{
				printf("Input wrong\n");
				continue;
		}

		uart_address = ad_uart_read();
		ad9680_spi_read

		ad9680_spi_write

	}
*/

	//xiehb add, print AD9234/9680 reg value
	//uint16_t array_c = 50;
	uint16_t reg_array[116]=
	{
		0x000,//ADC SPI REG
		0x001,
		0x002,
		0x003,
		0x004,
		0x005,
		0x006,
		0x008,
		0x00a,
		0x00b,
		0x00c,
		0x00d,
		0x015,
		0x016,
		0x018,
		0x024,
		0x028,
		0x03f,
		0x040,
		0x10b,
		0x10c,
		0x10d,
		0x117,
		0x118,
		0x11c,
		0x120,
		0x121,
		0x123,
		0x128,
		0x129,
		0x12a,
		0x1ff,
		0x200,
		0x201,
		0x228,
		0x245,
		0x247,
		0x248,
		0x249,
		0x24a,
		0x24b,
		0x24c,
		0x26f,
		0x270,
		0x271,
		0x272,
		0x273,
		0x279,
		0x27a,

		0x300,	//DDC REG
		0x310,
		0x311,
		0x314,
		0x315,
		0x320,
		0x321,
		0x327,
		0x330,
		0x331,
		0x334,
		0x335,
		0x340,
		0x341,
		0x347,

		0X550,	//TEST
		0x551,
		0x552,
		0x553,
		0x554,
		0x555,
		0x556,
		0x557,
		0x558,

		0x559,	//OUTPUT
		0x55A,
		0x561,
		0x562,
		0x563,
		0x564,

		0x56E,	//JESD204B
		0x56f,
		0x570,
		0x571,
		0x572,
		0x573,
		0x574,
		0x578,
		0x580,
		0x581,
		0x583,
		0x584,
		0x585,
		0x586,
		0x58B,
		0x58C,
		0x58D,
		0x58E,
		0x58F,
		0x590,
		0x591,
		0x592,
		0x5A0,
		0x5A1,
		0x5A2,
		0x5A3,
		0x5B0,
		0x5B2,
		0x5B3,
		0x5B5,
		0x5B6,
		0x5BF,

		0x5C1,	//De-emphasis
		0x5C2,
		0x5C3,
		0x5C4,
		0x5C5,

	};

	uint32_t jesd_reg_array[]=
	{
		0x000,
		0x004,
		0x008,
		0x00c,
		0x010,
		0x014,
		0x018,
		0x040,
		0x080,
		0x084,
		0x088,
		0x0c0,
		0x0c4,
		0x0c8,
		0x100,
		0x104,
		0x108,
		0x200,
		0x210,
		0x214,
		0x218,
		0x240,
		0x244,
		0x280,
		0x300,//lane0
		0x304,
		0x308,
		0x310,
		0x314,
		0x318,
		0x31c,
		0x320,//lane0
		0x324,
		0x328,
		0x330,
		0x334,
		0x338,
		0x33c,
		0x340,//lane2
		0x344,
		0x348,
		0x350,
		0x354,
		0x358,
		0x35c,
		0x360,//lane3
		0x364,
		0x368,
		0x370,
		0x374,
		0x378,
		0x37c,
	};

	uint16_t array_i = 0;
	uint8_t reg_value = 0;



/*
	printf("output reverse(Global)\n");
	ad9680_spi_write(ad9680_device, 0x008, 0x01);
	ad9680_spi_write(ad9680_device, 0x561, 0x05);
	ad9680_spi_write(ad9680_device, 0x008, 0x03);*/

	//ad9680_spi_write(ad9680_device, 0x016, 0x63);//50ohm

	//CH-B 1/2 input clock cycles delayed
	ad9680_spi_write(ad9680_device, 0x008, 0x02);
	ad9680_spi_write(ad9680_device, 0x10c, 0x01);
	ad9680_spi_write(ad9680_device, 0x008, 0x03);

	//AD9680 SYSREF mode select£º continuous
	ad9680_spi_write(ad9680_device, 0x120, 0x02);

	//enable fast detect output
	ad9680_spi_write(ad9680_device, 0x245, 0x01);

	//fda output LMFC, fdb output internal SYNC
	ad9680_spi_write(ad9680_device, 0x040, 0x11);

	//ignore the first 8 SYSREF transitions
	//ad9680_spi_write(ad9680_device, 0x121, 0x80);

	//JESD LINK RECV Setting the SYSREF_DISABLE ([0]) bit to 1 disables the SYSREF handling. All external SYSREF events are ignored and the LMFC is generated internally.
	//which means the subclass 0
	//jesd_write(&ad9680_jesd, 0x100, 0x0001);



	jesd_write(&ad9680_jesd, JESD204_REG_LINK_DISABLE, 1);
	//jesd_write(&ad9680_jesd, JESD204_REG_SYSREF_CONF, 1);

	//jesd_write(&ad9680_jesd, JESD204_REG_LINK_DISABLE, 1);
	mdelay(500);

	//jesd_write(&ad9680_jesd, JESD204_REG_SYSREF_CONF, 0);
	jesd_write(&ad9680_jesd, JESD204_REG_LINK_DISABLE, 0);

	mdelay(300);//pulse on 04610 output CH exist for more than 250ms



#define ADC_BASE_ADDR	0x00800000
#define ADC_CNT			1000	//single ADC channel samples, PL only transfer 1000
#define THRESHOLD_mV		50
#define THRESHOLD_ADC			(short)(THRESHOLD_mV*100) / (short)(ADC_SCALE_mV*100)
//#define THRESHOLD		(int)200
#define ADC_SCALE_mV		(float)1340/4095*1.4125*(50/47.16)	//12bit, 3dB AFE insertion loss, AC coupled, 47.16ohm input impedance, ¡Ö0.5mV
#define RECV_DELAY			0x0	//equal the HDL value
#define ADC_START_ADDR	0x00800000
#define ADC_END_ADDR	0x00801f5f
#define ADC_CAL			(short)0x10	//CH-B - CH-A = 0x10, this is rough!

//	ADC_START_ADDR + ((ADC_CNT << 2)-1)*0x20

	uint8_t capture = 0;
	int testcount = 0;
	while(1)
	{

		//printf("\n### Press 't' to calc tof, 'c' to caputre, 'r' to read 9234 reg value, 'j' to read jesd reg value, add ENTER ###\n");
		//capture = ad_uart_read();
		{
			mdelay(3000);
			capture = 't';
			testcount++;
			printf("\n\n			***Test[%d]***",testcount);
		}

		if(capture == 't')
		{
#ifndef LITE_DISPLAY
			printf("\n***You choose: t, calc tof!.\n");
			printf("THRESHOLD SET  %dmV\n", THRESHOLD_mV);
			printf("THRESHOLD ADC  0x%08x(%d)\n", THRESHOLD_ADC,THRESHOLD_ADC);
			printf("THRESHOLD ACT  %fmV\n", (float)THRESHOLD_ADC * ADC_SCALE_mV);
			printf("ADC_SCALE_mV   %fmV\n", ADC_SCALE_mV);
			//printf("ADC_BASE_ADDR 0x%08x\n", ADC_BASE_ADDR);
#endif

	//***DMA transfer
			ad9680_dma.type = DMAC_RX;
			ad9680_dma.transfer = &rx_xfer;
			rx_xfer.id = 0;
			rx_xfer.no_of_samples = (ADC_CNT << 2) + 0x20;
					//2048;
												//rx_xfer.no_of_samples = CH-A samples + CH-B samples, every 4 CH-A and CH-B samples to be a 128-bit data, like 0x00800010
												//we transfer CH-A and CH-B samples and time-stamp, so transfer 4 times the ADC_CNT
			int time_out = 20;
			do{
				mdelay(10);
				if(!dmac_start_transaction(ad9680_dma))	{
					//printf("daq2: RX capture done.\n");
#ifndef LITE_DISPLAY
					printf(".");
#endif
				};
				time_out--;
				if(time_out == 0)	{
					printf("daq time out\n");
					break;
				}
				/*
				uint32_t read_data[2000];
				for(int count = 0;count<2000;count++)	{
					read_data[count] = ad_reg_read((0x00800000+count*4));
					printf("read_data0x%08x 0x%08x\n",(0x00800000+count*4),read_data[count]);
				}*/
				//printf("read_data0x%08x 0x%08x\n",ADC_START_ADDR,ad_reg_read(ADC_START_ADDR));
				//printf("read_data0x%08x 0x%08x\n",0x00801f40,ad_reg_read(0x00801f40));
				//printf("read_data0x%08x 0x%08x\n",0x00801f50,ad_reg_read(0x00801f50));
			}
			while(ad_reg_read(ADC_START_ADDR) != RECV_DELAY ||	ad_reg_read(ADC_END_ADDR-0x10-0x0f) != 0x00fa00fa);	//the first sample value should be RECV_DELAY
#ifndef LITE_DISPLAY
			printf("daq2: RX capture done.\n");
#endif

			//Pick up all useful wave sample, that means all the samples between the first and last sample that exceed THRESHOLD

				//address:	10	FE		DC		BA		98		76		54		32		10
				//Sample:		B(N+3)	A(N+3)	B(N+2)	A(N+2)	B(N+1)	A(N+1)	B(N)	A(N)
				//address:	20	FE		DC		BA		98		76		54		32		10
				//time-stamp:	--		--		--		--		--		--		B(time)	A(time)
				//
				//A(time) equals B(time), need manual add delay 0.5ns


	//1st, find the start and end sample position
			short sample_value;
			int mi = 0;	//memory address count
			int ai = 0;	//adc value count
			int x = 0;
			int i=0;

			uint32_t ADC_sof_addr;
			uint32_t ADC_eof_addr;

			mi = 0x10;
			int sof_count = 0;
			for(i=0; i<(ADC_CNT>>2); i++,mi = mi+0x20)	{
				for(ai=0x0; ai<0xf; ai=ai+0x02)		{
					sample_value = (short)(Xil_In16(ADC_START_ADDR + mi + ai)) >> 2;//bit0 bit1 art control bit, delete
					//if(abs(sample_value) > THRESHOLD_ADC)	{
					if((sample_value) > THRESHOLD_ADC)	{
						if(sof_count == 0)
							ADC_sof_addr = ADC_START_ADDR + mi + ai;
						sof_count++;
						//printf("*ADC_sof_addr temp %d : 0x%08x value: 0x%04x\n",sof_count, ADC_START_ADDR + mi + ai,sample_value);
						if(sof_count > 2)
							break;
					}
					else	{
						if(sof_count != 0)
							sof_count = 0;
					}
				}
				if(sof_count > 2)	{
#ifndef LITE_DISPLAY
					printf("ADC_sof_addr: 0x%08x value: 0x%04x\n",ADC_sof_addr,(short)(Xil_In16(ADC_sof_addr)) >> 2);
#endif
					break;
				}
			}

			mi = 0x00;
			int eof_count = 0;
			for(i=0; i<(ADC_CNT>>2); i++,mi = mi+0x20)	{
				for(ai=0x1; ai<0xf; ai=ai+0x02)		{
					sample_value = (short)(Xil_In16(ADC_END_ADDR - mi - ai)) >> 2;//bit0 bit1 art control bit, delete
					//if(abs(sample_value) > THRESHOLD_ADC)	{
					if((sample_value) > THRESHOLD_ADC)	{
						if(eof_count == 0)
							ADC_eof_addr = (ADC_END_ADDR - mi - ai);
						eof_count++;
						//printf("*ADC_eof_addr temp %d : 0x%08x value: 0x%04x\n",eof_count, ADC_END_ADDR - mi - ai,sample_value);
						if(eof_count > 2)
							break;
					}
					else	{
						if(eof_count != 0)
							eof_count = 0;
					}
				}
				if(eof_count > 2)	{
#ifndef LITE_DISPLAY
					printf("ADC_eof_addr: 0x%08x value: 0x%04x\n",ADC_eof_addr,(short)(Xil_In16(ADC_eof_addr)) >> 2);
#endif
					break;
				}
			}

	//record wave and time-stamp
			short wave[1000];
			float time_stamp[1000];
			uint32_t addr_i;
			for(addr_i=ADC_sof_addr, i = 0, x=0; addr_i <= ADC_eof_addr; )	{
				if( (addr_i & 0x00000010) == 0)	{//time-stamp
					addr_i = addr_i + 0x10;
				}
				else	{//ADC sample value
					wave[i] = (short)(Xil_In16(addr_i)) >> 2;
					if( (addr_i & 0x00000002) == 0x02 )	{//CH-B sample value calibrate, for interleave
						wave[i] = wave[i] - ADC_CAL;
						//printf("CH-B CALIBRATE.\n");
					}
					//printf("addr 0x%08x  0x%04x\n", addr_i, wave[i]);
					addr_i = addr_i + 0x02;
					i++;
				}
			}
			uint32_t adc_amount = i;

			//because the samples between the ADC_sof_addr and ADC_eof_addr and continue, time-stamp can add continued
			time_stamp[0] = (Xil_In16( (ADC_sof_addr - 0x10) & 0xffffffff0)<<2) + (((ADC_sof_addr & 0x0000000f)) * 0.25);	//CH-A and CH-B time-stamp are the same, every 4 sample have a time-stamp, so <<2, units: ns
			//time_stamp[0] = time_stamp[0] - 2;	//adapt HDL
			//printf("(Xil_In16( (ADC_sof_addr - 0x10) & 0xffffffff0)) %x\n",(Xil_In16( (ADC_sof_addr - 0x10) & 0xffffffff0)));
			//printf("(Xil_In16( (ADC_sof_addr - 0x10) & 0xffffffff0)<<2) %x\n",(Xil_In16( (ADC_sof_addr - 0x10) & 0xffffffff0)<<2));
			//printf("(((ADC_sof_addr & 0x0000000f)) * 0.25) %f\n",(((ADC_sof_addr & 0x0000000f)) * 0.25));
			for(i=0; i<adc_amount; i++)	{
				time_stamp[i+1] = time_stamp[i] + 0.5;//interleave sample, 0.5ns
			}
#ifndef LITE_DISPLAY
			printf("No.  wave-x  wave-d  time-stamp\n");
			for(i=0; i<adc_amount; i++){
				printf("% 3d  %04x  % 4d  %f\n",i, wave[i], wave[i],time_stamp[i]);
			}
#endif

	//
			if(adc_amount > 0)	{
				float product_tv = 0;
				//float barycenter_rise;
				float barycenter_total;
				int adc_sum = 0;
				i = 0;
				do	{
					product_tv = product_tv + wave[i] * time_stamp[i];
					adc_sum = adc_sum + (int)wave[i];
					//printf("i %d , product_tv %f , adc_sum %d, \n",i, product_tv,adc_sum);
					i++;
					//printf("adc_sum %d\n", adc_sum);
				}
				while(i<adc_amount);

				barycenter_total = (float)product_tv / (float)adc_sum;
				printf("					***tof: %f ns.\n",barycenter_total);
			}

		}

		else if(capture == 'c')	{
			if(!dmac_start_transaction(ad9680_dma)){
				printf("AD9234: RX capture done.\n");
			};


			uint32_t read_data[500];
			for(int count = 0;count<500;count++)	{
				read_data[count] = ad_reg_read((0x00800000+count*4));
			}

			printf("CH-A\n");
			for(int count = 0;count<500;count++)	{
				printf("%04x\n",read_data[count]&0xffff);
			}
/*
			printf("\nCH-B\n");
			for(int count = 0;count<300;count++)
			{
				printf("%04x\n",(read_data[count]>>16)&0xffff);
			}
*/

			/*
			uint32_t read_data[100];
			for(int count = 0;count<100;count++)
			{
				read_data[count] = ad_reg_read((0x00800000+count*4));
				printf("read_data0x%08x 0x%016x\n",(0x00800000+count*4),read_data[count]);
			}*/
		}
		else if(capture == 'r')	{
			printf("\nRead AD9234 Reg Value(channel A)\n");
			for(array_i = 0; array_i<116; array_i++)	{
				if(reg_array[array_i] == 0x000)
					printf("ADC SPI REG\n");
				else if(reg_array[array_i] == 0x015)
					printf("ADC REG\n");
				else if(reg_array[array_i] == 0x300)
					printf("DDC REG\n");
				else if(reg_array[array_i] == 0x550)
					printf("TEST\n");
				else if(reg_array[array_i] == 0x559)
					printf("OUTPUT\n");
				else if(reg_array[array_i] == 0x56E)
					printf("JESD204B\n");
				else if(reg_array[array_i] == 0x5c1)
					printf("De-emphasis\n");

				ad9680_spi_read(ad9680_device,
							reg_array[array_i],
							&reg_value);

				printf("addr 0x%03x : 0x%02x\n",reg_array[array_i],reg_value);
			}
		}

		else if(capture == 'p')	{
			ad9680_spi_read(ad9680_device,
										0x128,
										&reg_value);
			printf("***addr 0x128 : 0x%02x\n",reg_value);

			ad9680_spi_read(ad9680_device,
										0x129,
										&reg_value);
			printf("***addr 0x129 : 0x%02x\n",reg_value);

			ad9680_spi_read(ad9680_device,
										0x12a,
										&reg_value);
			printf("***addr 0x12a : 0x%02x\n",reg_value);
		}

		else if(capture == 'j')	{
			printf("\nRead ADI JESD204B Link Receive Peripheral Reg Value\n");
			uint32_t jesd_reg = 0;

			for(array_i = 0; array_i<52; array_i++)	{
				jesd_read(&ad9680_jesd, jesd_reg_array[array_i], &jesd_reg);

				printf("addr 0x%03x : 0x%02x\n",jesd_reg_array[array_i],jesd_reg);
			}
		}

		else if(capture == 'a')	{
			printf("You choice 'a'\n");
			uint32_t jesd_reg = 0;
			jesd_read(&ad9680_jesd, 0x108, &jesd_reg);
			printf("JESD204B Link Receive Peripheral Reg 0x108 , Value 0x%04x\n",jesd_reg);
		}

		else if(capture == 'b')	{
			printf("You choice 'b'\n");
			uint32_t jesd_reg = 0;
			jesd_write(&ad9680_jesd, 0x108, 0x03);//clear reg
			jesd_read(&ad9680_jesd, 0x108, &jesd_reg);
			printf("JESD204B Link Receive Peripheral Reg 0x108 , Value 0x%04x\n",jesd_reg);
		}
		else if(capture == 's')	{
			printf("\nYou choice 's'\n");
			jesd_write(&ad9680_jesd, JESD204_REG_LINK_DISABLE, 1);
		}
		else if(capture == 'd')	{
			printf("\nYou choice 'd'\n");
			jesd_write(&ad9680_jesd, JESD204_REG_LINK_DISABLE, 0);
		}
		else
			continue;
	}

	//xiehb add end

	/* Memory deallocation for devices and spi */
	//ad9144_remove(ad9144_device);
	//ad9523_remove(ad9523_device);
	ad9680_remove(ad9680_device);

	/* Memory deallocation for gpios */
	//gpio_remove(clkd_sync);
	//gpio_remove(dac_reset);
	//gpio_remove(dac_txen);
	gpio_remove(adc_pd);

	return(0);
}
