#*TEMPLATE****************************************
#	Make will look for files under:
#						 $(DIR)/src/$(NAME)
#						 $(DIR)/inc/$(NAME)
NAME := main
#	DIR should be set up to relative directory 
# 	of this module compared to the root Makefile
# 	example: DIR := lib
# 	Meaning that module.mk path is lib/module.mk
#
#	Leave DIR undefined if path is ./mudule.mk
DIR := 
#	If ISLIB == YES then static lib is created:
#						under $(BUILD_DIR)/$(DIR)
#						LIB is added to BIN_LIBS
#	Otherwise or ISLIB undefined: 
#						Object files are added to
#						the BIN_FILES 
#
#	Where to look for sources and headers:
SRC_DIR:= src/$(NAME) 	\
	Middlewares/FreeRTOS/Source \
	Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM3 \
	Middlewares/FreeRTOS/Source/portable/MemMang
INC_PATH:=inc/$(NAME)	\
	Middlewares/FreeRTOS/Source/Include \
	Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM3
#	BIN_LIBS and BIN_FILES are used for .elf file gen.
ISLIB := 
# 	handler.mk is used to set up all global parameters
#	Include it at the end of every new filled TEMPLATE  
include $(MKFILE_ABS_DIR)/handler.mk

INC_PATHS +=	\
	Middlewares/FreeRTOS/Source/Include \
	Middlewares/FreeRTOS/Source/portable/GCC/ARM_CM3

#*END OF TEMPLATE*********************************
