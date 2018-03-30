ERL_INCLUDE_PATH=$(shell erl -eval 'io:format("~s~n", [lists:concat([code:root_dir(), "/erts-", erlang:system_info(version), "/include"])])' -s init stop -noshell)

CC      = cc
GCOV    = gcov
CFLAGS  = $(DCFLAGS) -Wall -fpic -I. -I..
LDFLAGS += -lc $(DLDFLAGS)
UNAME_SYS := $(shell uname -s)
ifeq ($(UNAME_SYS), Darwin)
	# CFLAGS += -O3 -std=c99 -arch x86_64 -finline-functions -Wall -Wmissing-prototypes
	# CXXFLAGS += -O3 -arch x86_64 -finline-functions -Wall
	LDFLAGS += -arch x86_64 -flat_namespace -undefined suppress
endif

SOURCES = \
	timestamp_compare.c \
	timestamp_format.c \
	timestamp_parse.c \
	timestamp_valid.c \
	timestamp_tm.c

OBJECTS = \
	timestamp_compare.o \
	timestamp_format.o \
	timestamp_parse.o \
	timestamp_valid.o \
	timestamp_tm.o

HARNESS_OBJS = \
	t/valid.o \
	t/compare.o \
	t/format.o \
	t/parse_wellformed.o \
	t/parse_malformed.o \
	t/tm.o

HARNESS_EXES = \
	t/valid.t \
	t/compare.t \
	t/format.t \
	t/parse_wellformed.t \
	t/parse_malformed.t \
	t/tm.t

HARNESS_DEPS = \
	$(OBJECTS) \
	t/tap.o

.SUFFIXES:
.SUFFIXES: .o .c .t

.PHONY: check-asan test gcov cover clean

../priv/isoformat.so: isoformat.c $(OBJECTS)
	$(CC) $(LDFLAGS) -fpic -shared -I$(ERL_INCLUDE_PATH) isoformat.c $(OBJECTS) -o ../priv/isoformat.so

.o.t:
	$(CC) $(LDFLAGS) $< $(HARNESS_DEPS) -o $@

t/valid.o: \
	$(HARNESS_DEPS) t/valid.c

t/compare.o: \
	$(HARNESS_DEPS) t/compare.c

t/format.o: \
	$(HARNESS_DEPS) t/format.c

t/parse_wellformed.o: \
	$(HARNESS_DEPS) t/parse_wellformed.c

t/parse_malformed.o: \
	$(HARNESS_DEPS) t/parse_malformed.c

t/tm.o: \
	$(HARNESS_DEPS) t/tm.c

test: $(HARNESS_EXES)
	@prove $(HARNESS_EXES)

check-asan:
	@$(MAKE) DCFLAGS="-O1 -g -fsanitize=address -fno-omit-frame-pointer" \
	DLDFLAGS="-g -fsanitize=address" test

gcov:
	@$(MAKE) DCFLAGS="-O0 -g -coverage" DLDFLAGS="-coverage" test
	@$(GCOV) $(SOURCES)

cover:
	@$(MAKE) DCFLAGS="-O0 -g --coverage" DLDFLAGS="-coverage" test
	@$(GCOV) -abc $(SOURCES)
	@gcov2perl *.gcov
	@cover --no-gcov

clean:
	rm -f $(HARNESS_DEPS) $(HARNESS_OBJS) $(HARNESS_EXES) *.gc{ov,da,no} t/*.gc{ov,da,no}
