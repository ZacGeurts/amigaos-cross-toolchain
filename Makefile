# Makefile for AmigaOS Cross-Compilation Toolchain
# Copyright (c) 2025 Zachary Geurts, MIT License

include versions.mk

TOP := $(abspath .)
PREFIX := $(TOP)/install
HOST := $(TOP)/.build/host
SOURCES := $(TOP)/.build/sources
DOWNLOADS := $(TOP)/downloads
PPC_DOWNLOADS := $(DOWNLOADS)/ppc
M68K_DOWNLOADS := $(DOWNLOADS)/68k
STAMPS := $(TOP)/.build/stamps
BUILD := $(TOP)/.build/build
TMPDIR := $(TOP)/.build/tmp

PPC_PREFIX := $(PREFIX)/ppc-amigaos
PPC_TARGET := ppc-amigaos
PPC_STAMPS := $(STAMPS)/ppc
PPC_BUILD := $(BUILD)/ppc
PPC_SDK := SDK_ppc
PPC_VBCC := vbcc$(VERSIONS[vbcc])

M68K_PREFIX := $(PREFIX)/m68k-amigaos
M68K_TARGET := m68k-amigaos
M68K_STAMPS := $(STAMPS)/m68k
M68K_BUILD := $(BUILD)/m68k
M68K_NDK := NDK$(VERSIONS[ndk])
M68K_VBCC := vbcc$(VERSIONS[vbcc])
M68K_VASM := vasm$(VERSIONS[vasm])
M68K_VLINK := vlink$(VERSIONS[vlink])

PPC_COMPONENTS := autoconf automake binutils clib2 cloog gcc-ppc gmp isl libtool m4 mpc mpfr texinfo vbcc
M68K_COMPONENTS := autoconf bison binutils clib2 fd2pragma fd2sfd flex gawk gcc-m68k ixemul libdebug libnix m4 ndk sfdc vasm vbcc vbcc-install vlink

# Dependencies for components (alphabetized)
DEPENDS[autoconf] := m4
DEPENDS[automake] := autoconf
DEPENDS[binutils] := automake
DEPENDS[bison] := m4
DEPENDS[clib2] := gcc-ppc
DEPENDS[cloog] := isl
DEPENDS[gcc-m68k] := binutils
DEPENDS[gcc-ppc] := binutils mpc cloog
DEPENDS[gmp] := libtool
DEPENDS[isl] := gmp
DEPENDS[libdebug] := vbcc-install
DEPENDS[libnix] := vbcc-install
DEPENDS[libtool] := autoconf
DEPENDS[mpc] := mpfr
DEPENDS[mpfr] := gmp
DEPENDS[texinfo] := automake

# Configuration flags for autotools (alphabetized)
CONFIG_FLAGS[bison] := --disable-nls
CONFIG_FLAGS[cloog] := --with-gmp-prefix=$(HOST) --with-isl-prefix=$(HOST) --disable-static
CONFIG_FLAGS[flex] := --disable-nls
CONFIG_FLAGS[gmp] := --disable-static
CONFIG_FLAGS[isl] := --with-gmp-prefix=$(HOST) --disable-static
CONFIG_FLAGS[libtool] := --disable-static
CONFIG_FLAGS[m4] := CFLAGS="-Wno-error"
CONFIG_FLAGS[mpc] := --with-gmp=$(HOST) --with-mpfr=$(HOST) --disable-static
CONFIG_FLAGS[mpfr] := --with-gmp=$(HOST) --disable-static
CONFIG_FLAGS[texinfo] := --disable-perl-api

# Tools
TOOLS := CC=gcc CXX=g++ MAKE=make CURL=curl PATCH=patch BISON=bison FLEX=flex SVN=svn GIT=git PERL=perl GPERF=gperf YACC=yacc HELP2MAN=help2man AUTOPOINT=autopoint
ARCHIVE_TOOLS := GZIP=gzip BZIP2=bzip2 XZ=xz
$(foreach tool,$(TOOLS),$(eval $(word 1,$(subst =, ,$(tool))) := $(word 2,$(subst =, ,$(tool)))))
$(foreach tool,$(ARCHIVE_TOOLS),$(eval ARCHIVE_TOOL_$(word 1,$(subst =, ,$(tool))) := $(word 2,$(subst =, ,$(tool)))))

# OS detection
OS := $(shell uname -s)
ifeq ($(OS),Linux)
	ARCHIVE_TOOL_LHA := lhasa
	OS_NAME := Linux
else ifeq ($(OS),Darwin)
	ARCHIVE_TOOL_LHA := lha
	OS_NAME := macOS
else ifeq ($(OS),AmigaOS)
	OS_NAME := AmigaOS
	ARCHIVE_TOOL_LHA := lha
	ifeq ($(shell uname -m),m68k)
		OS_SUBTYPE := M68K
	else
		OS_SUBTYPE := PPC
	endif
else ifeq ($(OS),Windows_NT)
	ARCHIVE_TOOL_LHA := lha
	OS_NAME := Windows
else
	OS_NAME := Unknown
	ARCHIVE_TOOL_LHA := lha
endif
ARCHIVE_TOOL_LHA := $(shell command -v $(ARCHIVE_TOOL_LHA) || echo $(ARCHIVE_TOOL_LHA))

CFLAGS := -g -O2
CXXFLAGS := -g -O2

ifeq ($(OS),Windows_NT)
	SHELL := cmd.exe
	MKDIR := mkdir
	CP := copy /Y
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

.DEFAULT_GOAL := help

.PHONY: all clean clean-download help ppc m68k check_tools check_headers
all: ppc m68k
clean: ; $(RM) $(TOP)/.build $(PREFIX)
clean-download: ; $(RM) $(DOWNLOADS)

define download
	$(MKDIR) $(2); \
	for pkg in $(1); do \
		name=$$(echo "$$pkg" | cut -d'=' -f1); \
		version=$$(echo "$$pkg" | cut -d'=' -f2); \
		url=$$(echo "$$pkg" | cut -d'=' -f3); \
		target=$$(echo "$$pkg" | cut -d'=' -f4); \
		platform=$$(echo "$$pkg" | cut -d'=' -f5); \
		dir=$$([ "$$platform" = "ppc" ] && echo $(PPC_DOWNLOADS) || [ "$$platform" = "m68k" ] && echo $(M68K_DOWNLOADS) || echo $(DOWNLOADS)); \
		$(MKDIR) "$$dir"; \
		if [ "$$version" = "git" ]; then \
			[ -d "$$dir/$$target" ] && echo "$$target exists in $$dir" || \
			(echo "Cloning $$url" && $(GIT) clone "$$url" "$$dir/$$target" || { echo "ERROR: Failed to clone $$url"; exit 2; }); \
			$(MKDIR) "$(2)/$$target"; $(CP) "$$dir/$$target"/* "$(2)/$$target/"; \
		else \
			[ -f "$$dir/$$target" ] && echo "$$target exists in $$dir" || \
			(echo "Downloading $$url" && $(CURL) -L -f -o "$$dir/$$target" "$$url" || { echo "ERROR: Failed to download $$url"; exit 2; }); \
			$(CP) "$$dir/$$target" "$(2)/"; \
		fi; \
	done; \
	$(TOUCH) $(2)/.downloaded
endef

define unpack
	$(MKDIR) $(3); cd $(3); \
	dir=$$([ "$(4)" = "ppc" ] && echo $(PPC_DOWNLOADS) || [ "$(4)" = "m68k" ] && echo $(M68K_DOWNLOADS) || echo $(DOWNLOADS)); \
	[ -f "$$dir/$(2)" ] || { echo "ERROR: Archive $$dir/$(2) not found"; exit 2; }; \
	case "$$(echo $(2) | grep -o '[^.]*$$')" in \
		lha) $(ARCHIVE_TOOL_LHA) x "$$dir/$(2)" || { echo "ERROR: Failed to extract $$dir/$(2)"; exit 2; };; \
		gz|Z|z) $(ARCHIVE_TOOL_GZIP) -d "$$dir/$(2)" -c | tar -x || { echo "ERROR: Failed to extract $$dir/$(2)"; exit 2; };; \
		bz2) $(ARCHIVE_TOOL_BZIP2) -d "$$dir/$(2)" -c | tar -x || { echo "ERROR: Failed to extract $$dir/$(2)"; exit 2; };; \
		xz|lz|zst) $(ARCHIVE_TOOL_XZ) -d "$$dir/$(2)" -c | tar -x || { echo "ERROR: Failed to extract $$dir/$(2)"; exit 2; };; \
		*) echo "ERROR: Unsupported archive: $(2)"; exit 2;; \
	esac
endef

define update_autotools
	$(RM) $(1)/config.{guess,sub}; \
	$(CP) $(SOURCES)/automake/lib/config.{guess,sub} $(1)/
endef

define generate_autogen
	cd $(1); \
	if [ ! -f autogen.sh ]; then \
		echo "Generating autogen.sh in $(1)"; \
		{ echo "#!/bin/bash"; echo "set -e"; \
		  [ -f configure.ac ] && { echo "libtoolize --force --copy"; echo "aclocal -I m4"; echo "autoconf"; echo "autoheader"; }; \
		  [ -f Makefile.am ] && echo "automake --add-missing --copy --foreign"; } > autogen.sh; \
		$(CHMOD) +x autogen.sh; \
	else \
		echo "autogen.sh exists in $(1)"; \
	fi
endef

define build_autotools
	$(MKDIR) $(2); cd $(2); \
	$(call generate_autogen,$(2)); \
	[ -f bootstrap ] || $(CP) autogen.sh bootstrap; \
	./bootstrap && ./configure --prefix=$(HOST) $(3) && $(MAKE) && $(MAKE) install; \
	$(call update_autotools,$(2)); \
	$(TOUCH) $(4)/$1
endef

DIRS := $(STAMPS) $(PPC_STAMPS) $(M68K_STAMPS) $(SOURCES) $(DOWNLOADS) $(PPC_DOWNLOADS) $(M68K_DOWNLOADS) $(BUILD) $(PPC_BUILD) $(M68K_BUILD) $(TMPDIR) $(PREFIX) $(PPC_PREFIX) $(M68K_PREFIX)
$(shell $(MKDIR) $(DIRS))

CHECK_TOOLS := $(foreach tool,$(TOOLS),$(word 1,$(subst =, ,$(tool)))) $(foreach tool,$(ARCHIVE_TOOLS),ARCHIVE_TOOL_$(word 1,$(subst =, ,$(tool))))
check_tools: $(CHECK_TOOLS)
$(CHECK_TOOLS):
	@command -v $($@) >/dev/null || { echo "Error: $($@) not found. Install via: $(if $(filter $(OS_NAME),Linux),sudo apt install,$(if $(filter $(OS_NAME),macOS),brew install,$(if $(filter $(OS_NAME),Windows),choco install,$(if $(filter $(OS_NAME),AmigaOS),Download from Aminet or OS4Depot,Check package manager for)))) $(if $(filter $(OS_NAME),Linux),$(if $(filter $($@),ARCHIVE_TOOL_GZIP),gzip,$(if $(filter $($@),ARCHIVE_TOOL_BZIP2),bzip2,$(if $(filter $($@),ARCHIVE_TOOL_XZ),xz-utils,$(if $(filter $($@),ARCHIVE_TOOL_LHA),lhasa,$(patsubst ARCHIVE_TOOL_%,%,$@)))))),$(patsubst ARCHIVE_TOOL_%,%,$@))"; exit 2; }

$(TMPDIR)/check_ncurses.h: | $(TMPDIR)
	@echo "#include <ncurses.h>\nint main() { return 0; }" > $@
check_headers: check_tools $(TMPDIR)/check_ncurses.h
	$(CC) $(TMPDIR)/check_ncurses.h -o /dev/null 2>/dev/null || { echo "ERROR: Missing ncurses headers"; exit 2; }

$(SOURCES)/automake: $(DOWNLOADS)/automake-$(VERSIONS[automake]).tar.gz) | $(SOURCES)
	$(MKDIR) $(SOURCES)/automake; $(call unpack,automake-$(VERSIONS[automake]).tar.gz,automake-$(VERSIONS[automake]),$(SOURCES)/automake)

# Download rules
define download_rule
$(1)/%.$(2): | $(1)
	@for pkg in $(URLS); do \
		name=$$(echo "$$pkg" | cut -d'=' -f1); \
		url=$$(echo "$$pkg" | cut -d'=' -f3); \
		target=$$(echo "$$pkg" | cut -d'=' -f4); \
		platform=$$(echo "$$pkg" | cut -d'=' -f5); \
		if [ "$$target" = "$(notdir $@)" ] && [ "$$platform" = "$(3)" ]; then \
			[ -f "$(1)/$$target" ] && echo "$$target exists in $(1)" || \
			(echo "Downloading $$url" && $(CURL) -L -f -o "$(1)/$$target" "$$url" || { echo "ERROR: Failed to download $$url"; exit 2; }); \
			break; \
		fi; \
	done
endef
$(eval $(call download_rule,$(DOWNLOADS),tar.gz,common))
$(eval $(call download_rule,$(DOWNLOADS),tar.bz2,common))
$(eval $(call download_rule,$(DOWNLOADS),tar.xz,common))
$(eval $(call download_rule,$(PPC_DOWNLOADS),lha,ppc))
$(eval $(call download_rule,$(M68K_DOWNLOADS),lha,m68k))
$(eval $(call download_rule,$(M68K_DOWNLOADS),tar.gz,m68k))

$(DOWNLOADS)/%.git: | $(DOWNLOADS)
	@for pkg in $(URLS); do \
		name=$$(echo "$$pkg" | cut -d'=' -f1); \
		version=$$(echo "$$pkg" | cut -d'=' -f2); \
		url=$$(echo "$$pkg" | cut -d'=' -f3); \
		target=$$(echo "$$pkg" | cut -d'=' -f4); \
		if [ "$$version" = "git" ] && [ "$$target" = "$(notdir $@)" ]; then \
			[ -d "$(DOWNLOADS)/$$target" ] && echo "$$target exists in $(DOWNLOADS)" || \
			(echo "Cloning $$url" && $(GIT) clone "$$url" "$(DOWNLOADS)/$$target" || { echo "ERROR: Failed to clone $$url"; exit 2; }); \
			break; \
		fi; \
	done

$(PPC_DOWNLOADS)/.downloaded: $(addprefix $(DOWNLOADS)/,$(filter-out %.git %.lha,$(foreach pkg,$(filter %=common %=ppc,$(URLS)),$(word 4,$(subst =, ,$(pkg)))))) $(addprefix $(PPC_DOWNLOADS)/,$(filter %.lha,$(foreach pkg,$(filter %=ppc,$(URLS)),$(word 4,$(subst =, ,$(pkg)))))) $(addprefix $(DOWNLOADS)/,$(filter %.git,$(foreach pkg,$(filter %=common %=ppc,$(URLS)),$(word 4,$(subst =, ,$(pkg)))))) | $(PPC_DOWNLOADS)
	$(call download,$(filter %=common %=ppc,$(URLS)),$(PPC_DOWNLOADS))

$(M68K_DOWNLOADS)/.downloaded: $(addprefix $(DOWNLOADS)/,$(filter-out %.git %.lha,$(foreach pkg,$(filter %=common %=m68k,$(URLS)),$(word 4,$(subst =, ,$(pkg)))))) $(addprefix $(M68K_DOWNLOADS)/,$(foreach pkg,$(filter %=m68k,$(URLS)),$(word 4,$(subst =, ,$(pkg))))) $(addprefix $(DOWNLOADS)/,$(filter %.git,$(foreach pkg,$(filter %=common %=m68k,$(URLS)),$(word 4,$(subst =, ,$(pkg)))))) | $(M68K_DOWNLOADS)
	$(call download,$(filter %=common %=m68k,$(URLS)),$(M68K_DOWNLOADS))

$(DOWNLOADS)/.downloaded: $(PPC_DOWNLOADS)/.downloaded $(M68K_DOWNLOADS)/.downloaded | $(DOWNLOADS)
	$(call download,$(filter %=common,$(URLS)),$(DOWNLOADS))
	$(TOUCH) $@

# Autotools component rule
define autotools_rule
$(1)_STAMPS/$2: $(addprefix $(1)_STAMPS/,$(DEPENDS[$2])) $(DOWNLOADS)/$2-$(VERSIONS[$2]).tar.$(if $(filter bison gawk libogg libsndfile libtheora libtool libvorbis m4 mpfr texinfo zlib,$(2)),xz,gz) | $(1)_BUILD
	$(call unpack,$2-$(VERSIONS[$2]).tar.$(if $(filter bison gawk libogg libsndfile libtheora libtool libvorbis m4 mpfr texinfo zlib,$(2)),xz,gz),$2-$(VERSIONS[$2]),$($(1)_BUILD))
	$(call build_autotools,$2,$($(1)_BUILD)/$2-$(VERSIONS[$2]),$(CONFIG_FLAGS[$2]),$($(1)_STAMPS))
endef
$(foreach comp,autoconf automake bison cloog flex gawk gmp isl libtool m4 mpc mpfr texinfo,$(eval $(call autotools_rule,PPC,$(comp))))
$(foreach comp,autoconf bison flex gawk m4,$(eval $(call autotools_rule,M68K,$(comp))))

# PPC Custom Rules
define ppc_rule
$(PPC_STAMPS)/$1: $(addprefix $(PPC_STAMPS)/,$(DEPENDS[$1])) $(if $(filter binutils clib2 newlib,$1),$(DOWNLOADS)/$1.git,$(if $(filter vbcc,$1),$(PPC_DOWNLOADS)/.downloaded $(PPC_DOWNLOADS)/$(PPC_VBCC)_bin_amigaosppc.lha $(PPC_DOWNLOADS)/$(PPC_VBCC)_target_ppc-amigaos.lha,$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.$(if $(filter gcc-ppc,$1),gz,xz))) | $(PPC_BUILD)
	$(MKDIR) $(PPC_BUILD)/$1
	$(if $(filter binutils clib2 newlib,$1),$(CP) $(DOWNLOADS)/$1/* $(PPC_BUILD)/$1/,$(if $(filter vbcc,$1),$(call unpack,$(PPC_VBCC)_bin_amigaosppc.lha,vbcc,$(PPC_BUILD),ppc); $(call unpack,$(PPC_VBCC)_target_ppc-amigaos.lha,vbcc-target,$(PPC_BUILD),ppc); $(MKDIR) $(PPC_PREFIX)/{bin,vbcc}; $(CP) $(PPC_BUILD)/vbcc/* $(PPC_PREFIX)/bin/; $(CP) $(PPC_BUILD)/vbcc-target/* $(PPC_PREFIX)/vbcc/,$(call unpack,$1-$(VERSIONS[$1]).tar.$(if $(filter gcc-ppc,$1),gz,xz),$1-$(VERSIONS[$1]),$(PPC_BUILD))))
	$(if $(filter binutils,$1),cd $(PPC_BUILD)/$1 && ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) --disable-nls && $(MAKE) YACC=$(BISON) && $(MAKE) install)
	$(if $(filter gcc-ppc,$1),cd $(PPC_BUILD)/$1-$(VERSIONS[$1]) && CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) --with-gmp=$(HOST) --with-mpfr=$(HOST) --with-mpc=$(HOST) --with-isl=$(HOST) --with-cloog=$(HOST) --enable-languages=c,c++ --enable-haifa --enable-sjlj-exceptions --disable-libstdcxx-pch --disable-tls --disable-nls && $(MAKE) && $(MAKE) install)
	$(if $(filter clib2,$1),cd $(PPC_BUILD)/$1 && $(MAKE) -f GNUmakefile.os4; $(MKDIR) $(PPC_PREFIX)/clib2; $(CP) $(PPC_BUILD)/$1/lib/* $(PPC_PREFIX)/clib2/lib/; $(CP) $(PPC_BUILD)/$1/include/* $(PPC_PREFIX)/clib2/include/)
	$(if $(filter newlib,$1),cd $(PPC_BUILD)/$1 && ./configure --prefix=$(PPC_PREFIX) --target=$(PPC_TARGET) && $(MAKE) && $(MAKE) install)
	$(TOUCH) $@
endef
$(foreach comp,binutils gcc-ppc vbcc clib2 newlib,$(eval $(call ppc_rule,$(comp))))

# M68K Custom Rules
define m68k_rule
$(M68K_STAMPS)/$1: $(addprefix $(M68K_STAMPS)/,$(DEPENDS[$1])) $(if $(filter fd2pragma fd2sfd ixemul libdebug libnix sfdc clib2,$1),$(DOWNLOADS)/$1.git,$(if $(filter vbcc,$1),$(M68K_DOWNLOADS)/.downloaded $(M68K_DOWNLOADS)/$(M68K_VBCC)_bin_amigaos68k.lha $(M68K_DOWNLOADS)/$(M68K_VBCC)_target_m68k-amigaos.lha,$(if $(filter vasm vlink,$1),$(M68K_DOWNLOADS)/.downloaded $(M68K_DOWNLOADS)/$(M68K_$(shell echo $1 | tr '[:lower:]' '[:upper:]')).tar.gz,$(if $(filter ndk,$1),$(M68K_DOWNLOADS)/.downloaded $(M68K_DOWNLOADS)/$(M68K_NDK).lha,$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.$(if $(filter gcc-m68k,$1),bz2,gz)))))) | $(M68K_BUILD)
	$(MKDIR) $(M68K_BUILD)/$1
	$(if $(filter fd2pragma fd2sfd ixemul libdebug libnix sfdc clib2,$1),$(CP) $(DOWNLOADS)/$1/* $(M68K_BUILD)/$1/,$(if $(filter vbcc,$1),$(call unpack,$(M68K_VBCC)_bin_amigaos68k.lha,vbcc,$(M68K_BUILD),m68k); $(call unpack,$(M68K_VBCC)_target_m68k-amigaos.lha,vbcc-target,$(M68K_BUILD),m68k); $(MKDIR) $(M68K_PREFIX)/{bin,vbcc}; $(CP) $(M68K_BUILD)/vbcc/* $(M68K_PREFIX)/bin/; $(CP) $(M68K_BUILD)/vbcc-target/* $(M68K_PREFIX)/vbcc/,$(if $(filter vasm vlink,$1),$(call unpack,$(M68K_$(shell echo $1 | tr '[:lower:]' '[:upper:]')).tar.gz,$1,$(M68K_BUILD),m68k),$(if $(filter ndk,$1),$(call unpack,$(M68K_NDK).lha,NDK_$(VERSIONS[ndk]),$(M68K_BUILD),m68k),$(call unpack,$1-$(VERSIONS[$1]).tar.$(if $(filter gcc-m68k,$1),bz2,gz),$1-$(VERSIONS[$1]),$(M68K_BUILD))))))
	$(if $(filter vasm,$1),$(MKDIR) $(M68K_BUILD)/$1/objects; cd $(M68K_BUILD)/$1 && $(MAKE) CPU=m68k SYNTAX=mot; $(MKDIR) $(M68K_PREFIX)/bin; $(CP) $(M68K_BUILD)/$1/vasmm68k_mot $(M68K_PREFIX)/bin/; $(CP) $(M68K_BUILD)/$1/vobjdump $(M68K_PREFIX)/bin/)
	$(if $(filter vlink,$1),$(MKDIR) $(M68K_BUILD)/$1/objects; cd $(M68K_BUILD)/$1 && $(MAKE); $(MKDIR) $(M68K_PREFIX)/bin; $(CP) $(M68K_BUILD)/$1/vlink $(M68K_PREFIX)/bin/)
	$(if $(filter fd2sfd,$1),cd $(M68K_BUILD)/$1 && ./configure --prefix=$(M68K_PREFIX) && $(MAKE); $(CP) $(M68K_BUILD)/$1/fd2sfd $(M68K_PREFIX)/bin/; $(CP) $(M68K_BUILD)/$1/cross/lib/share/alib.h $(M68K_PREFIX)/ndk/include/inline/)
	$(if $(filter fd2pragma,$1),cd $(M68K_BUILD)/$1 && ./configure --prefix=$(M68K_PREFIX) && $(MAKE); $(CP) $(M68K_BUILD)/$1/fd2pragma $(M68K_PREFIX)/bin/; $(CP) $(M68K_BUILD)/$1/Include/inline/{macros,stubs}.h $(M68K_PREFIX)/ndk/include/inline/)
	$(if $(filter sfdc,$1),cd $(M68K_BUILD)/$1 && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install)
	$(if $(filter ixemul,$1),cd $(M68K_BUILD)/$1 && ./configure --prefix=$(M68K_PREFIX)/lib && $(MAKE) && $(MAKE) install)
	$(if $(filter libnix,$1),cd $(M68K_BUILD)/$1 && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install; $(CP) $(M68K_BUILD)/$1/source/stabs.h $(M68K_PREFIX)/libnix/include/)
	$(if $(filter libdebug,$1),cd $(M68K_BUILD)/$1 && ./configure --prefix=$(M68K_PREFIX) && $(MAKE) && $(MAKE) install)
	$(if $(filter clib2,$1),cd $(M68K_BUILD)/$1 && $(MAKE) -f GNUmakefile.68k; $(MKDIR) $(M68K_PREFIX)/clib2/{lib,include}; $(CP) $(M68K_BUILD)/$1/lib/* $(M68K_PREFIX)/clib2/lib/; $(CP) $(M68K_BUILD)/$1/include/* $(M68K_PREFIX)/clib2/include/)
	$(if $(filter binutils,$1),cd $(M68K_BUILD)/$1 && ./configure --prefix=$(M68K_PREFIX) --target=$(M68K_TARGET) --disable-nls && $(MAKE) YACC=$(BISON) && $(MAKE) install)
	$(if $(filter gcc-m68k,$1),cd $(M68K_BUILD)/$1-$(VERSIONS[$1]) && CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) ./configure --prefix=$(M68K_PREFIX) --target=$(M68K_TARGET) --disable-nls && $(MAKE) && $(MAKE) install)
	$(if $(filter ndk,$1),$(MKDIR) $(M68K_PREFIX)/ndk/{include,lib/{fd,sfd},doc}; $(CP) $(M68K_BUILD)/NDK_$(VERSIONS[ndk])/Include/include_{h,i}/* $(M68K_PREFIX)/ndk/include/; $(CP) $(M68K_BUILD)/NDK_$(VERSIONS[ndk])/Include/{fd,sfd}/* $(M68K_PREFIX)/ndk/lib/{fd,sfd}/; $(CP) $(M68K_BUILD)/NDK_$(VERSIONS[ndk])/Include/linker_libs/lib{amiga,m}.a $(M68K_PREFIX)/ndk/lib/; $(CP) $(M68K_BUILD)/NDK_$(VERSIONS[ndk])/Documentation/Autodocs/* $(M68K_PREFIX)/ndk/doc/)
	$(if $(filter vbcc-install,$1),$(MKDIR) $(M68K_PREFIX)/{etc,lib}; echo "#!/bin/bash\n$(M68K_PREFIX)/bin/vasmm68k_mot -I$(M68K_PREFIX)/ndk/include \"\$$@\"" > $(M68K_PREFIX)/bin/vasm; $(CHMOD) 755 $(M68K_PREFIX)/bin/vasm; echo "-cc=$(M68K_PREFIX)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -quiet -I$(M68K_PREFIX)/vbcc/include -I$(M68K_PREFIX)/ndk/include\n-ccv=$(M68K_PREFIX)/bin/vbccm68k -hunkdebug %s -o= %s %s -O=%ld -I$(M68K_PREFIX)/vbcc/include -I$(M68K_PREFIX)/ndk/include\n-as=$(M68K_PREFIX)/bin/vasmm68k_mot -Fhunk -phxass -opt-fconst -nowarn=62 -quiet -I$(M68K_PREFIX)/ndk/include %s -o %s\n-asv=$(M68K_PREFIX)/bin/vasmm68k_amiga -Fhunk -phxass -opt-fconst -nowarn=62 -I$(M68K_PREFIX)/ndk/include %s -o %s\n-rm=rm %s\n-rmv=rm -v %s\n-ld=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/vbcc/lib -lvc -o %s\n-l2=$(M68K_PREFIX)/bin/vlink -bamigahunk -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/vbcc/lib -o %s\n-ldv=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib $(M68K_PREFIX)/vbcc/lib/startup.o %s %s -L$(M68K_PREFIX)/vbcc/lib -lvc -o %s\n-l2v=$(M68K_PREFIX)/bin/vlink -bamigahunk -t -x -Bstatic -Cvbcc -nostdlib %s %s -L$(M68K_PREFIX)/vbcc/lib -o %s\n-ldnodb=-s -Rshort\n-ul=-l%s\n$(M68K) = -f%s\n-ml=500" > $(M68K_PREFIX)/etc/vc.config; $(CHMOD) 644 $(M68K_PREFIX)/etc/vc.config)
	$(TOUCH) $@
endef
$(foreach comp,vasm vlink vbcc binutils gcc-m68k fd2sfd2sfd ffd2pragma sfdc ndk ixemul libnix libdebug clib2 vbcc-install,$(eval $(call m68k_rule,$(comp))))

ppc: $(addprefix $(PPC_STAMPS)/,$(PPC_COMPONENTS)) | check_headers
	@echo "PPC toolchain build completed successfully."

m68k: $(addprefix $(M68K_STAMPS)/,$(M68K_COMPONENTS)) | check_headers
	@echo "M68K toolchain build completed successfully."

help: check_tools
	@echo "=== AmigaOS Cross-Compilation Toolchain ==="
	@echo "Copyright (c) 2025 Zachary Geurts, MIT License"
	@echo "Builds toolchains for PPC (AmigaOS 4.x) and M68K (AmigaOS 3.x)."
	@echo "Host: $(OS_NAME) $(OS_SUBTYPE)"
	@echo "Prefix: $(TOP)$(PATHSEP)install"
	@echo "Memory Requirements:"
	@echo "  PPC Toolchain: ~1490 MB (build), ~599 MB (installed)"
	@echo "  M68K Toolchain: ~1148 MB (build), ~457 MB (installed)"
	@echo "=== PPC SDK Notes ==="
	@echo "  Download PPC SDK (SDK_ppc.lha) from https://www.hyperion-entertainment.com/"
	@echo "  Place at $(PPC_DOWNLOADS)$(PATHSEP)$(PPC_SDK).lha"
	@if [ -f "$(PPC_DOWNLOADS)$(PATHSEP)$(PPC_SDK).lha" ]; then \
		echo "  Found $(PPC_SDK).lha in $(PPC_DOWNLOADS)"; \
	else \
		echo "  WARNING: $(PPC_SDK).lha not found in $(PPC_DOWNLOADS). Download and place it there to build PPC toolchain."; \
	fi
	@echo "=== Networking Notes ==="
	@echo "  PPC: Roadshow TCP/IP stack required for git (available via OS4Depot)."
	@echo "  M68K: Roadshow or Miami TCP/IP stack required for git (available via Aminet)."
	@echo "=== Local Files ==="
	@total=0; downloads=0; ppc_downloads=0; m68k_downloads=0; build=0; ppc_build=0; m68k_build=0; git=0; \
	found_files=""; found_git=""; \
	for pkg in $(URLS); do \
		name=$$(echo "$$pkg" | cut -d'=' -f1); \
		version=$$(echo "$$pkg" | cut -d'=' -f2); \
		target=$$(echo "$$pkg" | cut -d'=' -f4); \
		platform=$$(echo "$$pkg" | cut -d'=' -f5); \
		dir=$$([ "$$platform" = "ppc" ] && echo "$(PPC_DOWNLOADS)" || [ "$$platform" = "m68k" ] && echo "$(M68K_DOWNLOADS)" || echo "$(DOWNLOADS)"); \
		bdir=$$([ "$$platform" = "ppc" ] && echo "$(PPC_BUILD)" || [ "$$platform" = "m68k" ] && echo "$(M68K_BUILD)" || echo "$(BUILD)"); \
		if [ "$$version" = "git" ]; then \
			if [ -d "$$dir/$$target" ]; then \
				found_git="$$found_git\n  Git: $$target (in $$dir)"; git=$$((git+1)); total=$$((total+1)); \
			elif [ -d "$$bdir/$$target" ]; then \
				found_git="$$found_git\n  Git: $$target (in $$bdir)"; git=$$((git+1)); total=$$((total+1)); \
			fi; \
		else \
			if [ -f "$$dir/$$target" ]; then \
				found_files="$$found_files\n  File: $$target (in $$dir)"; \
				case "$$platform" in \
					ppc) ppc_downloads=$$((ppc_downloads+1));; \
					m68k) m68k_downloads=$$((m68k_downloads+1));; \
					*) downloads=$$((downloads+1));; \
				esac; total=$$((total+1)); \
			elif [ -d "$$bdir/$$target-$(VERSIONS[$$name])" ] || [ -d "$$bdir/$$target" ]; then \
				found_files="$$found_files\n  File: $$target (extracted in $$bdir)"; \
				case "$$platform" in \
					ppc) ppc_build=$$((ppc_build+1));; \
					m68k) m68k_build=$$((m68k_build+1));; \
					*) build=$$((build+1));; \
				esac; total=$$((total+1)); \
			fi; \
		fi; \
	done; \
	if [ -f "$(PPC_DOWNLOADS)$(PATHSEP)$(PPC_SDK).lha" ]; then \
		found_files="$$found_files\n  File: $(PPC_SDK).lha (in $(PPC_DOWNLOADS))"; ppc_downloads=$$((ppc_downloads+1)); total=$$((total+1)); \
	fi; \
	if [ -f "$(M68K_DOWNLOADS)$(PATHSEP)$(M68K_NDK).lha" ]; then \
		found_files="$$found_files\n  File: $(M68K_NDK).lha (in $(M68K_DOWNLOADS))"; m68k_downloads=$$((m68k_downloads+1)); total=$$((total+1)); \
	fi; \
	if [ -n "$$found_files" ]; then \
		echo -e "$$found_files" | sort; \
	else \
		echo "  No archive files found in downloads or build directories."; \
	fi; \
	if [ -n "$$found_git" ]; then \
		echo -e "$$found_git" | sort; \
	else \
		echo "  No git repositories found in downloads or build directories."; \
	fi; \
	echo "Summary: downloads=$$downloads, ppc_downloads=$$ppc_downloads, m68k_downloads=$$m68k_downloads, build=$$build, ppc_build=$$ppc_build, m68k_build=$$m68k_build, git=$$git, total=$$total"
	@echo "=== URL Status for Missing Files ==="
	@checked=0; up=0; down=0; \
	for pkg in $(URLS); do \
		name=$$(echo "$$pkg" | cut -d'=' -f1); \
		version=$$(echo "$$pkg" | cut -d'=' -f2); \
		url=$$(echo "$$pkg" | cut -d'=' -f3); \
		target=$$(echo "$$pkg" | cut -d'=' -f4); \
		platform=$$(echo "$$pkg" | cut -d'=' -f5); \
		dir=$$([ "$$platform" = "ppc" ] && echo "$(PPC_DOWNLOADS)" || [ "$$platform" = "m68k" ] && echo "$(M68K_DOWNLOADS)" || echo "$(DOWNLOADS)"); \
		bdir=$$([ "$$platform" = "ppc" ] && echo "$(PPC_BUILD)" || [ "$$platform" = "m68k" ] && echo "$(M68K_BUILD)" || echo "$(BUILD)"); \
		check=1; \
		[ "$$version" = "git" ] && { [ -d "$$dir/$$target" ] || [ -d "$$bdir/$$target" ]; } && check=0; \
		[ "$$version" != "git" ] && { [ -f "$$dir/$$target" ] || [ -d "$$bdir/$$target-$(VERSIONS[$$name])" ] || [ -d "$$bdir/$$target" ]; } && check=0; \
		if [ "$$check" = "1" ]; then \
			checked=$$((checked+1)); \
			if $(CURL) -s --head "$$url" >/dev/null; then \
				echo "  Up: $$url (for $$target)"; up=$$((up+1)); \
			else \
				echo "  Down: $$url (for $$target)"; down=$$((down+1)); \
			fi; \
		fi; \
	done; \
	[ "$$checked" = "0" ] && echo "  All required files found locally; no URLs checked."; \
	echo "URL Summary: checked=$$checked, up=$$up, down=$$down"
	@echo "=== Requirements ==="
	@if [ "$(OS_NAME)" = "Linux" ]; then \
		echo "Linux: sudo apt install -y gcc g++ curl patch bison flex make subversion git perl libgmp-dev libxml2-dev libmpc-dev libmpfr-dev zlib1g-dev libbz2-dev liblzma-dev autoconf automake autopoint patchutils pkgconf help2man m4 gawk tar gzip bzip2 xz-utils lhasa libncurses-dev"; \
	elif [ "$(OS_NAME)" = "macOS" ]; then \
		echo "macOS: brew install gcc g++ curl patch bison flex make subversion git perl pkg-config m4 gawk autoconf automake autoreconf tar xz bzip2 lha ncurses"; \
	elif [ "$(OS_NAME)" = "Windows" ]; then \
		echo "Windows: Install Chocolatey from https://chocolatey.org/install (Run PowerShell as Administrator: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned; then: iwr https://chocolatey.org/install.ps1 -UseBasicParsing | iex)"; \
		echo "After installing Chocolatey, run: choco install -y gcc g++ curl patch m4 gawk autoconf automake bison flex make subversion git perl gperf zip unzip lzip tar gzip bzip2 xz"; \
		echo "Download lha from https://github.com/jca02266/lha/releases and add to PATH"; \
	elif [ "$(OS_NAME)" = "AmigaOS" ] && [ "$(OS_SUBTYPE)" = "PPC" ]; then \
		echo "AmigaOS PPC: Install GCC, Make, Bison, Flex, Curl, Git, Perl, and LhA from OS4Depot (http://os4depot.net)"; \
		echo "Download SDK_ppc.lha from https://www.hyperion-entertainment.com/ and place in $(PPC_DOWNLOADS)"; \
		echo "Install Roadshow TCP/IP stack from OS4Depot for git networking"; \
		echo "Install additional libraries (gmp, mpfr, mpc, zlib, bzip2, xz) from OS4Depot or compile from source"; \
	elif [ "$(OS_NAME)" = "AmigaOS" ] && [ "$(OS_SUBTYPE)" = "M68K" ]; then \
		echo "AmigaOS M68K: Install gcc, make, bison, flex, and lha from Aminet (https://aminet.net)"; \
		echo "Use vbcc (version $(VERSIONS[vbcc])) from http://phx.pl/ftp/vbcc/ for compilation"; \
		echo "Download NDK$(VERSIONS[ndk]).lha from Aminet and place in $(M68K_DOWNLOADS)"; \
		echo "Install Roadshow or Miami TCP/IP stack from Aminet for git networking"; \
		echo "Note: Limited resources may require cross-compilation on a more powerful host"; \
	else \
		echo "Unknown OS: Install gcc, g++, curl, patch, bison, flex, make, subversion, git, perl, gperf, autoconf, automake, m4, gawk, tar, gzip, bzip2, xz, lha, and ncurses manually."; \
		echo "Refer to Linux or AmigaOS requirements for guidance."; \
	fi
	@echo "=== Commands ==="
	@echo "make ppc	 : Build PPC toolchain"
	@echo "make m68k	: Build M68K toolchain"
	@echo "make all	 : Build both PPC and M68K toolchains"
	@echo "make clean	 : Remove build directories"
	@echo "make clean-download : Clear downloaded files"
	@echo "make help	:= This help message"
	@echo "=== Next Steps ==="
	@echo "Run 'make ppc' or 'make m68k' to build toolchains."
	@echo "Ensure $(PPC_SDK).lha is in $(PPC_DOWNLOADS) for PPC builds."
	@echo "For git, ensure TCP/IP stack (Roadshow/Miami) is installed on AmigaOS."