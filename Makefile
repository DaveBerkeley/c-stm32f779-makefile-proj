# Makefile for STM32F779 - Test PROJECT
# https://github.com/ulfen/stm32f7-discovery-blinky
# Used as template

PROJECT = STM_Eval

################
# Sources

SOURCES_S = Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/gcc/startup_stm32f779xx.s

SOURCES_C = src/main.c

# Uncomment when not using semihosting
#SOURCES_C = $(shell find src/ -name "*.c")

#SOURCES_C += sys/stubs.c sys/_sbrk.c sys/_io.c
SOURCES_C += Drivers/CMSIS/Device/ST/STM32F7xx/Source/Templates/system_stm32f7xx.c
SOURCES_C += Drivers/BSP/STM32F769I_EVAL/stm32f769i_eval.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_gpio.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_adc.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_cortex.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_uart.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_rcc.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_rcc_ex.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_pwr_ex.c
SOURCES_C += Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_hal_wwdg.c
SOURCES_C += src/stm32f7xx_it.c
SOURCES_C += src/stm32f7xx_hal_msp.c
#SOURCES_C += src/syscalls.c

SOURCES = $(SOURCES_S) $(SOURCES_C)
OBJS = $(SOURCES_S:.s=.o) $(SOURCES_C:.c=.o)

################
# Includes and Defines

INCLUDES += -I src
INCLUDES += -I Drivers/CMSIS/Include
INCLUDES += -I Drivers/CMSIS/Device/ST/STM32F7xx/Include
INCLUDES += -I Drivers/STM32F7xx_HAL_Driver/Inc
INCLUDES += -I Drivers/BSP/STM32F769I_EVAL

DEFINES = -DSTM32 -DSTM32F7 -DSTM32F779xx

################
# Compiler/Assembler/Linker/etc

CC_PATH ?= /usr/bin
PREFIX = $(CC_PATH)/arm-none-eabi

CC = $(PREFIX)-gcc
AS = $(PREFIX)-as
AR = $(PREFIX)-ar
LD = $(PREFIX)-gcc
NM = $(PREFIX)-nm
OBJCOPY = $(PREFIX)-objcopy
OBJDUMP = $(PREFIX)-objdump
READELF = $(PREFIX)-readelf
SIZE = $(PREFIX)-size
GDB = $(PREFIX)-gdb
RM = rm -f

################
# Compiler options

MCUFLAGS = -mcpu=cortex-m7 -mlittle-endian
MCUFLAGS += -mfloat-abi=hard -mfpu=fpv5-sp-d16
MCUFLAGS += -mthumb

DEBUGFLAGS = -O0 -g -ggdb
#DEBUGFLAGS = -O2

CFLAGS = -std=c11
CFLAGS += -Wall -Wextra --pedantic
CFLAGS += -g

CFLAGS_EXTRA += -nostartfiles -fdata-sections -ffunction-sections
CFLAGS_EXTRA += -Wl,--gc-sections -Wl,-Map=$(PROJECT).map

CFLAGS += $(DEFINES) $(MCUFLAGS) $(DEBUG_FLAGS) $(CFLAGS_EXTRA) $(INCLUDES)

LDFLAGS = -static $(MCUFLAGS) $(DEBUG_FLAGS)
#LDFLAGS += -Wl,--start-group -lgcc -lm -lc -lg -Wl,--end-group
LDFLAGS  += -Wl,--start-group -lgcc -lm -lc     -Wl,--end-group

# Enable Semihosting
LDFLAGS += --specs=rdimon.specs -lrdimon

LDFLAGS += -Wl,--gc-sections
LDFLAGS += -T STM32F7x9.ld -L. -Lldscripts
LDFLAGS += -Xlinker -Map -Xlinker $(PROJECT).map

################
# Build rules

all: $(PROJECT).bin

$(PROJECT).bin: $(PROJECT).elf
	$(OBJCOPY) -O binary $(PROJECT).elf $(PROJECT).bin

$(PROJECT).elf: $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -o $(PROJECT).elf
	$(SIZE) -A $(PROJECT).elf

clean: Makefile
	$(RM) $(OBJS) $(PROJECT).elf $(PROJECT).bin $(PROJECT).map
