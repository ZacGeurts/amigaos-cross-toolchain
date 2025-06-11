# Welcome Amiga enthusiasts! This Makefile builds a cross-compilation toolchain
# for AmigaOS, empowering your passion for PPC and M68K development.
# Crafted with care for the vibrant Amiga community. Happy coding!
# Copyright (c) 2025 Zachary Geurts, MIT License
ENABLE_STATIC ?= 0
include versions.mk

# Directories: Define paths for build, install, and download directories
TOP := $(abspath .)
BUILD := $(TOP)/.build/build
DOWNLOADS := $(TOP)/downloads
HOST := $(TOP)/.build/host
M68K := m68k-amigaos
M68K_BUILD := $(BUILD)/m68k
M68K_DOWNLOADS := $(DOWNLOADS)/m68k
M68K_NDK := NDK_3.9
M68K_PREFIX := $(PREFIX)/$(M68K)
M68K_STAMPS := $(STAMPS)/m68k
PPC := ppc-amigaos
PPC_BUILD := $(BUILD)/ppc
PPC_DOWNLOADS := $(DOWNLOADS)/ppc
PPC_PREFIX := $(PREFIX)/$(PPC)
PPC_SDK := SDK_ppc
PPC_STAMPS := $(STAMPS)/ppc
PREFIX := $(TOP)/install
SOURCES := $(TOP)/.build/sources
STAMPS := $(TOP)/.build/stamps
TMPDIR := $(TOP)/.build/tmp
VBCC := vbcc$(VERSIONS[vbcc])

# Validate versions.mk entries
$(foreach comp,$(PPC_COMPONENTS) $(M68K_COMPONENTS),$(if $(or $(VERSIONS[$comp]),$(filter clib2 newlib fd2pragma fd2sfd ixemul libdebug libnix sfdc,$comp)),,$(error ERROR: Version for component '$comp' not defined in versions.mk)))

# Components: Alphabetized lists of valid components for PPC and M68K toolchains
PPC_COMPONENTS := autoconf automake binutils-ppc bison busybox clib2 cloog cmake expat flex fontconfig freetype gawk gcc-ppc gdb giflib gmp isl libbz2 libcurl-ppc libffi libiconv libintl libjpeg libmpg123 libogg libpng libsndfile libtheora libtool libvorbis libxml2 m4 make mpc mpfr newlib perl pkg-config texinfo vbcc-ppc-bin vbcc-ppc-target vlink zlib
M68K := $(COMPONENTS) autoconf binutils-m68k bison busybox clib2 cmake db101 expat fd2pragma fd2sfd flex fontconfig freetype gawk gcc-m68k gdb giflib gmp ixemul libbz2 libcurl-m68k libdebug libffi libiconv libintl libjpeg libmpg123 libnix libogg libpng libsndfile libtheora libvorbis libxml2 make m4 perl pkg-config sfdc texinfo vasm vbcc-m68k-bin vbcc-m68k-target vlink zlib
# Ensure unique components and exclude invalid ones
PPC_COMPONENTS := $(sort $(filter-out omp,$(PPC_COMPONENTS)))
M68K_COMPONENTS := $(sort $(filter-out omp,$(M68K_COMPONENTS)))

# Configuration flags: Alphabetized component-specific configure options
CONFIG_FLAGS[bison] := --disable-nls
CONFIG_FLAGS[cloog] := --with-gmp-prefix=$(HOST) --with-isl-prefix=$(HOST)
CONFIG_FLAGS[flex] := --disable-nls
CONFIG_FLAGS[gawk] := --disable-extensions
CONFIG_FLAGS[gcc-m68k] := --disable-nls --enable-languages=c,c++ --disable-libstdcxx-pch --disable-tls
CONFIG_FLAGS[gcc-ppc] := --enable-languages=c,c++ --enable-haifa --enable-sjlj-exceptions --disable-libstdcxx-pch --disable-tls --disable-nls
CONFIG_FLAGS[isl] := --with-gmp-prefix=$(HOST)
CONFIG_FLAGS[m4] := CFLAGS="-Wno-error"
CONFIG_FLAGS[m4] := --with-gmp=$(HOST) --with-mpfr=$(HOST)
CONFIG_FLAGS[mpc] := --with-gmp=$(HOST)
CONFIG_FLAGS[mpfr] := --with-gmp=$(HOST)
CONFIG_FLAGS[texinfo] := --disable-perl-api
STATIC_FLAGS := $(if $(filter 1,$(ENABLE_STATIC)),--enable-static --disable-shared,--enable-shared --disable-static)

# Dependencies: Alphabetized build dependencies for components
DEPEND[autoconf] := m4
DEPEND[automake] := autoconf
DEPEND[binutils-m68k] := automake
DEPEND[binutils-ppc] := automake
DEPEND[bison] := m4
DEPEND[clib2] := gcc-ppc gcc-m68k
DEPEND[cloog] := isl
DEPEND[gcc-m68k] := binutils-m68k mpc mpfr gmp
DEPEND[gcc-ppc] := binutils-ppc mpc mpfr gmp cloog
DEPEND[isl] := gmp
DEPEND[libdebug] := vbcc-m68k-bin
DEPEND[libnix] := vbcc-m68k-bin
DEPEND[libtool] := autoconf
DEPEND[mpc] := mpfr
DEPEND[mpfr] := gmp
DEPEND[texinfo] := automake

# Tools: Define build and archive tools
TOOLS := CC=gcc CXX=g++ MAKE=make CURL=curl PATCH=patch BISON=bison FLEX=flex SVN=svn GIT=git PERL=perl GPERF=gperf YACC=yacc HELP2MAN=help2man AUTOPOINT=autopoint
ARCHIVE_TOOLS := GZIP=gzip BZIP2=bzip2 XZ=xz LHA=lha
$(foreach t,$(TOOLS) $(ARCHIVE_TOOLS),$(eval $(word 1,$(subst =, ,$(t))) := $(word 2,$(subst =, ,$(t)))))
ARCHIVE_TOOL_LHA := $(shell command -v lhasa || echo lha)

# OS detection: Handle platform-specific commands
OS := $(shell uname -s)
OS_NAME := $(if $(filter Linux,$(OS)),Linux,$(if $(filter Darwin,$(OS)),macOS,$(if $(filter Windows_NT,$(OS)),Windows,$(if $(filter AmigaOS,$(OS)),AmigaOS,Unknown))))
OS_SUBTYPE := $(if $(filter AmigaOS,$(OS)),$(if $(filter m68k,$(shell uname -m)),M68K,PPC))
SHELL := $(if $(filter Windows_NT,$(OS)),cmd.exe,/bin/bash)
MKDIR := $(if $(filter Windows_NT,$(OS)),mkdir,mkdir -p)
CP := $(if $(filter Windows_NT,$(OS)),copy /Y,cp -r)
RM := $(if $(filter Windows_NT,$(OS)),del /Q,rm -rf)
TOUCH := $(if $(filter Windows_NT,$(OS)),echo. >,touch)
CHMOD := $(if $(filter Windows_NT,$(OS)),attrib,chmod)
PATHSEP := $(if $(filter Windows_NT,$(OS)),\\,/)
ECHO := $(if $(filter Windows_NT,$(OS)),echo.,echo)
CFLAGS := -g -O2
CXXFLAGS := -g -O2

.DEFAULT_GOAL := help
.PHONY: all check clean clean-download debug_components debug_rules help m68k ppc check_headers check_tools

all: ppc m68k
clean: ; $(RM) $(TOP)/.build $(PREFIX)
clean-download: ; $(RM) $(DOWNLOADS)

# Directory creation: Ensure all required directories exist
DIRS := $(BUILD) $(DOWNLOADS) $(M68K_BUILD) $(M68K_DOWNLOADS) $(M68K_PREFIX) $(M68K_STAMPS) $(PPC_BUILD) $(PPC_DOWNLOADS) $(PPC_PREFIX) $(PPC_STAMPS) $(PREFIX) $(SOURCES) $(STAMPS) $(TMPDIR)
$(DIRS): ; $(MKDIR) $@

# Build utilities: Macros for parsing, downloading, unpacking, and building
define BUILD_AUTOTOOLS
	$(MKDIR) $(2); cd $(2); \
	[ -f autogen.sh ] || { echo "#!/bin/bash\nset -e\nlibtoolize --force --copy\naclocal -I m4\nautoconf\nautoheader\n[ -f Makefile.am ] && automake --add-missing --copy --foreign" > autogen.sh; $(CHMOD) +x autogen.sh; }; \
	[ -f bootstrap ] || $(CP) autogen.sh bootstrap; \
	./bootstrap && ./configure --prefix=$(HOST) $(STATIC_FLAGS) $(3) && $(MAKE) && $(MAKE) install || { $(ECHO) "ERROR: Failed to build $1"; exit 1; }; \
	$(RM) config.{guess,sub}; $(CP) $(SOURCES)/automake-$(VERSIONS[automake])/lib/config.{guess,sub} .; \
	$(TOUCH) $(4)/$1
endef

define BUILD_AUTOTOOLS_RULE
$(1)_STAMPS/$2: $(addprefix $(1)_STAMPS/,$(DEPENDS[$2])) $(DOWNLOADS)/$2-$(VERSIONS[$2]).tar.$(if $(filter bison flex gawk m4 mpfr texinfo,$2),xz,gz) | $(1)_BUILD
	$(call BUILD_UNPACK,$(DOWNLOADS)/$2-$(VERSIONS[$2]).tar.$(if $(filter bison flex gawk m4 mpfr texinfo,$2),xz,gz),$2-$(VERSIONS[$2]),$(1)_BUILD)
	$(call BUILD_AUTOTOOLS,$2,$($(1)_BUILD)/$2-$(VERSIONS[$2]),$(CONFIG_FLAGS[$2]),$(1)_STAMPS)
endef

define BUILD_COMPONENT
$(1)_STAMPS/$2: $(addprefix $(1)_STAMPS/,$(DEPENDS[$2])) $(call BUILD_COMPONENT_DEPS,$2,$(1)) | $(1)_BUILD
	$(MKDIR) $(1)_BUILD/$2
	$(call BUILD_COMPONENT_BUILD,$2,$(1))
	$(TOUCH) $@
endef

define BUILD_COMPONENT_BUILD
	$(if $(filter binutils-%,$1),$(CP) $(DOWNLOADS)/$1/* $2_BUILD/$1; cd $2_BUILD/$1 && ./configure --prefix=$($2_PREFIX) --target=$($2) --disable-nls $(STATIC_FLAGS) && $(MAKE) YACC=$(BISON) && $(MAKE) install,)
	$(if $(filter gcc-%,$1),$(call BUILD_UNPACK,$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.$(if $(filter gcc-ppc,$1),gz,bz2),$1-$(VERSIONS[$1]),$2_BUILD); cd $2_BUILD/$1-$(VERSIONS[$1]) && CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) ./configure --prefix=$($2_PREFIX) --target=$($2) --with-gmp=$(HOST) --with-mpfr=$(HOST) --with-mpc=$(HOST) $(if $(filter gcc-ppc,$1),--with-isl=$(HOST) --with-cloog=$(HOST)) $(CONFIG_FLAGS[$1]) && $(MAKE) && $(MAKE) install,)
	$(if $(filter clib2,$1),$(CP) $(DOWNLOADS)/$1/* $2_BUILD/$1; cd $2_BUILD/$1 && $(MAKE) -f GNUmakefile.$(if $(filter PPC,$2),os4,68k); $(MKDIR) $($2_PREFIX)/clib2/{lib,include}; $(CP) $2_BUILD/$1/lib/* $($2_PREFIX)/clib2/lib; $(CP) $2_BUILD/$1/include/* $($2_PREFIX)/clib2/include,)
	$(if $(filter newlib,$1),$(CP) $(DOWNLOADS)/$1/* $2_BUILD/$1; cd $2_BUILD/$1 && ./configure --prefix=$($2_PREFIX) --target=$($2) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install,)
	$(if $(filter vbcc-ppc-bin vbcc-m68k-bin,$1),$(call BUILD_UNPACK,$($2_DOWNLOADS)/$1.lha,vbcc,$2_BUILD,$2); $(MKDIR) $($2_PREFIX)/{bin,vbcc}; $(CP) $2_BUILD/vbcc/bin/* $($2_PREFIX)/bin,)
	$(if $(filter vbcc-ppc-target vbcc-m68k-target,$1),$(call BUILD_UNPACK,$($2_DOWNLOADS)/$1.lha,vbcc-target,$2_BUILD,$2); $(MKDIR) $($2_PREFIX)/vbcc; $(CP) $2_BUILD/vbcc-target/* $($2_PREFIX)/vbcc,)
	$(if $(filter vasm,$1),$(call BUILD_UNPACK,$(M68K_DOWNLOADS)/vasm$(VERSIONS[vasm]).tar.gz,$1,$2_BUILD,m68k); $(MKDIR) $2_BUILD/$1/objects; cd $2_BUILD/$1 && $(MAKE) CPU=m68k SYNTAX=mot; $(MKDIR) $($2_PREFIX)/bin; $(CP) $2_BUILD/$1/vasmm68k_mot $2_BUILD/$1/vobjdump $($2_PREFIX)/bin,)
	$(if $(filter vlink,$1),$(call BUILD_UNPACK,$(M68K_DOWNLOADS)/vlink$(VERSIONS[vlink]).tar.gz,$1,$2_BUILD,m68k); $(MKDIR) $2_BUILD/$1/objects; cd $2_BUILD/$1 && $(MAKE); $(MKDIR) $($2_PREFIX)/bin; $(CP) $2_BUILD/$1/vlink $($2_PREFIX)/bin,)
	$(if $(filter fd2sfd fd2pragma sfdc ixemul libnix libdebug,$1),$(CP) $(DOWNLOADS)/$1/* $2_BUILD/$1; cd $2_BUILD/$1 && ./configure --prefix=$($2_PREFIX)$(if $(filter ixemul,$1),/lib,) $(STATIC_FLAGS) && $(MAKE); $(if $(filter fd2sfd,$1),$(CP) $2_BUILD/$1/fd2sfd $($2_PREFIX)/bin; $(CP) $2_BUILD/$1/cross/lib/share/alib.h $($2_PREFIX)/ndk/include/inline,;$(if $(filter fd2pragma,$1),$(CP) $2_BUILD/$1/fd2pragma $($2_PREFIX)/bin; $(CP) $2_BUILD/$1/Include/inline/{macros,stubs}.h $($2_PREFIX)/ndk/include/inline,;$(if $(filter sfdc libnix libdebug,$1),$(MAKE) install,;$(if $(filter ixemul,$1),$(MAKE) install; $(CP) $2_BUILD/$1/source/stabs.h $($2_PREFIX)/libnix/include,)))),)
	$(if $(filter cmake,$1),$(call BUILD_UNPACK,$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.gz,$1,$2_BUILD); cd $2_BUILD/$1 && ./configure --prefix=$($2_PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install,)
	$(if $(filter gdb,$1),$(call BUILD_UNPACK,$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.xz,$1,$2_BUILD); cd $2_BUILD/$1 && ./configure --prefix=$($2_PREFIX) --target=$($2) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install,)
	$(if $(filter db101,$1),$(call BUILD_UNPACK,$(M68K_DOWNLOADS)/$1.lha,$1,$2_BUILD,m68k); $(MKDIR) $($2_PREFIX)/bin; $(CP) $2_BUILD/$1/* $($2_PREFIX)/bin,)
endef

define BUILD_COMPONENT_DEPS
	$(if $(filter clib2 newlib fd2pragma fd2sfd ixemul libdebug libnix sfdc,$1),$(DOWNLOADS)/$1.git,\
	$(if $(filter vbcc-ppc-bin vbcc-ppc-target,$1),$(PPC_DOWNLOADS)/$1.lha,\
	$(if $(filter vbcc-m68k-bin vbcc-m68k-target,$1),$(M68K_DOWNLOADS)/$1.lha,\
	$(if $(filter vasm,$1),$(M68K_DOWNLOADS)/$1$(VERSIONS[$1]).tar.gz,\
	$(if $(filter vlink,$1),$(M68K_DOWNLOADS)/$1$(VERSIONS[vlink]).tar.gz,\
	$(if $(filter binutils-ppc,$1),$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.bz2,\
	$(if $(filter binutils-m68k,$1),$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.gz,\
	$(if $(filter gcc-ppc,$1),$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.gz,\
	$(if $(filter gcc-m68k,$1),$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.bz2,\
	$(if $(filter gdb,$1),$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.xz,\
	$(if $(filter cmake,$1),$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.gz,\
	$(if $(filter db101,$1),$(M68K_DOWNLOADS)/$1.lha,\
	$(DOWNLOADS)/$1-$(VERSIONS[$1]).tar.$(if $(filter bison flex gawk m4 mpfr texinfo,$1),xz,gz)))))))))))))
endef

define BUILD_DOWNLOAD
	$(MKDIR) $(2); \
	for pkg in $(1); do \
		$(call BUILD_PARSE_URL,$$pkg); \
		if [ "$$VERSION" = "git" ]; then \
			if [ -d "$$DOWNLOAD_DIR/$$TARGET" ]; then \
				$(ECHO) "Repository $$TARGET already exists in $$DOWNLOAD_DIR"; \
			else \
				$(ECHO) "Cloning $$URL"; \
				$(GIT) clone "$$URL" "$$DOWNLOAD_DIR/$$TARGET" || { $(ECHO) "ERROR: Failed to clone $$URL"; exit 1; }; \
				$(MKDIR) "$(SOURCES)/$$TARGET"; \
				$(CP) "$$DOWNLOAD_DIR/$$TARGET"/* "$(SOURCES)/$$TARGET/"; \
			fi; \
		else \
			if [ -f "$$DOWNLOAD_DIR/$$TARGET" ]; then \
				$(ECHO) "File $$TARGET already exists in $$DOWNLOAD_DIR"; \
			else \
				$(ECHO) "Downloading $$URL"; \
				$(CURL) -L -f -o "$$DOWNLOAD_DIR/$$TARGET" "$$URL" || { $(ECHO) "ERROR: Failed to download $$URL"; exit 1; }; \
				$(CP) "$$DOWNLOAD_DIR/$$TARGET" "$(2)/"; \
			fi; \
		fi; \
	done; \
	$(TOUCH) $(2)/.downloaded
endef

define BUILD_PARSE_URL
	$(eval NAME := $(word 1,$(subst =, ,$(1))))
	$(eval VERSION := $(word 2,$(subst =, ,$(1))))
	$(eval URL := $(word 3,$(subst =, ,$(1))))
	$(eval TARGET := $(word 4,$(subst =, ,$(1))))
	$(eval PLATFORM := $(word 5,$(subst =, ,$(1))))
	$(eval DOWNLOAD_DIR := $(if $(filter ppc,$(PLATFORM)),$(PPC_DOWNLOADS),$(if $(filter m68k,$(PLATFORM)),$(M68K_DOWNLOADS),$(DOWNLOADS))))
	$(eval EXTENSION := $(if $(filter git,$(VERSION)),git,$(suffix $(TARGET))))
endef

define BUILD_UNPACK
	$(MKDIR) $(3); cd $(3); \
	case "$(suffix $(1))" in \
		.lha) $(ARCHIVE_TOOL_LHA) x "$(1)" || { $(ECHO) "ERROR: Failed to unpack $(1)"; exit 1; };; \
		.tar.gz|.tgz) $(ARCHIVE_TOOL_GZIP) -d "$(1)" -c | tar -x || { $(ECHO) "ERROR: Failed to unpack $(1)"; exit 1; };; \
		.tar.bz2|.tbz2) $(ARCHIVE_TOOL_BZIP2) -d "$(1)" -c | tar -x || { $(ECHO) "ERROR: Failed to unpack $(1)"; exit 1; };; \
		.tar.xz) $(ARCHIVE_XZ) -d "$(1)" -c | tar -x || { $(ECHO) "ERROR: Failed to unpack $(1)"; exit 1; };; \
		*) echo "ERROR: Unsupported extension: $(suffix $(1))"; exit 1;; \
	esac
endef

# Download rules: Handle file downloads for components
DOWNLOAD_FILES := $(foreach pkg,$(URLS),$(word 4,$(subst =, ,$(pkg))))
PPC_FILES := $(foreach pkg,$(filter %=common %=ppc,$(URLS)),$(word 4,$(subst =, ,$(pkg))))
M68K_FILES := $(foreach pkg,$(filter %=common %=m68k,$(URLS)),$(word 4,$(subst =, ,$(pkg))))
$(DOWNLOADS)/%: | $(DOWNLOADS)
	$(call BUILD_DOWNLOAD,$(filter %=$*,$(URLS)),$(DOWNLOADS))
$(PPC_DOWNLOADS)/%: | $(PPC_DOWNLOADS)
	$(call BUILD_DOWNLOAD,$(filter %=$*,$(URLS)),$(PPC_DOWNLOADS))
$(M68K_DOWNLOADS)/%: | $(M68K_DOWNLOADS)
	$(call BUILD_DOWNLOAD,$(filter %=$*,$(URLS)),$(M68K_DOWNLOADS))
$(PPC_DOWNLOADS)/.downloaded: $(addprefix $(DOWNLOADS)/,$(filter-out %.lha,$(PPC_FILES))) $(addprefix $(PPC_DOWNLOADS)/,$(filter %.lha,$(PPC_FILES))) | $(PPC_DOWNLOADS)
	$(call BUILD_DOWNLOAD,$(filter %=common %=ppc,$(URLS)),$(PPC_DOWNLOADS))
$(M68K_DOWNLOADS)/.downloaded: $(addprefix $(DOWNLOADS)/,$(filter-out %.lha,$(M68K_FILES))) $(addprefix $(M68K_DOWNLOADS)/,$(filter %.lha,$(M68K_FILES))) | $(M68K_DOWNLOADS)
	$(call BUILD_DOWNLOAD,$(filter %=common %=m68k,$(URLS)),$(M68K_DOWNLOADS))
$(DOWNLOADS)/.downloaded: $(PPC_DOWNLOADS)/.downloaded $(M68K_DOWNLOADS)/.downloaded | $(DOWNLOADS)
	$(call BUILD_DOWNLOAD,$(filter %=common,$(URLS)),$(DOWNLOADS))

# Debug components: Display processed components for troubleshooting
debug_components:
	@$(ECHO) "PPC components: $(PPC_COMPONENTS)"
	@$(ECHO) "M68K components: $(M68K_COMPONENTS)"
	@$(ECHO) "Autotools components: $(filter $(AUTOTOOLS_COMPONENTS),$(PPC_COMPONENTS) $(M68K_COMPONENTS))"
	@$(ECHO) "Non-autotools components: $(filter-out $(AUTOTOOLS_COMPONENTS),$(PPC_COMPONENTS) $(M68K_COMPONENTS))"

# Debug rules: Log generated rules for troubleshooting
debug_rules:
	@$(ECHO) "PPC rules:"
	@$(foreach comp,$(PPC_COMPONENTS),$(ECHO) "  $(comp): $(PPC_STAMPS)/$(comp)";)
	@$(ECHO) "M68K rules:"
	@$(foreach comp,$(M68K_COMPONENTS),$(ECHO) "  $(comp): $(M68K_STAMPS)/$(comp)";)

# Apply autotools rules: Generate build rules for autotools-based components
AUTOTOOLS_COMPONENTS := autoconf automake bison busybox cloog expat flex fontconfig freetype gawk gmp isl libbz2 libcurl-m68k libcurl-ppc libffi libiconv libintl libjpeg libmpg123 libogg libpng libsndfile libtheora libtool libvorbis libxml2 m4 make mpc mpfr perl pkg-config texinfo zlib
$(foreach comp,$(filter $(AUTOTOOLS_COMPONENTS),$(PPC_COMPONENTS)),$(eval $(call BUILD_AUTOTOOLS_RULE,PPC,$comp)))
$(foreach comp,$(filter $(AUTOTOOLS_COMPONENTS),$(M68K_COMPONENTS)),$(eval $(call BUILD_AUTOTOOLS_RULE,M68K,$comp)))

# Apply component rules: Generate build rules for non-autotools components
$(foreach comp,$(filter-out $(AUTOTOOLS_COMPONENTS),$(PPC_COMPONENTS)),$(eval $(call BUILD_COMPONENT,PPC,$comp)))
$(foreach comp,$(filter-out $(AUTOTOOLS_COMPONENTS),$(M68K_COMPONENTS)),$(eval $(call BUILD_COMPONENT,M68K,$comp)))

# Tool validation: Check for required tools
CHECK_TOOLS := $(foreach t,$(TOOLS) $(ARCHIVE_TOOLS),$(word 1,$(subst =, ,$(t))))
check_tools: $(CHECK_TOOLS)
$(CHECK_TOOLS): ; @command -v $($@) >/dev/null || { $(ECHO) "ERROR: Tool '$@' not found. Install on $(OS_NAME): $(if $(filter Linux,$(OS)),sudo apt install,$(if $(filter macOS,$(OS)),brew install)) $(subst ARCHIVE_,,$($@))"; exit 1; }

# Header check: Verify ncurses headers are available
$(TMPDIR)/check.c: | $(TMPDIR)
	$(ECHO) "#include <ncurses.h>\nint main(){return 0;}" > $@
check_headers: check_tools $(TMPDIR)/check.c
	$(CC) $(TMPDIR)/check.c -o /dev/null || { $(ECHO) "ERROR: Missing ncurses headers. Install on $(OS_NAME): $(if $(filter Linux,$(OS)),sudo apt install libncurses-dev,$(if $(filter macOS,$(OS)),brew install ncurses))"; exit 1; }

# Check target: Validate setup before building
check: check_headers
	@[ -f $(PPC_DOWNLOADS)/$(PPC_SDK).tar.gz ] || { $(ECHO) "WARNING: $(PPC_SDK).tar.gz not found in $(PPC_DOWNLOADS). Download from http://www.hyperion-entertainment.com/"; }
	@[ -f $(M68K_DOWNLOADS)/$(M68K_NDK).tar.gz ] || { $(ECHO) "WARNING: $(M68K_NDK).tar.gz not found in $(M68K_DOWNLOADS). Download from https://aminet.net/dev/misc/$(M68K_NDK).tar.gz"; }
	@$(ECHO) "Setup check complete. Run 'make ppc' or 'make m68k' to build."

# Main targets: Build PPC and M68K toolchains
ppc: $(addprefix $(PPC_STAMPS)/,$(PPC_COMPONENTS)) | check_headers
	@[ -f $(PPC_DOWNLOADS)/$(PPC_SDK).tar.gz ] || { $(ECHO) "ERROR: $(PPC_SDK).tar.gz not found in $(PPC_DOWNLOADS). Download from http://www.hyperion-entertainment.com/"; exit 1; }
	$(ECHO) "PPC toolchain built successfully."
m68k: $(addprefix $(M68K_STAMPS)/,$(M68K_COMPONENTS)) | check_headers
	@[ -f $(M68K_DOWNLOADS)/$(M68K_NDK).tar.gz ] || { $(ECHO) "ERROR: $(M68K_NDK).tar.gz not found in $(M68K_DOWNLOADS). Download from https://aminet.net/dev/misc/$(M68K_NDK).tar.gz"; exit 1; }
	$(ECHO) "M68K toolchain built successfully."

# Help target: Display toolchain info, file status, and URLs
help: check_tools
	$(ECHO) "=== AmigaOS Cross-Compilation Toolchain ==="
	$(ECHO) "OS: $(OS_NAME) $(OS_SUBTYPE)"
	$(ECHO) "Prefix: $(PREFIX)"
	$(ECHO) "Libs: $(if $(filter 1,$(ENABLE_STATIC)),Static,Shared)"
	$(ECHO) "Storage: PPC ~1.5GB (build), ~0.8GB (installed); M68K ~1.0GB (build), ~0.4GB (installed)"
	$(ECHO) "See versions.mk for component-specific storage estimates."
	$(ECHO) "=== PPC Notes ==="
	@[ -f $(PPC_DOWNLOADS)/$(PPC_SDK).tar.gz ] && $(ECHO) "  Found $(PPC_SDK).tar.gz" || $(ECHO) "  Missing $(PPC_SDK).tar.gz; download from http://www.hyperion-entertainment.com/"
	$(ECHO) "=== M68K Notes ==="
	@[ -f $(M68K_DOWNLOADS)/$(M68K_NDK).tar.gz ] && $(ECHO) "  Found $(M68K_NDK).tar.gz" || $(ECHO) "  Missing $(M68K_NDK).tar.gz; download from https://aminet.net/dev/misc/$(M68K_NDK).tar.gz"
	$(ECHO) "=== Files ==="
	$(foreach pkg,$(sort $(DOWNLOAD_FILES)),$(eval _f := $(wildcard $(DOWNLOADS)/$pkg $(PPC_DOWNLOADS)/$pkg $(M68K_DOWNLOADS)/$pkg $(BUILD)/$pkg $(PPC_BUILD)/$pkg $(M68K_BUILD)/$pkg))$(if $(_f),$(info _"\t$pkg ($(_f)))))
	@[ -f $(PPC_DOWNLOADS)/$(PPC_SDK).tar.gz ] && $(info _"\t$(PPC_SDK).tar.gz ($(PPC_DOWNLOADS))")
	@[ -f $(M68K_DOWNLOADS)/$(M68K_NDK).tar.gz ] && $(info _"\t$(M68K_NDK).tar.gz ($(M68K_DOWNLOADS))")
	$(ECHO) "=== URLs ==="
	@checked=0; up=0; down=0; \
	$(foreach pkg,$(URLS),$(call BUILD_PARSE_URL,$(pkg)); \
		$(if $(filter git,$(VERSION)), \
			$(if $(wildcard $(DOWNLOAD_DIR)/$$TARGET),, \
				$(if $(shell $(CURL) -sIL -m 3 $(URL) >/dev/null && echo OK), \
					$(ECHO) "$(URL) [OK]"); up=$$((up+1), \
					$(ECHO) "$(URL) [FAIL]"); down=$$((down+1))); \
				checked=$$((checked+1))), \
			$(if $(wildcard $(DOWNLOAD_DIR)/$$TARGET $(BUILD)/$$TARGET-$(VERSIONS[$$NAME]) $(BUILD)/$$TARGET),, \
				$(if $(shell $(CURL) -sIL -m 3 $$URL >/dev/null && echo OK), \
					$(info _"\t$$URL [OK]"); up=$$((up+1)), \
					$(info _"\t$$URL [FAIL]"); down=$$((down+1))); \
				checked=$$((checked+1)))))
	@[ $$checked -eq 0 ] && $(ECHO) "  All files are cached locally"
	$(ECHO) "URLs: checked=$$checked, up=$$up, down=$$down"
	$(ECHO) "=== Commands ==="
	$(ECHO) "make [all|check|ppc|m68k|clean|clean-download|debug_components|debug_rules|help]$(if $(ENABLE_STATIC),, ENABLE_STATIC=1 for static)"
	$(ECHO) "Start: Run 'make check' to validate, then 'make ppc' or 'make m68k'."