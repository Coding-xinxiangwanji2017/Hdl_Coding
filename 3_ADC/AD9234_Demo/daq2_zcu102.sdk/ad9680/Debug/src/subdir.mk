################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
LD_SRCS += \
../src/lscript.ld 

C_SRCS += \
../src/ad9680.c \
../src/adc_core.c \
../src/dmac_core.c \
../src/fmcdaq2.c \
../src/jesd_core.c \
../src/lmk04610.c \
../src/platform.c \
../src/platform_drivers.c \
../src/xcvr_core.c \
../src/xilinx_qpll.c \
../src/xilinx_xcvr_channel.c 

OBJS += \
./src/ad9680.o \
./src/adc_core.o \
./src/dmac_core.o \
./src/fmcdaq2.o \
./src/jesd_core.o \
./src/lmk04610.o \
./src/platform.o \
./src/platform_drivers.o \
./src/xcvr_core.o \
./src/xilinx_qpll.o \
./src/xilinx_xcvr_channel.o 

C_DEPS += \
./src/ad9680.d \
./src/adc_core.d \
./src/dmac_core.d \
./src/fmcdaq2.d \
./src/jesd_core.d \
./src/lmk04610.d \
./src/platform.d \
./src/platform_drivers.d \
./src/xcvr_core.d \
./src/xilinx_qpll.d \
./src/xilinx_xcvr_channel.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM v8 gcc compiler'
	aarch64-none-elf-gcc -Wall -O0 -g3 -c -fmessage-length=0 -MT"$@" -I../../ad9680_bsp/psu_cortexa53_0/include -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


