# FIXME: these two lines that need to be changed correspondingly. Another file is 
# tests/config.mk if you want to change the number of threads or input set (native | large)
#MYLIB_WITH_DIR = /home/mejbah/lockperf/src/liblockperf.so
MYLIB_WITH_DIR = /home/mejbah/git_clones/Perf-Anomaly/perfpoint/source/perfpoint.so
MYLIB_DIR = /home/mejbah/git_clones/Perf-Anomaly/perfpoint/source
MYLIB = perfpoint
CC = gcc 
CXX = g++ 
CFLAGS += -g -O #-fno-omit-frame-pointer

CONFIGS = pthread $(MYLIB)
#CONFIGS = $(MYLIB)
PROGS = $(addprefix $(TEST_NAME)-, $(CONFIGS))

.PHONY: default all clean

default: all
all: $(PROGS)
clean:
	find ./obj -name "*.o" -type f -delete
	rm -f $(PROGS) #obj/*

eval: $(addprefix eval-, $(CONFIGS))

############ pthread builders ############

PTHREAD_CFLAGS = $(CFLAGS)
PTHREAD_LIBS += $(LIBS) -lpthread

PTHREAD_OBJS = $(addprefix obj/, $(addsuffix -pthread.o, $(TEST_FILES)))

obj/%-pthread.o: %-pthread.c
	mkdir -p obj
	$(CC) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %.c
	mkdir -p obj
	$(CC) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-pthread.o: %.cpp
	mkdir -p obj
	$(CXX) $(PTHREAD_CFLAGS) -c $< -o $@ -I$(HOME)/include

$(TEST_NAME)-pthread: $(PTHREAD_OBJS)
	$(CXX) $(PTHREAD_CFLAGS) -o $@ $(PTHREAD_OBJS) $(PTHREAD_LIBS)

eval-pthread: $(TEST_NAME)-pthread
	time ./$(TEST_NAME)-pthread $(TEST_ARGS)

#time ./$(TEST_NAME)-pthread $(TEST_ARGS) &> /dev/null

############ $(MYLIB) builders ############

MYLIB_CFLAGS = $(CFLAGS) -DNDEBUG -I/home/mejbah/git_clones/Perf-Anomaly/perfpoint/source  -DPERFPOINT

RPATH = -Wl,-rpath $(MYLIB_DIR) -Wl,-rpath /usr/local/lib

#PAPI_LIB += /home/mejbah/papi/papi-5.5.1/src/libpapi.a
LD_FLAGS += -L$(MYLIB_DIR) -L/usr/local/lib
#MYLIB_LIBS += $(LIBS) $(MYLIB_WITH_DIR) -lpthread -ldl $(PAPI_LIB)
MYLIB_LIBS += $(LIBS) -rdynamic -lperfpoint -lpapi -lpthread -ldl $(PAPI_LIB)


MYLIB_OBJS = $(addprefix obj/, $(addsuffix -$(MYLIB).o, $(TEST_FILES)))

obj/%-$(MYLIB).o: %-pthread.c
	mkdir -p obj
	$(CC) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %.c
	mkdir -p obj
	$(CC) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %-pthread.cpp
	mkdir -p obj
	$(CXX) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

obj/%-$(MYLIB).o: %.cpp
	mkdir -p obj
	$(CXX) $(MYLIB_CFLAGS) -c $< -o $@ -I$(HOME)/include

### FIXME, put the 
$(TEST_NAME)-$(MYLIB): $(MYLIB_OBJS) 
	$(CXX) $(LD_FLAGS) $(RPATH) -o $@ $(MYLIB_OBJS) $(MYLIB_LIBS) 

eval-$(MYLIB): $(TEST_NAME)-$(MYLIB)
	time ./$(TEST_NAME)-$(MYLIB) $(TEST_ARGS)
