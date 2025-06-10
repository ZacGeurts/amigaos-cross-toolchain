TOP := $(shell pwd)
PREFIX ?= /usr/local
HOST := $(TOP)/.build/host
SOURCES := $(TOP)/.build/sources
ARCHIVES := $(TOP)/.build/archives
STAMPS := $(TOP)/.build/stamps
BUILD := $(TOP)/.build/build
TMPDIR := $(TOP)/.build/tmp
SUBMODULES := $(TOP)/submodules

PPC_PREFIX := $(PREFIX)/ppc-amigaos
PPC_TARGET := ppc-amigaos
PPC_STAMPS := $(STAMPS)/ppc
PPC_BUILD := $(BUILD)/ppc
PPC_ARCHIVES := $(ARCHIVES)/ppc
PPC_SDK := SDK_54.16

M68K_PREFIX := $(PREFIX)/m68k-amigaos
M68K_TARGET := m68k-amigaos
M68K_STAMPS := $(STAMPS)/m68k
M68K_BUILD := $(BUILD)/m68k
M68K_ARCHIVES := $(ARCHIVES)/m68k
M68K_NDK := NDK_3.9
M68K_IXEMUL := ixemul-48.2
M68K_VBCC := vbcc0_9k
M68K_VASM := vasm1_9c
M68K_VLINK := vlink0_17b
M68K_VCLIB := vbcc_target_m68k-amigaos

PPC_URLS := \
	https://github.com/alisw/GMP.git=gmp \
	https://gitlab.inria.fr/mpc/mpc.git=mpc \
	https://github.com/BrianGladman/mpfr.git=mpfr \
	https://github.com/trueroad/texinfo.git=texinfo \
	https://github.com/Meinersbur/isl.git=isl \
	https://github.com/periscop/cloog.git=cloog \
	https://github.com/autotools-mirror/automake.git=automake \
	https://git.savannah.gnu.org/git/libtool.git=libtool \
	http://os4depot.net/?function=showfile\&file=development/library/misc/sdk.lha=$(PPC_SDK).lha \
	https://github.com/adtools/amigaos-binutils-2.14.git=binutils \
	https://github.com/adtools/amigaos-gcc-2.95.3.git=gcc

M68K_URLS := \
	https://git.savannah.gnu.org/git/m4.git=m4 \
	https://git.savannah.gnu.org/git/gawk.git=gawk \
	https://git.savannah.gnu.org/git/autoconf.git=autoconf \
	https://git.savannah.gnu.org/git/bison.git=bison \
	https://git.savannah.gnu.org/git/texinfo.git=texinfo \
	https://git.savannah.gnu.org/git/automake.git=automake \
	https://github.com/westes/flex.git=flex \
	http://amiga.serveftp.net/MiscFiles/NDK39.lha=$(M68K_NDK).lha \
	http://downloads.sourceforge.net/project/amiga/ixemul.library/48.2/ixemul-src.lha=$(M68K_IXEMUL).lha \
	http://sun.hasenbraten.de/vasm/release/$(M68K_VASM).tar.gz=$(M68K_VASM).tar.gz \
	http://sun.hasenbraten.de/vlink/release/$(M68K_VLINK).tar.gz=$(M68K_VLINK).tar.gz \
	http://phoenix.owl.de/tags/$(M68K_VBCC).tar.gz=$(M68K_VBCC).tar.gz \
	http://aminet.net/dev/asm/ira-ssa.lha=ira.lha \
	http://sun.hasenbraten.de/~frank/projects/download/vdam68k.tar.gz=vdam68k.tar.gz \
	http://phoenix.owl.de/vbcc/current/$(M68K_VCLIB).lha=$(M68K_VCLIB).lha

CC := gcc
CXX := g++
MAKE := make
CURL := curl
PATCH := patch
BISON := bison
FLEX := flex
SVN := svn
GIT := git
PERL := perl
GPERF := gperf
YACC := yacc
TAR := tar
CP := cp
MKDIR := mkdir
RM := rm
CHMOD := chmod
TOUCH := touch

OS := $(shell uname -s)
ifeq ($(OS),Linux)
	SEVENZ := 7z
	LHASA := lhasa
	ARCHIVE_TOOL := $(shell command -v $(SEVENZ) >/dev/null 2>&1 && echo $(SEVENZ) || (command -v $(LHASA) >/dev/null 2>&1 && echo $(LHASA) || echo 7z))
else
	ARCHIVE_TOOL := 7z
endif

CFLAGS := -g -O2
CXXFLAGS := -g -O2
MAKEFLAGS := $(if $(filter no, $(QUIET)),,--silent)

ifeq ($(OS),Windows_NT)
	SHELL := cmd.exe
	MKDIR := mkdir
	CP := copy
	RM := del /Q
	TOUCH := echo. >
	CHMOD := attrib
	PATHSEP := \\
else
	SHELL := /bin/sh
	MKDIR := mkdir -p
	CP := cp -r
	RM := rm -rf
	TOUCH := touch
	CHMOD := chmod
	PATHSEP := /
endif

.PHONY: all
all: ppc m68k

$(STAMPS) $(PPC_STAMPS) $(M68K_STAMPS) $(SOURCES) $(ARCHIVES) $(PPC_ARCHIVES) $(M68K_ARCHIVES) $(BUILD) $(PPC_BUILD) $(M68K_BUILD) $(TMPDIR) $(PREFIX) $(PPC_PREFIX) $(M68K_PREFIX):
	@$(MKDIR) $@

CHECK_TOOLS := $(CC) $(CXX) $(CURL) $(PATCH) $(BISON) $(FLEX) $(MAKE) $(SVN) $(GIT) $(PERL) $(GPERF) $(YACC) $(TAR)
check_tools: $(CHECK_TOOLS)
$(CHECK_TOOLS):
	@command -v $@ >/dev/null 2>&1 || { echo "Error: $@ not found. Please install it."; exit 1; }
check_archive_tool:
	@command -v $(ARCHIVE_TOOL) >/dev/null 2>&1 || { echo "Error: $(ARCHIVE_TOOL) not found. Install 'p7zip' (all platforms) or 'lhasa' (Linux fallback)."; exit 1; }

$(TMPDIR)/check_ncurses.h: | $(TMPDIR)
	@echo "#include <ncurses.h>" > $@
	@echo "int main() { return 0; }" >> $@
check_headers: check_tools check_archive_tool $(TMPDIR)/check_ncurses.h
	@$(CC) $(TMPDIR)/check_ncurses.h -o /dev/null || { echo "ERROR: Missing ncurses development headers"; exit 1; }

$(SUBMODULES)/.stamp: | $(SUBMODULES)
	@$(GIT) submodule sync
	@$(GIT) submodule update --init --force || { echo "WARNING: Submodule update failed, attempting manual clone..."; \
		cd $(SUBMODULES) && \
		for pkg in binutils-2.14 gcc-2.95.3 clib2 libnix fd2sfd sfdc libdebug fd2pragma; do \
			if [ ! -d "$$pkg" ]; then \
				case $$pkg in \
					binutils-2.14) $(GIT) clone https://github.com/adtools/amigaos-binutils-2.14 $$pkg ;; \
					gcc-2.95.3) $(GIT) clone https://github.com/cahirwpz/amigaos-gcc-2.95.3 $$pkg ;; \
					clib2) $(GIT) clone https://github.com/adtools/clib2 $$pkg ;; \
					libnix) $(GIT) clone https://github.com/cahirwpz/libnix $$pkg ;; \
					fd2sfd) $(GIT) clone https://github.com/cahirwpz/fd2sfd $$pkg ;; \
					sfdc) $(GIT) clone https://github.com/adtools/sfdc $$pkg ;; \
					libdebug) $(GIT) clone https://github.com/cahirwpz/libdebug $$pkg ;; \
					fd2pragma) $(GIT) clone https://github.com/adtools/fd2pragma $$pkg ;; \
				esac; \
			fi; \
		done; }
	@$(TOUCH) $@

define download
	@$(MKDIR) $(2)
	@cd $(2) && for pkg in $(1); do \
		if echo "$$pkg" | grep -q '='; then \
			name="$${pkg##*=}"; pkgurl="$${pkg%=*}"; \
		else \
			name="$$(basename "$$pkg")"; pkgurl="$$pkg"; \
		fi; \
		if [ -n "$$name" ]; then \
			if echo "$$pkgurl" | grep -q '\.git$$'; then \
				if [ ! -d "$$name" ]; then \
					echo "Cloning $$pkgurl into $(2)/$$name"; \
					$(GIT) clone "$$pkgurl" "$$name" || { echo "ERROR: Failed to clone $$pkgurl"; exit 1; }; \
				else \
					echo "$$name already exists in $(2)"; \
				fi; \
			else \
				if [ ! -f "$$name" ]; then \
					echo "Downloading $$pkgurl to $(2)/$$name"; \
					$(CURL) -L -o "$$name" "$$pkgurl" || { echo "ERROR: Failed to download $$pkgurl"; exit 1; }; \
				else \
					echo "$$name already exists in $(2)"; \
				fi; \
			fi; \
		else \
			echo "Downloading $$pkgurl to $(2)/$$(basename "$$pkgurl")"; \
			$(CURL) -L -o "$$(basename "$$pkgurl")" "$$pkgurl" || { echo "ERROR: Failed to download $$pkgurl"; exit 1; }; \
		fi; \
	done
endef

define unpack
	@cd $(2) && \
	if [ "$(suffix $(1))" = ".lha" ]; then \
		if [ "$(ARCHIVE_TOOL)" = "lhasa" ]; then \
			$(LHASA) x $(1) $(3) >/dev/null; \
		else \
			$(ARCHIVE_TOOL) x $(1) -o$(2) >/dev/null; \
		fi; \
	elif [ "$(suffix $(1))" = ".gz" ] || [ "$(suffix $(1))" = ".bz2" ]; then \
		$(TAR) -xf $(1) -C $(2) $(3); \
	else \
		echo "ERROR: Unsupported archive: $(1)"; exit 1; \
	fi
endef

define update_autotools
	@$(RM) $(1)/config.guess $(1)/config.sub
	@$(CP) $(SOURCES)/automake/lib/config.guess $(1)/config.guess
	@$(CP) $(SOURCES)/automake/lib/config.sub $(1)/config.sub
endef

define generate_autogen
	@if [ ! -f $(1)/autogen.sh ]; then \
		echo "Generating autogen.sh in $(1)"; \
		echo "#!/bin/sh" > $(1)/autogen.sh; \
		echo "set -e" >> $(1)/autogen.sh; \
		if [ -f $(1)/configure.ac ]; then \
			echo "libtoolize --force --copy" >> $(1)/autogen.sh; \
			echo "aclocal -I m4" >> $(1)/autogen.sh; \
			echo "autoconf" >> $(1)/autogen.sh; \
			echo "autoheader" >> $(1)/autogen.sh; \
		fi; \
		if [ -f $(1)/Makefile.am ]; then \
			echo "automake --add-missing --copy --foreign" >> $(1)/autogen.sh; \
		fi; \
		$(CHMOD) +x $(1)/autogen.sh; \
	else \
		echo "autogen.sh already exists in $(1)"; \
	fi
endef

$(SOURCES)/automake: $(PPC_ARCHIVES)/.downloaded | $(SOURCES)
	@$(MKDIR) $(SOURCES)/automake
	@$(CP) -r $(PPC_ARCHIVES)/automake/* $(SOURCES)/automake/
	@$(TOUCH) $@

ppc: $(PPC_STAMPS)/toolchain | check_headers $(SUBMODULES)/.stamp

$(PPC_ARCHIVES)/.downloaded: | $(PPC_ARCHIVES)
	$(call download,$(PPC_URLS),$(PPC_ARCHIVES))
	@$(TOUCH) $@

$(PPC_STAMPS)/m4: $(PPC_ARCHIVES)/.downloaded | $(PPC_STAMPS)
	@cd $(PPC_ARCHIVES)/m4 && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(PPC_ARCHIVES)/m4); \
			mv autogen.sh bootstrap; \
		fi && \
		./bootstrap && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/m4)
	@$(TOUCH) $@

$(PPC_STAMPS)/autoconf: $(PPC_STAMPS)/m4 | $(PPC_STAMPS)
	@cd $(PPC_ARCHIVES)/autoconf && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(PPC_ARCHIVES)/autoconf); \
			mv autogen.sh bootstrap; \
		fi && \
		./bootstrap && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/autoconf)
	@$(TOUCH) $@

$(PPC_STAMPS)/libtool: $(PPC_STAMPS)/autoconf | $(PPC_STAMPS)
	@cd $(PPC_ARCHIVES)/libtool && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(PPC_ARCHIVES)/libtool); \
			mv autogen.sh bootstrap; \
		fi && \
		./bootstrap && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/libtool)
	@$(TOUCH) $@

$(PPC_STAMPS)/automake: $(PPC_STAMPS)/autoconf | $(PPC_STAMPS) $(SOURCES)/automake
	@cd $(PPC_ARCHIVES)/automake && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(PPC_ARCHIVES)/automake); \
			mv autogen.sh bootstrap; \
		fi && \
		./bootstrap && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@find $(HOST)/share/automake-* -name ylwrap -exec $(CP) {} $(PPC_ARCHIVES)/binutils/ylwrap \;
	$(call update_autotools,$(PPC_ARCHIVES)/automake)
	@$(TOUCH) $@

$(PPC_STAMPS)/texinfo: $(PPC_STAMPS)/automake
	@cd $(PPC_ARCHIVES)/texinfo && \
		$(call generate_autogen,$(PPC_ARCHIVES)/texinfo) && \
		./autogen.sh && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/texinfo)
	@$(TOUCH) $@

$(PPC_STAMPS)/gmp: $(PPC_STAMPS)/libtool
	@cd $(PPC_ARCHIVES)/gmp && \
		$(call generate_autogen,$(PPC_ARCHIVES)/gmp) && \
		./autogen.sh && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/gmp)
	@$(TOUCH) $@

$(PPC_STAMPS)/mpfr: $(PPC_STAMPS)/gmp
	@cd $(PPC_ARCHIVES)/mpfr && \
		$(call generate_autogen,$(PPC_ARCHIVES)/mpfr) && \
		./autogen.sh && ./configure --prefix=$(HOST) --with-gmp=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/mpfr)
	@$(TOUCH) $@

$(PPC_STAMPS)/mpc: $(PPC_STAMPS)/mpfr
	@cd $(PPC_ARCHIVES)/mpc && \
		$(call generate_autogen,$(PPC_ARCHIVES)/mpc) && \
		./autogen.sh && ./configure --prefix=$(HOST) --with-gmp=$(HOST) --with-mpfr=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/mpc)
	@$(TOUCH) $@

$(PPC_STAMPS)/isl: $(PPC_STAMPS)/gmp
	@cd $(PPC_ARCHIVES)/isl && \
		$(call generate_autogen,$(PPC_ARCHIVES)/isl) && \
		./autogen.sh && ./configure --prefix=$(HOST) --with-gmp-prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/isl)
	@$(TOUCH) $@

$(PPC_STAMPS)/cloog: $(PPC_STAMPS)/isl
	@cd $(PPC_ARCHIVES)/cloog && \
		$(call generate_autogen,$(PPC_ARCHIVES)/cloog) && \
		./autogen.sh && ./configure --prefix=$(HOST) --with-isl=system --with-gmp-prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(PPC_ARCHIVES)/cloog)
	@$(TOUCH) $@

$(PPC_STAMPS)/binutils: $(PPC_STAMPS)/automake
	@cd $(PPC_ARCHIVES)/binutils && ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) && $(MAKE) YACC=bison && $(MAKE) install
	@$(TOUCH) $@

$(PPC_STAMPS)/gcc: $(PPC_STAMPS)/binutils $(PPC_STAMPS)/mpc $(PPC_STAMPS)/cloog
	@cd $(PPC_ARCHIVES)/gcc && CFLAGS="$(CFLAGS)" CC="$(CC)" CXX="$(CXX)" ./configure --prefix=$(HOST) --target=$(PPC_TARGET) --with-gmp=$(HOST) --with-mpfr=$(HOST) --with-isl=$(HOST) --with-cloog=$(HOST) --enable-languages=c,c++ --enable-haifa --enable-sjlj-exceptions --disable-libstdcxx-pch --disable-tls && $(MAKE) && $(MAKE) install
	@$(TOUCH) $@

$(PPC_STAMPS)/sdk: $(PPC_STAMPS)/gcc
	$(call unpack,$(PPC_SDK).lha,$(PPC_ARCHIVES),SDK_Install)
	@$(MKDIR) $(PPC_PREFIX)/SDK/include $(PPC_PREFIX)/SDK/clib2 $(PPC_PREFIX)/$(PPC_TARGET)/lib
	@$(CP) $(PPC_ARCHIVES)/SDK_Install/* $(PPC_PREFIX)/SDK
	$(call unpack,SDK/base,$(PPC_PREFIX)/SDK,Include)
	@$(CP) $(PPC_PREFIX)/SDK/Include/* $(PPC_PREFIX)/SDK/include
	$(call unpack,SDK/clib2,$(PPC_PREFIX)/SDK,src)
	@$(CP) $(PPC_PREFIX)/SDK/src/* $(PPC_PREFIX)/SDK/clib2
	$(call unpack,SDK/newlib,$(PPC_PREFIX)/SDK,dst)
	@$(CP) $(PPC_PREFIX)/SDK/dst/* $(PPC_PREFIX)/$(PPC_TARGET)/lib
	@$(TOUCH) $@

$(PPC_STAMPS)/toolchain: $(PPC_STAMPS)/sdk
	@$(TOUCH) $@

m68k: $(M68K_STAMPS)/toolchain | check_headers $(SUBMODULES)/.stamp

$(M68K_ARCHIVES)/.downloaded: | $(M68K_ARCHIVES)
	$(call download,$(M68K_URLS),$(M68K_ARCHIVES))
	@$(TOUCH) $@

$(M68K_STAMPS)/automake: $(M68K_STAMPS)/autoconf $(SOURCES)/automake | $(M68K_STAMPS)
	@cd $(M68K_ARCHIVES)/automake && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(M68K_ARCHIVES)/automake); \
			mv autogen.sh bootstrap; \
		fi && \
		./bootstrap && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(M68K_ARCHIVES)/automake)
	@$(TOUCH) $@

$(M68K_STAMPS)/m4: $(M68K_ARCHIVES)/.downloaded | $(M68K_STAMPS)
	@cd $(M68K_ARCHIVES)/m4 && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(M68K_ARCHIVES)/m4); \
			mv autogen.sh bootstrap; \
		fi && \
		./bootstrap && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(M68K_ARCHIVES)/m4)
	@$(TOUCH) $@

$(M68K_STAMPS)/autoconf: $(M68K_STAMPS)/m4 | $(M68K_STAMPS)
	@cd $(M68K_ARCHIVES)/autoconf && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(M68K_ARCHIVES)/autoconf); \
			mv autogen.sh bootstrap; \
		&& \
		if [ ! -f bootstrap ]; then ./bootstrap.sh; else ./bootstrap; fi && \
		./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$(M68K_ARCHIVES)/autoconf)
	@$(TOUCH) $@

$(M68K_STAMPS)/gawk: $(M68K_STAMPS)/m4
	@cd $(M68K_ARCHIVES)/gawk && \
		if [ ! -f bootstrap.sh ]; then \
			$(call generate_autogen,($M68K_ARCHIVES)/gawk); \
		else \
			@cd ./bootstrap.sh && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$($M68K_ARCHIVES)/gawk)
	@$(TOUCH) $@

$(M68K_STAMPS)/flex: $(M68K_STAMPS)/m4
	@cd $(M68K_ARCHIVES)/flex && \
	$(call generate_autogen,$(M68K_ARCHIVES)/flex) && \
		./autogen.sh && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,($M68K_ARCHIVES)/flex)
	@$(TOUCH) $@

$(M68K_STAMPS)/bison: $(M68K_STAMPS)/m4
	@cd $(M68K_ARCHIVES)/bison && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,($M68K_ARCHIVES)/bison); \
			mv autogen.sh bootstrap; \
		else \
		./bootstrap && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$($M68K_ARCHIVES)/bison)
	@$(TOUCH) $@

$(M68K_STAMPS)/texinfo: $(M68K_STAMPS)/automake
	@cd $(M68K_ARCHIVES)/texinfo && \
		$(call generate_autogen,($M68K_ARCHIVES)/texinfo) && \
		./autogen.sh && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	$(call update_autotools,$($M68K_ARCHIVES)/texinfo)
	@$(TOUCH) $@

$(M68K_STAMPS)/target: $(M68K_STAMPS)/automake
	@$(MKDIR) $(M68K_PREFIX)/bin $(M68K_PREFIX)/etc $(M68K_PREFIX)/$(M68K_TARGET)/bin $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/lvo $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/fd $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/sfd
	@$(TOUCH) $@

$(M68K_STAMPS)/vasm: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_VASM).tar.gz,$(M68K_BUILD),vasm)
	@cd $(M68K_BUILD)/vasm && $(MAKE) CPU=m68k SYNTAX=mot
	@$(TOUCH) $@

$(M68K_STAMPS)/vlink: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_VLINK).tar.gz,$(M68K_BUILD),vlink)
	@$(MKDIR) $(M68K_BUILD)/vlink/objects
	@cd $(M68K_BUILD)/vlink && $(MAKE)
	@$(TOUCH) $@

$(M68K_STAMPS)/vbcc: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_VBCC).tar.gz,$(M68K_BUILD),vbcc)
	@$(MKDIR) $(M68K_BUILD)/vbcc/bin
	@echo -e "y\ny\nsigned char\ny\nunsigned char\nn\ny\nsigned short\nn\ny\nunsigned short\nn\ny\nsigned int\nn\ny\nunsigned int\nn\ny\nsigned long long\nn\ny\nunsigned long long\nn\ny\nfloat\nn\ny\ndouble" | $(M68K_BUILD)/vbcc/bin/vbccm68k -quiet -o=$(M68K_BUILD)/vbcc/bin/vbccm68k
	@$(TOUCH) $@

$(M68K_STAMPS)/vclib: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_VCLIB).lha,$(M68K_BUILD),$(M68K_VCLIB))
	@$(TOUCH) $@

$(M68K_STAMPS)/vbcc-install: $(M68K_STAMPS)/vasm $(M68K_STAMPS)/vlink $(M68K_STAMPS)/vbcc $(M68K_STAMPS)/vclib
	@$(CP) $(M68K_BUILD)/vasm/vasmm68k_mot $(M68K_PREFIX)/$(M68K_TARGET)/bin/
	@$(CP) $(M68K_BUILD)/vasm/vobjdump $(M68K_PREFIX)/bin/
	@echo -e "#!/bin/sh\n$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include \"$$@\"" > $(M68K_PREFIX)/bin/vasm
	@$(CHMOD) 755 $(M68K_PREFIX)/bin/vasm
	@$(CP) $(M68K_BUILD)/vlink/vlink $(M68K_PREFIX)/bin/
	@$(CP) $(M68K_BUILD)/vbcc/bin/vbccm68k $(M68K_PREFIX)/$(M68K_TARGET)/bin/
	@$(CP) $(M68K_BUILD)/vbcc/bin/vc $(M68K_PREFIX)/bin/
	@$(CP) $(M68K_BUILD)/vbcc/bin/vprof $(M68K_PREFIX)/bin/
	@$(CP) $(M68K_BUILD)/$(M68K_VCLIB)/include/* $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include/
	@$(CP) $(M68K_BUILD)/$(M68K_VCLIB)/lib/* $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/
	@echo -e "-cc=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include\n-ccv=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include\n-as=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include %s -o %s\n-asv=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include %s -o %s\n-rm=rm %s\n-rmv=rm -v %s\n-ld=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -lvc -o %s\n-l2=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -o %s\n-ldv=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc Monographs -nostdlib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/(M68K)/$TARGET)/vbcc/lib/ -lvc -o %s\n-l2v=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/(M68K)/$TARGET)/vbcc/lib/ -o %s\n-ldnodb=-s -Rshort\n-ul=-l%s\n-cf=-F%s\n-ml=500" > $(M68K_PREFIX)/etc/vc.config
	@$(CHMOD) 644 $(M68K_PREFIX)/etc/vc.config
	@$(TOUCH) $@

$(M68K_STAMPS)/fd2sfd: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d fd2sfd ]; then $(CP) $(SUBMODULES)/fd2sfd .; fi
	@cd $(M68K_BUILD)/fd2sfd && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(CP) fd2sfd $(M68K_PREFIX)/bin/ && $(CP) cross/share/$(M68K_TARGET)/alib.h $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline/
	@$(TOUCH) $@

$(M68K_STAMPS)/fd2pragma: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d fd2pragma ]; then $(CP) $(SUBMODULES)/fd2pragma .; fi
	@cd $(M68K_BUILD)/fd2pragma && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(CP) fd2pragma $(M68K_PREFIX)/bin/ && $(CP) Include/inline/macros.h Include/inline/stubs.h $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline/
	@$(TOUCH) $@

$(M68K_STAMPS)/sfdc: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d sfdc ]; then $(CP) $(SUBMODULES)/sfdc .; fi
	@cd $(M68K_BUILD)/sfdc && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install
	@$(TOUCH) $@

$(M68K_STAMPS)/ndk: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_NDK).lha,$(M68K_ARCHIVES),NDK39)
	@$(MKDIR) $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/include_h/* $(M68K_PREFIX)/$(M68K)/$TARGET)/ndk/include/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/include_i/* $(M68K68K_PREFIX)/$M68K_TARGET)/ndk/include/
	$(CP) $(M68K_ARCHIVES)/NDK39/Include/fd/* $(M68K_PREFIX)/$M68K_TARGET)/ndk/lib/fd/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/sfd/* $(M68K_PREFIX)/$M68K_TARGET)/ndk/lib/sfd/
	$(CP) $(M68K$(ARCHIVES)/NDK39/Include/linker_libs/libamiga.a $(M68K_PREFIX)/$M68K_TARGET)/ndk/lib/
	$(CP) $(M68K_ARCHIVES)/NDK39/Include/linker_libs/libm.a $(M68K68K_PREFIX)/$M68K_TARGET)/ndk/lib/
	$(CP) $(M68K_ARCHIVES)/NDK39/Documentation/Autodocs/* $(M68K68K_PREFIX)/$M68K_TARGET)/ndk/doc/
	@$(TOUCH) $

$(M68K_STAMPS)/ixemul: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_IXEMUL).lha,$(M68K_ARCHIVES),ixemul)
	@$(CP) $(M68K_ARCHIVES)/ixemul/include/* $(M68K_PREFIX)/$M68K_TARGET)/libnix/include/
	@$(TOUCH) $

$(M68K_STAMPS)/libnix: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d libnix ]; then $(CP) $(SUBMODULES)/lib/nix/ .; fi
	@cd $(M68K_BUILD)/libnix && ./configure --prefix=$(M68K_PREFIX)/$M68K_TARGET)/libnix && $(MAKE) && $(MAKE) install
	@$(CP) $(SUBMODULES)/libnix/sources/headers/stabs.h $(M68K_PREFIX)/$M68K_TARGET)/libnix/include/
	@$(TOUCH) $

$(M68K_STAMPS)/libdebug: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d libdebug ]; then $(CP) $(SUBMODULES)/libdebug .; fi
	@cd $(M68K_BUILD)/libdebug && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install
	@$(TOUCH) $

$(M68K_STAMPS)/clib2: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d clib2 ]; then $(CP) $(SUBMODULES)/clib2 .; fi
	@cd $(M68K_BUILD)/clib2 && $(MAKE) -f GNUmakefile.68k
	@$(MKDIR) $(M68K_PREFIX)/$(M68K_TARGET)/clib2
	@$(CP) $(M68K_BUILD)/clib2/lib/* $(M68K_PREFIX)/$(M68K_TARGET)/clib2/lib/
	@$(CP) $(M68K_BUILD)/clib2/include/* $(M68K_PREFIX)/$(M68K_TARGET)/clib2/include/
	@$(TOUCH) $

$(M68K_STAMPS)/ira: $(M68K_ARCHIVES)/.downloaded
	$(