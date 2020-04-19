# In module.mk should be set up:
#	NAME
#	DIR
#	ISLIB

ifdef  DIR
GLOBAL_NAME := $(DIR)/$(NAME)
else
GLOBAL_NAME := $(NAME)
endif
INC_PATHS += $(INC_PATH)

#	Under these names .d files are generated
MODULE_GLOBAL_NAMES += $(GLOBAL_NAME)

#	Taking all source files
#	OBJ files with right directory are set up
#		lib/src/main/main.o to build/lib/main/main.o

$(GLOBAL_NAME).SRC :=
#Function for adding source files from each DIR in SRC_DIR
define add_src =
	$(GLOBAL_NAME).SRC += 		\
		$(wildcard $(1)/*.c)
	$(GLOBAL_NAME).SRC += 		\
		$(wildcard $(1)/*.S)
endef
$(foreach DIRECTORY,$(SRC_DIR),$(eval $(call add_src,$(DIRECTORY))) )

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
BIN_FILES += $($(GLOBAL_NAME).OBJ)
else 
BIN_FILES += $($(GLOBAL_NAME).OBJ)
endif


