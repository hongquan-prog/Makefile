AR := ar 
ARFLAGS := crs
MKDIR := mkdir

CC := gcc
CFLAGS := $(addprefix -I,$(DIR_INC))

ifeq ($(DEBUG), true)
CFLAGS += -g
endif