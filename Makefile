CROSS_COMPILE=arm-none-eabi-
QEMU_STM32 ?= ../qemu_stm32/arm-softmmu/qemu-system-arm

ARCH=CM3
VENDOR=ST
PLAT=STM32F10x
CODEBASE= freertos
CMSIS_LIB=$(CODEBASE)/libraries/CMSIS/$(ARCH)
STM32_LIB=$(CODEBASE)/libraries/STM32F10x_StdPeriph_Driver

CMSIS_PLAT_SRC = $(CMSIS_LIB)/DeviceSupport/$(VENDOR)/$(PLAT)

FREERTOS_SRC = $(CODEBASE)/libraries/FreeRTOS
FREERTOS_INC = $(FREERTOS_SRC)/include/
FREERTOS_PORT_INC = $(FREERTOS_SRC)/portable/GCC/ARM_$(ARCH)/

CFLAGS = -fno-common -O0 \
		 -mcpu=cortex-m3 \
		 -Wall -std=c99 -pedantic \
		 -mthumb \
#CFLAGS_debug = $(CLAGS) -gdwarf-2 -g3

CMSIS_SRCS = \
		$(CMSIS_LIB)/CoreSupport/core_cm3.c \
		$(CMSIS_PLAT_SRC)/system_stm32f10x.c \
		$(CMSIS_PLAT_SRC)/startup/gcc_ride7/startup_stm32f10x_md.s

STM32_SRCS = \
			 $(STM32_LIB)/src/stm32f10x_rcc.c \
			 $(STM32_LIB)/src/stm32f10x_gpio.c \
			 $(STM32_LIB)/src/stm32f10x_usart.c \
			 $(STM32_LIB)/src/stm32f10x_exti.c \
			 $(STM32_LIB)/src/misc.c \

FREERTOS_SRCS = \
			$(FREERTOS_SRC)/croutine.c \
			$(FREERTOS_SRC)/list.c \
			$(FREERTOS_SRC)/queue.c \
			$(FREERTOS_SRC)/tasks.c \
			$(FREERTOS_SRC)/portable/GCC/ARM_CM3/port.c \
			$(FREERTOS_SRC)/portable/MemMang/heap_1.c \

SRCS = \
	   $(CMSIS_SRCS) \
	   $(STM32_SRCS) \
	   $(FREERTOS_SRCS) \
		stm32_p103.c \
		romfs.c \
		hash-djb2.c \
		filesystem.c \
		fio.c \
		osdebug.c \
		string-util.c \
		main.c \

INCS = \
		-I.-I$(FREERTOS_INC) \
		-I$(FREERTOS_PORT_INC) \
		-I$(CODEBASE)/libraries/CMSIS/CM3/CoreSupport \
		-I$(CODEBASE)/libraries/CMSIS/CM3/DeviceSupport/ST/STM32F10x \
		-I$(CODEBASE)/libraries/STM32F10x_StdPeriph_Driver/inc \

HEADERS= \
		filesystem.h     \
		fio.h            \
		FreeRTOSConfig.h \
		hash-djb2.h      \
		osdebug.h        \
		romfs.h          \
		stm32f10x_conf.h \
		stm32_p103.h     \

SRC_STRIP_PATH = $(notdir $(SRCS))
COBJS = $( patsubst $.c,%.o,$(SRC_STRIP_PATH))
OBJS  = $( patsubst %.s,$.o,$(COBJS) )

all: main.bin

objs: $(SRCS) $(HEADERS)
	$(CROSS_COMPILE)gcc $(CFLAGS) $(INCS) -c $(SRCS)

main.bin: objs test-romfs.o
	$(CROSS_COMPILE)ld -Tmain.ld -nostartfiles -o main.elf $(OBJS)
	$(CROSS_COMPILE)objcopy -Obinary main.elf main.bin
	$(CROSS_COMPILE)objdump -S main.elf > main.list


mkromfs:
	gcc -o mkromfs mkromfs.c

CPU=arm
TARGET_FORMAT = elf32-littlearm
TARGET_OBJCOPY_BIN = $(CROSS_COMPILE)objcopy -I binary -O $(TARGET_FORMAT) --binary-architecture $(CPU)

test-romfs.o: mkromfs
	./mkromfs -d test-romfs test-romfs.bin
	$(TARGET_OBJCOPY_BIN) --prefix-sections '.romfs' test-romfs.bin test-romfs.o


qemu: main.bin $(QEMU_STM32)
	$(QEMU_STM32) -M stm32-p103 -kernel main.bin

qemudbg: main.bin $(QEMU_STM32)
	$(QEMU_STM32) -M stm32-p103 \
		-gdb tcp::3333 -S \
		-kernel main.bin
		
qemuauto: main.bin $(QEMU_STM32)
	bash emulate.sh main.bin

clean:
	rm -f *.o *.elf *.bin *.list mkromfs
