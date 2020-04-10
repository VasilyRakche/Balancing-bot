# In module.mk should be set up:
#	NAME
#	DIR
#	ISLIB

#	If DIR is undefined then:
#				module.mk is in Makefile root folder
#				SRC_PREFIX is used to delete src from
#					OBJ path 
ifdef  DIR
SRC_PREFIX := /src
SRC_DIR:= $(DIR)/src/$(NAME)
GLOBAL_NAME := $(DIR)/$(NAME)
INC_PATHS += $(DIR)/inc/$(NAME)
else
SRC_PREFIX := src/
SRC_DIR:= src/$(NAME)
GLOBAL_NAME := $(NAME)
INC_PATHS += inc/$(NAME)
endif

#	Under these names .d files are generated
MODULE_GLOBAL_NAMES += $(GLOBAL_NAME)

#	Taking all source files
#	OBJ files with right directory are set up
#		lib/src/main/main.o to build/lib/main/main.o

$(GLOBAL_NAME).SRC := 		\
	$(wildcard $(SRC_DIR)/*.c)
$(GLOBAL_NAME).SRC += 		\
	$(wildcard $(SRC_DIR)/*.S)
$(GLOBAL_NAME).OBJ := 		\
	$(patsubst %.S,$(BUILD_DIR)/%.o,		\
	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
	$(subst $(SRC_PREFIX),,$($(GLOBAL_NAME).SRC))))


#	Library is generated and added to BIN_LIBS
# 	OBJ files are added to BIN_FILES
#
#	BIN_LIBS and BIN_FILES are used for .elf file gen.
ifeq ($(ISLIB),YES)
BIN_LIBS += $(BUILD_DIR)/$(GLOBAL_NAME).a
else 
BIN_FILES += $($(GLOBAL_NAME).OBJ)
endif

