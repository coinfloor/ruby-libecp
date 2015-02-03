OS := $(shell uname -s)

lib/libecp.so : ext/libecp/libecp.so
ifeq ($(OS),Darwin)
	install $< $@
else
	install -sT $< $@
endif

ext/libecp/libecp.so ::
	$(MAKE) -C ext/libecp libecp.so

.PHONY : clean
clean :
	rm -f lib/libecp.so
	$(MAKE) -C ext/libecp clean
