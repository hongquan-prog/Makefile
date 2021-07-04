.PHONY: all compile link clean $(MODULES)



DIR_PROJECT := $(realpath .)
DIR_BUILD_SUB := $(addprefix $(DIR_BUILD)/, $(MODULES))
MODULE_LIB := $(addsuffix .a, $(MODULES))
MODULE_LIB := $(addprefix $(DIR_BUILD)/lib, $(MODULE_LIB))
EXTERNAL_LIB := $(wildcard $(DIR_LIBS_LIB)/*)
EXTERNAL_LIB := $(notdir $(EXTERNAL_LIB))
EXTERNAL_LIB := $(addprefix $(DIR_BUILD)/,$(EXTERNAL_LIB))

HOST_NAME := $(shell uname)

define compile_module
	cd $1 && $(MAKE) \
        DEBUG:=$(DEBUG) \
        DIR_BUILD:=$(abspath $(DIR_BUILD)) \
        DIR_COMMON_INC:=$(abspath $(DIR_COMMON_INC)) \
        MOD_CFG:=$(MOD_CFG) \
        MOD_RULE:=$(MOD_RULE) \
        CMD_CFG:=$(CMD_CFG) \
		DIR_LIBS_INC:=$(abspath $(DIR_LIBS_INC)) \
        && cd $(DIR_PROJECT);
endef

all: $(DIR_BUILD) $(DIR_BUILD_SUB) compile link

compile: 
	@for dir in $(MODULES); \
    do \
        $(call compile_module, $$dir) \
    done

link: $(MODULE_LIB) $(EXTERNAL_LIB)
ifeq ($(HOST_NAME),Linux)
	$(CC) -o $(APP)  -Xlinker "-(" $^ -Xlinker "-)" $(LFLAGS)
else
	$(CC) -L$(DIR_BUILD) $(MODULE_LIB) $(EXTERNAL_LIB) -o $(APP)
endif

$(DIR_BUILD)/%:$(DIR_LIBS_LIB)/%
	$(CP) $^ $@

$(DIR_BUILD) $(DIR_BUILD_SUB):
	$(MKDIR) $@

clean:
	$(RM) $(DIR_BUILD)

$(MODULES): $(DIR_BUILD) $(DIR_BUILD)/$(MAKECMDGOALS)
	@$(call compile_module, $@)