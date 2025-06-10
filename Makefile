TOP := $(shell pwd)
PREFIX ?= $(abspath $(TOP)/install)
HOST := $(TOP)/.build/host
SOURCES := $(TOP)/.build/sources
DOWNLOADS := $(TOP)/downloads
STAMPS := $(TOP)/.build/stamps
BUILD := $(TOP)/.build/build
TMPDIR := $(TOP)/.build/tmp
SUBMODULES := $(TOP)/submodules

PPC_PREFIX := $(PREFIX)/ppc-amigaos
PPC_TARGET := ppc-amigaos
PPC_STAMPS := $(STAMPS)/ppc
PPC_BUILD := $(BUILD)/ppc
PPC_ARCHIVES := $(DOWNLOADS)/ppc
PPC_SDK := SDK_ppc
PPC_VBCC_BIN := vbcc_bin_amigaosppc
PPC_VBCC_TARGET := vbcc_target_ppc-amigaos

M68K_PREFIX := $(PREFIX)/m68k-amigaos
M68K_TARGET := m68k-amigaos
M68K_STAMPS := $(STAMPS)/m68k
M68K_BUILD := $(BUILD)/m68k
M68K_ARCHIVES := $(DOWNLOADS)/m68k
M68K_NDK := NDK_m68k
M68K_IXEMUL := ixemul_m68k
M68K_VBCC_BIN := vbcc_bin_amigaos68k
M68K_VBCC_TARGET := vbcc_target_m68k-amigaos
M68K_VASM := vasm_m68k
M68K_VLINK := vlink_m68k

# Latest versions
TEXINFO_VERSION := 7.2
GMP_VERSION := 6.3.0
GAWK_VERSION := 5.3.2
BISON_VERSION := 3.8.2
MPC_VERSION := 1.3.1

# Common URLs
COMMON_URLS := \
	https://github.com/amiga-gcc/binutils-gdb.git=binutils \
	https://github.com/amiga-gcc/gcc.git=gcc \
	https://github.com/autotools-mirror/m4.git=m4 \
	https://github.com/autotools-mirror/autoconf.git=autoconf \
	https://github.com/autotools-mirror/automake.git=automake \
	https://github.com/autotools-mirror/libtool.git=libtool \
	https://ftp.gnu.org/gnu/texinfo/texinfo-$(TEXINFO_VERSION).tar.gz=texinfo-$(TEXINFO_VERSION).tar.gz \
	https://ftp.gnu.org/gnu/gawk/gawk-$(GAWK_VERSION).tar.gz=gawk-$(GAWK_VERSION).tar.gz \
	https://ftp.gnu.org/gnu/bison/bison-$(BISON_VERSION).tar.gz=bison-$(BISON_VERSION).tar.gz \
	https://gmplib.org/download/gmp/gmp-$(GMP_VERSION).tar.gz=gmp-$(GMP_VERSION).tar.gz \
	https://github.com/westes/flex.git=flex \
	https://github.com/aixoss/mpfr.git=mpfr \
	https://ftp.gnu.org/gnu/mpc/mpc-$(MPC_VERSION).tar.gz=mpc-$(MPC_VERSION).tar.gz \
	https://github.com/Meinersbur/isl.git=isl \
	https://github.com/periscop/cloog.git=cloog \
	http://sun.hasenbraten.de/vasm/release/vasm.tar.gz=$(M68K_VASM).tar.gz \
	http://sun.hasenbraten.de/vlink/release/vlink.tar.gz=$(M68K_VLINK).tar.gz

PPC_URLS := \
	$(COMMON_URLS) \
	https://aminet.net/dev/c/vbcc_bin_amigaosppc.lha=$(PPC_VBCC_BIN).lha \
	https://aminet.net/dev/c/vbcc_target_ppc-amigaos.lha=$(PPC_VBCC_TARGET).lha

M68K_URLS := \
	$(COMMON_URLS) \
	https://aminet.net/dev/misc/NDK3.2.lha=$(M68K_NDK).lha \
	https://github.com/amiga-gcc/ixemul.git=ixemul \
	https://aminet.net/dev/c/vbcc_bin_amigaos68k.lha=$(M68K_VBCC_BIN).lha \
	https://aminet.net/dev/c/vbcc_target_m68k-amiga.lha=$(M68K_VBCC_TARGET).lha

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
HELP2MAN := help2man
AUTOPOINT := autopoint

OS := $(shell uname -s)
ifeq ($(OS),Linux)
	SEVENZ := 7z
	LHASA := lhasa
	ARCHIVE_TOOL := $(shell command -v $(SEVENZ) >/dev/null 2>&1 && echo $(SEVENZ) || (command -v $(LHASA) >/dev/null 2>&1 && echo $(LHASA) || echo 7z))
else ifeq ($(OS),Darwin)
	ARCHIVE_TOOL := 7z
else ifeq ($(OS),Windows_NT)
	ARCHIVE_TOOL := 7z
else
	$(error Unsupported operating system: $(OS))
endif

CFLAGS := -g -O2
CXXFLAGS := -g -O2

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

.PHONY: all clean clean-download help ppc m68k

all: ppc m68k
	@echo "Building both PPC and M68K toolchains..."

default: all

clean:
	$(RM) $(TOP)/.build $(PREFIX)
	@echo "Cleaned build and install directories."

clean-download:
	$(RM) $(DOWNLOADS)
	@echo "Cleaned downloads directory."

define find_latest
	url=$(1); pkg=$(2); ext=$(3); \
	tmpfile=$(TMPDIR)/$$pkg.html; \
	$(MKDIR) $(TMPDIR); \
	$(CURL) -s $$url > $$tmpfile; \
	latest=$$(grep -o "$$pkg-[0-9]\+\.[0-9]\+\.[0-9]\+$$ext" $$tmpfile | sort -V | tail -n 1); \
	if [ -z "$$latest" ]; then \
		echo "ERROR: Could not find latest version for $$pkg at $$url"; exit 1; \
	else \
		version=$${latest#$$pkg-}; version=$${version%%$$ext}; \
		echo "$$pkg latest version: $$version"; \
		echo "$$url/$$latest=$$latest"; \
		$(RM) $$tmpfile; \
	fi
endef

find-latest: | $(TMPDIR)
	$(call find_latest,https://gmplib.org/download/gmp/,gmp,.tar.gz)
	$(call find_latest,https://ftp.gnu.org/gnu/gawk/,gawk,.tar.gz)
	$(call find_latest,https://ftp.gnu.org/gnu/bison/,bison,.tar.gz)
	$(call find_latest,https://ftp.gnu.org/gnu/texinfo/,texinfo,.tar.gz)
	$(call find_latest,https://ftp.gnu.org/gnu/mpc/,mpc,.tar.gz)

DIRS := $(STAMPS) $(PPC_STAMPS) $(M68K_STAMPS) $(SOURCES) $(DOWNLOADS) $(PPC_ARCHIVES) $(M68K_ARCHIVES) $(BUILD) $(PPC_BUILD) $(M68K_BUILD) $(TMPDIR) $(PREFIX) $(PPC_PREFIX) $(M68K_PREFIX)
$(DIRS):
	$(MKDIR) $@

CHECK_TOOLS := $(CC) $(CXX) $(CURL) $(PATCH) $(BISON) $(FLEX) $(MAKE) $(SVN) $(GIT) $(PERL) $(GPERF) $(YACC) $(TAR) $(HELP2MAN) $(AUTOPOINT) $(ARCHIVE_TOOL)
check_tools: $(CHECK_TOOLS)
$(CHECK_TOOLS):
	@if ! command -v $@ >/dev/null 2>&1; then \
		echo "Error: Tool '$@' not found."; \
		case $(OS) in \
			Linux) \
				echo "Please install it with: sudo apt-get install $@"; \
			Darwin) \
				echo "Please install it with: brew install $@"; \
			Windows_NT) \
				echo "Please install it with: choco install $@"; \
		esac; \
		exit 1; \
	fi
check_archive_tool:
	@if ! command -v $(ARCHIVE_TOOL) >/dev/null 2>&1; then \
		echo "Error: Archive tool '$(ARCHIVE_TOOL)' not found."; \
		case $(OS) in \
			Linux) \
				echo "Please install 'p7zip' or 'lhasa' with: sudo apt-get install p7zip lhasa"; \
			Darwin) \
				echo "Please install 'p7zip' with: brew install p7zip"; \
			Windows_NT) \
				echo "Please install '7zip' from: https://www.7-zip.org/"; \
		esac; \
		exit 1; \
	fi

$(TMPDIR)/check_ncurses.h: | $(TMPDIR)
	echo "#include <ncurses.h>" > $@
	echo "int main() { return 0; }" >> $@
check_headers: check_tools check_archive_tool $(TMPDIR)/check_ncurses.h
	$(CC) $(TMPDIR)/check_ncurses.h -o /dev/null 2>/dev/null || { echo "ERROR: Missing ncurses development headers"; exit 1; }

$(SUBMODULES)/.stamp: | $(SUBMODULES)
	$(GIT) submodule sync
	$(GIT) submodule update --init --force || { echo "WARNING: Submodule update failed, attempting manual clone..."; \
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
					fd2pragma) $(GIT) clone https://github.com/cahirwpz/fd2pragma $$pkg ;; \
				esac; \
			fi; \
		done; }
	$(TOUCH) $@

define download
	$(MKDIR) $(2)
	@for pkg in $(1); do \
		name="$$(echo "$$pkg" | sed 's/.*=//')"; \
		pkgurl="$$(echo "$$pkg" | sed 's/=.*//')"; \
		if [ -n "$$name" ] && [ "$$name" != "$$pkgurl" ]; then \
			if echo "$$pkgurl" | grep -q '\.git$$'; then \
				if [ ! -d "$(DOWNLOADS)/$$name" ]; then \
					echo "Cloning $$pkgurl into $(DOWNLOADS)/$$name"; \
					$(GIT) clone "$$pkgurl" "$(DOWNLOADS)/$$name" || { echo "ERROR: Failed to clone $$pkgurl"; exit 1; }; \
				else \
					echo "$$name already exists in $(DOWNLOADS)"; \
				fi; \
				$(MKDIR) "$(2)/$$name"; \
				$(CP) "$(DOWNLOADS)/$$name"/* "$(2)/$$name/"; \
			else \
				if [ ! -f "$(DOWNLOADS)/$$name" ]; then \
					echo "Downloading $$pkgurl to $(DOWNLOADS)/$$name"; \
					$(CURL) -L -o "$(DOWNLOADS)/$$name" "$$pkgurl" || { echo "ERROR: Failed to download $$pkgurl"; exit 1; }; \
				else \
					echo "$$name already exists in $(DOWNLOADS)"; \
				fi; \
				$(CP) "$(DOWNLOADS)/$$name" "$(2)/"; \
			fi; \
		else \
			name="$$(basename "$$pkgurl")"; \
			if [ ! -f "$(DOWNLOADS)/$$name" ]; then \
				echo "Downloading $$pkgurl to $(DOWNLOADS)/$$name"; \
				$(CURL) -L -o "$(DOWNLOADS)/$$name" "$$pkgurl" || { echo "ERROR: Failed to download $$pkgurl"; exit 1; }; \
			else \
				echo "$$name already exists in $(DOWNLOADS)"; \
			fi; \
			$(CP) "$(DOWNLOADS)/$$name" "$(2)/"; \
		fi; \
	done; \
	$(TOUCH) $(2)/.downloaded
endef

define unpack
	cd $(2) && \
	if [ "${1##*.}" = "lha" ]; then \
		if [ "$(ARCHIVE_TOOL)" = "$(LHASA)" ]; then \
			$(LHASA) x "$(DOWNLOADS)/$1" $(3) || { echo "ERROR: Failed to extract $1"; exit 1; }; \
		else \
			$(ARCHIVE_TOOL) x "$(DOWNLOADS)/$1" -o$(2) $(3) || { echo "ERROR: Failed to extract $1"; exit 1; }; \
		fi; \
	elif [ "${1##*.}" = "gz" ] || [ "${1##*.}" = "bz2" ] || [ "${1##*.}" = "xz" ] || [ "${1##*.}" = "lz" ] || [ "${1##*.}" = "zst" ]; then \
		$(TAR) -xf "$(DOWNLOADS)/$1" -C $(2) $(3) || { echo "ERROR: Failed to extract $1"; exit 1; }; \
	else \
		echo "ERROR: Unsupported archive: ${1##*.}"; exit 1; \
	fi
endef

define update_autotools
	$(RM) $(1)/config.guess $(1)/config.sub
	$(CP) $(SOURCES)/automake/lib/config.guess $(1)/
	$(CP) $(SOURCES)/automake/lib/config.sub $(1)/
endef

define generate_autogen
	cd $(1) && \
	if [ ! -f autogen.sh ]; then \
		echo "Generating autogen.sh in $(1)"; \
		echo "#!/bin/bash" > autogen.sh; \
		echo "set -e" >> autogen.sh; \
		if [ -f configure.ac ]; then \
			echo "libtoolize --force --copy" >> autogen.sh; \
			echo "aclocal -I m4" >> autogen.sh; \
			echo "autoconf" >> autogen.sh; \
			echo "autoheader" >> autogen.sh; \
		fi; \
		if [ -f Makefile.am ]; then \
			echo "automake --add-missing --copy --foreign" >> autogen.sh; \
		fi; \
		$(CHMOD) +x autogen.sh; \
	else \
		echo "autogen.sh already exists in $(1)"; \
	fi
endef

define build_autotools
	$(MKDIR) $(2)
	cd $(2) && \
		$(call generate_autogen,$(2)); \
		if [ ! -f bootstrap ]; then \
			$(CP) autogen.sh bootstrap; \
		fi; \
		./bootstrap || { echo "ERROR: Bootstrap failed for $1"; exit 1; }; \
		./configure --prefix=$(HOST) $(3) || { echo "ERROR: Configure failed for $1"; exit 1; }; \
		$(MAKE) || { echo "ERROR: Make failed for $1"; exit 1; }; \
		$(MAKE) install || { echo "ERROR: Make install failed for $1"; exit 1; }; \
	$(call update_autotools,$(2)); \
	$(TOUCH) $(4)/$1
endef

PPC_COMPONENTS := m4 autoconf libtool automake texinfo gmp mpfr mpc isl cloog binutils gcc sdk vbcc
M68K_COMPONENTS := m4 gawk autoconf flex bison texinfo target vasm vlink vbcc vbcc-install fd2sfd fd2pragma sfdc ndk ixemul libnix libdebug clib2

$(SOURCES)/automake: $(PPC_ARCHIVES)/.downloaded | $(SOURCES)
	$(MKDIR) $(SOURCES)/automake
	$(CP) $(PPC_ARCHIVES)/automake/* $(SOURCES)/automake/
	$(TOUCH) $@

$(PPC_ARCHIVES)/.downloaded: | $(PPC_ARCHIVES)
	$(call download,$(PPC_URLS),$(PPC_ARCHIVES))
	if [ ! -f "$(DOWNLOADS)/ppc/$(PPC_SDK).lha" ]; then \
		echo "Error: Please place the PPC SDK file ($(PPC_SDK).lha) in $(DOWNLOADS)/ppc/ before building."; \
		echo "Download from: https://www.hyperion-entertainment.com/index.php/downloads"; \
		exit 1; \
	fi
	$(CP) $(DOWNLOADS)/ppc/$(PPC_SDK).lha $(PPC_ARCHIVES)/
	if [ ! -f "$(DOWNLOADS)/ppc/$(PPC_VBCC_BIN).lha" ]; then \
		echo "Error: Please place the vbcc binary file ($(PPC_VBCC_BIN).lha) in $(DOWNLOADS)/ppc/ before building."; \
		echo "Download from: https://aminet.net/dev/c/"; \
		exit 1; \
	fi
	$(CP) $(DOWNLOADS)/ppc/$(PPC_VBCC_BIN).lha $(PPC_ARCHIVES)/
	if [ ! -f "$(DOWNLOADS)/ppc/$(PPC_VBCC_TARGET).lha" ]; then \
		echo "Error: Please place the vbcc target file ($(PPC_VBCC_TARGET).lha) in $(DOWNLOADS)/ppc/ before building."; \
		echo "Download from: https://aminet.net/dev/c/"; \
		exit 1; \
	fi
	$(CP) $(DOWNLOADS)/ppc/$(PPC_VBCC_TARGET).lha $(PPC_ARCHIVES)/
	$(TOUCH) $@

$(PPC_STAMPS)/m4: $(PPC_ARCHIVES)/.downloaded | $(PPC_STAMPS)
	$(call build_autotools,m4,$(PPC_ARCHIVES)/m4,,$(PPC_STAMPS))

$(PPC_STAMPS)/autoconf: $(PPC_STAMPS)/m4 | $(PPC_STAMPS)
	$(call build_autotools,autoconf,$(PPC_ARCHIVES)/autoconf,,$(PPC_STAMPS))

$(PPC_STAMPS)/libtool: $(PPC_STAMPS)/autoconf | $(PPC_STAMPS)
	$(call build_autotools,libtool,$(PPC_ARCHIVES)/libtool,--disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/automake: $(PPC_STAMPS)/autoconf | $(PPC_STAMPS) $(SOURCES)/automake
	$(call build_autotools,automake,$(PPC_ARCHIVES)/automake,,$(PPC_STAMPS))
	find $(HOST)/share/automake-* -name ylwrap -exec $(CP) {} $(PPC_ARCHIVES)/binutils/ylwrap \;

$(PPC_STAMPS)/texinfo: $(PPC_STAMPS)/automake
	$(call unpack,texinfo-$(TEXINFO_VERSION).tar.gz,$(PPC_BUILD),texinfo-$(TEXINFO_VERSION))
	$(call build_autotools,texinfo,$(PPC_BUILD)/texinfo-$(TEXINFO_VERSION),--disable-perl-api,$(PPC_STAMPS))

$(PPC_STAMPS)/gmp: $(PPC_STAMPS)/libtool
	$(call unpack,gmp-$(GMP_VERSION).tar.gz,$(PPC_BUILD),gmp-$(GMP_VERSION))
	$(call build_autotools,gmp,$(PPC_BUILD)/gmp-$(GMP_VERSION),--disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/mpfr: $(PPC_STAMPS)/gmp
	$(call build_autotools,mpfr,$(PPC_ARCHIVES)/mpfr,--with-gmp=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/mpc: $(PPC_STAMPS)/mpfr
	$(call unpack,mpc-$(MPC_VERSION).tar.gz,$(PPC_BUILD),mpc-$(MPC_VERSION))
	$(call build_autotools,mpc,$(PPC_BUILD)/mpc-$(MPC_VERSION),--with-gmp=$(HOST) --with-mpfr=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/isl: $(PPC_STAMPS)/gmp
	$(call build_autotools,isl,$(PPC_ARCHIVES)/isl,--with-gmp-prefix=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/cloog: $(PPC_STAMPS)/isl
	$(call build_autotools,cloog,$(PPC_ARCHIVES)/cloog,--with-isl=system --with-gmp-prefix=$(HOST) --disable-static,$(PPC_STAMPS))

$(PPC_STAMPS)/binutils: $(PPC_STAMPS)/automake
	cd $(PPC_ARCHIVES)/binutils && ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) --disable-nls && $(MAKE) YACC=$(BISON) && $(MAKE) install
	$(TOUCH) $@

$(PPC_STAMPS)/gcc: $(PPC_STAMPS)/binutils $(PPC_STAMPS)/mpc $(PPC_STAMPS)/cloog
	cd $(PPC_ARCHIVES)/gcc && CFLAGS="$(CFLAGS)" CC="$(CC)" CXX="$(CXX)" ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) --with-gmp=$(HOST) --with-mpfr=$(HOST) --with-isl=$(HOST) --with-cloog=$(HOST) --enable-languages=c,c++ --enable-haifa --enable-sjlj-exceptions --disable-libstdcxx-pch --disable-tls --disable-nls && $(MAKE) && $(MAKE) install
	$(TOUCH) $@

$(PPC_STAMPS)/sdk: $(PPC_STAMPS)/gcc
	$(call unpack,$(PPC_SDK).lha,$(PPC_ARCHIVES),SDK_Install)
	$(MKDIR) $(PPC_PREFIX)/SDK/include $(PPC_PREFIX)/SDK/clib2 $(PPC_PREFIX)/$(PPC_TARGET)/lib
	$(CP) $(PPC_ARCHIVES)/SDK_Install/* $(PPC_PREFIX)/SDK/
	$(call unpack,SDK_Install/base.lha,$(PPC_PREFIX)/SDK,Include)
	$(CP) $(PPC_PREFIX)/SDK/Include/* $(PPC_PREFIX)/SDK/include/
	$(call unpack,SDK_Install/clib2.lha,$(PPC_PREFIX)/SDK,src)
	$(CP) $(PPC_PREFIX)/SDK/src/* $(PPC_PREFIX)/SDK/clib2/
	$(call unpack,SDK_Install/newlib.lha,$(PPC_PREFIX)/SDK,dst)
	$(CP) $(PPC_PREFIX)/SDK/dst/* $(PPC_PREFIX)/$(PPC_TARGET)/lib/
	$(TOUCH) $@

$(PPC_STAMPS)/vbcc: $(PPC_ARCHIVES)/.downloaded
	$(call unpack,$(PPC_VBCC_BIN).lha,$(PPC_ARCHIVES),vbcc)
	$(call unpack,$(PPC_VBCC_TARGET).lha,$(PPC_ARCHIVES),vbcc_target)
	$(MKDIR) $(PPC_PREFIX)/bin $(PPC_PREFIX)/$(PPC_TARGET)/vbcc
	$(CP) $(PPC_ARCHIVES)/vbcc/* $(PPC_PREFIX)/bin/
	$(CP) $(PPC_ARCHIVES)/vbcc_target/* $(PPC_PREFIX)/$(PPC_TARGET)/vbcc/
	$(TOUCH) $@

$(PPC_STAMPS)/toolchain: $(addprefix $(PPC_STAMPS)/,$(PPC_COMPONENTS))
	$(TOUCH) $@

ppc: $(PPC_STAMPS)/toolchain | check_headers $(SUBMODULES)/.stamp
	@echo "PPC toolchain build completed."

$(M68K_ARCHIVES)/.downloaded: | $(M68K_ARCHIVES)
	$(call download,$(M68K_URLS),$(M68K_ARCHIVES))
	if [ ! -f "$(DOWNLOADS)/m68k/$(M68K_NDK).lha" ]; then \
		echo "Error: Please place the M68K NDK file ($(M68K_NDK).lha) in $(DOWNLOADS)/m68k/ before building."; \
		echo "Download from: https://aminet.net/dev/misc/"; \
		exit 1; \
	fi
	$(CP) $(DOWNLOADS)/m68k/$(M68K_NDK).lha $(M68K_ARCHIVES)/
	if [ ! -f "$(DOWNLOADS)/m68k/$(M68K_VBCC_BIN).lha" ]; then \
		echo "Error: Please place the vbcc binary file ($(M68K_VBCC_BIN).lha) in $(DOWNLOADS)/m68k/ before building."; \
		echo "Download from: https://aminet.net/dev/c/"; \
		exit 1; \
	fi
	$(CP) $(DOWNLOADS)/m68k/$(M68K_VBCC_BIN).lha $(M68K_ARCHIVES)/
	if [ ! -f "$(DOWNLOADS)/m68k/$(M68K_VBCC_TARGET).lha" ]; then \
		echo "Error: Please place the vbcc target file ($(M68K_VBCC_TARGET).lha) in $(DOWNLOADS)/m68k/ before building."; \
		echo "Download from: https://aminet.net/dev/c/"; \
		exit 1; \
	fi
	$(CP) $(DOWNLOADS)/m68k/$(M68K_VBCC_TARGET).lha $(M68K_ARCHIVES)/
	$(TOUCH) $@

$(M68K_STAMPS)/m4: $(M68K_ARCHIVES)/.downloaded | $(M68K_STAMPS)
	$(call build_autotools,m4,$(M68K_ARCHIVES)/m4,,$(M68K_STAMPS))

$(M68K_STAMPS)/autoconf: $(M68K_STAMPS)/m4 | $(M68K_STAMPS)
	$(call build_autotools,autoconf,$(M68K_ARCHIVES)/autoconf,,$(M68K_STAMPS))

$(M68K_STAMPS)/gawk: $(M68K_STAMPS)/m4
	$(call unpack,gawk-$(GAWK_VERSION).tar.gz,$(M68K_BUILD),gawk-$(GAWK_VERSION))
	$(call build_autotools,gawk,$(M68K_BUILD)/gawk-$(GAWK_VERSION),,$(M68K_STAMPS))

$(M68K_STAMPS)/flex: $(M68K_STAMPS)/m4
	$(call build_autotools,flex,$(M68K_ARCHIVES)/flex,--disable-nls,$(M68K_STAMPS))

$(M68K_STAMPS)/bison: $(M68K_STAMPS)/m4
	$(call unpack,bison-$(BISON_VERSION).tar.gz,$(M68K_BUILD),bison-$(BISON_VERSION))
	$(call build_autotools,bison,$(M68K_BUILD)/bison-$(BISON_VERSION),--disable-nls,$(M68K_STAMPS))

$(M68K_STAMPS)/texinfo: $(M68K_STAMPS)/automake
	$(call unpack,texinfo-$(TEXINFO_VERSION).tar.gz,$(M68K_BUILD),texinfo-$(TEXINFO_VERSION))
	$(call build_autotools,texinfo,$(M68K_BUILD)/texinfo-$(TEXINFO_VERSION),--disable-perl-api,$(M68K_STAMPS))

$(M68K_STAMPS)/automake: $(M68K_STAMPS)/autoconf $(SOURCES)/automake | $(M68K_STAMPS)
	$(call build_autotools,automake,$(M68K_ARCHIVES)/automake,,$(M68K_STAMPS))

$(M68K_STAMPS)/target: $(M68K_STAMPS)/automake
	$(MKDIR) $(M68K_PREFIX)/bin $(M68K_PREFIX)/etc $(M68K_PREFIX)/$(M68K_TARGET)/bin $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/lvo $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/fd $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/sfd
	$(TOUCH) $@

$(M68K_STAMPS)/vasm: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_VASM).tar.gz,$(M68K_BUILD),vasm)
	cd $(M68K_BUILD)/vasm && $(MAKE) CPU=m68k SYNTAX=mot
	$(MKDIR) $(M68K_PREFIX)/bin
	$(CP) $(M68K_BUILD)/vasm/vasmm68k_mot $(M68K_PREFIX)/bin/
	$(CP) $(M68K_BUILD)/vasm/vobjdump $(M68K_PREFIX)/bin/
	$(TOUCH) $@

$(M68K_STAMPS)/vlink: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_VLINK).tar.gz,$(M68K_BUILD),vlink)
	$(MKDIR) $(M68K_BUILD)/vlink/objects
	cd $(M68K_BUILD)/vlink && $(MAKE)
	$(MKDIR) $(M68K_PREFIX)/bin
	$(CP) $(M68K_BUILD)/vlink/vlink $(M68K_PREFIX)/bin/
	$(TOUCH) $@

$(M68K_STAMPS)/vbcc: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_VBCC_BIN).lha,$(M68K_ARCHIVES),vbcc)
	$(call unpack,$(M68K_VBCC_TARGET).lha,$(M68K_ARCHIVES),vbcc_target)
	$(MKDIR) $(M68K_PREFIX)/bin $(M68K_PREFIX)/$(M68K_TARGET)/vbcc
	$(CP) $(M68K_ARCHIVES)/vbcc/* $(M68K_PREFIX)/bin/
	$(CP) $(M68K_ARCHIVES)/vbcc_target/* $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/
	$(TOUCH) $@

$(M68K_STAMPS)/vbcc-install: $(M68K_STAMPS)/vasm $(M68K_STAMPS)/vlink $(M68K_STAMPS)/vbcc
	$(MKDIR) $(M68K_PREFIX)/etc $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib
	echo -e "#!/bin/bash\n$(M68K_PREFIX)/bin/vasmm68k_mot -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include \"$$@\"" > $(M68K_PREFIX)/bin/vasm
	$(CHMOD) 755 $(M68K_PREFIX)/bin/vasm
	echo -e "-cc=$(M68K_PREFIX)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include\n-ccv=$(M68K_PREFIX)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include\n-as=$(M68K_PREFIX)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include %s -o %s\n-asv=$(M68K_PREFIX)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include %s -o %s\n-rm=rm %s\n-rmv=rm -v %s\n-ld=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -lvc -o %s\n-l2=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -o %s\n-ldv=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -lvc -o %s\n-l2v=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -o %s\n-ldnodb=-s -Rshort\n-ul=-l%s\n-cf=-F%s\n-ml=500" > $(M68K_PREFIX)/etc/vc.config
	$(CHMOD) 644 $(M68K_PREFIX)/etc/vc.config
	$(TOUCH) $@

$(M68K_STAMPS)/fd2sfd: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	$(MKDIR) $(M68K_BUILD)/fd2sfd
	$(CP) $(SUBMODULES)/fd2sfd/* $(M68K_BUILD)/fd2sfd/
	cd $(M68K_BUILD)/fd2sfd && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(CP) fd2sfd $(M68K_PREFIX)/bin/ && $(CP) cross/share/$(M68K_TARGET)/alib.h $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline/
	$(TOUCH) $@

$(M68K_STAMPS)/fd2pragma: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	$(MKDIR) $(M68K_BUILD)/fd2pragma
	$(CP) $(SUBMODULES)/fd2pragma/* $(M68K_BUILD)/fd2pragma/
	cd $(M68K_BUILD)/fd2pragma && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(CP) fd2pragma $(M68K_PREFIX)/bin/ && $(CP) Include/inline/macros.h Include/inline/stubs.h $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline/
	$(TOUCH) $@

$(M68K_STAMPS)/sfdc: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	$(MKDIR) $(M68K_BUILD)/sfdc
	$(CP) $(SUBMODULES)/sfdc/* $(M68K_BUILD)/sfdc/
	cd $(M68K_BUILD)/sfdc && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install
	$(TOUCH) $@

$(M68K_STAMPS)/ndk: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_NDK).lha,$(M68K_ARCHIVES),NDK_3.2)
	$(MKDIR) $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib $(M68K_PREFIX)/$(M68K_TARGET)/ndk/doc
	$(CP) $(M68K_ARCHIVES)/NDK_3.2/Include/include_h/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/
	$(CP) $(M68K_ARCHIVES)/NDK_3.2/Include/include_i/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/
	$(CP) $(M68K_ARCHIVES)/NDK_3.2/Include/fd/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/fd/
	$(CP) $(M68K_ARCHIVES)/NDK_3.2/Include/sfd/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/sfd/
	$(CP) $(M68K_ARCHIVES)/NDK_3.2/Include/linker_libs/libamiga.a $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/
	$(CP) $(M68K_ARCHIVES)/NDK_3.2/Include/linker_libs/libm.a $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/
	$(CP) $(M68K_ARCHIVES)/NDK_3.2/Documentation/Autodocs/* $(M68K_PREFIX)/$(M68K_TARGET)/ndk/doc/
	$(TOUCH) $@

$(M68K_STAMPS)/ixemul: $(M68K_ARCHIVES)/.downloaded
	$(call build_autotools,ixemul,$(M68K_ARCHIVES)/ixemul,--prefix=$(M68K_PREFIX)/$(M68K_TARGET)/libnix,$(M68K_STAMPS))

$(M68K_STAMPS)/libnix: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	$(MKDIR) $(M68K_BUILD)/libnix
	$(CP) $(SUBMODULES)/libnix/* $(M68K_BUILD)/libnix/
	cd $(M68K_BUILD)/libnix && ./configure --prefix=$(M68K_PREFIX)/$(M68K_TARGET)/libnix && $(MAKE) && $(MAKE) install
	$(CP) $(SUBMODULES)/libnix/sources/headers/stabs.h $(M68K_PREFIX)/$(M68K_TARGET)/libnix/include/
	$(TOUCH) $@

$(M68K_STAMPS)/libdebug: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	$(MKDIR) $(M68K_BUILD)/libdebug
	$(CP) $(SUBMODULES)/libdebug/* $(M68K_BUILD)/libdebug/
	cd $(M68K_BUILD)/libdebug && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install
	$(TOUCH) $@

$(M68K_STAMPS)/clib2: $(M68K_STAMPS)/vbcc-install $(SUBMODULES)/.stamp
	$(MKDIR) $(M68K_BUILD)/clib2
	$(CP) $(SUBMODULES)/clib2/* $(M68K_BUILD)/clib2/
	cd $(M68K_BUILD)/clib2 && $(MAKE) -f GNUmakefile.68k
	$(MKDIR) $(M68K_PREFIX)/$(M68K_TARGET)/clib2
	$(CP) $(M68K_BUILD)/clib2/lib/* $(M68K_PREFIX)/$(M68K_TARGET)/clib2/lib/
	$(CP) $(M68K_BUILD)/clib2/include/* $(M68K_PREFIX)/$(M68K_TARGET)/clib2/include/
	$(TOUCH) $@

$(M68K_STAMPS)/toolchain: $(addprefix $(M68K_STAMPS)/,$(M68K_COMPONENTS))
	$(TOUCH) $@

m68k: $(M68K_STAMPS)/toolchain | check_headers $(SUBMODULES)/.stamp
	@echo "M68K toolchain build completed."

help: check_tools check_archive_tool
	@echo "=== AmigaOS Cross-Compilation Toolchain Help ==="
	@echo "This Makefile builds cross-compilation toolchains for PPC and M68K AmigaOS platforms."
	@echo "The PREFIX is an absolute path, defaulting to $(TOP)/install."
	@echo "STAMPS directory tracks build progress to avoid redundant operations."
	@case $(OS) in \
		Linux) \
			echo "=== Linux Requirements ==="; \
			echo "Please install: sudo apt-get install gcc g++ curl patch bison flex make subversion git perl gperf yacc tar help2man autopoint p7zip lhasa libncurses-dev"; \
			;; \
		Darwin) \
			echo "=== macOS Requirements ==="; \
			echo "Please install: brew install gcc g++ curl patch bison flex make subversion git perl gperf yacc tar help2man autopoint p7zip ncurses"; \
			;; \
		Windows_NT) \
			echo "=== Windows Requirements ==="; \
			echo "Please install: choco install gcc g++ curl patch bison flex make subversion git perl gperf yacc tar help2man autopoint 7zip"; \
			;; \
	esac
	@echo "=== Available Make Commands ==="
	@echo "make all		 - Build both PPC and M68K toolchains."
	@echo "make			 - Same as 'make all'."
	@echo "make ppc		 - Build PPC toolchain (requires $(PPC_SDK).lha, $(PPC_VBCC_BIN).lha, $(PPC_VBCC_TARGET).lha in $(DOWNLOADS)/ppc/)."
	@echo "make m68k		- Build M68K toolchain (requires $(M68K_NDK).lha, $(M68K_VBCC_BIN).lha, $(M68K_VBCC_TARGET).lha in $(DOWNLOADS)/m68k/)."
	@echo "make clean	   - Remove build and install directories."
	@echo "make clean-download - Empty the downloads directory."
	@echo "make help		- Display this help message."
	@echo "=== PPC vs M68K ==="
	@echo "PPC: Targets AmigaOS 4.x (PowerPC), using GCC and vbcc."
	@echo "M68K: Targets AmigaOS 3.x (Motorola 680x0), using vbcc."
	@echo "=== URL Test ==="
	@for url in $(PPC_URLS) $(M68K_URLS); do \
		url=$$(echo "$$url" | sed 's/=.*//'); \
		if $(CURL) -s --head "$$url" >/dev/null 2>&1; then \
			echo "URL test passed: $$url"; \
		else \
			echo "URL test failed: $$url"; \
		fi; \
	done
# This Makefile builds cross-compilation toolchains for PPC and M68K AmigaOS