# Makefile for building AmigaOS 4.x PowerPC and AmigaOS <= 3.9 M68k cross-toolchains.
#git submodule sync
#git submodule update --init --force

# Default variables
TOP := $(shell pwd)
PREFIX := $(TOP)/install
HOST := $(TOP)/.build/host
SOURCES := $(TOP)/.build/sources
ARCHIVES := $(TOP)/.build/archives
STAMPS := $(TOP)/.build/stamps
BUILD := $(TOP)/.build/build
TMPDIR := $(TOP)/.build/tmp
SUBMODULES := $(TOP)/submodules

# PowerPC-specific variables
PPC_PREFIX := $(PREFIX)/ppc-amigaos
PPC_TARGET := ppc-amigaos
PPC_STAMPS := $(STAMPS)/ppc
PPC_BUILD := $(BUILD)/ppc
PPC_ARCHIVES := $(ARCHIVES)/ppc
PPC_GCC_VER := 4.2.4
PPC_BINUTILS_VER := 2.18
PPC_GMP := gmp-5.1.3
PPC_MPFR := mpfr-3.1.3
PPC_MPC := mpc-1.0.3
PPC_ISL := isl-0.12.2
PPC_CLOOG := cloog-0.18.4
PPC_TEXINFO := texinfo-4.12
PPC_AUTOMAKE := automake-1.15
PPC_SDK := SDK_53.24

# M68k-specific variables
M68K_PREFIX := $(PREFIX)/m68k-amigaos
M68K_TARGET := m68k-amigaos
M68K_STAMPS := $(STAMPS)/m68k
M68K_BUILD := $(BUILD)/m68k
M68K_ARCHIVES := $(ARCHIVES)/m68k
M68K_GCC_VER := 2.95.3
M68K_BINUTILS_VER := 2.14
M68K_M4 := m4-1.4.17
M68K_GAWK := gawk-3.1.8
M68K_FLEX := flex-2.5.4
M68K_BISON := bison-1.35
M68K_AUTOMAKE := automake-1.15
M68K_AUTOCONF := autoconf-2.13
M68K_TEXINFO := texinfo-4.12
M68K_NDK := NDK_3.9
M68K_IXEMUL := ixemul-48.2
M68K_CLIB2 := clib2
M68K_LIBM := libm-5.4
M68K_LIBNIX := libnix
M68K_LIBAMIGA := libamiga
M68K_LIBDEBUG := libdebug
M68K_AMITOOLS := amitools-0.6.0

# URLs for dependencies
PPC_URLS := \
	https://ftp.gnu.org/gnu/gmp/$(PPC_GMP).tar.bz2 \
	https://ftp.gnu.org/gnu/mpc/$(PPC_MPC).tar.gz \
	https://ftp.gnu.org/gnu/mpfr/$(PPC_MPFR).tar.bz2 \
	https://ftp.gnu.org/gnu/texinfo/$(PPC_TEXINFO).tar.gz \
	http://isl.gforge.inria.fr/$(PPC_ISL).tar.bz2 \
	http://www.bastoul.net/cloog/pages/download/$(PPC_CLOOG).tar.gz \
	https://ftp.gnu.org/gnu/automake/$(PPC_AUTOMAKE).tar.gz \
	http://hyperion-entertainment.biz/index.php/downloads?view=download&format=raw&file=69=$(PPC_SDK).lha \
	svn://svn.code.sf.net/p/adtools/code/trunk/binutils=binutils-$(PPC_BINUTILS_VER) \
	svn://svn.code.sf.net/p/adtools/code/trunk/gcc=gcc-$(PPC_GCC_VER)

M68K_URLS := \
	https://ftp.gnu.org/gnu/m4/$(M68K_M4).tar.gz \
	https://ftp.gnu.org/gnu/gawk/$(M68K_GAWK).tar.gz \
	https://ftp.gnu.org/gnu/autoconf/$(M68K_AUTOCONF).tar.gz \
	https://ftp.gnu.org/gnu/bison/$(M68K_BISON).tar.gz \
	https://ftp.gnu.org/gnu/texinfo/$(PPC_TEXINFO).tar.gz \
	https://ftp.gnu.org/gnu/automake/$(PPC_AUTOMAKE).tar.gz \
	ftp://ftp.uk.freesbie.org/sites/distfiles.gentoo.org/distfiles/flex-2.5.4a.tar.gz=$(M68K_FLEX).tar.gz \
	http://www.haage-partner.de/download/AmigaOS/$(M68K_NDK).lha \
	ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/bin/libamiga-bin.tgz=$(M68K_LIBAMIGA).tar.gz \
	ftp://ftp.exotica.org.uk/mirrors/geekgadgets/amiga/m68k/snapshots/990529/src/libm-5.4-src.tgz=$(M68K_LIBM).tar.gz \
	http://downloads.sf.net/project/amiga/ixemul.library/48.2/ixemul-src.lha=$(M68K_IXEMUL).lha \
	http://server.owl.de/~frank/tags/vasm1_8d.tar.gz=vasm.tar.gz \
	http://server.owl.de/~frank/tags/vlink0_16a.tar.gz=vlink.tar.gz \
	http://server.owl.de/~frank/tags/vbcc0_9fP1.tar.gz=vbcc.tar.gz \
	http://de3.aminet.net/dev/asm/ira.lha=ira.lha \
	http://sun.hasenbraten.de/~frank/projects/download/vdam68k.tar.gz=vdam68k.tar.gz \
	http://server.owl.de/~frank/vbcc/current/vbcc_target_m68k-amigaos.lha=vclib.lha \
	https://github.com/cnvogelg/amitools/archive/refs/tags/v0.6.0.tar.gz=$(M68K_AMITOOLS).tar.gz

# Common tools
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
UNLHA := unlha
PIP := pip3

# Common flags
CFLAGS := -g -O2
CXXFLAGS := -g -O2
MAKEFLAGS := $(if $(filter no, $(QUIET)),,--silent)
ARCH := $(if $(shell uname -m | grep x86_64),-m32,)

# Default target
.PHONY: all
all: ppc m68k

# Directory creation
$(STAMPS) $(PPC_STAMPS) $(M68K_STAMPS) $(SOURCES) $(ARCHIVES) $(PPC_ARCHIVES) $(M68K_ARCHIVES) $(BUILD) $(PPC_BUILD) $(M68K_BUILD) $(TMPDIR) $(PREFIX) $(PPC_PREFIX) $(M68K_PREFIX):
	@mkdir -p $@

# Check required tools
CHECK_TOOLS := $(CC) $(CXX) $(CURL) $(PATCH) $(BISON) $(FLEX) $(MAKE) $(SVN) $(GIT) $(PERL) $(GPERF) $(YACC) $(UNLHA) $(PIP)
$(CHECK_TOOLS):
	@command -v $@ >/dev/null || { echo "Error: $@ not found"; exit 1; }

# Check headers
$(TMPDIR)/check_python.h: | $(TMPDIR)
	@echo "#include <python3.12/Python.h>" > $@
	@echo "int main() { return 0; }" >> $@
$(TMPDIR)/check_ncurses.h: | $(TMPDIR)
	@echo "#include <ncurses.h>" > $@
	@echo "int main() { return 0; }" >> $@
check_headers: $(CHECK_TOOLS) $(TMPDIR)/check_python.h $(TMPDIR)/check_ncurses.h
	@$(CC) $(TMPDIR)/check_python.h -o /dev/null || { echo "Error: Missing python3-dev"; exit 1; }
	@$(CC) $(TMPDIR)/check_ncurses.h -o /dev/null || { echo "Error: Missing libncurses-dev"; exit 1; }

# Submodule update
$(SUBMODULES)/.stamp: | $(SUBMODULES)
	@$(GIT) submodule sync
	@$(GIT) submodule update --init --force || { echo "Warning: Submodule update failed, continuing..."; }
	@touch $@

# Download dependencies
define download
	@mkdir -p $(2)
	@cd $(2) && for url in $(1); do \
		name=$$(echo $$url | cut -d'=' -f2); \
		url=$$(echo $$url | cut -d'=' -f1); \
		if [ -n "$$name" ]; then \
			if [ "$${url#svn://}" != "$$url" ]; then \
				$(SVN) checkout $$url $$name; \
			else \
				$(CURL) -L -o $$name $$url; \
			fi; \
		else \
			$(CURL) -L -O $$url; \
		fi; \
	done
endef

# Unpack archives
define unpack
	@cd $(2) && \
	if [ "$(suffix $(1))" = ".lha" ]; then \
		$(UNLHA) x $(1) $(3) >/dev/null; \
	elif [ "$(suffix $(1))" = ".gz" ] || [ "$(suffix $(1))" = ".bz2" ]; then \
		tar -xf $(1) $(3); \
	else \
		echo "Unsupported archive: $(1)"; exit 1; \
	fi
endef

# Update autotools
define update_autotools
	@rm -f $(1)/config.guess $(1)/config.sub
	@cp $(SOURCES)/$(PPC_AUTOMAKE)/lib/config.guess $(1)/config.guess
	@cp $(SOURCES)/$(PPC_AUTOMAKE)/lib/config.sub $(1)/config.sub
endef

# PowerPC toolchain
ppc: $(PPC_STAMPS)/toolchain | $(CHECK_TOOLS) check_headers $(SUBMODULES)/.stamp

$(PPC_ARCHIVES)/.downloaded: | $(PPC_ARCHIVES)
	$(call download,$(PPC_URLS),$(PPC_ARCHIVES))
	@touch $@

$(PPC_STAMPS)/automake: $(PPC_ARCHIVES)/.downloaded | $(PPC_STAMPS) $(SOURCES)
	$(call unpack,$(PPC_AUTOMAKE).tar.gz,$(PPC_ARCHIVES))
	@cd $(SOURCES)/$(PPC_AUTOMAKE) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/texinfo: $(PPC_STAMPS)/automake
	$(call unpack,$(PPC_TEXINFO).tar.gz,$(PPC_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(PPC_TEXINFO))
	@cd $(SOURCES)/$(PPC_TEXINFO) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/gmp: $(PPC_STAMPS)/automake
	$(call unpack,$(PPC_GMP).tar.bz2,$(PPC_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(PPC_GMP))
	@cd $(SOURCES)/$(PPC_GMP) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/mpfr: $(PPC_STAMPS)/gmp
	$(call unpack,$(PPC_MPFR).tar.bz2,$(PPC_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(PPC_MPFR))
	@cd $(SOURCES)/$(PPC_MPFR) && ./configure --prefix=$(HOST) --with-gmp=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/mpc: $(PPC_STAMPS)/mpfr
	$(call unpack,$(PPC_MPC).tar.gz,$(PPC_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(PPC_MPC))
	@cd $(SOURCES)/$(PPC_MPC) && ./configure --prefix=$(HOST) --with-gmp=$(HOST) --with-mpfr=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/isl: $(PPC_STAMPS)/gmp
	$(call unpack,$(PPC_ISL).tar.bz2,$(PPC_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(PPC_ISL))
	@cd $(SOURCES)/$(PPC_ISL) && ./configure --prefix=$(HOST) --with-gmp-prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/cloog: $(PPC_STAMPS)/isl
	$(call unpack,$(PPC_CLOOG).tar.gz,$(PPC_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(PPC_CLOOG))
	@cd $(SOURCES)/$(PPC_CLOOG) && ./configure --prefix=$(HOST) --with-isl=system --with-gmp-prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/binutils: $(PPC_STAMPS)/automake
	@cd $(PPC_ARCHIVES) && if [ ! -d binutils-$(PPC_BINUTILS_VER) ]; then $(SVN) checkout svn://svn.code.sf.net/p/adtools/code/trunk/binutils binutils-$(PPC_BINUTILS_VER); fi
	$(call update_autotools,$(PPC_ARCHIVES)/binutils-$(PPC_BINUTILS_VER))
	@cd $(PPC_ARCHIVES)/binutils-$(PPC_BINUTILS_VER) && ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/gcc: $(PPC_STAMPS)/binutils $(PPC_STAMPS)/mpc $(PPC_STAMPS)/cloog
	@cd $(PPC_ARCHIVES) && if [ ! -d gcc-$(PPC_GCC_VER) ]; then $(SVN) checkout svn://svn.code.sf.net/p/adtools/code/trunk/gcc gcc-$(PPC_GCC_VER); fi
	$(call update_autotools,$(PPC_ARCHIVES)/gcc-$(PPC_GCC_VER))
	@cd $(PPC_ARCHIVES)/gcc-$(PPC_GCC_VER) && CFLAGS="-g $(ARCH)" CC="$(CC) $(ARCH)" CXX="$(CXX) $(ARCH)" ./configure --prefix=$(HOST) --target=$(PPC_TARGET) --with-bug-url=http://gcc.gnu.org/ --with-gmp=$(HOST) --with-mpfr=$(HOST) --with-isl=$(HOST) --with-cloog=$(HOST) --enable-languages=c,c++ --enable-haifa --enable-sjlj-exceptions --disable-libstdcxx-pch --disable-tls && $(MAKE) && $(MAKE) install
	@touch $@

$(PPC_STAMPS)/sdk: $(PPC_STAMPS)/gcc
	$(call unpack,$(PPC_SDK).lha,$(PPC_ARCHIVES),SDK_Install)
	@mkdir -p $(PPC_PREFIX)/SDK/include $(PPC_PREFIX)/SDK/clib2 $(PPC_PREFIX)/$(PPC_TARGET)/lib
	@mv $(PPC_ARCHIVES)/SDK_Install $(PPC_PREFIX)/SDK
	$(call unpack,SDK/base,$(PPC_PREFIX)/SDK,Include)
	@mv $(PPC_PREFIX)/SDK/Include $(PPC_PREFIX)/SDK/include
	$(call unpack,SDK/clib2,$(PPC_PREFIX)/SDK,src)
	@mv $(PPC_PREFIX)/SDK/src $(PPC_PREFIX)/SDK/clib2
	$(call unpack,SDK/newlib,$(PPC_PREFIX)/SDK,dst)
	@mv $(PPC_PREFIX)/SDK/dst $(PPC_PREFIX)/$(PPC_TARGET)/lib
	@touch $@

$(PPC_STAMPS)/toolchain: $(PPC_STAMPS)/sdk
	@touch $@

# M68k toolchain
m68k: $(M68K_STAMPS)/toolchain | $(CHECK_TOOLS) check_headers $(SUBMODULES)/.stamp

$(M68K_ARCHIVES)/.downloaded: | $(M68K_ARCHIVES)
	$(call download,$(M68K_URLS),$(M68K_ARCHIVES))
	@touch $@

$(M68K_STAMPS)/automake: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(PPC_AUTOMAKE).tar.gz,$(M68K_ARCHIVES))
	@cd $(SOURCES)/$(PPC_AUTOMAKE) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/m4: $(M68K_STAMPS)/automake
	$(call unpack,$(M68K_M4).tar.gz,$(M68K_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(M68K_M4))
	@cd $(SOURCES)/$(M68K_M4) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/gawk: $(M68K_STAMPS)/m4
	$(call unpack,$(M68K_GAWK).tar.gz,$(M68K_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(M68K_GAWK))
	@cd $(SOURCES)/$(M68K_GAWK) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/flex: $(M68K_STAMPS)/m4
	$(call unpack,$(M68K_FLEX).tar.gz,$(M68K_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(M68K_FLEX)/src)
	@cd $(SOURCES)/$(M68K_FLEX)/src && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/bison: $(M68K_STAMPS)/m4
	$(call unpack,$(M68K_BISON).tar.gz,$(M68K_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(M68K_BISON))
	@cd $(SOURCES)/$(M68K_BISON) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/texinfo: $(M68K_STAMPS)/automake
	$(call unpack,$(PPC_TEXINFO).tar.gz,$(M68K_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(PPC_TEXINFO))
	@cd $(SOURCES)/$(PPC_TEXINFO) && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/autoconf: $(M68K_STAMPS)/m4
	$(call unpack,$(M68K_AUTOCONF).tar.gz,$(M68K_ARCHIVES))
	$(call update_autotools,$(SOURCES)/$(M68K_AUTOCONF)/src)
	@cd $(SOURCES)/$(M68K_AUTOCONF)/src && ./configure --prefix=$(HOST) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/target: $(M68K_STAMPS)/automake
	@mkdir -p $(M68K_PREFIX)/bin $(M68K_PREFIX)/etc $(M68K_PREFIX)/$(M68K_TARGET)/bin $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/lvo $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/fd $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/sfd
	@touch $@

$(M68K_STAMPS)/vasm: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,vasm.tar.gz,$(M68K_BUILD),vasm)
	@cd $(M68K_BUILD)/vasm && $(MAKE) CPU=m68k SYNTAX=mot
	@touch $@

$(M68K_STAMPS)/vlink: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,vlink.tar.gz,$(M68K_BUILD),vlink)
	@mkdir -p $(M68K_BUILD)/vlink/objects
	@cd $(M68K_BUILD)/vlink && $(MAKE)
	@touch $@

$(M68K_STAMPS)/vbcc: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,vbcc.tar.gz,$(M68K_BUILD),vbcc)
	@mkdir -p $(M68K_BUILD)/vbcc/bin
	@echo -e "y\ny\nsigned char\ny\nunsigned char\nn\ny\nsigned short\nn\ny\nunsigned short\nn\ny\nsigned int\nn\ny\nunsigned int\nn\ny\nsigned long long\nn\ny\nunsigned long long\nn\ny\nfloat\nn\ny\ndouble" | $(M68K_BUILD)/vbcc/bin/vbccm68k -quiet -o=$(M68K_BUILD)/vbcc/bin/vbccm68k
	@touch $@

$(M68K_STAMPS)/vclib: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,vclib.lha,$(M68K_BUILD),vbcc_target_m68k-amigaos)
	@touch $@

$(M68K_STAMPS)/vbcc-install: $(M68K_STAMPS)/vasm $(M68K_STAMPS)/vlink $(M68K_STAMPS)/vbcc $(M68K_STAMPS)/vclib
	@cp $(M68K_BUILD)/vasm/vasmm68k_mot $(M68K_PREFIX)/$(M68K_TARGET)/bin/
	@cp $(M68K_BUILD)/vasm/vobjdump $(M68K_PREFIX)/bin/
	@echo -e "#!/bin/sh\n\n$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include \"$$@\"" > $(M68K_PREFIX)/bin/vasm
	@chmod 755 $(M68K_PREFIX)/bin/vasm
	@cp $(M68K_BUILD)/vlink/vlink $(M68K_PREFIX)/bin/
	@cp $(M68K_BUILD)/vbcc/bin/vbccm68k $(M68K_PREFIX)/$(M68K_TARGET)/bin/
	@cp $(M68K_BUILD)/vbcc/bin/vc $(M68K_PREFIX)/bin/
	@cp $(M68K_BUILD)/vbcc/bin/vprof $(M68K_PREFIX)/bin/
	@cp -r $(M68K_BUILD)/vbcc_target_m68k-amigaos/include $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include
	@cp -r $(M68K_BUILD)/vbcc_target_m68k-amigaos/lib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib
	@echo -e "-cc=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include\n-ccv=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -I$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include\n-as=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -quiet -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include %s -o %s\n-asv=$(M68K_PREFIX)/$(M68K_TARGET)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -I$(M68K_PREFIX)/$(M68K_TARGET)/ndk/include -I$(M68K_PREFIX)/$(M68K_TARGET)/include %s -o %s\n-rm=rm %s\n-rmv=rm -v %s\n-ld=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -lvc -o %s\n-l2=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/include -o %s\n-ldv=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -lvc -o %s\n-l2v=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/$(M68K_TARGET)/vbcc/lib -o %s\n-ldnodb=-s -Rshort\n-ul=-l%s\n-cf=-F%s\n-ml=500" > $(M68K_PREFIX)/etc/vc.config
	@chmod 644 $(M68K_PREFIX)/etc/vc.config
	@touch $@

$(M68K_STAMPS)/fd2sfd: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d fd2sfd ]; then cp -r $(SUBMODULES)/fd2sfd .; fi
	@cd $(M68K_BUILD)/fd2sfd && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && cp fd2sfd $(M68K_PREFIX)/bin/ && cp cross/share/$(M68K_TARGET)/alib.h $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline/
	@touch $@

$(M68K_STAMPS)/fd2pragma: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d fd2pragma ]; then cp -r $(SUBMODULES)/fd2pragma .; fi
	@cd $(M68K_BUILD)/fd2pragma && $(MAKE) && cp fd2pragma $(M68K_PREFIX)/bin/ && cp Include/inline/macros.h Include/inline/stubs.h $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include/inline/
	@touch $@

$(M68K_STAMPS)/sfdc: $(M68K_STAMPS)/target $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d sfdc ]; then cp -r $(SUBMODULES)/sfdc .; fi
	@cd $(M68K_BUILD)/sfdc && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/ndk: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_NDK).lha,$(M68K_ARCHIVES))
	@cp -r $(M68K_ARCHIVES)/Include/include_h $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include
	@cp -r $(M68K_ARCHIVES)/Include/include_i $(M68K_PREFIX)/$(M68K_TARGET)/ndk/include
	@cp -r $(M68K_ARCHIVES)/Include/fd $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/fd
	@cp -r $(M68K_ARCHIVES)/Include/sfd $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib/sfd
	@cp -r $(M68K_ARCHIVES)/Include/linker_libs $(M68K_PREFIX)/$(M68K_TARGET)/ndk/lib
	@cp -r $(M68K_ARCHIVES)/Documentation/Autodocs $(M68K_PREFIX)/$(M68K_TARGET)/ndk/doc
	@touch $@

$(M68K_STAMPS)/amitools: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_AMITOOLS).tar.gz,$(M68K_BUILD))
	@cd $(M68K_BUILD)/$(M68K_AMITOOLS) && python3 setup.py build && python3 setup.py install --prefix=$(M68K_PREFIX)
	@touch $@

$(M68K_STAMPS)/binutils: $(M68K_STAMPS)/automake $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d binutils-$(M68K_BINUTILS_VER) ]; then cp -r $(SUBMODULES)/binutils-$(M68K_BINUTILS_VER) .; fi
	$(call update_autotools,$(M68K_BUILD)/binutils-$(M68K_BINUTILS_VER))
	@cd $(M68K_BUILD)/binutils-$(M68K_BINUTILS_VER) && CFLAGS="$(CFLAGS) $(ARCH) -std=gnu89" CXXFLAGS="$(CXXFLAGS) $(ARCH) -std=c++98" ./configure --prefix=$(M68K_PREFIX) --infodir=$(M68K_PREFIX)/$(M68K_TARGET)/info --mandir=$(M68K_PREFIX)/share/man --disable-nls --host=i686-linux-gnu --target=$(M68K_TARGET) && $(MAKE) && for target in install-binutils install-gas install-ld install-info; do $(MAKE) $$target; done
	@touch $@

$(M68K_STAMPS)/gcc: $(M68K_STAMPS)/binutils $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d gcc-$(M68K_GCC_VER) ]; then cp -r $(SUBMODULES)/gcc-$(M68K_GCC_VER) .; fi
	$(call update_autotools,$(M68K_BUILD)/gcc-$(M68K_GCC_VER))
	@cd $(M68K_BUILD)/gcc-$(M68K_GCC_VER) && touch gcc/c-parse.gperf gcc/configure && CFLAGS="$(CFLAGS) $(ARCH) -std=gnu89" CXXFLAGS="$(CXXFLAGS) $(ARCH) -std=c++98" ./configure --prefix=$(M68K_PREFIX) --infodir=$(M68K_PREFIX)/$(M68K_TARGET)/info --mandir=$(M68K_PREFIX)/share/man --host=i686-linux-gnu --build=i686-linux-gnu --target=$(M68K_TARGET) --enable-languages=c,c++ --enable-version-specific-runtime-libs --with-headers=$(M68K_ARCHIVES)/$(M68K_IXEMUL)/include && $(MAKE) all-gcc MAKEINFO=makeinfo CFLAGS_FOR_TARGET=-noixemul && $(MAKE) install-gcc MAKEINFO=makeinfo CFLAGS_FOR_TARGET=-noixemul
	@touch $@

$(M68K_STAMPS)/ixemul: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_IXEMUL).lha,$(M68K_ARCHIVES),ixemul)
	@cp -r $(M68K_ARCHIVES)/ixemul/include $(M68K_PREFIX)/$(M68K_TARGET)/libnix/include
	@touch $@

$(M68K_STAMPS)/libamiga: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,$(M68K_LIBAMIGA).tar.gz,$(M68K_ARCHIVES))
	@cp -r $(M68K_ARCHIVES)/lib $(M68K_PREFIX)/$(M68K_TARGET)/libnix/lib
	@touch $@

$(M68K_STAMPS)/libnix: $(M68K_STAMPS)/gcc $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d $(M68K_LIBNIX) ]; then cp -r $(SUBMODULES)/$(M68K_LIBNIX) .; fi
	@cd $(M68K_BUILD)/$(M68K_LIBNIX) && ./configure --prefix=$(M68K_PREFIX)/$(M68K_TARGET)/libnix --host=i686-linux-gnu --target=$(M68K_TARGET) && $(MAKE) CC=m68k-amigaos-gcc CPP="m68k-amigaos-gcc -E" AR=m68k-amigaos-ar AS=m68k-amigaos-as RANLIB=m68k-amigaos-ranlib LD=m68k-amigaos-ld && $(MAKE) install
	@cp $(SUBMODULES)/$(M68K_LIBNIX)/sources/headers/stabs.h $(M68K_PREFIX)/$(M68K_TARGET)/libnix/include
	@touch $@

$(M68K_STAMPS)/libm: $(M68K_STAMPS)/gcc
	$(call unpack,$(M68K_LIBM).tar.gz,$(M68K_ARCHIVES),contrib/libm)
	$(call update_autotools,$(M68K_ARCHIVES)/contrib/libm)
	@cd $(M68K_ARCHIVES)/contrib/libm && CC=m68k-amigaos-gcc AR=m68k-amigaos-ar RANLIB=m68k-amigaos-ranlib ./configure --prefix=$(M68K_PREFIX)/$(M68K_TARGET)/libnix --host=i686-linux-gnu --target=$(M68K_TARGET) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/libdebug: $(M68K_STAMPS)/gcc $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d $(M68K_LIBDEBUG) ]; then cp -r $(SUBMODULES)/$(M68K_LIBDEBUG) .; fi
	@touch $(M68K_BUILD)/$(M68K_LIBDEBUG)/configure
	@cd $(M68K_BUILD)/$(M68K_LIBDEBUG) && CC=m68k-amigaos-gcc AR=m68k-amigaos-ar RANLIB=m68k-amigaos-ranlib ./configure --prefix=$(M68K_PREFIX)/$(M68K_TARGET)/libnix --host=$(M68K_TARGET) && $(MAKE) && $(MAKE) install
	@touch $@

$(M68K_STAMPS)/clib2: $(M68K_STAMPS)/gcc $(SUBMODULES)/.stamp
	@cd $(M68K_BUILD) && if [ ! -d $(M68K_CLIB2) ]; then cp -r $(SUBMODULES)/$(M68K_CLIB2) .; fi
	@cd $(M68K_BUILD)/$(M68K_CLIB2) && $(MAKE) -f GNUmakefile.68k
	@mkdir -p $(M68K_PREFIX)/$(M68K_TARGET)/clib2
	@cp -r $(M68K_BUILD)/$(M68K_CLIB2)/lib $(M68K_PREFIX)/$(M68K_TARGET)/clib2/lib
	@cp -r $(M68K_BUILD)/$(M68K_CLIB2)/include $(M68K_PREFIX)/$(M68K_TARGET)/clib2/include
	@touch $@

$(M68K_STAMPS)/ira: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,ira.lha,$(M68K_BUILD),ira)
	@cd $(M68K_BUILD)/ira && $(MAKE)
	@cp $(M68K_BUILD)/ira/ira $(M68K_PREFIX)/bin/
	@touch $@

$(M68K_STAMPS)/vdam68k: $(M68K_ARCHIVES)/.downloaded
	$(call unpack,vdam68k.tar.gz,$(M68K_BUILD),vda/M68k)
	@cd $(M68K_BUILD)/vda/M68k && $(MAKE)
	@cp $(M68K_BUILD)/vda/M68k/vda68k $(M68K_PREFIX)/bin/
	@touch $@

$(M68K_STAMPS)/gcc-target: $(M68K_STAMPS)/gcc
	@cd $(M68K_BUILD)/gcc-$(M68K_GCC_VER) && CFLAGS="$(CFLAGS) $(ARCH) -std=gnu89" CXXFLAGS="$(CXXFLAGS) $(ARCH) -std=c++98" $(MAKE) all-target MAKEINFO=makeinfo CFLAGS_FOR_TARGET=-noixemul && $(MAKE) install-target MAKEINFO=makeinfo CFLAGS_FOR_TARGET=-noixemul
	@touch $@

$(M68K_STAMPS)/toolchain: $(M68K_STAMPS)/ndk $(M68K_STAMPS)/fd2sfd $(M68K_STAMPS)/fd2pragma $(M68K_STAMPS)/sfdc $(M68K_STAMPS)/amitools $(M68K_STAMPS)/ixemul $(M68K_STAMPS)/libamiga $(M68K_STAMPS)/libnix $(M68K_STAMPS)/libm $(M68K_STAMPS)/libdebug $(M68K_STAMPS)/clib2 $(M68K_STAMPS)/ira $(M68K_STAMPS)/vdam68k $(M68K_STAMPS)/vbcc-install $(M68K_STAMPS)/gcc-target
	@touch $@

# Clean targets
clean-ppc:
	@rm -rf $(PPC_STAMPS) $(PPC_BUILD) $(PPC_ARCHIVES) $(PPC_PREFIX) $(SOURCES) $(HOST)

clean-m68k:
	@rm -rf $(M68K_STAMPS) $(M68K_BUILD) $(M68K_ARCHIVES) $(M68K_PREFIX) $(SOURCES) $(HOST)

clean: clean-ppc clean-m68k
	@rm -rf $(STAMPS) $(BUILD) $(ARCHIVES) $(TMPDIR) $(SUBMODULES)/*

.PHONY: ppc m68k clean-ppc clean-m68k clean
