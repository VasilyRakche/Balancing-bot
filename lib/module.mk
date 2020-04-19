#*TEMPLATE****************************************
#	Make will look for files under:
#						 $(DIR)/src/$(NAME)
#						 $(DIR)/inc/$(NAME)
NAME := stm32boot
#	DIR should be set up to relative directory 
# 	of this module compared to the root Makefile
# 	example: DIR := lib
# 	Meaning that module.mk path is lib/module.mk
#
#	Leave DIR undefined if path is ./mudule.mk
DIR := lib
#	If ISLIB == YES then static lib is created:
#						under $(BUILD_DIR)/$(DIR)
#						LIB is added to BIN_LIBS
#	If ISLIB undefined: 
#						Object files are added to
#						the BIN_FILES 
#
#	Where to look for sources and headers:
SRC_DIR:= $(DIR)/src/$(NAME)
INC_PATH:=$(DIR)/inc/$(NAME) \
	$(DIR)/inc/CMSIS/Device/ST/STM32F1xx 
#	BIN_LIBS and BIN_FILES are used for .elf file gen.
ISLIB := YES
# 	handler.mk is used to set up all global parameters
#	include it at the end of every new filled TEMPLATE  
include $(MKFILE_ABS_DIR)/handler.mk
#*END OF TEMPLATE*********************************
