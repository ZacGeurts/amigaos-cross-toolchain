# steamlink.mk
# Platform-specific versions and build rules for Steam Link cross-compiling
# Copyright (c) 2025 Zachary Geurts, MIT License
#
# platform/<platform>.mk
# Available variables for defining VERSIONS and BUILD_ entries:
#
# Global Variables (from Makefile):
# - PREFIX: Installation path prefix (default: ./build/install/<platform>, override with make PREFIX=/custom/path).
# - DISPLAY_AS_LOG: 0 to write to logs/*.log only, 1 to output to screen only (default: 0).
# - ENABLE_STATIC: 0 for shared libraries, 1 for static (default: 0).
# - STATIC_FLAGS: Set to --enable-static --disable-shared if ENABLE_STATIC=1, else --enable-shared --disable-static.
# - OS: Host OS (e.g., Linux, Darwin, Windows_NT).
# - OS_NAME: Friendly OS name (e.g., Linux, macOS, Windows, Unknown).
# - TOP: Absolute path to project root.
# - BUILD: Build directory (./build).
# - DOWNLOAD: Download directory (./download).
# - LOGS: Log directory (./logs).
# - SOURCES: Source directory (./build/sources).
# - STAMPS: Stamp directory (./build/stamps).
# - TMPDIR: Temporary directory (./build/tmp).
#
# Target-Specific Variables (for PLATFORM=<platform>):
# - $(PLATFORM)_TARGET: Target system name (e.g., ppc-amigaos for amigaos-ppc).
# - $(PLATFORM)_BUILD: Platform build directory (./build/<platform>).
# - $(PLATFORM)_DOWNLOAD: Platform download directory (./download/<platform>).
# - $(PLATFORM)_PREFIX: Platform install prefix (PREFIX/<platform> or ./build/install/<platform>).
# - $(PLATFORM)_STAMPS: Platform stamp directory (./build/stamps/<platform>).
# - $(PLATFORM)_COMPONENTS: List of components defined by VERSIONS for this platform.
#
# Tool Variables (from Makefile TOOLS and ARCHIVE_TOOLS):
# - CC: C compiler (gcc).
# - CXX: C++ compiler (g++).
# - MAKE: Make command (make).
# - CURL: Download tool (curl).
# - PATCH: Patch tool (patch).
# - BISON: Bison parser generator (bison).
# - FLEX: Lexical analyzer generator (flex).
# - SVN: Subversion client (svn).
# - GIT: Git client (git).
# - PERL: Perl interpreter (perl).
# - GPERF: Perfect hash function generator (gperf).
# - YACC: Parser generator (yacc).
# - HELP2MAN: Manual page generator (help2man).
# - AUTOPOINT: Gettext internationalization tool (autopoint).
# - GZIP: Gzip decompressor (gzip).
# - BZIP2: Bzip2 decompressor (bzip2).
# - XZ: XZ decompressor (xz).
# - LHA: LHA archiver (lha or lhasa).
# - 7Z: 7z archiver (7z).
# - ARCHIVE_TOOL_LHA: LHA tool fallback (lhasa if available, else lha).
# - ARCHIVE_TOOL_7Z: 7z tool fallback (7z).
#
# OS-Specific Commands (from Makefile):
# - SHELL: Shell for commands (cmd.exe on Windows, /bin/sh elsewhere).
# - MKDIR: Directory creation (mkdir on Windows, mkdir -p elsewhere).
# - CP: Copy command (copy /Y on Windows, cp -r elsewhere).
# - RM: Remove command (del /Q on Windows, rm -rf elsewhere).
# - TOUCH: File touch command (echo. > on Windows, touch elsewhere).
# - CHMOD: Permission change (attrib on Windows, chmod elsewhere).
# - PATHSEP: Path separator (\ on Windows, / elsewhere).
# - ECHO: Echo command (echo on Windows, echo elsewhere).
# - TIMESTAMP: Current time (time /T on Windows, date +%H:%M:%S elsewhere).
# - DATE: Current date (date /T on Windows, date +%Y-%m-%d elsewhere).
#
# Configuration Flags (from Makefile, for ./configure):
# - CONFIG_FLAGS[component]: Component-specific configure options, e.g.:
#   - CONFIG_FLAGS[bison]: --disable-nls
#   - CONFIG_FLAGS[flex]: --disable-nls
#   - CONFIG_FLAGS[gawk]: --disable-extensions
#   - CONFIG_FLAGS[gcc]: --disable-nls --enable-languages=c,c++ --disable-libstdcxx-pch --disable-tls
#   - CONFIG_FLAGS[m4]: CFLAGS="-Wno-error" --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX)
#   - CONFIG_FLAGS[mpc]: --with-gmp=$(PREFIX)
#   - CONFIG_FLAGS[mpfr]: --with-gmp=$(PREFIX)
#   - CONFIG_FLAGS[texinfo]: --disable-perl-api
#
# Logging and Progress (from defines.mk):
# - CURRENT_TIMESTAMP: Current time for log messages (format depends on OS).
# - LOG_MESSAGE: Macro to log messages (to logs/summary.log if DISPLAY_AS_LOG=0, to screen if DISPLAY_AS_LOG=1).
# - LOG_ERROR: Macro to log errors (to logs/summary.log if DISPLAY_AS_LOG=0, to screen if DISPLAY_AS_LOG=1).
# - PROGRESS_TICKER: Starts progress ticker (Linux/macOS only, logs every 60s to logs/summary.log or screen).
# - STOP_TICKER: Stops progress ticker.
#
# Expected Platform Definitions:
# - VERSIONS[component]: Format: version=url=filename=platform (e.g., VERSIONS[zlib]=1.2.11=https://zlib.net/zlib-1.2.11.tar.gz=zlib-1.2.11.tar.gz=amigaos-ppc).
# - BUILD_component: Format: custom:<build commands> (e.g., BUILD_zlib=custom:cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) && $(MAKE) && $(MAKE) install).
#
# Notes:
# - Use $(PLATFORM)_PREFIX, $(PLATFORM)_BUILD, etc., for platform-specific paths in BUILD_ commands.
# - Variables defined locally in this file are not visible to versions.mk or Makefile.
# - See versions.mk for fallback VERSIONS and BUILD_ entries.
# - Use the internet to find stable component versions for your platform.