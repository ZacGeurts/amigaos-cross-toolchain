# m68k-amigaos.mk
# Platform-specific versions and build rules for M68K-AmigaOS cross-compilation
# Format: VERSIONS[component]=version=url=filename=platform
# Optimized for AmigaOS 3.x on 1996 hardware (7MHz CPU, 512KB-2MB RAM)
# Copyright (c) 2025 Zachary Geurts, MIT License

.PHONY: m68k-amigaos

# User Notes:
# - Add or modify VERSIONS and BUILD_ lines together (both commented or uncommented).
# - Use BUILD_STUB=custom:$(call o7_CENTER,build_stub,critical);true;$(call STOP_o7) for manual builds after download.
# - Leave downloads in $(BUILD_DIR) to avoid re-downloading.
# - Order: Dependency-first, then alphabetical within Build Tools, Libraries, Extras, Optional.
# - Use $(PREFIX), $(BUILD_DIR), $(LOG_FILE), $(STATIC_FLAGS) for consistency.
# - Wrap build commands with $(call o7_CENTER,build_<component>,critical) and $(call STOP_o7).
# - Target variables: $(m68k-amigaos)_PREFIX, $(m68k-amigaos)_BUILD, $(m68k-amigaos)_DOWNLOAD, $(m68k-amigaos)_STAMPS.
# - Commented components (e.g., quake, scummvm) are optional.
# - GCC 2.95.3, Binutils 2.14, SDL 1.2, and MiniGL are stable; SDL2 and games are optional.

# Versions: VERSIONS[component]=version=url=filename=platform
# Build Tools (Dependency-first, then alphabetical)
VERSIONS[m4]=1.4.19=https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz=m4-1.4.19.tar.gz=m68k-amigaos
VERSIONS[autoconf]=2.71=https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz=autoconf-2.71.tar.gz=m68k-amigaos
VERSIONS[automake]=1.16.5=https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.gz=automake-1.16.5.tar.gz=m68k-amigaos
VERSIONS[bison]=3.8.2=https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz=bison-3.8.2.tar.gz=m68k-amigaos
VERSIONS[flex]=2.6.4=https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz=flex-2.6.4.tar.gz=m68k-amigaos
VERSIONS[gmp]=6.2.1=https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz=gmp-6.2.1.tar.xz=m68k-amigaos
VERSIONS[mpfr]=4.1.0=https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.gz=mpfr-4.1.0.tar.gz=m68k-amigaos
VERSIONS[mpc]=1.2.1=https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz=mpc-1.2.1.tar.gz=m68k-amigaos
VERSIONS[binutils]=2.14=https://ftp.gnu.org/gnu/binutils/binutils-2.14.tar.gz=binutils-2.14.tar.gz=m68k-amigaos
VERSIONS[gcc]=2.95.3=https://ftp.gnu.org/gnu/gcc/gcc-2.95.3.tar.gz=gcc-2.95.3.tar.gz=m68k-amigaos
VERSIONS[cmake]=3.22.1=https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz=cmake-3.22.1.tar.gz=m68k-amigaos
VERSIONS[gdb]=7.5=https://ftp.gnu.org/gnu/gdb/gdb-7.5.tar.gz=gdb-7.5.tar.gz=m68k-amigaos
VERSIONS[libtool]=2.4.6=https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.gz=libtool-2.4.6.tar.gz=m68k-amigaos
VERSIONS[make]=4.3=https://ftp.gnu.org/gnu/make/make-4.3.tar.gz=make-4.3.tar.gz=m68k-amigaos
VERSIONS[pkg-config]=0.29.2=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz=pkg-config-0.29.2.tar.gz=m68k-amigaos
VERSIONS[vasm]=1.9d=https://aminet.net/dev/asm/vasm.lha=vasm1_9d.lha=m68k-amigaos
VERSIONS[vbcc-bin]=0.9j=https://aminet.net/dev/c/vbcc_bin.lha=vbcc0_9j_bin_amigaos68k.lha=m68k-amigaos
VERSIONS[vbcc-target]=0.9j=https://aminet.net/dev/c/vbcc_m68k_target.lha=vbcc_target_m68k-amigaos.lha=m68k-amigaos

# Libraries (Dependency-first, then alphabetical)
VERSIONS[zlib]=1.2.11=https://zlib.net/zlib-1.2.11.tar.gz=zlib-1.2.11.tar.gz=m68k-amigaos
VERSIONS[libbz2]=1.0.8=https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz=bzip2-1.0.8.tar.gz=m68k-amigaos
VERSIONS[libpng]=1.6.37=https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz/download=libpng-1.6.37.tar.gz=m68k-amigaos
VERSIONS[libogg]=1.3.5=https://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.gz=libogg-1.3.5.tar.gz=m68k-amigaos
VERSIONS[libvorbis]=1.3.7=https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.gz=libvorbis-1.3.7.tar.gz=m68k-amigaos
VERSIONS[opengl]=1.1=https://aminet.net/dev/lib/MiniGL.lha=MiniGL.lha=m68k-amigaos
VERSIONS[sdl]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.2.15.tar.gz=m68k-amigaos
VERSIONS[sdl2]=2.0.7=https://libsdl.org/release/SDL2-2.0.7.tar.gz=SDL2-2.0.7.tar.gz=m68k-amigaos
VERSIONS[sdl_image]=1.2.12=https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz=SDL_image-1.2.12.tar.gz=m68k-amigaos
VERSIONS[expat]=2.4.8=https://github.com/libexpat/libexpat/releases/download/R_2_4_8/expat-2.4.8.tar.gz=expat-2.4.8.tar.gz=m68k-amigaos
VERSIONS[libffi]=3.4.2=https://github.com/libffi/libffi/releases/download/v3.4.2/libffi-3.4.2.tar.gz=libffi-3.4.2.tar.gz=m68k-amigaos
VERSIONS[libiconv]=1.16=https://ftp.gnu.org/gnu/libiconv/libiconv-1.16.tar.gz=libiconv-1.16.tar.gz=m68k-amigaos
VERSIONS[libintl]=0.21.1=https://ftp.gnu.org/gnu/gettext/gettext-0.21.1.tar.gz=gettext-0.21.1.tar.gz=m68k-amigaos

# Extras (Dependency-first, then alphabetical)
VERSIONS[busybox]=1.35.0=https://busybox.net/downloads/busybox-1.35.0.tar.bz2=busybox-1.35.0.tar.bz2=m68k-amigaos
VERSIONS[curl]=7.83.1=https://curl.se/download/curl-7.83.1.tar.gz=curl-7.83.1.tar.gz=m68k-amigaos
VERSIONS[lame]=3.100=https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz=lame-3.100.tar.gz=m68k-amigaos
VERSIONS[nano]=6.3=https://www.nano-editor.org/dist/v6/nano-6.3.tar.xz=nano-6.3.tar.xz=m68k-amigaos

# Optional (Dependency-first, then alphabetical)
#VERSIONS[amimodplayer]=1.0=https://aminet.net/mus/play/AmiModPlayer.lha=AmiModPlayer.lha=m68k-amigaos
#VERSIONS[quake]=1.0=https://aminet.net/game/shoot/QuakeAOS.lha=QuakeAOS.lha=m68k-amigaos
#VERSIONS[scummvm]=2.8.0=https://aminet.net/game/adv/scummvm.lha=scummvm.lha=m68k-amigaos
#VERSIONS[sdl-test]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.2.15.tar.gz=m68k-amigaos

# m68k-amigaos Components Build Processes
# BUILD_STUB=custom:$(call o7_CENTER,build_stub,critical);true;$(call STOP_o7)
# STUB allows manual build from $(BUILD_DIR); leave download in place to avoid re-download.

# Build Tools
BUILD_m4=custom:$(call o7_CENTER,build_m4,critical);cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_autoconf=custom:$(call o7_CENTER,build_autoconf,critical);cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_automake=custom:$(call o7_CENTER,build_automake,critical);cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_bison=custom:$(call o7_CENTER,build_bison,critical);cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_flex=custom:$(call o7_CENTER,build_flex,critical);cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gmp=custom:$(call o7_CENTER,build_gmp,critical);cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_mpfr=custom:$(call o7_CENTER,build_mpfr,critical);cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_mpc=custom:$(call o7_CENTER,build_mpc,critical);cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_binutils=custom:$(call o7_CENTER,build_binutils,critical);cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-nls --enable-profiling $(STATIC_FLAGS) && $(MAKE) YACC=$(BISON) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gcc=custom:$(call o7_CENTER,build_gcc,critical);cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && CFLAGS="$(CFLAGS)" CC=$(PREFIX)/bin/m68k-amigaos-gcc CXX=$(PREFIX)/bin/m68k-amigaos-g++ ./configure --prefix=$(PREFIX) --target=m68k-amigaos --enable-languages=c,c++ --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) --enable-profiling $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_cmake=custom:$(call o7_CENTER,build_cmake,critical);cd $(BUILD_DIR)/cmake-$(VERSIONS[cmake]) && ./bootstrap --prefix=$(PREFIX) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gdb=custom:$(call o7_CENTER,build_gdb,critical);cd $(BUILD_DIR)/gdb-$(VERSIONS[gdb]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libtool=custom:$(call o7_CENTER,build_libtool,critical);cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_make=custom:$(call o7_CENTER,build_make,critical);cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_pkg-config=custom:$(call o7_CENTER,build_pkg-config,critical);cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vasm=custom:$(call o7_CENTER,build_vasm,critical);cd $(BUILD_DIR)/vasm && $(MKDIR) $(BUILD_DIR)/vasm/objects && $(MAKE) CPU=m68k SYNTAX=mot && $(MKDIR) $(PREFIX)/m68k/bin && $(CP) vasmm68k_mot vobjdump $(PREFIX)/m68k/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vbcc-bin=custom:$(call o7_CENTER,build_vbcc-bin,critical);$(MKDIR) $(PREFIX)/{bin,vbcc} && $(CP) $(BUILD_DIR)/vbcc/bin/* $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vbcc-target=custom:$(call o7_CENTER,build_vbcc-target,critical);$(MKDIR) $(PREFIX)/vbcc && $(CP) $(BUILD_DIR)/vbcc-target/* $(PREFIX)/vbcc >>$(LOG_FILE) 2>&1;$(call STOP_o7)

# Libraries
BUILD_zlib=custom:$(call o7_CENTER,build_zlib,critical);cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libbz2=custom:$(call o7_CENTER,build_libbz2,critical);cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so CC=$(PREFIX)/bin/m68k-amigaos-gcc AR=$(PREFIX)/bin/m68k-amigaos-ar RANLIB=$(PREFIX)/bin/m68k-amigaos-ranlib && $(MAKE) install PREFIX=$(PREFIX) && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc bzip2 && $(CP) bzip2 $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libpng=custom:$(call o7_CENTER,build_libpng,critical);cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libogg=custom:$(call o7_CENTER,build_libogg,critical);cd $(BUILD_DIR)/libogg-$(VERSIONS[libogg]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libvorbis=custom:$(call o7_CENTER,build_libvorbis,critical);cd $(BUILD_DIR)/libvorbis-$(VERSIONS[libvorbis]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-ogg=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_opengl=custom:$(call o7_CENTER,build_opengl,critical);cd $(BUILD_DIR)/MiniGL && $(MKDIR) $(PREFIX)/include/GL && $(CP) *.h $(PREFIX)/include/GL && $(CP) *.library $(PREFIX)/lib >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl=custom:$(call o7_CENTER,build_sdl,critical);cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --enable-video --enable-audio --disable-video-opengl --disable-x11 $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl2=custom:$(call o7_CENTER,build_sdl2,critical);cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --enable-video --enable-audio --disable-video-opengl $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl_image=custom:$(call o7_CENTER,build_sdl_image,critical);cd $(BUILD_DIR)/SDL_image-$(VERSIONS[sdl_image]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-sdl-prefix=$(PREFIX) --disable-jpg-shared --disable-png-shared $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_expat=custom:$(call o7_CENTER,build_expat,critical);cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libffi=custom:$(call o7_CENTER,build_libffi,critical);cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libiconv=custom:$(call o7_CENTER,build_libiconv,critical);cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libintl=custom:$(call o7_CENTER,build_libintl,critical);cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)

# Extras
BUILD_busybox=custom:$(call o7_CENTER,build_busybox,critical);cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc && $(MAKE) install CONFIG_PREFIX=$(PREFIX) >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_curl=custom:$(call o7_CENTER,build_curl,critical);cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_lame=custom:$(call o7_CENTER,build_lame,critical);cd $(BUILD_DIR)/lame-$(VERSIONS[lame]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_nano=custom:$(call o7_CENTER,build_nano,critical);cd $(BUILD_DIR)/nano-$(VERSIONS[nano]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-nls --disable-libmagic $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)

# Optional
#BUILD_amimodplayer=custom:$(call o7_CENTER,build_amimodplayer,critical);cd $(BUILD_DIR)/amimodplayer && $(MKDIR) $(PREFIX)/apps/amimodplayer && $(CP) AmiModPlayer $(PREFIX)/apps/amimodplayer >>$(LOG_FILE) 2>&1;$(call STOP_o7)
#BUILD_quake=custom:$(call o7_CENTER,build_quake,critical);cd $(BUILD_DIR)/quake && $(MKDIR) $(PREFIX)/games/quake && $(CP) quake.exe $(PREFIX)/games/quake && $(CP) -r pak0.pak $(PREFIX)/games/quake >>$(LOG_FILE) 2>&1;$(call STOP_o7)
#BUILD_scummvm=custom:$(call o7_CENTER,build_scummvm,critical);cd $(BUILD_DIR)/scummvm && $(MKDIR) $(PREFIX)/games/scummvm && $(CP) scummvm $(PREFIX)/games/scummvm >>$(LOG_FILE) 2>&1;$(call STOP_o7)
#BUILD_sdl-test=custom:$(call o7_CENTER,build_sdl-test,critical);cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl-test])/test && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MKDIR) $(PREFIX)/sdl-test && $(CP) test* $(PREFIX)/sdl-test >>$(LOG_FILE) 2>&1;$(call STOP_o7)