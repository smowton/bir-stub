#------------------------------------------------------------------------------
# File: Makefile
#
# Note: This Makefile requires GNU make.
#
# (c) 2001,2000 Stanford University
#
#------------------------------------------------------------------------------

all : sr

CC = gcc

# MODE controls whether the router gets/sends packets from/to the NetFPGA or VNS
MODE_NETFPGA = -D_CPUMODE_
MODE_VNS     =
MODE = $(MODE_VNS)

include Makefile.common

PFLAGS= -follow-child-processes=yes -cache-dir=/tmp/${USER}
PURIFY= purify ${PFLAGS}

sr_SRCS = sr_router.c sr_main.c  \
          sr_if.c sr_rt.c sr_vns_comm.c   \
          sr_dumper.c sha1.c real_socket_helper.c \
	  sr_lwtcp_glue.c sr_cpu_extension_nf2.c nf2util.c

sr_OBJS = $(patsubst %.c,%.o,$(sr_SRCS))
sr_DEPS = $(patsubst %.c,.%.d,$(sr_SRCS))

#------------------------------------------------------------------------------

RESTRICTED_CLI_SRCS = cli/cli.c cli/cli_help.c cli/cli_main.c \
                      cli/search_state.c cli/cli_local.c \
                      cli/lex.yy.c cli/y.tab.c cli/helper.c
CLI_SRCS = cli/socket_helper.c $(RESTRICTED_CLI_SRCS)  sr_lwtcp_glue.c
CLI_OBJS = $(patsubst cli/%.c, %.o, $(CLI_SRCS))

cli/lex.yy.c cli/lex.yy.o :
	make -C cli lex.yy.o

cli/y.tab.c cli/y.tab.o :
	make -C cli y.tab.o

LWTCP_SRCS = lwtcp/tcp.c lwtcp/tcp_input.c lwtcp/tcp_output.c \
             lwtcp/mem.c lwtcp/memp.c lwtcp/stats.c lwtcp/sys.c \
             lwtcp/inet.c lwtcp/pbuf.c lwtcp/sys_arch.c \
             lwtcp/sockets.c lwtcp/api_lib.c lwtcp/api_msg.c \
             lwtcp/transport_subsys.c lwtcp/udp.c lwtcp/icmp.c lwtcp/ip_addr.c \
             lwtcp/err.c

LWTCP_OBJS = $(patsubst lwtcp/%.c, %.o, $(LWTCP_SRCS))

liblwtcp.a : $(LWTCP_OBJS)
	ar rcu liblwtcp.a $(LWTCP_OBJS)

#------------------------------------------------------------------------------

# CLI Test targe
TEST_CLI_APP  = cli/test_cli.exe
TEST_CLI_SRCS = cli/cli_test.c $(SR_SRCS_BASE) $(RESTRICTED_CLI_SRCS)
TEST_CLI_OBJS = $(patsubst %.c,%.o,$(TEST_CLI_SRCS)) cli/socket_helper_to_stderr.o

cli/socket_helper_to_stderr.o : cli/socket_helper.c cli/socket_helper.h
	make -C cli socket_helper_to_stderr.o

test_cli.exe: $(TEST_CLI_OBJS) $(USER_LIBS)
	$(CC) $(CFLAGS) -o $(TEST_CLI_APP) $(TEST_CLI_OBJS) $(LIBS) $(USER_LIBS)

ALL_SRCS   = $(sort $(sr_SRCS) $(LWTCP_SRCS) $(CLI_SRCS))

ALL_CLI_SRCS   = $(filter cli/%.c, $(ALL_SRCS))
ALL_CLI_OBJS   = $(patsubst cli/%.c,%.o, $(ALL_CLI_SRCS))
ALL_CLI_DEPS   = $(patsubst cli/%.c,.%.d,$(ALL_CLI_SRCS))

$(ALL_CLI_OBJS) : %.o : ./cli/%.c
	$(CC) -c $(CFLAGS) $< -o $@

$(ALL_CLI_DEPS) : .%.d : ./cli/%.c
	$(CC) -MM $(CFLAGS) -I cli/ $<  > $@

include $(ALL_CLI_DEPS)

ALL_LWTCP_SRCS = $(filter lwtcp/%.c, $(ALL_SRCS))
ALL_LWTCP_OBJS = $(patsubst lwtcp/%.c,%.o, $(ALL_LWTCP_SRCS))
ALL_LWTCP_DEPS = $(patsubst lwtcp/%.c,.%.d,$(ALL_LWTCP_SRCS))

$(ALL_LWTCP_OBJS) : %.o : ./lwtcp/%.c
	$(CC) -c $(CFLAGS) $< -o $@

$(ALL_LWTCP_DEPS) : .%.d : ./lwtcp/%.c
	$(CC) -MM $(CFLAGS) -I lwtcp/ $<  > $@

include $(ALL_LWTCP_DEPS)

$(sr_OBJS) : %.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

$(sr_DEPS) : .%.d : %.c
	$(CC) -MM $(CFLAGS) $<  > $@

include $(sr_DEPS)	

sr : $(sr_OBJS) $(ALL_CLI_OBJS) liblwtcp.a
	$(CC) $(CFLAGS) -o sr $(sr_OBJS) $(ALL_CLI_OBJS) liblwtcp.a $(LIBS)

sr.purify : $(sr_OBJS)
	$(PURIFY) $(CC) $(CFLAGS) -o sr.purify $(sr_OBJS) $(LIBS)

.PHONY : clean clean-deps dist

clean:
	rm -f *.o *~ core sr *.dump *.tar tags
	make -C cli clean

clean-deps:
	rm -f .*.d

dist-clean: clean clean-deps
	rm -f .*.swp sr_stub.tar.gz

dist: dist-clean
	(cd ..; tar -X stub/exclude -cvf sr_stub.tar stub/; gzip sr_stub.tar); \
    mv ../sr_stub.tar.gz .

tags:
	ctags *.c
