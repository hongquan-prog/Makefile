.PHONY: all

MODULE := $(notdir $(realpath .))
DIR_OUTPUT := $(addprefix $(DIR_BUILD)/,$(MODULE))
OUTPUT := $(addprefix $(DIR_BUILD)/lib,$(MODULE).a)

SRCS := $(wildcard $(DIR_SRC)/*$(TYPE_SRC))
SRCS := $(notdir $(SRCS))
OBJS := $(SRCS:$(TYPE_SRC)=$(TYPE_OBJ))
DEPS := $(SRCS:$(TYPE_SRC)=$(TYPE_DEP))
OBJS := $(addprefix $(DIR_OUTPUT)/,$(OBJS))
DEPS := $(addprefix $(DIR_OUTPUT)/,$(DEPS))

vpath %$(TYPE_SRC) $(DIR_SRC)
vpath %$(TYPE_INC) $(DIR_INC)

$(OUTPUT):$(OBJS)
	$(AR) $(ARFLAGS) $@ $^

$(DIR_OUTPUT):
	@$(MKDIR) $@

-include $(DEPS)
ifeq ("$(wildcard $(DIR_OUTPUT))","")
$(DIR_OUTPUT)/%$(TYPE_DEP):$(DIR_OUTPUT) %$(TYPE_SRC)
else
$(DIR_OUTPUT)/%$(TYPE_DEP):%$(TYPE_SRC)
endif
	$(CC) $(CFLAGS) -MM -E $(filter %$(TYPE_SRC), $^) | sed 's,\(.*\)\.o[ :]*,$(DIR_OUTPUT)/\1.o $@:,g' > $@

$(DIR_OUTPUT)/%$(TYPE_OBJ):%$(TYPE_SRC)
	$(CC) $(CFLAGS) -o $@ -c $(filter %$(TYPE_SRC),$^)

all: $(OUTPUT)