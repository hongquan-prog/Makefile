DIR_SRC := src
DIR_INC := inc 
ifneq ("$(DIR_COMMON_INC)","")
DIR_INC += $(DIR_COMMON_INC)
endif
ifneq ("$(DIR_LIBS_INC)","")
DIR_INC += $(DIR_LIBS_INC)
endif

TYPE_INC := .h
TYPE_SRC := .c
TYPE_OBJ := .o 
TYPE_DEP := .dep 