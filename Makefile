TOP := $(shell pwd)
PREFIX ?= $(abspath $(TOP)/install)
HOST := $(TOP)/.build/host
SOURCES := $(TOP)/.build/sources
DOWNLOADS := $(TOP)/.build/downloads
STAMPS := $(TOP)/.build/stamps
BUILD := $(TOP)/.build/build
TMPDIR := $(TOP)/.build/tmp
SUBMODULES := $(TOP)/submodules

PPC_PREFIX := $(PREFIX)/ppc-amigaos
PPC_TARGET := ppc-amigaos
PPC_STAMPS := $(STAMPS)/ppc
PPC_BUILD := $(BUILD)/ppc
PPC_ARCHIVES := $(DOWNLOADS)/ppc
PPC_SDK := SDK_54.16

M68K_PREFIX := $(PREFIX)/m68k-amigaos
M68K_TARGET := m68k-amigaos
M68K_STAMPS := $(STAMPS)/m68k
M68K_BUILD := $(BUILD)/m68k
M68K_ARCHIVES := $(DOWNLOADS)/m68k
M68K_NDK := NDK_3.9
M68K_IXEMUL := ixemul-48.2
M68K_VBCC := vbcc0_9k
M68K_VASM := vasm1_9c
M68K_VLINK := vlink0_17b
M68K_VCLIB := vbcc_target_m68k-amigaos

# Latest versions (for reference, latest dynamically fetched where possible)
TEXINFO_VERSION := 7.2
GMP_VERSION := 6.3.0
GAWK_VERSION := 5.3.2
BISON_VERSION := 3.8.2
MPC_VERSION := 1.3.1

# Common URLs
COMMON_URLS := \
	https://github.com/adtools/amigaos-binutils-2.14.git=binutils \
	https://github.com/adtools/amigaos-gcc-2.95.3.git=gcc \
	https://github.com/autotools-mirror/m4.git=m4 \
	https://github.com/autotools-mirror/autoconf.git=autoconf \
	https://github.com/autotools-mirror/automake.git=automake \
	https://github.com/autotools-mirror/libtool.git=libtool \
	https://ftp.gnu.org/gnu/texinfo/texinfo-$(TEXINFO_VERSION).tar.xz=texinfo-$(TEXINFO_VERSION).tar.xz \
	https://ftp.gnu.org/gnu/gawk/gawk-$(GAWK_VERSION).tar.xz=gawk-$(GAWK_VERSION).tar.xz \
	https://ftp.gnu.org/gnu/bison/bison-$(BISON_VERSION).tar.xz=bison-$(BISON_VERSION).tar.xz \
	https://gmplib.org/download/gmp/gmp-$(GMP_VERSION).tar.xz=gmp-$(GMP_VERSION).tar.xz \
	https://github.com/westes/flex.git=flex \
	https://github.com/aixoss/mpfr.git=mpfr \
	https://ftp.gnu.org/gnu/mpc-$(MPC_VERSION).tar.xz=mpc-$(MPC_VERSION).tar.xz \
	https://github.com/Meinersbur/isl.git=isl \
	https://github.com/periscop/cloog.git=cloog

# PPC URLs
PPC_URLS := \
	$(COMMON_URLS) \
	http://os4depot.net/?function=showfile&file=development/library/misc/sdk.lha=$(PPC_SDK).lha

# M68K URLs
M68K_URLS := \
	$(COMMON_URLS) \
	http://amiga.serveftp.net/MiscFiles/NDK39.lha=$(M68K_NDK).lha \
	http://downloads.sourceforge.net/project/amiga/ixemul.library/48.2/ixemul-src.lha=$(M68K_IXEMUL).lha \
	http://sun.hasenbraten.de/vasm/release/$(M68K_VASM).tar.gz=$(M68K_VASM).tar.gz \
	http://sun.hasenbraten.de/vlink/release/$(M68K_VLINK).tar.gz=$(M68K_VLINK).tar.gz \
	http://phoenix.owl.de/tags/$(M68K_VBCC).tar.gz=$(M68K_VBCC).tar.gz \
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
	SHELL := /bin/bash
	MKDIR := mkdir -p
	CP := cp -r
	RM := rm -rf
	TOUCH := touch
	CHMOD := chmod
	PATHSEP := /
endif

.PHONY: all clean clean-download find-latest
all: ppc m68k

clean:
	@$(RM) $(TOP)/.build $(PREFIX)

clean-download: clean
	@$(RM) $(DOWNLOADS)

# Find latest versions dynamically
define find_latest
	@url=$(1); pkg=$(2); ext=$(3); \
	tmpfile=$(TMPDIR)/$$pkg.html; \
	$(CURL) -s $$url > $$tmpfile; \
	latest=$$(grep -o "$$pkg-[0-9]\+\.[0-9]\+\.[0-9]\+$$ext" $$tmpfile | sort -V | tail -n 1); \
	if [ -z "$$latest" ]; then \
		echo "ERROR: Could not find latest version for $$pkg at $$url"; exit 1; \
	else \
		version=$${latest#$$pkg-}; version=$${version%$$ext}; \
		echo "$$pkg latest version: $$version"; \
		echo "$$url/$$latest=$$latest"; \
	fi; \
	$(RM) $$tmpfile
endef

find-latest:
	$(call find_latest,https://gmplib.org/download/gmp/,gmp,.tar.xz)
	$(call find_latest,https://ftp.gnu.org/gnu/gawk/,gawk,.tar.xz)
	$(call find_latest,https://ftp.gnu.org/gnu/bison/,bison,.tar.xz)

# Directories
DIRS := $(STAMPS) $(PPC_STAMPS) $(M68K_STAMPS) $(SOURCES) $(DOWNLOADS) $(PPC_ARCHIVES) $(M68K_ARCHIVES) $(BUILD) $(PPC_BUILD) $(M68K_BUILD) $(TMPDIR) $(PREFIX) $(PPC_PREFIX) $(M68K_PREFIX)
$(DIRS):
	@$(MKDIR) $@

# Tool checks
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

# Submodules
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

# Common functions
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
				if [ ! -d "$(DOWNLOADS)/$$name" ]; then \
					echo "Cloning $$pkgurl into $(DOWNLOADS)/$$name"; \
					$(GIT) clone "$$pkgurl" "$(DOWNLOADS)/$$name" || { echo "ERROR: Failed to clone $$pkgurl"; exit 1; }; \
				else \
					echo "$$name already exists in $(DOWNLOADS)"; \
				fi; \
				$(MKDIR) "$$name"; \
				$(CP) -r "$(DOWNLOADS)/$$name"/* "$$name/"; \
			else \
				if [ ! -f "$(DOWNLOADS)/$$name" ]; then \
					echo "Downloading $$pkgurl to $(DOWNLOADS)/$$name"; \
					$(CURL) -L -o "$(DOWNLOADS)/$$name" "$$pkgurl" || { echo "ERROR: Failed to download $$pkgurl"; exit 1; }; \
				else \
					echo "$$name already exists in $(DOWNLOADS)"; \
				fi; \
				$(CP) "$(DOWNLOADS)/$$name" "$$name"; \
			fi; \
		else \
			name="$$(basename "$$pkgurl")"; \
			if [ ! -f "$(DOWNLOADS)/$$name" ]; then \
				echo "Downloading $$pkgurl to $(DOWNLOADS)/$$name"; \
				$(CURL) -L -o "$(DOWNLOADS)/$$name" "$$pkgurl" || { echo "ERROR: Failed to download $$pkgurl"; exit 1; }; \
			else \
				echo "$$name already exists in $(DOWNLOADS)"; \
			fi; \
			$(CP) "$(DOWNLOADS)/$$name" "$$name"; \
		fi; \
	done
endef

define unpack
	@cd $(2) && \
	if [ "$(suffix $(1))" = ".lha" ]; then \
		if [ "$(ARCHIVE_TOOL)" = "$(LHASA)" ]; then \
			$(LHASA) x "$(DOWNLOADS)/$1" $(3) >/dev/null || { echo "ERROR: Failed to extract $1"; exit 1; }; \
		else \
			$(ARCHIVE_TOOL) x "$(DOWNLOADS)/$1" -o$(2) >/dev/null || { echo "ERROR: Failed to extract $1"; exit 1; }; \
		fi; \
	elif [ "$(suffix $(1))" = ".gz" ] || [ "$(suffix $(1))" = ".bz2" ] || [ "$(suffix $(1))" = ".xz" ] || [ "$(suffix $(1))" = ".lz" ] || [ "$(suffix $(1))" = ".zst" ]; then \
		$(TAR) -xf "$(DOWNLOADS)/$1" -C $(2) $(3) || { echo "ERROR: Failed to extract $1"; exit 1; }; \
	else \
		echo "ERROR: Unsupported archive: $(suffix $1)"; exit 1; \
	fi
endef

define update_autotools
	@$(RM) $(1)/config.guess $(1)/config.sub
	@$(CP) $(SOURCES)/automake/lib/config.guess $(1)/
	@$(CP) $(SOURCES)/automake/lib/config.sub $(1)/
endef

define generate_autogen
	@if [ ! -f $(1)/autogen.sh ]; then \
		echo "Generating autogen.sh in $(1)"; \
		echo "#!/bin/bash" > $(1)/autogen.sh; \
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

define build_autotools
	@$(MKDIR) $(2)/$1
	@cd $(2)/$1 && \
		if [ ! -f bootstrap ]; then \
			$(call generate_autogen,$(2)/$1); \
			$(CP) autogen.sh bootstrap; \
		fi; \
		./bootstrap || { echo "ERROR: Bootstrap failed for $1"; exit 1; }; \
		./configure --prefix=$(HOST) $(3) || { echo "ERROR: Configure failed for $1"; exit 1; }; \
		$(MAKE) || { echo "ERROR: Make failed for $1"; exit 1; }; \
		$(MAKE) install || { echo "ERROR: Make install failed for $1"; exit 1; }; \
	$(call update_autotools,$(2)/$1); \
	@$(TOUCH) $(4)/$1
endef

# Component definitions
PPC_COMPONENTS := m4 autoconf libtool automake texinfo gmp mpfr mpc isl cloog binutils gcc sdk
M68K_COMPONENTS := m4 gawk autoconf flex bison texinfo target vasm vlink vbcc vclib vbcc-install fd2sfd fd2pragma sfdc ndk ixemul libnix libdebug clib2

# PPC rules
$(SOURCES)/automake: $(PPC_ARCHIVES)/.downloaded | $(SOURCES)
	@$(MKDIR) $(SOURCES)/automake
	@$(CP) -r $(PPC_ARCHIVES)/automake/* $(SOURCES)/automake/
	@$(TOUCH) $@

$(PPC_ARCHIVES)/.downloaded: | $(PPC_ARCHIVES)
	$(call download,$(PPC_URLS),$(PPC_ARCHIVES))
	@$(TOUCH) $@

$(PPC_STAMPS)/m4: $(PPC_ARCHIVES)/.downloaded | $(PPC_STAMPS)
	$(call build_autotools,m4,$(PPC_ARCHIVES),,$(PPC_STAMPS))

$(PPC_STAMPS)/autoconf: $(PPC_STAMPS)/m4 | $(PPC_STAMPS)
	$(call build_autotools,autoconf,$(PPC_ARCHIVES),,$(PPC_STAMPS))

$(PPC_STAMPS)/libtool: $(PPC_STAMPS)/autoconf | $(PPC_STAMPS)
	$(call build_autotools,libtool,$(PPC_ARCHIVES),,--disable-static $(PPC_STAMPS))

$(PPC_STAMPS)/automake: $(PPC_STAMPS)/autoconf | $(PPC_STAMPS) $(SOURCES)/automake
	$(call build_autotools,automake,$(PPC_ARCHIVES),,$(PPC_STAMPS))
	@find $(HOST)/share/automake-* -name ylwrap -exec $(CP) {} $(PPC_ARCHIVES)/binutils/ylwrap \;

$(PPC_STAMPS)/texinfo: $(PPC_STAMPS)/automake
	$(call build_autotools,texinfo,$(PPC_ARCHIVES),,--disable-perl-api $(PPC_STAMPS))

$(PPC_STAMPS)/gmp: $(PPC_STAMPS)/libtool
	$(call unpack,gmp-$(GMP_VERSION).tar.xz,$(PPC_BUILD),gmp-$(GMP_VERSION))
	$(call build_autotools,gmp-$(GMP_VERSION),$(PPC_BUILD),--disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/mpfr: $(PPC_STAMPS)/gmp
	$(call build_autotools,mpfr,$(PPC_ARCHIVES),--with-gmp=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/mpc: $(PPC_STAMPS)/mpfr
	$(call build_autotools,mpc,$(PPC_ARCHIVES),--with-gmp=$(HOST) --with-mpfr=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/isl: $(PPC_STAMPS)/gmp
	$(call build_autotools,isl,$(PPC_ARCHIVES),--with-gmp-prefix=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/cloog: $(PPC_STAMPS)/isl
	$(call build_autotools,cloog,$(PPC_ARCHIVES),--with-isl=system --with-gmp-prefix=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/binutils: $(PPC_STAMPS)/automake
	@cd $(PPC_ARCHIVES)/binutils && ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) --disable-nls && $(MAKE) YACC=bison && $(MAKE) install
	@$(TOUCH) $@

$(PPC_STAMPS)/gcc: $(PPC_STAMPS)/binutils $(PPC_STAMPS)/mpc $(PPC_STAMPS)/cloog
	@cd $(PPC_ARCHIVES)/gcc && CFLAGS="$(CFLAGS)" CC="$(CC)" CXX="$(CXX)" ./configure --prefix=$(HOST) --target=$(PPC_TARGET) --with-gmp=$(HOST) --with-mpfr=$(HOST) --with-isl=$(HOST) --with-cloog=$(HOST) --enable-languages=c,c++ --enable-haifa --enable-sjlj-exceptions --disable-libstdcxx-pch --disable-tls --disable-nls && $(MAKE) && $(MAKE) install
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

ppc: $(PPC_STAMPS)/toolchain | check_headers $(SUBMODULES)/.stamp

# M68K rules
$(M68K_ARCHIVES)/.downloaded: | $(M68K_ARCHIVES)
	$(call download,$(M68K_URLS),$(M68K_ARCHIVES))
	@$(TOUCH) $@

$(M68K_STAMPS)/m4: $(M68K_ARCHIVES)/.downloaded | $(M68K_STAMPS)
	$(call build_autotools,m4,$(M68K_ARCHIVES),,$(M68K_STAMPS))

$(M68K_STAMPS)/autoconf: $(M68K_STAMPS)/m4 | $(M68K_STAMPS)
	$(call build_autotools,autoconf,$(M68K_ARCHIVES),,$(M68K_STAMPS))

$(M68K_STAMPS)/gawk: $(M68K_STAMPS)/m4
	$(call unpack,gawk-$(GAWK_VERSION).tar.xz,$(M68K_BUILD),gawk-$(GAWK_VERSION))
	$(call build_autotools,gawk-$(GAWK_VERSION),$(M68K_BUILD),,$(M68K_STAMPS))

$(M68K_STAMPS)/flex: $(M68K_STAMPS)/m4
	$(call build_autotools,flex,$(M68K_ARCHIVES),,--disable-nls $(M68K_STAMPS))

$(M68K_STAMPS)/bison: $(M68K_STAMPS)/m4
	$(call unpack,bison-$(BISON_VERSION).tar.xz,$(M68K_BUILD),bison-$(BISON_VERSION))
	$(call build_autotools,bison-$(BISON_VERSION),$(M68K_BUILD),,--disable-nls $(M68K_STAMPS))

$(M68K_STAMPS)/texinfo: $(M68K_STAMPS)/automake
	$(call build_autotools,texinfo,$(M68K_ARCHIVES),,--disable-perl-api $(M68K_STAMPS))

$(M68K_STAMPS)/automake: $(M68K_STAMPS)/autoconf $(SOURCES)/automake | $(M68K_STAMPS)
	$(call build_autotools,automake,$(M68K_ARCHIVES),,$(M68K_STAMPS))

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
	@echo -e "#!/bin/bash\n$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include \"$$@\"" > $(M68K_PREFIX)/bin/vasm
	@$(CHMOD) 755 $(M68K_PREFIX)/bin/vasm
	@$(CP) $(M68K_BUILD)/vlink/vlink $(M68K_PREFIX)/bin/
	@$(CP) $(M68K_BUILD)/vbcc/bin/vbccm68k $(M68K_PREFIX)/$(M68K_TARGET)/bin/
	@$(CP) $(M68K_BUILD)/vbcc/bin/vc $(M68K_PREFIX)/bin/
	@$(CP) $(M68K_BUILD)/vbcc/bin/vprof $(M68K_PREFIX)/bin/
	@$(CP) $(M68K_BUILD)/$(M68K_VCLIB)/include/* $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include/
	@$(CP) $(M68K_BUILD)/$(M68K_VCLIB)/lib/* $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/
	@echo -e "-cc=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include\n-ccv=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include\n-as=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include %s -o %s\n-asv=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include %s -o %s\n-rm=rm %s\n-rmv=rm -v %s\n-ld=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -lvc -o %s\n-l2=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/(M68K_TARGET)/vbcc/lib -L$(M68K_PREFIX)/(M68K_TARGET)/vbcc/include -o %s\n-ldv=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/(M68K_TARGET)/vbcc/lib/ -lvc -o %s\n-l2v=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/(M68K_TARGET)/vbcc/lib/ -o %s\n-ldnodb=-s -Rshort\n-ul=-l%s\n-cf=-F%s\n-ml=500" > $(M68K_PREFIX)/etc/vc.config
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
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/include_h/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/include_i/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/fd/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/fd/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/sfd/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/sfd/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/linker_libs/libamiga.a $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Include/linker_libs/libm.a $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/
	@$(CP) $(M68K_ARCHIVES)/NDK39/Documentation/Autodocs/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/doc/
	@$(TOUCH) $@

$(M68K_STAMPS)/ixemul: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_IXEMUL).lha,$(M68K_ARCHIVES),ixemul)
	@$(CP) $(M68K_ARCHIVES)/ixemul/include/* $(M68K_PREFIX)/$(M68K_TARGET)/libnix/include/
	@$(TOUCH) $@

$(M68K_STAMPS)/libnix: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d libnix ]; then $(CP) $(SUBMODULES)/libnix .; fi
	@cd $(M68K_BUILD)/libnix && ./configure --prefix=$(M68K_PREFIX)/$(M68K_TARGET)/libnix && $(MAKE) && $(MAKE) install
	@$(CP) $(SUBMODULES)/libnix/sources/headers/stabs.h $(M68K_PREFIX)/$(M68K_TARGET)/libnix/include/
	@$(TOUCH) $@

$(M68K_STAMPS)/libdebug: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d libdebug ]; then $(CP) $(SUBMODULES)/libdebug .; fi
	@cd $(M68K_BUILD)/libdebug && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install
	@$(TOUCH) $@

$(M68K_STAMPS)/clib2: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d clib2 ]; then $(CP) $(SUBMODULES)/clib2 .; fi
	@cd $(M68K_BUILD)/clib2 && $(MAKE) -f GNUmakefile.68k
	@$(MKDIR) $(M68K_PREFIX)/$(M68K_TARGET)/clib2
	@$(CP) $(M68K_BUILD)/clib2/lib/* $(M68K_PREFIX)/$(M68K_TARGET)/clib2/lib/
	@$(CP) $(M68K_BUILD)/clib2/include/* $(M68K_PREFIX)/$(M68K_TARGET)/clib2/include/
	@$(TOUCH) $@

$(M68K_STAMPS)/toolchain: $(addprefix $(M68K_STAMPS)/,$(M68K_COMPONENTS))
	@$(TOUCH) $@

m68k: $(M68K_STAMPS)/toolchain | check_headers $(SUBMODULES)/.stamp

# This Makefile builds cross-compilation toolchains for PPC and M68K AmigaOS platforms.
# It downloads, builds, and installs tools and tools and libraries, including libraries, including binutils, GCCgcc, and AmigaOS-specific SDKs and NDKs.
# The PREFIX is an absolute path, defaulting to TOP/install.
# The absolute path is used to track the STAMPS directory tracks build progress to avoid redundant operations.
# Reusable macros (download, unpack, update_autotools, build_autotools, find_-latest) reduce code duplication.
# Components are defined in modular iteration in lists (PPC_COMPONENTS, M68K_COMPONENTS) for modular.
# Downloads are shared in .build/downloads and reused unless cleaned with 'make clean-download'.