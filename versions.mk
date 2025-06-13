# versions.mk
# Hardcoded versions and URLs for toolchains
# Copyright (c) 2025 Zachary Geurts, MIT License

# Use this as a reference when creating a new platform file.
# This is comment tutorial and a loop to find ./platform/<platform>.mk files at the bottom.
# Each component definition requires 2 lines. VERSIONS and BUILD_
# If you do not want to be intimidated by this document then open a platform/<platform>.mk file first.
# We break that down and discuss the method. The explanation looks like that in practice.

# Instructions for New Platforms:
# 1. Copy an existing platform/<platform>.mk as a template.
# 2. Define exact VERSIONS and BUILD_ entries in your platform file for your platform components.
# 3. Use Deepsearch to find stable, tested versions for your platform, preferring older, reliable versions for legacy systems.
# 4. If a download fails, place the specified file in ./download/<platform>/<filename>.

# Usage Notes:
# - To enable a component, uncomment its VERSIONS and BUILD_ lines in platform/<platform>.mk.
# - To disable a component, comment out both its VERSIONS and BUILD_ lines.
# - Variables defined in platform/<platform>.mk are local to that file and not visible to versions.mk.
# - See Makefile DEPEND entries for build order and dependencies.
# - Logs are written to ./logs/summary.log and ./logs/<component>.log; check for build errors.
# - It is not recommended reading from logs as they are being written. (most recent and summary)

# System Requirements:
# - Minimum: 2GHz CPU, 2GB RAM, 500GB free disk space (build time may take days on low-spec systems).
# - Required tools: gcc, make, curl, bison, flex, git, perl, gzip, bzip2, xz, lhasa or lha, 7z.
# - Not all decompressors are needed for every component.

# Configuration:
# - PREFIX=/custom/path sets install path (default: ./build/install/<platform>).
# - Downloads go to ./download/<platform>/; builds occur in ./build/<platform>/.
# - STATIC_FLAGS: Set by Makefile based on ENABLE_STATIC (0 for shared libraries, 1 for static).
# - VERSIONS format: VERSIONS[component]=version=url=filename=platform
# - 0.0.0 in common components is a placeholder for latest stable; platform files specify exact versions.

# Common Components Versions
# These are fallback versions for all platforms, using 0.0.0 to indicate latest stable.
# Platform/<platform>.mk should override with exact versions for stability, especially for legacy platforms.
# VERSIONS[autoconf]=0.0.0=https://ftp.gnu.org/gnu/autoconf/autoconf-latest.tar.gz=autoconf-latest.tar.gz=common
# VERSIONS[automake]=0.0.0=https://ftp.gnu.org/gnu/automake/automake-latest.tar.gz=automake-latest.tar.gz=common
# VERSIONS[bison]=0.0.0=https://ftp.gnu.org/gnu/bison/bison-latest.tar.gz=bison-latest.tar.gz=common
# VERSIONS[busybox]=0.0.0=https://busybox.net/downloads/busybox-latest.tar.bz2=busybox-latest.tar.bz2=common
# VERSIONS[expat]=0.0.0=https://github.com/libexpat/libexpat/releases/latest/download/expat-latest.tar.gz=expat-latest.tar.gz=common
# VERSIONS[flex]=0.0.0=https://github.com/westes/flex/releases/latest/download/flex-latest.tar.gz=flex-latest.tar.gz=common
# VERSIONS[gmp]=0.0.0=https://ftp.gnu.org/gnu/gmp/gmp-latest.tar.xz=gmp-latest.tar.xz=common
# VERSIONS[libbz2]=0.0.0=https://sourceware.org/pub/bzip2/bzip2-latest.tar.gz=bzip2-latest.tar.gz=common
# VERSIONS[curl]=0.0.0=https://curl.se/download/curl-latest.tar.gz=curl-latest.tar.gz=common
# VERSIONS[libffi]=0.0.0=https://github.com/libffi/libffi/releases/latest/download/libffi-latest.tar.gz=libffi-latest.tar.gz=common
# VERSIONS[libiconv]=0.0.0=https://ftp.gnu.org/gnu/libiconv/libiconv-latest.tar.gz=libiconv-latest.tar.gz=common
# VERSIONS[libintl]=0.0.0=https://ftp.gnu.org/gnu/gettext/gettext-latest.tar.gz=gettext-latest.tar.gz=common
# VERSIONS[libpng]=0.0.0=https://sourceforge.net/projects/libpng/files/libpng16/latest/download=libpng-latest.tar.gz=common
# VERSIONS[libtool]=0.0.0=https://ftp.gnu.org/gnu/libtool/libtool-latest.tar.gz=libtool-latest.tar.gz=common
# VERSIONS[m4]=0.0.0=https://ftp.gnu.org/gnu/m4/m4-latest.tar.gz=m4-latest.tar.gz=common
# VERSIONS[make]=0.0.0=https://ftp.gnu.org/gnu/make/make-latest.tar.gz=make-latest.tar.gz=common
# VERSIONS[mpc]=0.0.0=https://ftp.gnu.org/gnu/mpc/mpc-latest.tar.gz=mpc-latest.tar.gz=common
# VERSIONS[mpfr]=0.0.0=https://ftp.gnu.org/gnu/mpfr/mpfr-latest.tar.gz=mpfr-latest.tar.gz=common
# VERSIONS[opengl]=0.0.0=https://github.com/KhronosGroup/OpenGL-Registry/archive/refs/tags/main.tar.gz=opengl-latest.tar.gz=common
# VERSIONS[pkg-config]=0.0.0=https://pkgconfig.freedesktop.org/releases/pkg-config-latest.tar.gz=pkg-config-latest.tar.gz=common
# VERSIONS[sdl]=0.0.0=https://libsdl.org/release/SDL-latest.tar.gz=SDL-latest.tar.gz=common
# VERSIONS[sdl2]=0.0.0=https://libsdl.org/release/SDL2-latest.tar.gz=SDL2-latest.tar.gz=common
# VERSIONS[texinfo]=0.0.0=https://ftp.gnu.org/gnu/texinfo/texinfo-latest.tar.gz=texinfo-latest.tar.gz=common
# VERSIONS[zlib]=0.0.0=https://zlib.net/zlib-latest.tar.gz=zlib-latest.tar.gz=common

# Common Components Build Processes
# Build processes are grouped by pattern similarity (e.g., same configure steps) to simplify maintenance.
# Each group respects dependency chains defined in Makefile DEPEND.
# Use && for single-line commands or \ for multi-line readability.
# Example:
# BUILD_autoconf=custom:cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
#
# Equivalent to:
# BUILD_autoconf=custom:cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) \
#	./bootstrap \
#	./configure --prefix=$(PREFIX) $(STATIC_FLAGS) \
#	$(MAKE) \
#	$(MAKE) install
#
# These reflect manual command-line build steps, preserving $(MAKE) for PREFIX compatibility.

# Group 1: Simple Non-Configure Builds
# Pattern: No ./configure; uses direct make or file copy.
# Components: opengl, libbz2, busybox
# Dependencies:
# - opengl: Required by sdl, sdl2 (Group 2).
# - libbz2, busybox: No dependencies.
# BUILD_opengl=custom:cd $(BUILD_DIR)/opengl-$(VERSIONS[opengl]) && $(MKDIR) $(PREFIX)/include/GL && $(CP) headers/*.h $(PREFIX)/include/GL
# BUILD_libbz2=custom:cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so && $(MAKE) install PREFIX=$(PREFIX)
# BUILD_busybox=custom:cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) && $(MAKE) install CONFIG_PREFIX=$(PREFIX)

# Group 2: Basic Configure Builds
# Pattern: ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# Components: m4, libiconv, libintl, make, texinfo, zlib, sdl, sdl2
# Dependencies:
# - m4: Required by autoconf, bison (Group 4).
# - zlib: Required by libpng, curl (Group 3, Group 6).
# - sdl, sdl2: Depend on opengl (Group 1).
# - libiconv, libintl, make, texinfo: No dependencies.
# BUILD_m4=custom:cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libiconv=custom:cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libintl=custom:cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_make=custom:cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_texinfo=custom:cd $(BUILD_DIR)/texinfo-$(VERSIONS[texinfo]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_zlib=custom:cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_sdl=custom:cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_sdl2=custom:cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install

# Group 3: Configure with Dependency Flags
# Pattern: ./configure with dependency flags (e.g., --with-zlib, --with-gmp)
# Components: gmp, mpfr, mpc, libpng, pkg-config
# Dependencies:
# - gmp: Required by mpfr, mpc.
# - mpfr: Depends on gmp.
# - mpc: Depends on mpfr, gmp.
# - libpng: Depends on zlib (Group 2).
# - pkg-config: No dependencies.
# BUILD_gmp=custom:cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_mpfr=custom:cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_mpc=custom:cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libpng=custom:cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_pkg-config=custom:cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install

# Group 4: Bootstrap + Configure Builds
# Pattern: ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# Components: autoconf, automake, bison, libtool
# Dependencies:
# - autoconf: Depends on m4 (Group 2).
# - automake, libtool: Depend on autoconf.
# - bison: Depends on m4 (Group 2).
# Note: m4 is in Group 2 but listed here for dependency context.
# BUILD_autoconf=custom:cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_automake=custom:cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_bison=custom:cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libtool=custom:cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./bootstrap && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install

# Group 5: Autogen + Configure Builds
# Pattern: ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# Components: flex, libffi
# Dependencies:
# - flex, libffi: No dependencies.
# BUILD_flex=custom:cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libffi=custom:cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install

# Group 6: Buildconf + Configure Builds
# Pattern: ./buildconf or ./buildconf.sh && ./configure with optional dependency flags
# Components: expat, curl
# Dependencies:
# - expat: No dependencies.
# - curl: Depends on zlib (Group 2).
# BUILD_expat=custom:cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_curl=custom:cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install

############### You just need A and B filled out.
### VERSIONS downloads and BUILD_ builds. We have identified 6 different build patterns above for your reference.
## Uncommon shows what a tool collection can look like. We just showed you Common splayed out, but it just looked like this too.
# Uncommon Components Versions (alphabetized)
# VERSIONS[binutils]=0.0.0=https://ftp.gnu.org/gnu/binutils/binutils-latest.tar.gz=binutils-latest.tar.gz=linux,windows,macos
# VERSIONS[fontconfig]=0.0.0=https://www.freedesktop.org/software/fontconfig/release/fontconfig-latest.tar.gz=fontconfig-latest.tar.gz=linux,windows,macos
# VERSIONS[freetype]=0.0.0=https://download.savannah.gnu.org/releases/freetype/freetype-latest.tar.gz=freetype-latest.tar.gz=linux,windows,macos
# VERSIONS[gawk]=0.0.0=https://ftp.gnu.org/gnu/gawk/gawk-latest.tar.gz=gawk-latest.tar.gz=linux,windows,macos
# VERSIONS[gcc]=0.0.0=https://ftp.gnu.org/gnu/gcc/gcc-latest.tar.gz=gcc-latest.tar.gz=linux,windows,macos
# VERSIONS[giflib]=0.0.0=https://sourceforge.net/projects/giflib/files/latest/download=giflib-latest.tar.gz=linux,windows,macos
# VERSIONS[libjpeg]=0.0.0=https://github.com/libjpeg-turbo/libjpeg-turbo/releases/latest/download/libjpeg-turbo-latest.tar.gz=libjpeg-turbo-latest.tar.gz=linux,windows,macos
# VERSIONS[libmpg123]=0.0.0=https://www.mpg123.de/download/mpg123-latest.tar.bz2=mpg123-latest.tar.bz2=linux,windows,macos
# VERSIONS[libogg]=0.0.0=https://downloads.xiph.org/releases/ogg/libogg-latest.tar.gz=libogg-latest.tar.gz=linux,windows,macos
# VERSIONS[libsndfile]=0.0.0=https://github.com/libsndfile/libsndfile/releases/latest/download/libsndfile-latest.tar.gz=libsndfile-latest.tar.gz=linux,windows,macos
# VERSIONS[libtheora]=0.0.0=https://downloads.xiph.org/releases/theora/libtheora-latest.tar.gz=libtheora-latest.tar.gz=linux,windows,macos
# VERSIONS[libvorbis]=0.0.0=https://downloads.xiph.org/releases/vorbis/libvorbis-latest.tar.gz=libvorbis-latest.tar.gz=linux,windows,macos
# VERSIONS[libxml2]=0.0.0=https://download.gnome.org/sources/libxml2/cache/libxml2-latest.tar.xz=libxml2-latest.tar.xz=linux,windows,macos
# VERSIONS[vlink]=0.0.0=https://github.com/phx/vlink/releases/latest/download/vlink-latest.tar.gz=vlink-latest.tar.gz=linux,windows,macos

# Uncommon Components Build Processes (alphabetized)
# BUILD_binutils=custom:cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --disable-nls $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_fontconfig=custom:cd $(BUILD_DIR)/fontconfig-$(VERSIONS[fontconfig]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_freetype=custom:cd $(BUILD_DIR)/freetype-$(VERSIONS[freetype]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_gawk=custom:cd $(BUILD_DIR)/gawk-$(VERSIONS[gawk]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_gcc=custom:cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && ./configure --prefix=$(PREFIX) --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) --disable-nls $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_giflib=custom:cd $(BUILD_DIR)/giflib-$(VERSIONS[giflib]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libjpeg=custom:cd $(BUILD_DIR)/libjpeg-turbo-$(VERSIONS[libjpeg]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libmpg123=custom:cd $(BUILD_DIR)/mpg123-$(VERSIONS[libmpg123]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libogg=custom:cd $(BUILD_DIR)/libogg-$(VERSIONS[libogg]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libsndfile=custom:cd $(BUILD_DIR)/libsndfile-$(VERSIONS[libsndfile]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libtheora=custom:cd $(BUILD_DIR)/libtheora-$(VERSIONS[libtheora]) && ./configure --prefix=$(PREFIX) --with-ogg=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libvorbis=custom:cd $(BUILD_DIR)/libvorbis-$(VERSIONS[libvorbis]) && ./configure --prefix=$(PREFIX) --with-ogg=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_libxml2=custom:cd $(BUILD_DIR)/libxml2-$(VERSIONS[libxml2]) && ./autogen.sh && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install
# BUILD_vlink=custom:cd $(BUILD_DIR)/vlink-$(VERSIONS[vlink]) && $(MAKE) && $(MKDIR) $(PREFIX)/bin && $(CP) vlink $(PREFIX)/bin

# Include platform-specific configurations
ifneq ($(MAKECMDGOALS),$(filter help check clean debug_components debug_rules,$(MAKECMDGOALS)))
ifndef PLATFORM
$(error PLATFORM variable must be set make PLATFORM=<mkplatform>)
endif
include platform/$(PLATFORM).mk
endif

# If you made it this far, just go look at a completed platform/<platform>.mk