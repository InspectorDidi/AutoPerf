include ../defines.mk

TEST_NAME = pmatrixcompare
TEST_FILES = pmatrixcompare
#THREADS = $(shell echo $(NCORES)-1 | bc)
#TEST_ARGS=$(THREADS)
CFLAGS = -DBAD_FS -DREPEAT=5
APP_LIBS = -lrt
include $(HOME)/Default.mk

