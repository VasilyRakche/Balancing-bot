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
OCP = $(CROSS_COMPILE)objcopy

#***********
# VARIABLE definitions
#***********
MAIN_OUT := $(BUILD_DIR)/$(PROJECT)

CFLAGS :=	\
	-mcpu=cortex-m3 \
 	-mthumb -Wall	\
	-g	\
	-O0

LDFLAGS = 	\
	-Wl,--gc-sections,-Map=$@.map,-cref,--orphan-handling=warn,-u,Reset_Handler \
	-Tstm32.ld 

ARFLAGS := rcs

OBJCPFLAGS = -O binary

MODULES := lib . 

MKFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
MKFILE_ABS_DIR := $(dir $(MKFILE_PATH))

# Extra libraries
LIBS :=

#Script to flash stm 
STM32FLASH := $(MKFILE_ABS_DIR)/.stm_cfg/stm32_flash.py

#***********
# VARIABLES to be changed by MODULES
#***********
INC_PATHS :=	\
	ld 

BIN_LIBS :=

MODULE_GLOBAL_NAMES :=

BIN_LIBS:=

BIN_FILES:=

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
	$(ECHO)$(OCP) $(OBJCPFLAGS) $< $@

$(MAIN_OUT).elf: $(BIN_FILES) $(BIN_LIBS)
	$(ECHO)#.elf
	$(ECHO)$(CC) $(CFLAGS) $(LIBS) $^ $(LDFLAGS) -o $@  

#***********
# CUSTOM BINARY LIBRARIES compilation
#***********

.SECONDEXPANSION:
$(BUILD_DIR)/%.a: $$($$(addsuffix .OBJ,%))
	$(ECHO)#%.a
	$(ECHO)$(AR) $(ARFLAGS) $@ $^

#***********
# MAKE FUNCTIONS scripts
#***********

# For adding src to supplied PATH
# in a way:
# 	lib/main/main to lib/src/main/main.c
# 	or main/main to src/main/main.c
#
# Called by: $(BUILD_DIR)/%.o and $(DEP_DIR)/%.d 
join_with_src = $(dir $(1))src/$(notdir $(1))/$(2).c
to_c =$(call join_with_src,\
$(patsubst %/$(notdir $(1)),%,$(1)),$(notdir $(1)))

# For setting right directory path and .d includes
# 	build/lib/main/main.o to .deps/lib/main/main.d
#
# Called by: INCLUDE dependencies
define include_d_from_o =
	include $(patsubst $(BUILD_DIR)/%.o,$(DEP_DIR)/%.d,\
	$($(addsuffix .OBJ,$(1))))
endef

#***********
# GENERATE regular object files
#***********

.SECONDEXPANSION:
$(BUILD_DIR)/%.o: $$(call to_c,%)
	$(ECHO)#%.o		
	$(ECHO)$(MKDIR) -p $(dir $@)
	$(ECHO)$(CC) $(CFLAGS) -c $< -o $@

#***********
# INCLUDE dependencies
#***********

# For .o file includes, calls function include_d_from_o
$(foreach MODULE,$(MODULE_GLOBAL_NAMES),$(eval $(call include_d_from_o,$(MODULE))) )

#For CUSTOM BINARY LIBRARIES(.a), .d file generation
DEP_LIB := $(patsubst \
	$(BUILD_DIR)/%.a,$(DEP_DIR)/%.d,$(BIN_LIBS))
include $(DEP_LIB)


#***********
# CALCULATE dependencies
#***********
.SECONDEXPANSION:
$(DEP_DIR)/%.d: $$(call to_c,%)	
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
run: main.bin
	@echo "....running"
	$(STM32FLASH) main.bin
