NAME := main
DIR := lib/
SRC_DIR:= $(DIR)/src/$(NAME)

GLOBAL_NAME := $(DIR)$(NAME)
MODULE_NAMES += $(GLOBAL_NAME)

BIN_LIBS += $(GLOBAL_NAME).a
INC_PATHS += $(DIR)inc/$(NAME)

$(GLOBAL_NAME).SRC := 		\
	$(wildcard $(SRC_DIR)/*.c)
$(GLOBAL_NAME).OBJ := 		\
	$(patsubst %.c,$(BUILD_DIR)/%.o,		\
	$(subst /src,,$($(GLOBAL_NAME).SRC)))
	# $(patsubst %.c,%.o,$($(DIR)/$(NAME).SRC))

# SRC += ant/src/main.c

# $(warning in $(NAME))
# $(warning $(DIR)/$(NAME).OBJ) 
# $(warning $($(DIR)/$(NAME).OBJ)) 
# $(warning $(DIR)/$(NAME).a) 
# $(warning $(BIN_LIBS))
# $(warning $(INC_PATHS)) 


# $(warning A top-level warning $(SRC))
# $(warning In module.mk)
# $(warning ****$($(DIR)/$(NAME).SRC))
# $(warning ****$($(DIR)/$(NAME).OBJ))
