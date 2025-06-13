# Hardcoded versions and URLs for toolchains
# Copyright (c) 2025 Zachary Geurts, MIT License
#
# Instructions: type make or make help for details.
# - Common components (e.g., curl, sdl) are latest stable (0.0.0), support all platforms, always built.
# - Uncommon components (e.g., libogg) are latest stable (0.0.0), for linux,windows,macos, built only if INCLUDE_UNCOMMON=1.
# - Platform-specific components (e.g., curl in amigaos-ppc) override common/uncommon versions.
# - If download fails, place the specified version in ./downloads/<platform>.
# - Tools recognized by name and version (0.0.0 = latest stable for common; exact for amigaos-m68k/amigaos-ppc).
# - To enable: add to VERSIONS: version=<ver>=<url>=<file>=<platform>.
# - To disable: comment out or remove.
# - Standard autotools use DEFAULT_BUILD_AUTOTOOLS unless overridden.
# - Add BUILD_<component> for custom builds below VERSIONS.
# - E.g., to add sdl2 for psp:
#	1. Add to psp:
#	   VERSIONS[sdl2]=2.30.8=https://libsdl.org/release/SDL2-2.30.8.tar.gz=SDL2-2.30.8.tar.gz=psp
#	2. If custom, add to PSP Build:
#	   BUILD_sdl2=custom:cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) --disable-video-x11 && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
# - PREFIX=/custom/path sets install path (default: ./build/install/<platform>).
# - Downloads to ./downloads/<platform>/; builds in ./build/<platform>/.
# - STATIC_FLAGS: Set by Makefile based on ENABLE_STATIC (default 0 for shared, 1 for static).
# - Dependencies: See Makefile DEPEND entries for build order.
# - Required Tools: gcc, make, curl, bison, flex, git, perl, gzip, bzip2, xz, lhasa (for .lha files), 7z (for zip).
# - Not every toolchain build requires every decompressor.

# Versions: VERSIONS[component]=version=url=filename=platform
# If you comment out an existing VERSIONS, also comment out its build.

# Common Components Versions (latest stable, supports all platforms, prefer GitHub, always built)
VERSIONS[autoconf]=0.0.0=https://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz=autoconf-latest.tar.gz=common
VERSIONS[automake]=0.0.0=https://ftp.gnu.org/gnu/automake/automake-latest.tar.gz=automake-latest.tar.gz=common
VERSIONS[bison]=0.0.0=https://ftp.gnu.org/gnu/bison/bison-latest.tar.gz=bison-latest.tar.gz=common
VERSIONS[busybox]=0.0.0=https://busybox.net/downloads/busybox-latest.tar.bz2=busybox-latest.tar.bz2=common
VERSIONS[expat]=0.0.0=https://github.com/libexpat/libexpat/releases/latest/download/expat-latest.tar.gz=expat-latest.tar.gz=common
VERSIONS[flex]=0.0.0=https://github.com/westes/flex/releases/latest/download/flex-latest.tar.gz=flex-latest.tar.gz=common
VERSIONS[gmp]=0.0.0=https://ftp.gnu.org/gnu/gmp/gmp-latest.tar.xz=gmp-latest.tar.xz=common
VERSIONS[libbz2]=0.0.0=https://sourceware.org/pub/bzip2/bzip2-latest.tar.gz=bzip2-latest.tar.gz=common
VERSIONS[curl]=0.0.0=https://curl.se/download/curl-latest.tar.gz=curl-latest.tar.gz=common
VERSIONS[libffi]=0.0.0=https://github.com/libffi/libffi/releases/latest/download/libffi-latest.tar.gz=libffi-latest.tar.gz=common
VERSIONS[libiconv]=0.0.0=https://ftp.gnu.org/gnu/libiconv/libiconv-latest.tar.gz=libiconv-latest.tar.gz=common
VERSIONS[libintl]=0.0.0=https://ftp.gnu.org/gnu/gettext/gettext-latest.tar.gz=gettext-latest.tar.gz=common
VERSIONS[libpng]=0.0.0=https://sourceforge.net/projects/libpng/files/libpng16/latest/download=libpng-latest.tar.gz=common
VERSIONS[libtool]=0.0.0=https://ftp.gnu.org/gnu/libtool/libtool-latest.tar.gz=libtool-latest.tar.gz=common
VERSIONS[m4]=0.0.0=https://ftp.gnu.org/gnu/m4/m4-latest.tar.gz=m4-latest.tar.gz=common
VERSIONS[make]=0.0.0=https://ftp.gnu.org/gnu/make/make-latest.tar.gz=make-latest.tar.gz=common
VERSIONS[mpc]=0.0.0=https://ftp.gnu.org/gnu/mpc/mpc-latest.tar.gz=mpc-latest.tar.gz=common
VERSIONS[mpfr]=0.0.0=https://ftp.gnu.org/gnu/mpfr/mpfr-latest.tar.gz=mpfr-latest.tar.gz=common
VERSIONS[opengl]=0.0.0=https://github.com/KhronosGroup/OpenGL-Registry/archive/refs/tags/main.tar.gz=opengl-latest.tar.gz=common
VERSIONS[pkg-config]=0.0.0=https://pkgconfig.freedesktop.org/releases/pkg-config-latest.tar.gz=pkg-config-latest.tar.gz=common
VERSIONS[sdl]=0.0.0=https://libsdl.org/release/SDL-latest.tar.gz=SDL-latest.tar.gz=common
VERSIONS[sdl2]=0.0.0=https://libsdl.org/release/SDL2-latest.tar.gz=SDL2-latest.tar.gz=common
VERSIONS[texinfo]=0.0.0=https://ftp.gnu.org/gnu/texinfo/texinfo-latest.tar.gz=texinfo-latest.tar.gz=common
VERSIONS[zlib]=0.0.0=https://zlib.net/zlib-latest.tar.gz=zlib-latest.tar.gz=common

# Common Components Build Processes
BUILD_autoconf=custom:cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_automake=custom:cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_bison=custom:cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_busybox=custom:cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) && $(MAKE) install CONFIG_PREFIX=$(PREFIX) >$(LOG_FILE) 2>&1
BUILD_expat=custom:cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_flex=custom:cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gmp=custom:cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libbz2=custom:cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so && $(MAKE) install PREFIX=$(PREFIX) >$(LOG_FILE) 2>&1
BUILD_curl=custom:cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libffi=custom:cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libiconv=custom:cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libintl=custom:cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libpng=custom:cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libtool=custom:cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_m4=custom:cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_make=custom:cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpc=custom:cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpfr=custom:cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_opengl=custom:cd $(BUILD_DIR)/opengl-$(VERSIONS[opengl]) && $(MKDIR) $(PREFIX)/include/GL && $(CP) headers/*.h $(PREFIX)/include/GL >$(LOG_FILE) 2>&1
BUILD_pkg-config=custom:cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl=custom:cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl2=custom:cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_texinfo=custom:cd $(BUILD_DIR)/texinfo-$(VERSIONS[texinfo]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_zlib=custom:cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1

# Uncommon Components Versions (latest stable, for linux,windows,macos, built only if INCLUDE_UNCOMMON=1)
VERSIONS[binutils]=0.0.0=https://ftp.gnu.org/gnu/binutils/binutils-latest.tar.gz=binutils-latest.tar.gz=linux,windows,macos
VERSIONS[fontconfig]=0.0.0=https://www.freedesktop.org/software/fontconfig/release/fontconfig-latest.tar.gz=fontconfig-latest.tar.gz=linux,windows,macos
VERSIONS[freetype]=0.0.0=https://download.savannah.gnu.org/releases/freetype/freetype-latest.tar.gz=freetype-latest.tar.gz=linux,windows,macos
VERSIONS[gawk]=0.0.0=https://ftp.gnu.org/gnu/gawk/gawk-latest.tar.gz=gawk-latest.tar.gz=linux,windows,macos
VERSIONS[gcc]=0.0.0=https://ftp.gnu.org/gnu/gcc/gcc-latest.tar.gz=gcc-latest.tar.gz=linux,windows,macos
VERSIONS[giflib]=0.0.0=https://sourceforge.net/projects/giflib/files/latest/download=giflib-latest.tar.gz=linux,windows,macos
VERSIONS[libjpeg]=0.0.0=https://github.com/libjpeg-turbo/libjpeg-turbo/releases/latest/download/libjpeg-turbo-latest.tar.gz=libjpeg-turbo-latest.tar.gz=linux,windows,macos
VERSIONS[libmpg123]=0.0.0=https://www.mpg123.de/download/mpg123-latest.tar.bz2=mpg123-latest.tar.bz2=linux,windows,macos
VERSIONS[libogg]=0.0.0=https://downloads.xiph.org/releases/ogg/libogg-latest.tar.gz=libogg-latest.tar.gz=linux,windows,macos
VERSIONS[libsndfile]=0.0.0=https://github.com/libsndfile/libsndfile/releases/latest/download/libsndfile-latest.tar.gz=libsndfile-latest.tar.gz=linux,windows,macos
VERSIONS[libtheora]=0.0.0=https://downloads.xiph.org/releases/theora/libtheora-latest.tar.gz=libtheora-latest.tar.gz=linux,windows,macos
VERSIONS[libvorbis]=0.0.0=https://downloads.xiph.org/releases/vorbis/libvorbis-latest.tar.gz=libvorbis-latest.tar.gz=linux,windows,macos
VERSIONS[libxml2]=0.0.0=https://download.gnome.org/sources/libxml2/cache/libxml2-latest.tar.xz=libxml2-latest.tar.xz=linux,windows,macos
VERSIONS[vlink]=0.0.0=https://github.com/phx/vlink/releases/latest/download/vlink-latest.tar.gz=vlink-latest.tar.gz=linux,windows,macos

# Uncommon Components Build Processes
BUILD_binutils=custom:cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --disable-nls $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_fontconfig=custom:cd $(BUILD_DIR)/fontconfig-$(VERSIONS[fontconfig]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_freetype=custom:cd $(BUILD_DIR)/freetype-$(VERSIONS[freetype]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gawk=custom:cd $(BUILD_DIR)/gawk-$(VERSIONS[gawk]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gcc=custom:cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) --disable-nls $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_giflib=custom:cd $(BUILD_DIR)/giflib-$(VERSIONS[giflib]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libjpeg=custom:cd $(BUILD_DIR)/libjpeg-turbo-$(VERSIONS[libjpeg]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libmpg123=custom:cd $(BUILD_DIR)/mpg123-$(VERSIONS[libmpg123]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libogg=custom:cd $(BUILD_DIR)/libogg-$(VERSIONS[libogg]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libsndfile=custom:cd $(BUILD_DIR)/libsndfile-$(VERSIONS[libsndfile]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libtheora=custom:cd $(BUILD_DIR)/libtheora-$(VERSIONS[libtheora]) && ./configure --prefix=$(PREFIX) --with-ogg=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libvorbis=custom:cd $(BUILD_DIR)/libvorbis-$(VERSIONS[libvorbis]) && ./configure --prefix=$(PREFIX) --with-ogg=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libxml2=custom:cd $(BUILD_DIR)/libxml2-$(VERSIONS[libxml2]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_vlink=custom:cd $(BUILD_DIR)/vlink-$(VERSIONS[vlink]) && $(MAKE) && $(MKDIR) $(PREFIX)/bin && $(CP) vlink $(PREFIX)/bin >$(LOG_FILE) 2>&1

# amigaos-m68k Components Versions (complete for AmigaOS cross-compiling, exact versions for archival)
INCLUDE_UNCOMMON=0
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

# amigaos-m68k Components Build Processes
BUILD_autoconf=custom:cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_automake=custom:cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_bison=custom:cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_busybox=custom:cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) && $(MAKE) install CONFIG_PREFIX=$(PREFIX) >$(LOG_FILE) 2>&1
BUILD_expat=custom:cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_flex=custom:cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gmp=custom:cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libbz2=custom:cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so && $(MAKE) install PREFIX=$(PREFIX) >$(LOG_FILE) 2>&1
BUILD_curl=custom:cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libffi=custom:cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libiconv=custom:cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libintl=custom:cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libpng=custom:cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libtool=custom:cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_m4=custom:cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_make=custom:cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpc=custom:cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpfr=custom:cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_opengl=custom:cd $(BUILD_DIR)/MiniGL && $(MKDIR) $(PREFIX)/include/GL && $(CP) *.h $(PREFIX)/include/GL >$(LOG_FILE) 2>&1
BUILD_pkg-config=custom:cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl=custom:cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) --disable-video-opengl --disable-x11 $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl2=custom:cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) --disable-video-opengl $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_texinfo=custom:cd $(BUILD_DIR)/texinfo-$(VERSIONS[texinfo]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_zlib=custom:cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_binutils=custom:cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-nls $(STATIC_FLAGS) && $(MAKE) YACC=$(BISON) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_cmake=custom:cd $(BUILD_DIR)/cmake-$(VERSIONS[cmake]) && ./bootstrap --prefix=$(PREFIX) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_clib2=custom:cd $(BUILD_DIR)/clib2 && $(MAKE) -f GNUmakefile-68k && $(MKDIR) $(PREFIX)/clib2/{lib,include} && $(CP) $(BUILD_DIR)/clib2/lib/* $(PREFIX)/clib2/lib && $(CP) $(BUILD_DIR)/clib2/include/* $(PREFIX)/clib2/include >$(LOG_FILE) 2>&1
BUILD_db101=custom:$(MKDIR) $(PREFIX)/bin && $(CP) $(BUILD_DIR)/db101/* $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_fd2pragma=custom:cd $(BUILD_DIR)/fd2pragma && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(CP) $(BUILD_DIR)/fd2pragma/fd2pragma $(PREFIX)/bin && $(CP) $(BUILD_DIR)/fd2pragma/Include/include/inline/{macros,stubs}.h $(PREFIX)/ndk/include/inline >$(LOG_FILE) 2>&1
BUILD_fd2sfd=custom:cd $(BUILD_DIR)/fd2sfd && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gcc=custom:cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gdb=custom:cd $(BUILD_DIR)/gdb-$(VERSIONS[gdb]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_ixemul=custom:cd $(BUILD_DIR)/ixemul && ./configure --prefix=$(PREFIX)/lib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install && $(CP) $(BUILD_DIR)/ixemul/source/stabs.h $(PREFIX)/libnix/include >$(LOG_FILE) 2>&1
BUILD_libdebug=custom:cd $(BUILD_DIR)/libdebug && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libnix=custom:cd $(BUILD_DIR)/libnix && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_newlib=custom:cd $(BUILD_DIR)/newlib && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sfdc=custom:cd $(BUILD_DIR)/sfdc && $(MAKE) && $(MKDIR) $(PREFIX)/bin && $(CP) sfdc $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_vasm=custom:cd $(BUILD_DIR)/vasm && $(MKDIR) $(BUILD_DIR)/vasm/objects && $(MAKE) CPU=m68k SYNTAX=mot && $(MKDIR) $(PREFIX)/m68k/bin && $(CP) $(BUILD_DIR)/vasm/vasmm68k_mot $(BUILD_DIR)/vasm/vobjdump $(PREFIX)/m68k/bin >$(LOG_FILE) 2>&1
BUILD_vbcc-bin=custom:$(MKDIR) $(PREFIX)/{bin,vbcc} && $(CP) $(BUILD_DIR)/vbcc/bin/* $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_vbcc-target=custom:$(MKDIR) $(PREFIX)/vbcc && $(CP) $(BUILD_DIR)/vbcc-target/* $(PREFIX)/vbcc >$(LOG_FILE) 2>&1

# amigaos-ppc Components Versions (complete for AmigaOS 4.x cross-compiling, exact versions for archival)
INCLUDE_UNCOMMON=0
VERSIONS[autoconf]=2.72=https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz=autoconf-2.72.tar.gz=amigaos-ppc
VERSIONS[automake]=1.17=https://ftp.gnu.org/gnu/automake/automake-1.17.tar.gz=automake-1.17.tar.gz=amigaos-ppc
VERSIONS[bison]=3.8.2=https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz=bison-3.8.2.tar.gz=amigaos-ppc
VERSIONS[busybox]=1.36.1=https://busybox.net/downloads/busybox-1.36.1.tar.bz2=busybox-1.36.1.tar.bz2=amigaos-ppc
VERSIONS[expat]=2.6.3=https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-2.6.3.tar.gz=expat-2.6.3.tar.gz=amigaos-ppc
VERSIONS[flex]=2.6.4=https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz=flex-2.6.4.tar.gz=amigaos-ppc
VERSIONS[gmp]=6.3.0=https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz=gmp-6.3.0.tar.xz=amigaos-ppc
VERSIONS[libbz2]=1.0.8=https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz=bzip2-1.0.8.tar.gz=amigaos-ppc
VERSIONS[curl]=8.10.1=https://curl.se/download/curl-8.10.1.tar.gz=curl-8.10.1.tar.gz=amigaos-ppc
VERSIONS[libffi]=3.4.6=https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz=libffi-3.4.6.tar.gz=amigaos-ppc
VERSIONS[libiconv]=1.17=https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz=libiconv-1.17.tar.gz=amigaos-ppc
VERSIONS[libintl]=0.22.5=https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz=gettext-0.22.5.tar.gz=amigaos-ppc
VERSIONS[libpng]=1.6.44=https://sourceforge.net/projects/libpng/files/libpng16/1.6.44/libpng-1.6.44.tar.gz/download=libpng-1.6.44.tar.gz=amigaos-ppc
VERSIONS[libtool]=2.4.7=https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz=libtool-2.4.7.tar.gz=amigaos-ppc
VERSIONS[m4]=1.4.19=https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz=m4-1.4.19.tar.gz=amigaos-ppc
VERSIONS[make]=4.4.1=https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz=make-4.4.1.tar.gz=amigaos-ppc
VERSIONS[mpc]=1.3.1=https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz=mpc-1.3.1.tar.gz=amigaos-ppc
VERSIONS[mpfr]=4.2.1=https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.gz=mpfr-4.2.1.tar.gz=amigaos-ppc
VERSIONS[opengl]=1.1=https://aminet.net/dev/misc/Warp3D_PPC.lha=Warp3D_PPC.lha=amigaos-ppc
VERSIONS[pkg-config]=0.29.2=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz=pkg-config-0.29.2.tar.gz=amigaos-ppc
VERSIONS[sdl]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.2.15.tar.gz=amigaos-ppc
VERSIONS[sdl2]=2.30.8=https://libsdl.org/release/SDL2-2.30.8.tar.gz=SDL2-2.30.8.tar.gz=amigaos-ppc
VERSIONS[texinfo]=7.1=https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.gz=texinfo-7.1.tar.gz=amigaos-ppc
VERSIONS[zlib]=1.3.2=https://zlib.net/zlib-1.3.2.tar.gz=zlib-1.3.2.tar.gz=amigaos-ppc
VERSIONS[binutils]=2.23=https://ftp.gnu.org/gnu/binutils/binutils-2.23.tar.bz2=binutils-2.23.tar.bz2=amigaos-ppc
VERSIONS[cmake]=3.30.5=https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5.tar.gz=cmake-3.30.5.tar.gz=amigaos-ppc
VERSIONS[clib2]=git=https://github.com/adtools/clib2.git=clib2=amigaos-ppc
VERSIONS[gcc]=8.4.0=https://ftp.gnu.org/gnu/gcc/gcc-8.4.0.tar.gz=gcc-8.4.0.tar.gz=amigaos-ppc
VERSIONS[gdb]=7.5=https://ftp.gnu.org/gnu/gdb/gdb-7.5.tar.gz=gdb-7.5.tar.gz=amigaos-ppc
VERSIONS[git]=2.46.2=https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.46.2.tar.gz=git-2.46.2.tar.gz=amigaos-ppc
VERSIONS[libogg]=1.3.5=https://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.gz=libogg-1.3.5.tar.gz=amigaos-ppc
VERSIONS[libvorbis]=1.3.7=https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.gz=libvorbis-1.3.7.tar.gz=amigaos-ppc
VERSIONS[newlib]=git=https://github.com/sba1/adtools.git=newlib=amigaos-ppc
VERSIONS[perl]=5.40.0=https://www.cpan.org/src/5.0/perl-5.40.0.tar.gz=perl-5.40.0.tar.gz=amigaos-ppc
VERSIONS[vbcc-bin]=0.9j=http://phx.de/ftp/vbcc/vbcc0_9j_bin_amigaosppc.lha=vbcc0_9j_bin_amigaosppc.lha=amigaos-ppc
VERSIONS[vbcc-target]=0.9j=http://phx.de/ftp/vbcc/vbcc_target_ppc-amigaos.lha=vbcc_target_ppc-amigaos.lha=amigaos-ppc

# amigaos-ppc Components Build Processes
BUILD_autoconf=custom:cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_automake=custom:cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_bison=custom:cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_busybox=custom:cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) && $(MAKE) install CONFIG_PREFIX=$(PREFIX) >$(LOG_FILE) 2>&1
BUILD_expat=custom:cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_flex=custom:cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gmp=custom:cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libbz2=custom:cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so && $(MAKE) install PREFIX=$(PREFIX) >$(LOG_FILE) 2>&1
BUILD_curl=custom:cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libffi=custom:cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libiconv=custom:cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libintl=custom:cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libpng=custom:cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libtool=custom:cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_m4=custom:cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_make=custom:cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpc=custom:cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_mpfr=custom:cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_opengl=custom:cd $(BUILD_DIR)/Warp3D_PPC && $(MKDIR) $(PREFIX)/include/GL && $(CP) *.h $(PREFIX)/include/GL >$(LOG_FILE) 2>&1
BUILD_pkg-config=custom:cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl=custom:cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) --disable-video-opengl $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_sdl2=custom:cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) --disable-video-opengl $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_texinfo=custom:cd $(BUILD_DIR)/texinfo-$(VERSIONS[texinfo]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_zlib=custom:cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_binutils=custom:cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --disable-nls $(STATIC_FLAGS) && $(MAKE) YACC=$(BISON) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_cmake=custom:cd $(BUILD_DIR)/cmake-$(VERSIONS[cmake]) && ./bootstrap --prefix=$(PREFIX) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_clib2=custom:cd $(BUILD_DIR)/clib2 && $(MAKE) -f GNUmakefile-os4 && $(MKDIR) $(PREFIX)/clib2/{lib,include} && $(CP) $(BUILD_DIR)/clib2/lib/* $(PREFIX)/clib2/lib && $(CP) $(BUILD_DIR)/clib2/include/* $(PREFIX)/clib2/include >$(LOG_FILE) 2>&1
BUILD_gcc=custom:cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && CFLAGS="$(CFLAGS)" CC=$(CC) CXX=$(CXX) ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_gdb=custom:cd $(BUILD_DIR)/gdb-$(VERSIONS[gdb]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_git=custom:cd $(BUILD_DIR)/git-$(VERSIONS[git]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libogg=custom:cd $(BUILD_DIR)/libogg-$(VERSIONS[libogg]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_libvorbis=custom:cd $(BUILD_DIR)/libvorbis-$(VERSIONS[libvorbis]) && ./configure --prefix=$(PREFIX) --with-ogg=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_newlib=custom:cd $(BUILD_DIR)/newlib && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_perl=custom:cd $(BUILD_DIR)/perl-$(VERSIONS[perl]) && ./Configure -des -Dprefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
BUILD_vbcc-bin=custom:$(MKDIR) $(PREFIX)/{bin,vbcc} && $(CP) $(BUILD_DIR)/vbcc/bin/* $(PREFIX)/bin >$(LOG_FILE) 2>&1
BUILD_vbcc-target=custom:$(MKDIR) $(PREFIX)/vbcc && $(CP) $(BUILD_DIR)/vbcc-target/* $(PREFIX)/vbcc >$(LOG_FILE) 2>&1

# topplatform-ppc Components (placeholder, no relation to amigaos)
INCLUDE_UNCOMMON=1
# topplatform-ppc Build Rules: define versions and build rules as needed.

# topplatform-m68k Components (placeholder, no relation to amigaos)
INCLUDE_UNCOMMON=1
# topplatform-m68k Build Rules: define versions and build rules as needed.

# Placeholder Platforms (for future expansion, not built unless VERSIONS and BUILD rules are added)
# Uncommon components may be incompatible with some platforms; specify platform-specific gcc, binutils, etc., and disable as needed.
# These should use SDK files where applicable.
# 3do Components
INCLUDE_UNCOMMON=1
# 3do Build Rules: define versions and build rules as needed.

# aarch64 Components
INCLUDE_UNCOMMON=1
# aarch64 Build Rules: define versions and build rules as needed.

# alpha Components
INCLUDE_UNCOMMON=1
# alpha Build Rules: define versions and build rules as needed.

# armv6 Components
INCLUDE_UNCOMMON=1
# armv6 Build Rules: define versions and build rules as needed.

# armv7 Components
INCLUDE_UNCOMMON=1
# armv7 Build Rules: define versions and build rules as needed.

# armv8 Components
INCLUDE_UNCOMMON=1
# armv8 Build Rules: define versions and build rules as needed.

# atari-st Components
INCLUDE_UNCOMMON=1
# atari-st Build Rules: define versions and build rules as needed.

# dreamcast Components
INCLUDE_UNCOMMON=1
# dreamcast Build Rules: define versions and build rules as needed.

# hppa Components
INCLUDE_UNCOMMON=1
# hppa Build Rules: define versions and build rules as needed.

# ia64 Components
INCLUDE_UNCOMMON=1
# ia64 Build Rules: define versions and build rules as needed.

# ps2 Components
INCLUDE_UNCOMMON=1
# ps2 Build Rules: define versions and build rules as needed.

# psp Components
INCLUDE_UNCOMMON=1
# psp Build Rules: define versions and build rules as needed.

# steamlink Components
INCLUDE_UNCOMMON=1
# steamlink Build Rules: define versions and build rules as needed.

# wii Components
INCLUDE_UNCOMMON=1
# wii Build Rules: define versions and build rules as needed.

# x86 Components
INCLUDE_UNCOMMON=1
# x86 Build Rules: define versions and build rules as needed.

# x86_64 Components
INCLUDE_UNCOMMON=1
# x86_64 Build Rules: define versions and build rules as needed.