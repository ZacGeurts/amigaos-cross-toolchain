# Makefile - Cross-compilation toolchain build system for SDL and OpenGL (SDK)
# Copyright (c) 2025 Zachary Geurts, MIT License
# This Makefile uses defines.mk as the engine
# platform/<platform>.mk defines versions and builds.
# Early build estimates require 2GB RAM, 2GHz Pentium-4ish, and 500GB free disk space recommended.
# Builds may take days on low-spec systems.

# platform/<platform>.mk must specify exact, tested versions for all components.
# Prefer stable versions, even if older, ideally from the same era as the target platform.
# If a download fails, update the url in your platform file or place the file in ./download/<platform>.

DISPLAY_AS_LOG ?= 0
ENABLE_STATIC ?= 0
include defines.mk

# Configuration flags: Component-specific configure options
CONFIG_FLAGS[bison] := --disable-nls
CONFIG_FLAGS[flex] := --disable-nls
CONFIG_FLAGS[gawk] := --disable-extensions
CONFIG_FLAGS[gcc] := --disable-nls --enable-languages=c,c++ --disable-libstdcxx-pch --disable-tls
CONFIG_FLAGS[m4] := CFLAGS="-Wno-error" --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX)
CONFIG_FLAGS[mpc] := --with-gmp=$(PREFIX)
CONFIG_FLAGS[mpfr] := --with-gmp=$(PREFIX)
CONFIG_FLAGS[texinfo] := --disable-perl-api

# Static/shared library flags
STATIC_FLAGS := $(if $(filter 1,$(ENABLE_STATIC)),--enable-static --disable-shared,--enable-shared --disable-static)

# Dependencies: Build dependencies for components
DEPEND[autoconf] := m4
DEPEND[automake] := autoconf
DEPEND[binutils] := automake
DEPEND[bison] := m4
DEPEND[clib2] := gcc
DEPEND[gcc] := binutils mpc mpfr gmp
DEPEND[libdebug] := vbcc-bin
DEPEND[libnix] := vbcc-bin
DEPEND[libtool] := autoconf
DEPEND[mpc] := mpfr
DEPEND[mpfr] := gmp
DEPEND[texinfo] := automake
DEPEND[sdl] := opengl
DEPEND[sdl2] := opengl opengles

# Tools: Define build and archive tools
TOOLS := CC=gcc CXX=g++ MAKE=make CURL=curl PATCH=patch BISON=bison FLEX=flex SVN=svn GIT=git PERL=perl GPERF=gperf YACC=yacc HELP2MAN=help2man AUTOPOINT=autopoint
ARCHIVE_TOOLS := GZIP=gzip BZIP2=bzip2 XZ=xz LHA=lha 7Z=7z

# Archive tool fallbacks
ARCHIVE_TOOL_LHA := $(shell command -v lhasa || echo lha)
ARCHIVE_TOOL_7Z := $(shell command -v 7z || echo 7z)

# Autotools components
AUTOTOOLS_COMPONENTS := autoconf automake bison flex busybox expat gawk gmp libbz2 libffi libiconv giflib libintl libjpeg libmpg123 libogg libpng libsndfile libtheora libvorbis libxml2 m4 make mpc mpfr pkg-config texinfo zlib

# OS detection: Handle host OS-specific commands
OS := $(shell uname -s)
OS_NAME := $(if $(filter Linux,$(OS)),Linux,$(if $(filter Darwin,$(OS)),macOS,$(if $(filter Windows_NT,$(OS)),Windows,Unknown)))
SHELL := $(if $(filter Windows_NT,$(OS)),cmd.exe,/bin/sh)
MKDIR := $(if $(filter Windows_NT,$(OS)),mkdir,mkdir -p)
CP := $(if $(filter Windows_NT,$(OS)),copy /Y,cp -r)
RM := $(if $(filter Windows_NT,$(OS)),del /Q,rm -rf)
TOUCH := $(if $(filter Windows_NT,$(OS)),echo. >,touch)
CHMOD := $(if $(filter Windows_NT,$(OS)),attrib,chmod)
PATHSEP := $(if $(filter Windows_NT,$(OS)),\\,/)
ECHO := $(if $(filter Windows_NT,$(OS)),echo,echo)
TIMESTAMP := $(shell $(if $(filter Windows_NT,$(OS)),time /T,date +%H:%M:%S))
DATE := $(if $(filter Windows_NT,$(OS)),date /T,date +%Y-%m-%d)

# Directories: Define paths for build, install, download, and log directories
TOP := $(abspath .)
DOWNLOAD := $(TOP)/download
BUILD := $(TOP)/build
LOGS := $(TOP)/logs
SOURCES := $(BUILD)/sources
STAMPS := $(BUILD)/stamps
TMPDIR := $(BUILD)/tmp

# Error and message tracking
FIRST_ERROR ?=
RECENT_ERROR ?=
LAST_MESSAGE ?=

# List supported platforms by scanning platform/*.mk files
PLATFORMS := $(patsubst platform/%.mk,%,$(wildcard platform/*.mk))

.DEFAULT_GOAL := help
.PHONY: check clean debug_components debug_rules help check_headers check_tools

# Help target
help:
	$(call LOG_MESSAGE,=== Cross-Compilation Toolchain for SDL and OpenGL SDK ===)
	$(ECHO) "Host OS: $(OS_NAME)"
	$(ECHO) "Build Directory: $(BUILD)"
	$(ECHO) "Download Directory: $(DOWNLOAD)"
	$(ECHO) "Log Directory: $(LOGS)"
	$(ECHO) "Library Type: $(if $(filter 1,$(ENABLE_STATIC)),Static,Shared)"
	$(ECHO) "=== Configuration ==="
	$(ECHO) "PLATFORM variable must be set, e.g., make PLATFORM=amigaos-ppc"
	$(ECHO) "Supported platforms: $(PLATFORMS)"
	$(ECHO) "Define exact versions and build rules in platform/<platform>.mk"
	$(ECHO) "DISPLAY_AS_LOG: $(if $(filter 1,$(DISPLAY_AS_LOG)),Output to screen only (no logs),Output to logs/summary.log and logs/<component>.log only)"
	$(ECHO) "=== Status ==="
	$(ECHO) "First Error: $(if $(FIRST_ERROR),$(FIRST_ERROR),None)"
	$(ECHO) "Recent Error: $(if $(RECENT_ERROR),$(RECENT_ERROR),None)"
	$(ECHO) "Last Message: $(if $(LAST_MESSAGE),$(LAST_MESSAGE),None)"
	$(ECHO) "=== Commands ==="
	$(ECHO) "  make [check|clean|debug_components|debug_rules|help]$(if $(ENABLE_STATIC),, ENABLE_STATIC=1 for static)"
	$(ECHO) "  Build toolchain: make PLATFORM=<platform>"
	$(ECHO) "  Override: make PLATFORM=<platform> PREFIX=/custom/path DISPLAY_AS_LOG=1"
	$(ECHO) "  Start: Run 'make check' to validate, then 'make PLATFORM=<platform>' to build."
	$(call LOG_MESSAGE,Help command executed. $(if $(filter 0,$(DISPLAY_AS_LOG)),See $(LOGS)/summary.log for details,Output displayed on screen))

# Platform configuration
ifneq ($(MAKECMDGOALS),$(filter help check clean debug_components debug_rules,$(MAKECMDGOALS)))
ifndef PLATFORM
$(error PLATFORM variable must be set, e.g., make PLATFORM=amigaos-ppc)
endif
include platform/$(PLATFORM).mk
endif

# Cache VERSIONS entries for efficiency
$(foreach comp,$(filter VERSIONS[%],$(.VARIABLES)),$(eval URL_$(patsubst VERSIONS[%,%,$(subst ],,$(comp))) := $(value $(comp))))

# Targets: Dynamically extract target systems from platform/*.mk
TARGETS := $(PLATFORMS)

# Target-specific variables
$(foreach target,$(TARGETS),\
	$(eval $(target)_TARGET := $(if $(filter amigaos-ppc amigaos-m68k,$(target)),$(subst amigaos-,,$(target))-amigaos,$(target)))\
	$(eval $(target)_BUILD := $(BUILD)/$(target))\
	$(eval $(target)_DOWNLOAD := $(DOWNLOAD)/$(target))\
	$(eval $(target)_PREFIX := $(if $(PREFIX),$(PREFIX)/$(target),$(BUILD)/install/$(target)))\
	$(eval $(target)_STAMPS := $(STAMPS)/$(target))\
	$(eval $(target)_COMPONENTS := $(sort $(foreach comp,$(filter VERSIONS[%],$(.VARIABLES)),$(if $(filter $(target),$(word 5,$(subst =, ,$(value $(comp))))),$(patsubst VERSIONS[%,%,$(subst ],,$(comp))))))))

# Validate components: Ensure defined components have VERSIONS entries
$(foreach target,$(TARGETS),\
	$(foreach comp,$($(target)_COMPONENTS),\
		$(if $(VERSIONS[$(comp)]),,$(error ERROR: Version for component '$(comp)' not defined in platform/$(target).mk))))

# Target-specific dependency mapping
$(foreach target,$(TARGETS),\
	$(foreach comp,$($(target)_COMPONENTS),\
		$(eval DEPEND_$(target)_$(comp) := $(foreach dep,$(DEPEND[$(comp)]),$(if $(filter $(dep),$($(target)_COMPONENTS)),$(dep))))))

# Apply tool definitions
$(foreach t,$(TOOLS) $(ARCHIVE_TOOLS),$(eval $(word 1,$(subst =, ,$(t))) := $(word 2,$(subst =, ,$(t)))))

.PHONY: $(TARGETS)

# Clean target to prompt before removing build, prefix, and logs directories
clean:
	@$(ECHO) "WARNING: 'make clean' will remove all files in $(BUILD), $(if $(PREFIX),$(PREFIX),<no prefix set>), and $(LOGS)."; \
	$(ECHO) "Proceed? [y/n]"; \
	read -r answer; \
	if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then \
		$(RM) $(BUILD) $(if $(PREFIX),$(PREFIX)) "$(LOGS)"; \
		$(call LOG_MESSAGE,Cleaned build, prefix, and logs directories); \
	else \
		$(call LOG_MESSAGE,Aborted clean operation, no directories removed); \
		exit 1; \
	fi

# Directory creation
DIRS := $(BUILD) $(DOWNLOAD) $(LOGS) $(SOURCES) $(STAMPS) $(TMPDIR) $(foreach target,$(TARGETS),$($(target)_BUILD) $($(target)_DOWNLOAD) $($(target)_PREFIX) $($(target)_STAMPS))
$(DIRS):
	$(MKDIR) $@
	$(call LOG_MESSAGE,Created directory $@)

# Download rules
URLS := $(foreach comp,$(filter VERSIONS[%],$(.VARIABLES)),$(subst VERSIONS[,,$(subst ],,$(comp))=$(value $(comp))))
DOWNLOAD_FILES := $(foreach pkg,$(URLS),$(call FIND_COMPONENT_FILE,$(word 1,$(subst =, ,$(pkg))),$(word 5,$(subst =, ,$(pkg)))))
$(DOWNLOAD)/%: | $(LOGS)
	$(call FETCH_SOURCE,$(filter %=$*,$(URLS)),$(DOWNLOAD))
$(foreach target,$(TARGETS),$(eval $($(target)_DOWNLOAD)/%: | $($(target)_DOWNLOAD)
	$(call FETCH_SOURCE,$(filter %=$*,$(URLS)),$($(target)_DOWNLOAD))))
$(DOWNLOAD)/.downloaded: $(filter $(DOWNLOAD)/%,$(DOWNLOAD_FILES)) | $(DOWNLOAD)
	$(TOUCH) $@
	$(call LOG_MESSAGE,Marked $(DOWNLOAD) as processed)
$(foreach target,$(TARGETS),$(eval $($(target)_DOWNLOAD)/.downloaded: $(filter $($(target)_DOWNLOAD)/%,$(DOWNLOAD_FILES)) | $($(target)_DOWNLOAD) $(TOUCH) $@ $(call LOG_MESSAGE,Marked $($(target)_DOWNLOAD) as processed)))

# Debug targets
debug_components:
	$(call LOG_MESSAGE,Listing components)
	$(foreach target,$(TARGETS),$(ECHO) "$(target) components: $($(target)_COMPONENTS)")
debug_rules:
	$(call LOG_MESSAGE,Listing generated rules)
	$(foreach target,$(TARGETS),$(ECHO) "$(target) rules:";$(foreach comp,$($(target)_COMPONENTS),$(ECHO) "  $(comp): $($(target)_STAMPS)/$(comp)"))

# Apply rules
$(foreach target,$(TARGETS),$(foreach comp,$(filter $(AUTOTOOLS_COMPONENTS),$($(target)_COMPONENTS)),$(eval $(call BUILD_AUTOTOOLS_RULE,$(target),$(comp)))))
$(foreach target,$(TARGETS),$(foreach comp,$(filter-out $(AUTOTOOLS_COMPONENTS),$($(target)_COMPONENTS)),$(eval $(call BUILD_COMPONENT,$(target),$(comp)))))

# Tool validation
CHECK_TOOLS := $(subst :, ,$(TOOLS) $(ARCHIVE_TOOLS)) lhasa
$(CHECK_TOOLS):
	@command -v $@ >/dev/null || { $(call LOG_ERROR,Tool '$@' not found. Install on $(OS_NAME): $(if $(filter Linux,$(OS)),sudo apt-get install $(subst ARCHIVE_,,$@),$(if $(filter macOS,$(OS)),brew install $(subst ARCHIVE_,,$@),$(subst ARCHIVE_,,$@)))); exit 2; }

# Header check
$(TMPDIR)/check.c: | $(TMPDIR)
	$(ECHO) "#include <ncurses.h>\nint main() { return 0; }" > $@
	$(call LOG_MESSAGE,Created test file $@)
check_headers: check_tools $(TMPDIR)/check.c
	$(CC) $(TMPDIR)/check.c -o /dev/null && $(call LOG_MESSAGE,ncurses headers verified) || \
	{ $(call LOG_ERROR,Missing ncurses headers. Install on $(OS_NAME): $(if $(filter Linux,$(OS)),sudo apt-get install libncurses-dev,$(if $(filter macOS,$(OS)),brew install ncurses,libncurses))); exit 2; }

# Check target
check: check_headers
	$(call LOG_MESSAGE,Setup check completed. Run 'make check' or 'make PLATFORM=<platform>' to build.)

# Main targets
$(TARGETS): %: $(addprefix %_%_STAMPS/,$(%_COMPONENTS)) | check_headers
	$(call LOG_MESSAGE,Successfully built $@ toolchain)