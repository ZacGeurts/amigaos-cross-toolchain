# amigaos-m68k.mk
# Platform-specific versions and build rules for AmigaOS M68K cross-compiling
# Copyright (c) 2025 Zachary Geurts, MIT License

# Versions: VERSIONS[component]=version=url=filename=platform
VERSIONS[autoconf]=2.72=https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz=autoconf-2.72.tar.gz=amigaos-m68k
VERSIONS[automake]=1.17=https://ftp.gnu.org/gnu/automake/automake-1.17.tar.gz=automake-1.17.tar.gz=amigaos-m68k
VERSIONS[bison]=3.8.2=https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz=bison-3.8.2.tar.gz=amigaos-m68k
VERSIONS[busybox]=1.36.1=https://busybox.net/downloads/busybox-1.36.1.tar.bz2=busybox-1.36.1.tar.bz2=amigaos-m68k
VERSIONS[expat]=2.6.3=https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-2.6.3.tar.gz=expat-2.6.3.tar.gz=amigaos-m68k
VERSIONS[flex]=2.6.4=https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz=flex-2.6.4.tar.gz=amigaos-m68k
VERSIONS[gmp]=6.3.0=https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz=gmp-6.3.0.tar.xz=amigaos-m68k
VERSIONS[libbz2]=1.0.8=https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz=bzip2-1.0.8.tar.gz=amigaos-m68k
VERSIONS[curl]=8.10.1=https://curl.se/download/curl-8.10.1.tar.gz=curl-8.10.1.tar.gz=amigaos-m68k
VERSIONS[libffi]=3.4.6=https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz=libffi-3.4.6.tar.gz=amigaos-m68k
VERSIONS[libiconv]=1.17=https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz=libiconv-1.17.tar.gz=amigaos-m68k
VERSIONS[libintl]=0.22.5=https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz=gettext-0.22.5.tar.gz=amigaos-m68k
VERSIONS[libpng]=1.6.44=https://sourceforge.net/projects/libpng/files/libpng16/1.6.44/libpng-1.6.44.tar.gz/download=libpng-1.6.44.tar.gz=amigaos-m68k
VERSIONS[libtool]=2.4.7=https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz=libtool-2.4.7.tar.gz=amigaos-m68k
VERSIONS[m4]=1.4.19=https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz=m4-1.4.19.tar.gz=amigaos-m68k
VERSIONS[make]=4.4.1=https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz=make-4.4.1.tar.gz=amigaos-m68k
VERSIONS[mpc]=1.3.1=https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz=mpc-1.3.1.tar.gz=amigaos-m68k
VERSIONS[mpfr]=4.2.1=https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.gz=mpfr-4.2.1.tar.gz=amigaos-m68k
VERSIONS[opengl]=1.1=https://aminet.net/dev/lib/MiniGL.lha=MiniGL.lha=amigaos-m68k
VERSIONS[pkg-config]=0.29.2=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz=pkg-config-0.29.2.tar.gz=amigaos-m68k
VERSIONS[sdl]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.2.15.tar.gz=amigaos-m68k
VERSIONS[sdl2]=2.30.8=https://libsdl.org/release/SDL2-2.30.8.tar.gz=SDL2-2.30.8.tar.gz=amigaos-m68k
VERSIONS[texinfo]=7.1=https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.gz=texinfo-7.1.tar.gz=amigaos-m68k
VERSIONS[zlib]=1.3.2=https://zlib.net/zlib-1.3.2.tar.gz=zlib-1.3.2.tar.gz=amigaos-m68k
VERSIONS[binutils]=2.14=https://ftp.gnu.org/gnu/binutils/binutils-2.14.tar.gz=binutils-2.14.tar.gz=amigaos-m68k
VERSIONS[cmake]=3.30.5=https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5.tar.gz=cmake-3.30.5.tar.gz=amigaos-m68k
VERSIONS[clib2]=git=https://github.com/adtools/clib2.git=clib2=amigaos-m68k
VERSIONS[db101]=2.1=https://aminet.net/dev/debug/db101.lha=db101.lha=amigaos-m68k
VERSIONS[fd2pragma]=git=https://github.com/adtools/fd2pragma.git=fd2pragma=amigaos-m68k
VERSIONS[fd2sfd]=git=https://github.com/adtools/fd2sfd.git=fd2sfd=amigaos-m68k
VERSIONS[gcc]=2.95.3=https://ftp.gnu.org/gnu/gcc/gcc-2.95.3.tar.gz=gcc-2.95.3.tar.gz=amigaos-m68k
VERSIONS[gdb]=7.5=https://ftp.gnu.org/gnu/gdb/gdb-7.5.tar.gz=gdb-7.5.tar.gz=amigaos-m68k
VERSIONS[ixemul]=git=https://github.com/amiga/ixemul.git=ixemul=amigaos-m68k
VERSIONS[libdebug]=git=https://github.com/amiga/libdebug.git=libdebug=amigaos-m68k
VERSIONS[libnix]=git=https://github.com/cahirwpz/libnix.git=libnix=amigaos-m68k
VERSIONS[newlib]=git=https://github.com/sba1/adtools.git=newlib=amigaos-m68k
VERSIONS[sfdc]=git=https://github.com/adtools/sfdc.git=sfdc=amigaos-m68k
VERSIONS[vasm]=1.9d=http://phx.de/ftp/vasm/vasm1_9d.tar.gz=vasm1_9d.tar.gz=amigaos-m68k
VERSIONS[vbcc-bin]=0.9j=http://phx.de/ftp/vbcc/vbcc0_9j_bin_amigaos68k.lha=vbcc0_9j_bin_amigaos68k.lha=amigaos-m68k
VERSIONS[vbcc-target]=0.9j=http://phx.de/ftp/vbcc/vbcc_target_m68k-amigaos.lha=vbcc_target_m68k-amigaos.lha=amigaos-m68k
VERSIONS[codebench]=0.55=https://codebench.co.uk/downloads/CodeBench_Demo_0.55.lha=CodeBench_Demo_0.55.lha=amigaos-m68k
VERSIONS[lha]=2.92=https://aminet.net/util/arc/lha_2.92_src.lha=lha_2.92_src.lha=amigaos-m68k
VERSIONS[p7zip]=17.05=https://github.com/p7zip-project/p7zip/releases/download/v17.05/p7zip_17.05_src_all.tar.bz2=p7zip_17.05_src_all.tar.bz2=amigaos-m68k
VERSIONS[gzip]=1.14=https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.gz=gzip-1.14.tar.gz=amigaos-m68k

# amigaos-m68k Components Build Processes
BUILD_autoconf=custom:cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_automake=custom:cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_bison=custom:cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_busybox=custom:cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc && $(MAKE) install CONFIG_PREFIX=$(PREFIX) >$(LOG_FILE) 2>&1
BUILD_expat=custom:cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_flex=custom:cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gmp=custom:cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libbz2=custom:cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so CC=$(PREFIX)/bin/m68k-amigaos-gcc AR=$(PREFIX)/bin/m68k-amigaos-ar RANLIB=$(PREFIX)/bin/m68k-amigaos-ranlib && $(MAKE) install PREFIX=$(PREFIX) && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc bzip2 && $(CP) bzip2 $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_curl=custom:cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libffi=custom:cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libiconv=custom:cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libintl=custom:cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libpng=custom:cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libtool=custom:cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_m4=custom:cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_make=custom:cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpc=custom:cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpfr=custom:cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_opengl=custom:cd $(BUILD_DIR)/MiniGL && $(MKDIR) $(PREFIX)/include/GL && $(CP) *.h $(PREFIX)/include/GL >$(LOG_FILE) 2>&1
BUILD_pkg-config=custom:cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl=custom:cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-video-opengl --disable-x11 $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl2=custom:cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-video-opengl $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_texinfo=custom:cd $(BUILD_DIR)/texinfo-$(VERSIONS[texinfo]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_zlib=custom:cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_binutils=custom:cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-nls $(STATIC_FLAGS) && $(MAKE) YACC=$(BISON) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_cmake=custom:cd $(BUILD_DIR)/cmake-$(VERSIONS[cmake]) && ./bootstrap --prefix=$(PREFIX) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_clib2=custom:cd $(BUILD_DIR)/clib2 && $(MAKE) -f GNUmakefile-68k && $(MKDIR) $(PREFIX)/clib2/{lib,include} && $(CP) $(BUILD_DIR)/clib2/lib/* $(PREFIX)/clib2/lib && $(CP) $(BUILD_DIR)/clib2/include/* $(PREFIX)/clib2/include >$(LOG_FILE) 2>&1
BUILD_db101=custom:$(MKDIR) $(PREFIX)/bin && $(CP) $(BUILD_DIR)/db101/* $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_fd2pragma=custom:cd $(BUILD_DIR)/fd2pragma && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(CP) $(BUILD_DIR)/fd2pragma/fd2pragma $(PREFIX)/bin && $(CP) $(BUILD_DIR)/fd2pragma/Include/include/inline/{macros,stubs}.h $(PREFIX)/ndk/include/inline >$(LOG_FILE) 2>&1
BUILD_fd2sfd=custom:cd $(BUILD_DIR)/fd2sfd && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gcc=custom:cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && CFLAGS="$(CFLAGS)" CC=$(PREFIX)/bin/m68k-amigaos-gcc CXX=$(PREFIX)/bin/m68k-amigaos-g++ ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gdb=custom:cd $(BUILD_DIR)/gdb-$(VERSIONS[gdb]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_ixemul=custom:cd $(BUILD_DIR)/ixemul && ./configure --prefix=$(PREFIX)/lib --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install && $(CP) $(BUILD_DIR)/ixemul/source/stabs.h $(PREFIX)/libnix/include >$(LOG_FILE) 2>&1
BUILD_libdebug=custom:cd $(BUILD_DIR)/libdebug && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libnix=custom:cd $(BUILD_DIR)/libnix && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_newlib=custom:cd $(BUILD_DIR)/newlib && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sfdc=custom:cd $(BUILD_DIR)/sfdc && $(MAKE) && $(MKDIR) $(PREFIX)/bin && $(CP) sfdc $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_vasm=custom:cd $(BUILD_DIR)/vasm && $(MKDIR) $(BUILD_DIR)/vasm/objects && $(MAKE) CPU=m68k SYNTAX=mot && $(MKDIR) $(PREFIX)/m68k/bin && $(CP) $(BUILD_DIR)/vasm/vasmm68k_mot $(BUILD_DIR)/vasm/vobjdump $(PREFIX)/m68k/bin >$(LOG_FILE) 2>&1
BUILD_vbcc-bin=custom:$(MKDIR) $(PREFIX)/{bin,vbcc} && $(CP) $(BUILD_DIR)/vbcc/bin/* $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_vbcc-target=custom:$(MKDIR) $(PREFIX)/vbcc && $(CP) $(BUILD_DIR)/vbcc-target/* $(PREFIX)/vbcc >$(LOG_FILE) 2>&1
BUILD_codebench=custom:$(MKDIR) $(BUILD_DIR)/codebench && cd $(BUILD_DIR)/codebench && $(PREFIX)/bin/lha x $(DOWNLOAD)/amigaos-m68k/CodeBench_Demo_0.55.lha && $(MKDIR) $(PREFIX)/CodeBench && $(CP) -r CodeBench/* $(PREFIX)/CodeBench && echo "gcc=$(PREFIX)/bin/m68k-amigaos-gcc\ng++=$(PREFIX)/bin/m68k-amigaos-g++\nld=$(PREFIX)/bin/m68k-amigaos-ld\nincludes=$(PREFIX)/include;$(PREFIX)/clib2/include;$(PREFIX)/libnix/include;C:SDK/Include\nlibs=$(PREFIX)/lib;$(PREFIX)/clib2/lib;$(PREFIX)/libnix/lib;C:SDK/Libs" > $(PREFIX)/CodeBench/.codebench >$(LOG_FILE) 2>&1
BUILD_lha=custom:cd $(BUILD_DIR)/lha-$(VERSIONS[lha]) && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc CFLAGS="-O2 -fbaserel" && $(MKDIR) $(PREFIX)/bin && $(CP) lha $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_p7zip=custom:cd $(BUILD_DIR)/p7zip-$(VERSIONS[p7zip]) && $(CP) makefile.amiga $(BUILD_DIR)/p7zip-$(VERSIONS[p7zip])/makefile && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc CXX=$(PREFIX)/bin/m68k-amigaos-g++ 7z && $(MKDIR) $(PREFIX)/bin && $(CP) bin/7z $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_gzip=custom:cd $(BUILD_DIR)/gzip-$(VERSIONS[gzip]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-nls $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1

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