OS := $(shell uname -s)

lib/libecp.so : ext/libecp/libecp.so
ifeq ($(OS),Darwin)
	install $< $@
else
	install -sT $< $@
endif

ext/libecp/libecp.so ::
	$(MAKE) -C ext/libecp libecp.so

.PHONY : install clean

install : lib/libecp.so

clean :
	$(MAKE) -C ext/libecp clean
