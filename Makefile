PREFIX = arm-none-eabi
CC = $(PREFIX)-gcc
OBJCOPY = $(PREFIX)-objcopy
SIZE = $(PREFIX)-size

TOOLCHAIN_DIR = /usr/arm-none-eabi
BUILD_DIR = build

CFLAGS += -O0 -g3 -Wall -Wextra \
          -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16 \
          -I$(TOOLCHAIN_DIR)/include \
          -DSTM32F4

LDFLAGS += -Tstm32f411re.ld \
           -L$(TOOLCHAIN_DIR)/lib \
           -lopencm3_stm32f4 \
           -nostdlib \
           -Wl,--gc-sections

COMMON_C = protocol.c

all: $(BUILD_DIR) $(BUILD_DIR)/tx.elf $(BUILD_DIR)/tx.bin $(BUILD_DIR)/rx.elf $(BUILD_DIR)/rx.bin

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/tx.elf: tx_main.c $(COMMON_C) stm32f411re.ld | $(BUILD_DIR)
	$(CC) $(CFLAGS) tx_main.c $(COMMON_C) $(LDFLAGS) -o $@
	$(SIZE) $@

$(BUILD_DIR)/rx.elf: rx_main.c $(COMMON_C) stm32f411re.ld | $(BUILD_DIR)
	$(CC) $(CFLAGS) rx_main.c $(COMMON_C) $(LDFLAGS) -o $@
	$(SIZE) $@

$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf
	$(OBJCOPY) -O binary $< $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
