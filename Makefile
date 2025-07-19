# Makefile
#AI: Cross-compilation toolchain for SDL/OpenGL SDK, (c) 2025 Zachary Geurts, MIT License
#AI: Uses defines.mk for macros, platform/<platform>.mk for versions/builds
#AI: Run 'make <platform>' (e.g., 'make m68k-amigaos') to build; see 'make help' for platforms
#AI: Requires 2GB RAM, 2GHz CPU, 500GB disk; may take days on low-spec systems
#AI: On download failure, place file in ./download/<platform> or update platform/<platform>.mk URL
#AI: On critical error, o7_CENTER_ERROR dumps status with "o7" salute to logs/o7_center_*.log
# Makefile requires tabs not spaces. If the AI gives you four spaces to indent, find and replace with tab.
# This includes all .mk files. Error looks like Makefile:XXX: *** missing separator.  Stop.
DISPLAY_AS_LOG?=0
ENABLE_STATIC?=0
include defines.mk
CONFIG_FLAGS[bison]:=--disable-nls
CONFIG_FLAGS[flex]:=--disable-nls
CONFIG_FLAGS[gawk]:=--disable-extensions
CONFIG_FLAGS[gcc]:=--disable-nls --enable-languages=c,c++ --disable-libstdcxx-pch --disable-tls
CONFIG_FLAGS[m4]:=CFLAGS="-Wno-error" --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX)
CONFIG_FLAGS[mpc]:=--with-gmp=$(PREFIX)
CONFIG_FLAGS[mpfr]:=--with-gmp=$(PREFIX)
CONFIG_FLAGS[texinfo]:=--disable-perl-api
STATIC_FLAGS:=$(if $(filter 1,$(ENABLE_STATIC)),--enable-static --disable-shared,--enable-shared --disable-static)
DEPEND[autoconf]:=m4
DEPEND[automake]:=autoconf
DEPEND[binutils]:=automake
DEPEND[bison]:=m4
DEPEND[clib2]:=gcc
DEPEND[curl]:=zlib
DEPEND[gcc]:=binutils mpc mpfr gmp
DEPEND[libdebug]:=vbcc-bin
DEPEND[libnix]:=vbcc-bin
DEPEND[libtool]:=autoconf
DEPEND[libpng]:=zlib
DEPEND[libvorbis]:=libogg
DEPEND[mpc]:=mpfr
DEPEND[mpfr]:=gmp
DEPEND[p7zip]:=libbz2
DEPEND[sdl]:=opengl
DEPEND[sdl2]:=opengl
DEPEND[sdl_image]:=sdl2 libpng
DEPEND[sdl-test]:=sdl
DEPEND[quake]:=sdl opengl
DEPEND[scummvm]:=sdl
DEPEND[amimodplayer]:=sdl libvorbis
DEPEND[texinfo]:=automake
TOOLS:=CC=gcc CXX=g++ MAKE=make CURL=curl PATCH=patch BISON=bison FLEX=flex SVN=svn GIT=git PERL=perl GPERF=gperf YACC=yacc HELP2MAN=help2man AUTOPOINT=autopoint
ARCHIVE_TOOLS:=GZIP=gzip BZIP2=bzip2 XZ=xz LHA=lha 7Z=7z
ARCHIVE_TOOL_LHA:=$(shell command -v lhasa || echo lha)
ARCHIVE_TOOL_7Z:=$(shell command -v 7z || echo 7z)
AUTOTOOLS_COMPONENTS:=autoconf automake bison flex busybox expat gawk gmp libbz2 libffi libiconv libintl libjpeg libmpg123 libogg libpng libsndfile libtheora libvorbis libxml2 m4 make mpc mpfr pkg-config texinfo zlib
OS:=$(shell uname -s)
OS_NAME:=$(if $(filter Linux,$(OS)),Linux,$(if $(filter Darwin,$(OS)),macOS,$(if $(filter Windows_NT,$(OS)),Windows,Unknown)))
SHELL:=$(if $(filter Windows_NT,$(OS)),cmd.exe,/bin/sh)
MKDIR:=$(if $(filter Windows_NT,$(OS)),mkdir,mkdir -p)
CP:=$(if $(filter Windows_NT,$(OS)),copy /Y,cp -r)
RM:=$(if $(filter Windows_NT,$(OS)),del /Q,rm -rf)
TOUCH:=$(if $(filter Windows_NT,$(OS)),echo. >,touch)
CHMOD:=$(if $(filter Windows_NT,$(OS)),attrib,chmod)
PATHSEP:=$(if $(filter Windows_NT,$(OS)),\\,/)
ECHO:=$(if $(filter Windows_NT,$(OS)),echo,echo)
TIMESTAMP:=$(shell $(if $(filter Windows_NT,$(OS)),time /T,date +%H:%M:%S))
DATE:=$(shell $(if $(filter Windows_NT,$(OS)),date /T,date +%Y-%m-%d))
TOP:=$(abspath .)
DOWNLOAD:=$(TOP)/download
BUILD:=$(TOP)/build
LOGS:=$(TOP)/logs
SOURCES:=$(BUILD)/sources
STAMPS:=$(BUILD)/stamps
TMPDIR:=$(BUILD)/tmp
FIRST_ERROR?=
RECENT_ERROR?=
LAST_MESSAGE?=
PLATFORMS:=$(patsubst platform/%.mk,%,$(wildcard platform/*.mk))
TARGETS:=$(PLATFORMS)
.DEFAULT_GOAL:=help
.PHONY: check clean debug_components debug_rules help check_headers check_tools show_status init_help init_build generate_download_rules $(PLATFORMS)

# Cache version information in global scope
$(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(eval URL_$(patsubst VERSIONS[%,%,$(subst ],,$(c))):=$(value $(c))))

# Lightweight initialization for help target
init_help:
	$(foreach t,$(TARGETS),\
		$(eval $(t)_COMPONENTS:=$(sort $(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(if $(filter $(t),$(word 5,$(subst =, ,$(value $(c))))),$(patsubst VERSIONS[%,%,$(subst ],,$(c))))))) \
		$(if $($(t)_COMPONENTS),,$(call LOG_MESSAGE,Warning: No components defined for $(t) in platform/$(t).mk)))

# Initialization for build targets
init_build:
	$(foreach t,$(TARGETS),\
		$(eval $(t)_TARGET:=$(if $(filter ppc-amigaos m68k-amigaos,$(t)),$(subst -amigaos,,$(t))-amigaos,$(t))) \
		$(eval $(t)_BUILD:=$(BUILD)/$(t)) \
		$(eval $(t)_DOWNLOAD:=$(DOWNLOAD)/$(t)) \
		$(eval $(t)_PREFIX:=$(if $(PREFIX),$(PREFIX)/$(t),$(BUILD)/install/$(t))) \
		$(eval $(t)_STAMPS:=$(STAMPS)/$(t)) \
		$(eval $(t)_COMPONENTS:=$(sort $(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(if $(filter $(t),$(word 5,$(subst =, ,$(value $(c))))),$(patsubst VERSIONS[%,%,$(subst ],,$(c))))))) \
		$(call LOG_MESSAGE,Set target vars for platform: $(t)))
	$(foreach t,$(TARGETS),$(foreach c,$($(t)_COMPONENTS),$(if $(VERSIONS[$(c)]),,$(call LOG_ERROR,No version for '$(c)' in platform/$(t).mk))))
	$(foreach t,$(TARGETS),$(foreach c,$($(t)_COMPONENTS),$(eval DEPEND_$(t)_$(c):=$(foreach d,$(DEPEND[$c]),$(if $(filter $(d),$($(t)_COMPONENTS)),$(d))))))
	$(foreach t,$(TARGETS),$(eval $($(t)_DOWNLOAD)/% : | $($(t)_DOWNLOAD)\n\t$$(call o7_CENTER,download,=$$*,critical)\n\t$$(call FETCH_SOURCE,$$(filter %=$$*,$$(URLS)),$($(t)_DOWNLOAD))\n\t$$(call STOP_o7)))
	$(foreach t,$(TARGETS),$(eval $(t)_DOWNLOAD/.downloaded : $(filter $($(t)_DOWNLOAD)/%,$(DOWNLOAD_FILES)) | $($(t)_DOWNLOAD)\n\t$$(TOUCH) $$@\n\t$$(call LOG_MESSAGE,Marked $($(t)_DOWNLOAD) processed)))
	$(foreach t,$(TARGETS),$(foreach c,$(filter $(AUTOTOOLS_COMPONENTS),$($(t)_COMPONENTS)),$(eval $(call BUILD_AUTOTOOLS_RULE,$(t),$(c)))))
	$(foreach t,$(TARGETS),$(foreach c,$(filter-out $(AUTOTOOLS_COMPONENTS),$($(t)_COMPONENTS)),$(eval $(call BUILD_COMPONENT,$(t),$(c)))))

# Status report target
show_status: init_build
	@$(call o7_CENTER,show_status,non-critical)
	@$(MKDIR) "$(LOGS)"
	@$(ECHO) "[$(TIMESTAMP)] Status Report" >> "$(LOGS)/summary.log"
	@$(ECHO) ""
	@$(ECHO) "Status:"
	@$(ECHO) "  First Error:	$(if $(FIRST_ERROR),$(FIRST_ERROR),None)"
	@$(ECHO) "  Recent Error:   $(if $(RECENT_ERROR),$(RECENT_ERROR),None)"
	@$(ECHO) "  Last Message:   $(if $(LAST_MESSAGE),$(LAST_MESSAGE),None)"
	@$(ECHO) "[$(TIMESTAMP)] Status displayed. $(if $(filter 0,$(DISPLAY_AS_LOG)),See $(LOGS)/summary.log,Screen output)"
	@$(call STOP_o7)

# Help target
help: init_help
	@$(call o7_CENTER,help,non-critical)
	@$(MKDIR) "$(LOGS)"
	@$(ECHO) "[$(TIMESTAMP)] Cross-Compilation Toolchain for SDL/OpenGL SDK" >> "$(LOGS)/summary.log"
	@$(ECHO) ""
	@$(ECHO) "Cross-Compilation Toolchain for SDL/OpenGL SDK"
	@$(ECHO) "=============================================="
	@$(ECHO) "Host OS:		$(OS_NAME)"
	@$(ECHO) "Build Dir:	  $(BUILD)"
	@$(ECHO) "Download Dir:   $(DOWNLOAD)"
	@$(ECHO) "Log Dir:		$(LOGS)"
	@$(ECHO) "Lib Type:	   $(if $(filter 1,$(ENABLE_STATIC)),Static,Shared)"
	@$(ECHO) ""
	@$(ECHO) "Supported Platforms:	$(PLATFORMS)"
	@$(ECHO) ""
	@$(ECHO) "Usage:"
	@$(ECHO) "  make <platform>		 Build toolchain for <platform> (e.g., 'make m68k-amigaos')"
	@$(ECHO) "  make check			  Verify tools and headers"
	@$(ECHO) "  make clean			  Remove build, logs, and prefix (with confirmation)"
	@$(ECHO) "  make debug_components   List components per platform"
	@$(ECHO) "  make debug_rules		List build rules per platform"
	@$(ECHO) ""
	@$(ECHO) "Options:"
	@$(ECHO) "  DISPLAY_AS_LOG=1		Output to screen only (default: logs to $(LOGS)/summary.log)"
	@$(ECHO) "  ENABLE_STATIC=1		 Build static libraries (default: shared)"
	@$(ECHO) "  PREFIX=/custom/path	 Set custom install prefix"
	@$(ECHO) ""
	@$(ECHO) "Status:"
	@$(ECHO) "  First Error:	$(if $(FIRST_ERROR),$(FIRST_ERROR),None)"
	@$(ECHO) "  Recent Error:   $(if $(RECENT_ERROR),$(RECENT_ERROR),None)"
	@$(ECHO) "  Last Message:   $(if $(LAST_MESSAGE),$(LAST_MESSAGE),None)"
	@$(ECHO) ""
	@$(ECHO) "Notes:"
	@$(ECHO) "  - Define components in platform/<platform>.mk with VERSIONS[component]=version url target platform"
	@$(ECHO) "  - Requires 2GB RAM, 2GHz CPU, 500GB disk"
	@$(ECHO) "  - On download failure, place file in $(DOWNLOAD)/<platform> or update URL"
	@$(ECHO) "[$(TIMESTAMP)] Help executed. Platforms: $(PLATFORMS). $(if $(filter 0,$(DISPLAY_AS_LOG)),See $(LOGS)/summary.log,Screen output)"
	@$(call STOP_o7)

# Clean target
clean:
	@$(call o7_CENTER,clean,non-critical)
	@$(ECHO) "WARNING: 'make clean' removes $(BUILD), $(if $(PREFIX),$(PREFIX),<no prefix>), $(LOGS). Proceed? [y/n]"
	@$(if $(filter Windows_NT,$(OS)),\
		set /p answer= && if /i "!answer!"=="y" ( $(ECHO) "[$(TIMESTAMP)] Cleaned build, prefix, logs" >> "$(LOGS)/summary.log" && $(RM) $(BUILD) $(if $(PREFIX),$(PREFIX)) "$(LOGS)" ) else ( $(ECHO) "[$(TIMESTAMP)] Aborted clean" >> "$(LOGS)/summary.log" && exit /b 1 ),\
		read -r answer && if [ "$$answer" = "y" ] || [ "$$answer" = "Y" ]; then $(ECHO) "[$(TIMESTAMP)] Cleaned build, prefix, logs" >> "$(LOGS)/summary.log" && $(RM) $(BUILD) $(if $(PREFIX),$(PREFIX)) "$(LOGS)"; else $(ECHO) "[$(TIMESTAMP)] Aborted clean" >> "$(LOGS)/summary.log"; exit 1; fi)
	@$(call STOP_o7)

# Consolidated check target
check: init_build check_headers
	@$(call o7_CENTER,check,critical)
	$(call LOG_MESSAGE,Setup check done. Run 'make' or 'make <platform>')
	@$(call STOP_o7)

# Check headers target
check_headers:
	@$(call o7_CENTER,check_headers,critical)
	@if $(CC) $(TMPDIR)/check.c -o /dev/null; then $(ECHO) "[$(TIMESTAMP)] ncurses headers verified" >> "$(LOGS)/summary.log" && $(ECHO) "[$(TIMESTAMP)] ncurses headers verified"; else $(call LOG_ERROR,Missing ncurses headers. Install on $(OS_NAME): $(if $(filter Linux,$(OS)),sudo apt-get install libncurses-dev,$(if $(filter macOS,$(OS)),brew install libncurses,Consult your package manager for ncurses))); fi
	@$(call STOP_o7)

# Debug targets
debug_components: init_build
	@$(call o7_CENTER,debug_components,non-critical)
	$(call LOG_MESSAGE,Listing components)
	$(foreach t,$(TARGETS),$(ECHO) $(t) components: $($(t)_COMPONENTS))
	@$(call STOP_o7)

debug_rules: init_build
	@$(call o7_CENTER,debug_rules,non-critical)
	$(call LOG_MESSAGE,Listing rules)
	$(foreach t,$(TARGETS),$(ECHO) $(t) rules:;$(foreach c,$($(t)_COMPONENTS),$(ECHO) $(c): $(($t)_STAMPS)/$(c)))
	@$(call STOP_o7)

# Include platform-specific makefiles for valid platform targets
ifneq ($(MAKECMDGOALS),$(filter help check clean debug_components debug_rules check_headers check_tools show_status generate_download_rules,$(MAKECMDGOALS)))
ifneq ($(filter $(PLATFORMS),$(MAKECMDGOALS)),$(MAKECMDGOALS))
ifneq ($(MAKECMDGOALS),)
	$(call LOG_ERROR,Invalid target: $(MAKECMDGOALS). Use 'make <platform>' where <platform> is one of: $(PLATFORMS))
endif
endif
include platform/$(MAKECMDGOALS).mk
endif

# Define tool variables
$(foreach t,$(TOOLS) $(ARCHIVE_TOOLS),$(eval $(word 1,$(subst =, ,$(t))) := $(word 2,$(subst =, ,$(t)))))

# Directory creation rules
DIRS:=$(BUILD) $(DOWNLOAD) $(LOGS) $(SOURCES) $(STAMPS) $(TMPDIR) $(foreach t,$(TARGETS),$($(t)_BUILD) $($(t)_DOWNLOAD) $($(t)_PREFIX) $($(t)_STAMPS))
$(DIRS):
	@$(MKDIR) $@
	$(call LOG_MESSAGE,Created $@)

# URL and download file handling
URLS:=$(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(subst VERSIONS[,,$(subst ],,$(c))=$(value $(c))))
DOWNLOAD_FILES:=$(foreach p,$(URLS),$(call FIND_COMPONENT_FILE,$(word 1,$(subst =, ,$(p))),$(word 5,$(subst =, ,$(p)))))

$(DOWNLOAD)/%: | init_build $(LOGS)
	@$(call o7_CENTER,download,=$*,critical)
	$(call FETCH_SOURCE,$(filter %=$*,$(URLS)),$(DOWNLOAD))
	$(call STOP_o7)

$(DOWNLOAD)/.downloaded: init_build $(filter $(DOWNLOAD)/%,$(DOWNLOAD_FILES)) | $(DOWNLOAD)
	@$(TOUCH) $@
	$(call LOG_MESSAGE,Marked $(DOWNLOAD) processed)

# Debug download rules and files
$(info TARGETS: $(TARGETS))
$(info URLS: $(URLS))
$(info DOWNLOAD_FILES: $(DOWNLOAD_FILES))
$(info Generated Rules: $(foreach t,$(TARGETS),$($(t)_DOWNLOAD)/%:|$($(t)_DOWNLOAD)\n\t$$(call o7_CENTER,download,=$$*,critical)\n\t$$(call FETCH_SOURCE,$$(filter %=$$*,$$(URLS)),$($(t)_DOWNLOAD))\n\t$$(call STOP_o7)))

generate_download_rules: init_build
	$(call SET_DOWNLOADED_FILES)

# Tool checks
CHECK_TOOLS:=$(subst :, ,$(TOOLS) $(ARCHIVE_TOOLS)) lhasa
$(CHECK_TOOLS):
	@command -v $@ >/dev/null || { $(call LOG_ERROR,Tool '$@' missing. Install on $(OS_NAME): $(if $(filter Linux,$(OS)),sudo apt-get install $(subst ARCHIVE_,,$@),$(if $(filter macOS,$(OS)),brew install $(subst ARCHIVE_,,$@),$(subst ARCHIVE_,,$@)))); exit 2; }

# Create check.c for header verification
$(TMPDIR)/check.c: | $(TMPDIR)
	@$(ECHO) "#include <ncurses.h>\nint main() { return 0; }" > $@
	$(call LOG_MESSAGE,Created $@)

# Platform build rules
$(TARGETS): %: init_build $(addprefix %_%/,$(%_COMPONENTS)) | check_headers
	@$(call o7_CENTER,build_%,critical)
	$(call LOG_MESSAGE,Built $@ toolchain)
	$(call STOP_o7)