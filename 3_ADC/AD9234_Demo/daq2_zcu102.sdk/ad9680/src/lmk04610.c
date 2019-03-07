/*
 * lmk04610.c
 *
 *  Created on: 2018Äê9ÔÂ26ÈÕ
 *      Author: xiehb
 */


/******************************************************************************/
/***************************** Include Files **********************************/
/******************************************************************************/
#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include "platform_drivers.h"
#include "lmk04610.h"

/***************************************************************************//**
 * @brief ad9680_spi_read
 *******************************************************************************/
int32_t lmk04610_spi_read(struct lmk04610_dev *dev,
			uint16_t reg_addr,
			uint8_t *reg_data)
{
	uint8_t buf[3];

	int32_t ret;

	buf[0] = 0x80 | (reg_addr >> 8);
	buf[1] = reg_addr & 0xFF;
	buf[2] = 0x00;

	ret = spi_write_and_read_1(dev->spi_desc,
				 buf,
				 3);
	*reg_data = buf[2];

	return ret;
}

/***************************************************************************//**
 * @brief ad9680_spi_write
 *******************************************************************************/
int32_t lmk04610_spi_write(struct lmk04610_dev *dev,
			 uint16_t reg_addr,
			 uint8_t reg_data)
{
	uint8_t buf[3];

	int32_t ret;

	buf[0] = reg_addr >> 8;
	buf[1] = reg_addr & 0xFF;
	buf[2] = reg_data;

	ret = spi_write_and_read_1(dev->spi_desc,
				 buf,
				 3);

	return ret;
}


/***************************************************************************//**
 * @brief ad9680_setup
 *******************************************************************************/
int32_t lmk04610_setup(struct lmk04610_dev **device,
		     const struct lmk04610_init_param *init_param)
{
	//printf("%s\n",__func__);
	uint8_t chip_id;
	//uint8_t pll_stat;
	int32_t ret;
	struct lmk04610_dev *dev;

	ret = 0;

	dev = (struct lmk04610_dev *)malloc(sizeof(*dev));
	if (!dev)
		return -1;

	/* SPI */
	ret = spi_init_1(&dev->spi_desc, &init_param->spi_init);

	lmk04610_spi_read(dev,	0x04,	&chip_id);
	//printf("%s CHIP ID (0x%x).\n", __func__,chip_id);
	/*while(1){
		lmk04610_spi_read(dev,	0x04,	&chip_id);
		printf("%s CHIP ID (0x%x).\n", __func__,chip_id);
		mdelay(1000);
	}*/

	uint8_t regbuf;

/*	lmk04610_spi_read(dev,	0x43,	&regbuf);
	printf("%s CHIP ID (0x%x).\n", __func__,regbuf);

	lmk04610_spi_write(dev,	0x43,	regbuf+1);	//OUTCH1DIV_BY1, [15:8]
	lmk04610_spi_read(dev,	0x43,	&regbuf);
	printf("%s CHIP ID (0x%x).\n", __func__,regbuf);*/

	int i=0;
	do{
		//printf("i[%x] lmk04610_reg_array 0x%04x 0x%04x\n", i, (uint16_t)(lmk04610_reg_array[i]>>8), (uint8_t)(lmk04610_reg_array[i] & 0xff));
		lmk04610_spi_write(dev,	(uint16_t)(lmk04610_reg_array[i]>>8),	(uint8_t)(lmk04610_reg_array[i] & 0xff));
		i++;
	//}while((uint16_t)(lmk04610_reg_array[i] >> 8) < 0x153);
	}while(i<218);

	*device = dev;

	return ret;
}

int32_t lmk04610_dev_start(struct lmk04610_dev *device)
{
	//printf("%s\n",__func__);
	int32_t ret;
	ret = lmk04610_spi_write(device,	0x11,	0x01);
	//lmk04610_spi_write(device,	0x14,	0xa0);
	return ret;
}

int32_t lmk04610_global_sysref(struct lmk04610_dev *device)
{
	//printf("%s\n",__func__);
	int32_t ret = 0;
	uint8_t regbuf;
	lmk04610_spi_read(device,	0x14,	&regbuf);
	lmk04610_spi_write(device,	0x14,	regbuf | (1<<5));
	return ret;

}

/***************************************************************************//**
 * @brief Free the resources allocated by ad9680_setup().
 *
 * @param dev - The device structure.
 *
 * @return SUCCESS in case of success, negative error code otherwise.
*******************************************************************************/
int32_t lmk04610_remove(struct lmk04610_dev *dev)
{
	int32_t ret;

	ret = spi_remove(dev->spi_desc);

	free(dev);

	return ret;
}



/*
	//0x10,
	lmk04610_spi_write(dev,	0x12,	0x04);	//DIGCLKCTRL, Enable PLL2 Digital Clock Buffer.
	lmk04610_spi_write(dev,	0x13,	0x10);	//PLL2REFCLKDIV,
	lmk04610_spi_write(dev,	0x14,	0x80);	//GLBL_SYNC_SYSREF,
	lmk04610_spi_write(dev,	0x16,	0x50);	//CLKIN_CTRL1,
	lmk04610_spi_write(dev,	0x19,	0x29);	//CLKIN0CTRL,
	lmk04610_spi_write(dev,	0x1a,	0x3a);	//CLKIN1CTRL,
	lmk04610_spi_write(dev,	0x2c,	0x80);	//CLKIN_SWCTRL1
	lmk04610_spi_write(dev,	0x2e,	0x16);	//OSCIN_CTRL

	lmk04610_spi_write(dev,	0x33,	0x00);	//OUTCH1CNTL0, LDO enable
	lmk04610_spi_write(dev,	0x34,	0x63);	//OUTCH1CNTL1, HSDS 8mA,
	lmk04610_spi_write(dev,	0x35,	0x40);	//OUTCH2CNTL0
	lmk04610_spi_write(dev,	0x36,	0x02);	//OUTCH2CNTL1
	lmk04610_spi_write(dev,	0x37,	0x40);	//OUTCH34CNTL0
	lmk04610_spi_write(dev,	0x38,	0x02);	//OUTCH34CNTL1
	lmk04610_spi_write(dev,	0x39,	0x18);	//OUTCH5CNTL0
	lmk04610_spi_write(dev,	0x3a,	0x03);	//OUTCH5CNTL1
	lmk04610_spi_write(dev,	0x3b,	0x40);	//OUTCH6CNTL0
	lmk04610_spi_write(dev,	0x3c,	0x02);	//OUTCH6CNTL1
	lmk04610_spi_write(dev,	0x3d,	0x18);	//OUTCH78CNTL0
	lmk04610_spi_write(dev,	0x3e,	0x03);	//OUTCH78CNTL1
	lmk04610_spi_write(dev,	0x3f,	0x00);	//OUTCH9CNTL0
	lmk04610_spi_write(dev,	0x40,	0x63);	//OUTCH9CNTL1
	lmk04610_spi_write(dev,	0x41,	0x40);	//OUTCH10CNTL0
	lmk04610_spi_write(dev,	0x42,	0x02);	//OUTCH10CNTL1

	lmk04610_spi_write(dev,	0x43,	0x01);	//OUTCH1DIV_BY1, [15:8]
	lmk04610_spi_write(dev,	0x44,	0x00);	//OUTCH1DIV_BY0, [7:0]
	lmk04610_spi_write(dev,	0x45,	0x01);	//OUTCH2DIV_BY1
	lmk04610_spi_write(dev,	0x46,	0x00);	//OUTCH2DIV_BY0
	lmk04610_spi_write(dev,	0x47,	0x00);	//OUTCH34DIV_BY1
	lmk04610_spi_write(dev,	0x48,	0x01);	//OUTCH34DIV_BY0
	lmk04610_spi_write(dev,	0x49,	0x01);	//OUTCH5DIV_BY1
	lmk04610_spi_write(dev,	0x4a,	0x00);	//OUTCH5DIV_BY0
	lmk04610_spi_write(dev,	0x4b,	0x00);	//OUTCH6DIV_BY1
	lmk04610_spi_write(dev,	0x4c,	0x08);	//OUTCH6DIV_BY0
	lmk04610_spi_write(dev,	0x4d,	0x00);	//OUTCH78DIV_BY1
	lmk04610_spi_write(dev,	0x4e,	0x02);	//OUTCH78DIV_BY0
	lmk04610_spi_write(dev,	0x4f,	0x00);	//OUTCH9DIV_BY1
	lmk04610_spi_write(dev,	0x50,	0x08);	//OUTCH9DIV_BY0
	lmk04610_spi_write(dev,	0x51,	0x00);	//OUTCH10DIV_BY1
	lmk04610_spi_write(dev,	0x52,	0x08);	//OUTCH10DIV_BY0

											//ignore all PLL1 config

	lmk04610_spi_write(dev,	0x6c,	0x00);	//PLL2_CTRL0
	lmk04610_spi_write(dev,	0x6d,	0x08);	//PLL2_CTRL1
	lmk04610_spi_write(dev,	0x6e,	0x1b);	//PLL2_CTRL2
	lmk04610_spi_write(dev,	0x70,	0x00);	//PLL2_LF_C4R4
	lmk04610_spi_write(dev,	0x71,	0x00);	//PLL2_LF_C3R3
	lmk04610_spi_write(dev,	0x72,	0x14);	//PLL2_CP_SETTING
	lmk04610_spi_write(dev,	0x00,	0x00);	//
	lmk04610_spi_write(dev,	0x00,	0x00);	//
	lmk04610_spi_write(dev,	0x00,	0x00);	//
	lmk04610_spi_write(dev,	0x00,	0x00);	//
	lmk04610_spi_write(dev,	0x00,	0x00);	//
*/
