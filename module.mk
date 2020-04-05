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
#	BIN_LIBS and BIN_FILES are used for .elf file gen.
ISLIB := 
# 	handler.mk is used to set up all global parameters
#	Include it at the end of every new filled TEMPLATE  
include $(MKFILE_ABS_DIR)/handler.mk
#*END OF TEMPLATE*********************************
