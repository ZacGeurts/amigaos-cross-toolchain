# ppc-amigaos.mk
# Platform-specific versions and build rules for PPC-AmigaOS cross-compilation
# Format: VERSIONS[component]=version=url=filename=platform
# Optimized for AmigaOS 4.x on early 2000s hardware (200MHz+ CPU)
# Copyright (c) 2025 Zachary Geurts, MIT License

.PHONY: ppc-amigaos

# User Notes:
# - Add or modify VERSIONS and BUILD_ lines together (both commented or uncommented).
# - Use BUILD_STUB=custom:$(call o7_CENTER,build_stub,critical);true;$(call STOP_o7) for manual builds after download.
# - Leave downloads in $(BUILD_DIR) to avoid re-downloading.
# - Order: Dependency-first, then alphabetical within Build Tools, Libraries, Extras, Optional.
# - Use $(PREFIX), $(BUILD_DIR), $(LOG_FILE), $(STATIC_FLAGS) for consistency.
# - Wrap build commands with $(call o7_CENTER,build_<component>,critical) and $(call STOP_o7).
# - Target variables: $(ppc-amigaos)_PREFIX, $(ppc-amigaos)_BUILD, $(ppc-amigaos)_DOWNLOAD, $(ppc-amigaos)_STAMPS.
# - Commented components (e.g., quake, sdl-test) are optional.
# - GCC 4.2.4, Binutils 2.18, and SDL 1.2 are stable; SDL2 and games are optional.

# Versions: VERSIONS[component]=version=url=filename=platform
# Build Tools (Dependency-first, then alphabetical)
VERSIONS[m4]=1.4.19=https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz=m4-1.4.19.tar.gz=ppc-amigaos
VERSIONS[autoconf]=2.71=https://ftp.gnu.org/gnu/autoconf/autoconf-2.71.tar.gz=autoconf-2.71.tar.gz=ppc-amigaos
VERSIONS[automake]=1.16.5=https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.gz=automake-1.16.5.tar.gz=ppc-amigaos
VERSIONS[bison]=3.8.2=https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz=bison-3.8.2.tar.gz=ppc-amigaos
VERSIONS[flex]=2.6.4=https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz=flex-2.6.4.tar.gz=ppc-amigaos
VERSIONS[gmp]=6.2.1=https://ftp.gnu.org/gnu/gmp/gmp-6.2.1.tar.xz=gmp-6.2.1.tar.xz=ppc-amigaos
VERSIONS[mpfr]=4.1.0=https://ftp.gnu.org/gnu/mpfr/mpfr-4.1.0.tar.gz=mpfr-4.1.0.tar.gz=ppc-amigaos
VERSIONS[mpc]=1.2.1=https://ftp.gnu.org/gnu/mpc/mpc-1.2.1.tar.gz=mpc-1.2.1.tar.gz=ppc-amigaos
VERSIONS[binutils]=2.18=https://ftp.gnu.org/gnu/binutils/binutils-2.18.tar.gz=binutils-2.18.tar.gz=ppc-amigaos
VERSIONS[gcc]=4.2.4=https://ftp.gnu.org/gnu/gcc/gcc-4.2.4.tar.gz=gcc-4.2.4.tar.gz=ppc-amigaos
VERSIONS[cmake]=3.22.1=https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz=cmake-3.22.1.tar.gz=ppc-amigaos
VERSIONS[fd2pragma]=1.0=https://github.com/adtools/fd2pragma/archive/refs/tags/v1.0.tar.gz=fd2pragma-1.0.tar.gz=ppc-amigaos
VERSIONS[fd2sfd]=1.0=https://github.com/adtools/fd2sfd/archive/refs/tags/v1.0.tar.gz=fd2sfd-1.0.tar.gz=ppc-amigaos
VERSIONS[gdb]=8.3=https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.gz=gdb-8.3.tar.gz=ppc-amigaos
VERSIONS[libtool]=2.4.6=https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.gz=libtool-2.4.6.tar.gz=ppc-amigaos
VERSIONS[make]=4.3=https://ftp.gnu.org/gnu/make/make-4.3.tar.gz=make-4.3.tar.gz=ppc-amigaos
VERSIONS[pkg-config]=0.29.2=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz=pkg-config-0.29.2.tar.gz=ppc-amigaos
VERSIONS[sfdc]=1.0=https://github.com/sba1/sfdc/archive/refs/tags/v1.0.tar.gz=sfdc-1.0.tar.gz=ppc-amigaos
VERSIONS[texinfo]=6.8=https://ftp.gnu.org/gnu/texinfo/texinfo-6.8.tar.gz=texinfo-6.8.tar.gz=ppc-amigaos
VERSIONS[vasm]=1.9d=https://aminet.net/dev/asm/vasm.lha=vasm1_9d.lha=ppc-amigaos
VERSIONS[vbcc-bin]=0.9j=https://aminet.net/dev/c/vbcc_bin.lha=vbcc0_9j_bin_amigaos.lha=ppc-amigaos
VERSIONS[vbcc-target]=0.9j=https://aminet.net/dev/c/vbcc_ppc_target.lha=vbcc_target_ppc-amigaos.lha=ppc-amigaos

# Libraries (Dependency-first, then alphabetical)
VERSIONS[zlib]=1.2.11=https://zlib.net/zlib-1.2.11.tar.gz=zlib-1.2.11.tar.gz=ppc-amigaos
VERSIONS[libbz2]=1.0.8=https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz=bzip2-1.0.8.tar.gz=ppc-amigaos
VERSIONS[libpng]=1.6.37=https://sourceforge.net/projects/libpng/files/libpng16/1.6.37/libpng-1.6.37.tar.gz/download=libpng-1.6.37.tar.gz=ppc-amigaos
VERSIONS[libogg]=1.3.5=https://downloads.xiph.org/releases/ogg/libogg-1.3.5.tar.gz=libogg-1.3.5.tar.gz=ppc-amigaos
VERSIONS[libvorbis]=1.3.7=https://downloads.xiph.org/releases/vorbis/libvorbis-1.3.7.tar.gz=libvorbis-1.3.7.tar.gz=ppc-amigaos
VERSIONS[opengl]=2.0=https://aminet.net/dev/lib/Warp3D.lha=Warp3D.lha=ppc-amigaos
VERSIONS[sdl]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.2.15.tar.gz=ppc-amigaos
VERSIONS[sdl2]=2.0.7=https://libsdl.org/release/SDL2-2.0.7.tar.gz=SDL2-2.0.7.tar.gz=ppc-amigaos
VERSIONS[sdl_image]=1.2.12=https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz=SDL_image-1.2.12.tar.gz=ppc-amigaos
VERSIONS[clib2]=1.0=https://github.com/adtools/clib2/archive/refs/tags/v1.0.tar.gz=clib2-1.0.tar.gz=ppc-amigaos
VERSIONS[expat]=2.4.8=https://github.com/libexpat/libexpat/releases/download/R_2_4_8/expat-2.4.8.tar.gz=expat-2.4.8.tar.gz=ppc-amigaos
VERSIONS[ixemul]=1.0=https://github.com/amigadave/ixemul/archive/refs/tags/v1.0.tar.gz=ixemul-1.0.tar.gz=ppc-amigaos
VERSIONS[libdebug]=1.0=https://github.com/amigadave/libdebug/archive/refs/tags/v1.0.tar.gz=libdebug-1.0.tar.gz=ppc-amigaos
VERSIONS[libnix]=1.0=https://github.com/cahir/libnix/archive/refs/tags/v1.0.tar.gz=libnix-1.0.tar.gz=ppc-amigaos
VERSIONS[newlib]=1.0=https://github.com/sba1/adtools/archive/refs/tags/v1.0.tar.gz=adtools-1.0.tar.gz=ppc-amigaos
VERSIONS[libffi]=3.4.2=https://github.com/libffi/libffi/releases/download/v3.4.2/libffi-3.4.2.tar.gz=libffi-3.4.2.tar.gz=ppc-amigaos
VERSIONS[libiconv]=1.16=https://ftp.gnu.org/gnu/libiconv/libiconv-1.16.tar.gz=libiconv-1.16.tar.gz=ppc-amigaos
VERSIONS[libintl]=0.21.1=https://ftp.gnu.org/gnu/gettext/gettext-0.21.1.tar.gz=gettext-0.21.1.tar.gz=ppc-amigaos

# Extras (Dependency-first, then alphabetical)
VERSIONS[busybox]=1.35.0=https://busybox.net/downloads/busybox-1.35.0.tar.bz2=busybox-1.35.0.tar.bz2=ppc-amigaos
VERSIONS[curl]=7.83.1=https://curl.se/download/curl-7.83.1.tar.gz=curl-7.83.1.tar.gz=ppc-amigaos
VERSIONS[gzip]=1.10=https://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.gz=gzip-1.10.tar.gz=ppc-amigaos
VERSIONS[lame]=3.100=https://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz=lame-3.100.tar.gz=ppc-amigaos
VERSIONS[lha]=2.92=https://aminet.net/util/arc/LhA_2_92.lha=LhA_2_92.lha=ppc-amigaos
VERSIONS[p7zip]=16.02=https://sourceforge.net/projects/p7zip/files/p7zip/16.02/p7zip_16.02_src_all.tar.bz2=p7zip_16.02.tar.bz2=ppc-amigaos

# Optional (Dependency-first, then alphabetical)
#VERSIONS[amimodplayer]=1.0=https://aminet.net/mus/play/AmiModPlayer.lha=AmiModPlayer.lha=ppc-amigaos
#VERSIONS[quake]=1.0=https://aminet.net/game/shoot/QuakeAOS4.lha=QuakeAOS4.lha=ppc-amigaos
#VERSIONS[sdl-test]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.2.15.tar.gz=ppc-amigaos

# ppc-amigaos Components Build Processes
# BUILD_STUB=custom:$(call o7_CENTER,build_stub,critical);true;$(call STOP_o7)
# STUB allows manual build from $(BUILD_DIR); leave download in place to avoid re-download.

# Build Tools
BUILD_m4=custom:$(call o7_CENTER,build_m4,critical);cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_autoconf=custom:$(call o7_CENTER,build_autoconf,critical);cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_automake=custom:$(call o7_CENTER,build_automake,critical);cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_bison=custom:$(call o7_CENTER,build_bison,critical);cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_flex=custom:$(call o7_CENTER,build_flex,critical);cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gmp=custom:$(call o7_CENTER,build_gmp,critical);cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_mpfr=custom:$(call o7_CENTER,build_mpfr,critical);cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_mpc=custom:$(call o7_CENTER,build_mpc,critical);cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_binutils=custom:$(call o7_CENTER,build_binutils,critical);cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --disable-nls $(STATIC_FLAGS) && $(MAKE) YACC=$(BISON) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gcc=custom:$(call o7_CENTER,build_gcc,critical);cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && CFLAGS="$(CFLAGS)" CC=$(PREFIX)/bin/ppc-amigaos-gcc CXX=$(PREFIX)/bin/ppc-amigaos-g++ ./configure --prefix=$(PREFIX) --target=ppc-amigaos --enable-languages=c,c++ --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) --with-newlib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_cmake=custom:$(call o7_CENTER,build_cmake,critical);cd $(BUILD_DIR)/cmake-$(VERSIONS[cmake]) && ./bootstrap --prefix=$(PREFIX) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_fd2pragma=custom:$(call o7_CENTER,build_fd2pragma,critical);cd $(BUILD_DIR)/fd2pragma && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MKDIR) $(PREFIX)/ndk/include/inline && $(CP) fd2pragma $(PREFIX)/bin && $(CP) Include/include/inline/{macros,stubs}.h $(PREFIX)/ndk/include/inline >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_fd2sfd=custom:$(call o7_CENTER,build_fd2sfd,critical);cd $(BUILD_DIR)/fd2sfd && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gdb=custom:$(call o7_CENTER,build_gdb,critical);cd $(BUILD_DIR)/gdb-$(VERSIONS[gdb]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libtool=custom:$(call o7_CENTER,build_libtool,critical);cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_make=custom:$(call o7_CENTER,build_make,critical);cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_pkg-config=custom:$(call o7_CENTER,build_pkg-config,critical);cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sfdc=custom:$(call o7_CENTER,build_sfdc,critical);cd $(BUILD_DIR)/sfdc && $(MAKE) && $(MKDIR) $(PREFIX)/bin && $(CP) sfdc $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_texinfo=custom:$(call o7_CENTER,build_texinfo,critical);cd $(BUILD_DIR)/texinfo-$(VERSIONS[texinfo]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vasm=custom:$(call o7_CENTER,build_vasm,critical);cd $(BUILD_DIR)/vasm && $(MKDIR) $(BUILD_DIR)/vasm/objects && $(MAKE) CPU=ppc SYNTAX=mot && $(MKDIR) $(PREFIX)/ppc/bin && $(CP) vasmppc_mot vobjdump $(PREFIX)/ppc/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vbcc-bin=custom:$(call o7_CENTER,build_vbcc-bin,critical);$(MKDIR) $(PREFIX)/{bin,vbcc} && $(CP) $(BUILD_DIR)/vbcc/bin/* $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vbcc-target=custom:$(call o7_CENTER,build_vbcc-target,critical);$(MKDIR) $(PREFIX)/vbcc && $(CP) $(BUILD_DIR)/vbcc-target/* $(PREFIX)/vbcc >>$(LOG_FILE) 2>&1;$(call STOP_o7)

# Libraries
BUILD_zlib=custom:$(call o7_CENTER,build_zlib,critical);cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libbz2=custom:$(call o7_CENTER,build_libbz2,critical);cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so CC=$(PREFIX)/bin/ppc-amigaos-gcc AR=$(PREFIX)/bin/ppc-amigaos-ar RANLIB=$(PREFIX)/bin/ppc-amigaos-ranlib && $(MAKE) install PREFIX=$(PREFIX) && $(CP) bzip2 $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libpng=custom:$(call o7_CENTER,build_libpng,critical);cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libogg=custom:$(call o7_CENTER,build_libogg,critical);cd $(BUILD_DIR)/libogg-$(VERSIONS[libogg]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libvorbis=custom:$(call o7_CENTER,build_libvorbis,critical);cd $(BUILD_DIR)/libvorbis-$(VERSIONS[libvorbis]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-ogg=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_opengl=custom:$(call o7_CENTER,build_opengl,critical);cd $(BUILD_DIR)/Warp3D && $(MKDIR) $(PREFIX)/include/GL && $(CP) *.h $(PREFIX)/include/GL && $(CP) *.library $(PREFIX)/lib >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl=custom:$(call o7_CENTER,build_sdl,critical);cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --enable-video --enable-audio --disable-video-opengl --disable-x11 $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl2=custom:$(call o7_CENTER,build_sdl2,critical);cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --enable-video --enable-audio --disable-video-opengl $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl_image=custom:$(call o7_CENTER,build_sdl_image,critical);cd $(BUILD_DIR)/SDL_image-$(VERSIONS[sdl_image]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-sdl-prefix=$(PREFIX) --disable-jpg-shared --disable-png-shared $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_clib2=custom:$(call o7_CENTER,build_clib2,critical);cd $(BUILD_DIR)/clib2 && $(MAKE) -f GNUmakefile TARGET=ppc-amigaos && $(MKDIR) $(PREFIX)/clib2/{lib,include} && $(CP) lib/* $(PREFIX)/clib2/lib && $(CP) include/* $(PREFIX)/clib2/include >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_expat=custom:$(call o7_CENTER,build_expat,critical);cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_ixemul=custom:$(call o7_CENTER,build_ixemul,critical);cd $(BUILD_DIR)/ixemul && ./configure --prefix=$(PREFIX)/lib --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MKDIR) $(PREFIX)/libnix/include && $(CP) source/stabs.h $(PREFIX)/libnix/include >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libdebug=custom:$(call o7_CENTER,build_libdebug,critical);cd $(BUILD_DIR)/libdebug && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libnix=custom:$(call o7_CENTER,build_libnix,critical);cd $(BUILD_DIR)/libnix && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_newlib=custom:$(call o7_CENTER,build_newlib,critical);cd $(BUILD_DIR)/adtools/newlib && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libffi=custom:$(call o7_CENTER,build_libffi,critical);cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libiconv=custom:$(call o7_CENTER,build_libiconv,critical);cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libintl=custom:$(call o7_CENTER,build_libintl,critical);cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)

# Extras
BUILD_busybox=custom:$(call o7_CENTER,build_busybox,critical);cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) CC=$(PREFIX)/bin/ppc-amigaos-gcc CONFIG_PREFIX=$(PREFIX) >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_curl=custom:$(call o7_CENTER,build_curl,critical);cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gzip=custom:$(call o7_CENTER,build_gzip,critical);cd $(BUILD_DIR)/gzip-$(VERSIONS[gzip]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos --disable-nls $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_lame=custom:$(call o7_CENTER,build_lame,critical);cd $(BUILD_DIR)/lame-$(VERSIONS[lame]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_lha=custom:$(call o7_CENTER,build_lha,critical);cd $(BUILD_DIR)/lha-$(VERSIONS[lha]) && $(MAKE) CC=$(PREFIX)/bin/ppc-amigaos-gcc CFLAGS="-O2 -fbaserel" && $(MKDIR) $(PREFIX)/bin && $(CP) lha $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_p7zip=custom:$(call o7_CENTER,build_p7zip,critical);cd $(BUILD_DIR)/p7zip-$(VERSIONS[p7zip]) && $(CP) makefile.amiga makefile && $(MAKE) CC=$(PREFIX)/bin/ppc-amigaos-gcc CXX=$(PREFIX)/bin/ppc-amigaos-g++ 7z && $(MKDIR) $(PREFIX)/bin && $(CP) bin/7z $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)

# Optional
#BUILD_amimodplayer=custom:$(call o7_CENTER,build_amimodplayer,critical);cd $(BUILD_DIR)/amimodplayer && $(MKDIR) $(PREFIX)/apps/amimodplayer && $(CP) AmiModPlayer $(PREFIX)/apps/amimodplayer >>$(LOG_FILE) 2>&1;$(call STOP_o7)
#BUILD_quake=custom:$(call o7_CENTER,build_quake,critical);cd $(BUILD_DIR)/quake && $(MKDIR) $(PREFIX)/games/quake && $(CP) quake.exe $(PREFIX)/games/quake && $(CP) -r pak0.pak $(PREFIX)/games/quake >>$(LOG_FILE) 2>&1;$(call STOP_o7)
#BUILD_sdl-test=custom:$(call o7_CENTER,build_sdl-test,critical);cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl-test])/test && ./configure --prefix=$(PREFIX) --target=ppc-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MKDIR) $(PREFIX)/sdl-test && $(CP) test* $(PREFIX)/sdl-test >>$(LOG_FILE) 2>&1;$(call STOP_o7)