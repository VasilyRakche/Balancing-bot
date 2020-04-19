.SECONDARY:

# DEBUG INFO for function calls
ifdef DEBUG
ECHO :=
else
ECHO := @
endif

MAKEFLAGS += -r
DEP_DIR := .deps
MKDIR := mkdir
BUILD_DIR ?= build
PROJECT := stm32f10x

#***********
# COMPILER options
#*********** 
CROSS_COMPILE ?= arm-none-eabi-
CC := $(CROSS_COMPILE)gcc
AR := $(CROSS_COMPILE)ar
LD := $(CROSS_COMPILE)gcc
OCP := $(CROSS_COMPILE)objcopy
OPENOCD := openocd
#***********
# VARIABLE definitions
#***********
MAIN_OUT := $(BUILD_DIR)/$(PROJECT)
# Possible additional arguments for Linker
# Arguments from GNU ARM Toolchain examples:
# -Os -flto -ffunction-sections -fdata-sections
CFLAGS :=	\
	-mcpu=cortex-m3 \
 	-mthumb -Wall	\
	-g	\
	-O0	

USE_SEMIHOST=--specs=rdimon.specs
USE_NOHOST=--specs=nosys.specs
USE_NANO=--specs=nano.specs

LDSCRIPTS=-L.stm_cfg/ld -Tstm32_gnu.ld
# Possible additional arguments for Linker
# ,--orphan-handling=warn
LDFLAGS = 	\
	-Wl,--gc-sections,-Map=$@.map,-cref,-u,Reset_Handler \
	 $(LDSCRIPTS) \
	 $(USE_NANO) \
	 $(USE_SEMIHOST)

ARFLAGS := rcs

OBJCPFLAGS = -O binary

MODULES := lib . 

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_ABS_DIR := $(dir $(MKFILE_PATH))

# Extra libraries
LIBS :=

#Script to flash stm 
STM32FLASH_CFG := .stm_cfg/stm32f103c8t6.cfg

#***********
# VARIABLES to be changed by MODULES
#***********
INC_PATHS :=	\
	ld \
	lib/inc/CMSIS/Device/ST/STM32F1xx \
	Middlewares/FreeRTOS/Source/Include \
	Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM3


BIN_LIBS :=

MODULE_GLOBAL_NAMES :=

BIN_LIBS:=

BIN_FILES:=

ASSEMBLY_OBJ:=
#***********
# INCLUDE module descriptions
#***********

include $(patsubst %,%/module.mk,$(MODULES))

#***********
# UPDATES
#***********

CFLAGS +=$(patsubst %,-I%,\
	$(INC_PATHS))


#***********
# PROGRAM compilation
#***********

$(MAIN_OUT).bin: $(MAIN_OUT).elf
	$(ECHO)#%.bin	
	$(OCP) $(OBJCPFLAGS) $< $@

$(MAIN_OUT).elf: $(BIN_FILES) $(BIN_LIBS)
	$(ECHO)#%.elf
	$(ECHO)$(CC) $(CFLAGS) $(LIBS) $^ $(LDFLAGS) -o $@  

#***********
# CUSTOM BINARY LIBRARIES compilation
#***********

.SECONDEXPANSION:
$(BUILD_DIR)/%.a: $$($$(addsuffix .OBJ,%))
	$(ECHO)#%.a
	$(ECHO)$(AR) $(ARFLAGS) $@ $^

#***********
# GENERATE regular object files
#***********

.SECONDEXPANSION:
$(BUILD_DIR)/%.o: $$(wildcard %.*)
	$(ECHO)#%.o		
	$(ECHO)$(MKDIR) -p $(dir $@)
	$(ECHO)$(CC) $(CFLAGS) -c $< -o $@

#***********
# INCLUDE dependencies
#***********

include $(patsubst $(BUILD_DIR)/%.o,$(DEP_DIR)/%.d, $(BIN_FILES))
#For CUSTOM BINARY LIBRARIES(.a), .d file generation
DEP_LIB := $(patsubst \
	$(BUILD_DIR)/%.a,$(DEP_DIR)/%.d,$(BIN_LIBS))
include $(DEP_LIB)


#***********
# CALCULATE dependencies
#***********
.SECONDEXPANSION:
$(DEP_DIR)/%.d: $$(wildcard %.*)
	$(ECHO)#%.d		
	$(ECHO)$(MKDIR) -p $(dir $@)	
	$(ECHO)bash depend.sh 'dirname $@' \
	'dirname $(patsubst $(DEP_DIR)%,$(BUILD_DIR)%,$@)'   \
	$(CFLAGS) $< > $@


.SECONDEXPANSION:
$(DEP_LIB): $$(subst .d,.a,$$(subst $$(DEP_DIR),$$(BUILD_DIR),$$@))
	$(ECHO)#DEP_LIB
	$(ECHO)$(MKDIR) -p $(dir $@)
	$(ECHO)echo "$@ $<: $($(subst $(BUILD_DIR)/,,$(basename $<)).OBJ)" > $@


#***********
# PHONY functions
#***********

.PHONY: clean
clean:
	rm -rf prog $(DEP_DIR) $(BUILD_DIR)

.PHONY: run
run: $(MAIN_OUT).bin
	@echo "%FLASH"
	$(OPENOCD) -f $(STM32FLASH_CFG) -c "program $(MAIN_OUT).bin verify reset exit 0x08000000"
