# m68k-amigaos.mk
#AI: Platform-specific versions and build rules for M68K-AmigaOS cross-compilation
#AI: Format: VERSIONS[component]=version=url=filename=platform
#AI: Machine-readable/writable; human-editable for adding versions and builds

# Copyright (c) 2025 Zachary Geurts, MIT License

#AI: Component Details
#AI: |Component|Description|Installed Size|Memory|Min CPU|
#AI: |---------|-----------|--------------|------|-------|
#AI:|autoconf|Generates configure scripts|2.1MB|512KB|7MHz|
#AI:|automake|Automates Makefile|1.8MB|512KB|7MHz|
#AI:|bison|Parser generator|1.3MB|256KB|7MHz|
#AI:|busybox|Lightweight Unix utilities|512KB|512KB|7MHz|
#AI:|expat|XML parsing library|256KB|128KB|7MHz|
#AI:|flex|Lexical analyzer|512KB|256KB|7MHz|
#AI:|gmp|Arbitrary-precision arithmetic|512KB|512KB|7MHz|
#AI:|libbz2|Compression library, bzip2 tool|256KB|128KB|7MHz|
#AI:|curl|Data transfer library and tool|512KB|512KB|7MHz|
#AI:|libffi|Foreign function interface|128KB|128KB|7MHz|
#AI:|libiconv|Character encoding conversion|1.2MB|256KB|7MHz|
#AI:|libintl|Internationalization library|1.5MB|256KB|7MHz|
#AI:|libpng|PNG image library|256KB|256KB|7MHz|
#AI:|libtool|Library building tool|1MB|256KB|7MHz|
#AI:|m4|Macro processor|512KB|128KB|7MHz|
#AI:|make|Build automation tool|1MB|256KB|7MHz|
#AI:|mpc|Complex arithmetic library|128KB|128KB|7MHz|
#AI:|mpfr|Floating-point arithmetic|512KB|512KB|7MHz|
#AI:|nano|Lightweight editor|512KB|512KB|7MHz|
#AI:|opengl|MiniGL OpenGL 1.1|256KB|1MB|14MHz|
#AI:|pkg-config|Package configuration|128KB|128KB|7MHz|
#AI:|sdl|SDL 1.2 video/audio|512KB|1MB|7MHz|
#AI:|sdl2|SDL 2.30 video/audio|1MB|1.5MB|14MHz|
#AI:|sdl_image|Image loading for SDL|256KB|512KB|7MHz|
#AI:|zlib|Compression library|128KB|128KB|7MHz|
#AI:|binutils|Assembler, linker, gprof|1.5MB|512KB|7MHz|
#AI:|cmake|Modern build system|10MB|2MB|14MHz|
#AI:|gcc|C/C++ compiler with gprof|8MB|2MB|7MHz|
#AI:|gdb|Debugger for C/C++|2MB|1MB|7MHz|
#AI:|vasm|M68K assembler|512KB|256KB|7MHz|
#AI:|vbcc-bin|VBCC C compiler binaries|1MB|512KB|7MHz|
#AI:|vbcc-target|VBCC M68K target config|512KB|256KB|7MHz|
#AI: Components requiring >2MB RAM (cmake, gcc) are included; comment out if RAM is limited.

# Declare phony target
.PHONY: m68k-amigaos

# If you comment out a VERSIONS line, you will need to comment out the corresponding BUILD_ section
# Versions: VERSIONS[component]=version=url=filename=platform
VERSIONS[autoconf]=2.72=https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz=autoconf-2.72.tar.gz=m68k-amigaos
VERSIONS[automake]=1.17=https://ftp.gnu.org/gnu/automake/automake-1.17.tar.gz=automake-1.17.tar.gz=m68k-amigaos
VERSIONS[bison]=3.8.2=https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz=bison-3.8.2.tar.gz=m68k-amigaos
VERSIONS[busybox]=1.36.1=https://busybox.net/downloads/busybox-1.36.1.tar.bz2=busybox-1.36.1.tar.bz2=m68k-amigaos
VERSIONS[expat]=2.6.3=https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-2.6.3.tar.gz=expat-2.6.3.tar.gz=m68k-amigaos
VERSIONS[flex]=2.6.4=https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz=flex-2.6.4.tar.gz=m68k-amigaos
VERSIONS[gmp]=6.3.0=https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz=gmp-6.3.0.tar.xz=m68k-amigaos
VERSIONS[libbz2]=1.0.8=https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz=bzip2-1.0.8.tar.gz=m68k-amigaos
VERSIONS[curl]=8.10.1=https://curl.se/download/curl-8.10.1.tar.gz=curl-8.10.1.tar.gz=m68k-amigaos
VERSIONS[libffi]=3.4.6=https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz=libffi-3.4.6.tar.gz=m68k-amigaos
VERSIONS[libiconv]=1.17=https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz=libiconv-1.17.tar.gz=m68k-amigaos
VERSIONS[libintl]=0.22.5=https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz=gettext-0.22.5.tar.gz=m68k-amigaos
VERSIONS[libpng]=1.6.44=https://sourceforge.net/projects/libpng/files/libpng16/1.6.44/libpng-1.6.44.tar.gz/download=libpng-1.6.44.tar.gz=m68k-amigaos
VERSIONS[libtool]=2.4.7=https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz=libtool-2.4.7.tar.gz=m68k-amigaos
VERSIONS[m4]=1.4.19=https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz=m4-1.4.19.tar.gz=m68k-amigaos
VERSIONS[make]=4.4.1=https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz=make-4.4.1.tar.gz=m68k-amigaos
VERSIONS[mpc]=1.3.1=https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz=mpc-1.3.1.tar.gz=m68k-amigaos
VERSIONS[mpfr]=4.2.1=https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.gz=mpfr-4.2.1.tar.gz=m68k-amigaos
VERSIONS[nano]=8.2=https://www.nano-editor.org/dist/v8/nano-8.2.tar.xz=nano-8.2.tar.xz=m68k-amigaos
VERSIONS[opengl]=1.1=https://aminet.net/dev/lib/MiniGL.lha=MiniGL.lha=m68k-amigaos
VERSIONS[pkg-config]=0.29.2=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz=pkg-config-0.29.2.tar.gz=m68k-amigaos
VERSIONS[sdl]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.2.15.tar.gz=m68k-amigaos
VERSIONS[sdl2]=2.30.8=https://libsdl.org/release/SDL2-2.30.8.tar.gz=SDL2-2.30.8.tar.gz=m68k-amigaos
VERSIONS[sdl_image]=2.8.2=https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.8.2.tar.gz=SDL2_image-2.8.2.tar.gz=m68k-amigaos
VERSIONS[cmake]=3.30.5=https://github.com/Kitware/CMake/releases/download/v3.30.5/cmake-3.30.5.tar.gz=cmake-3.30.5.tar.gz=m68k-amigaos
VERSIONS[gcc]=2.95.3=https://ftp.gnu.org/gnu/gcc/gcc-2.95.3.tar.gz=gcc-2.95.3.tar.gz=m68k-amigaos
VERSIONS[gdb]=7.5=https://ftp.gnu.org/gnu/gdb/gdb-7.5.tar.gz=gdb-7.5.tar.gz=m68k-amigaos
VERSIONS[vasm]=1.9d=http://phx.de/ftp/vasm/vasm1_9d.tar.gz=vasm1_9d.tar.gz=m68k-amigaos
VERSIONS[vbcc-bin]=0.9j=http://phx.de/ftp/vbcc/vbcc0_9j_bin_amigaos68k.lha=vbcc0_9j_bin_amigaos68k.lha=m68k-amigaos
VERSIONS[vbcc-target]=0.9j=http://phx.de/ftp/vbcc/vbcc_target_m68k-amigaos.lha=vbcc_target_m68k-amigaos.lha=m68k-amigaos
VERSIONS[zlib]=1.3.2=https://zlib.net/zlib-1.3.2.tar.gz=zlib-1.3.2.tar.gz=m68k-amigaos
VERSIONS[binutils]=2.14=https://ftp.gnu.org/gnu/binutils/binutils-2.14.tar.gz=binutils-2.14.tar.gz=m68k-amigaos

# If you comment out a BUILD_ line, you will need to comment out the corresponding VERSIONS section
# m68k-amigaos Components Build Processes
BUILD_autoconf=custom:$(call o7_CENTER,build_autoconf,critical);cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_automake=custom:$(call o7_CENTER,build_automake,critical);cd $(BUILD_DIR)/automake-$(VERSIONS[automake]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_bison=custom:$(call o7_CENTER,build_bison,critical);cd $(BUILD_DIR)/bison-$(VERSIONS[bison]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_busybox=custom:$(call o7_CENTER,build_busybox,critical);cd $(BUILD_DIR)/busybox-$(VERSIONS[busybox]) && $(MAKE) defconfig && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc && $(MAKE) install CONFIG_PREFIX=$(PREFIX) >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_expat=custom:$(call o7_CENTER,build_expat,critical);cd $(BUILD_DIR)/expat-$(VERSIONS[expat]) && ./buildconf.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_flex=custom:$(call o7_CENTER,build_flex,critical);cd $(BUILD_DIR)/flex-$(VERSIONS[flex]) && ./autogen.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gmp=custom:$(call o7_CENTER,build_gmp,critical);cd $(BUILD_DIR)/gmp-$(VERSIONS[gmp]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libbz2=custom:$(call o7_CENTER,build_libbz2,critical);cd $(BUILD_DIR)/bzip2-$(VERSIONS[libbz2]) && $(MAKE) -f Makefile-libbz2_so CC=$(PREFIX)/bin/m68k-amigaos-gcc AR=$(PREFIX)/bin/m68k-amigaos-ar RANLIB=$(PREFIX)/bin/m68k-amigaos-ranlib && $(MAKE) install PREFIX=$(PREFIX) && $(MAKE) CC=$(PREFIX)/bin/m68k-amigaos-gcc bzip2 && $(CP) bzip2 $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_curl=custom:$(call o7_CENTER,build_curl,critical);cd $(BUILD_DIR)/curl-$(VERSIONS[curl]) && ./buildconf && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libffi=custom:$(call o7_CENTER,build_libffi,critical);cd $(BUILD_DIR)/libffi-$(VERSIONS[libffi]) && ./autogen.sh && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libiconv=custom:$(call o7_CENTER,build_libiconv,critical);cd $(BUILD_DIR)/libiconv-$(VERSIONS[libiconv]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libintl=custom:$(call o7_CENTER,build_libintl,critical);cd $(BUILD_DIR)/gettext-$(VERSIONS[libintl]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libpng=custom:$(call o7_CENTER,build_libpng,critical);cd $(BUILD_DIR)/libpng-$(VERSIONS[libpng]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-zlib=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_libtool=custom:$(call o7_CENTER,build_libtool,critical);cd $(BUILD_DIR)/libtool-$(VERSIONS[libtool]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_m4=custom:$(call o7_CENTER,build_m4,critical);cd $(BUILD_DIR)/m4-$(VERSIONS[m4]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_make=custom:$(call o7_CENTER,build_make,critical);cd $(BUILD_DIR)/make-$(VERSIONS[make]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_mpc=custom:$(call o7_CENTER,build_mpc,critical);cd $(BUILD_DIR)/mpc-$(VERSIONS[mpc]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_mpfr=custom:$(call o7_CENTER,build_mpfr,critical);cd $(BUILD_DIR)/mpfr-$(VERSIONS[mpfr]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-gmp=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_nano=custom:$(call o7_CENTER,build_nano,critical);cd $(BUILD_DIR)/nano-$(VERSIONS[nano]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-nls --disable-libmagic $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_opengl=custom:$(call o7_CENTER,build_opengl,critical);cd $(BUILD_DIR)/MiniGL && $(MKDIR) $(PREFIX)/include/GL && $(CP) *.h $(PREFIX)/include/GL && $(CP) *.library $(PREFIX)/lib >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_pkg-config=custom:$(call o7_CENTER,build_pkg-config,critical);cd $(BUILD_DIR)/pkg-config-$(VERSIONS[pkg-config]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-internal-glib $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl=custom:$(call o7_CENTER,build_sdl,critical);cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --enable-video --enable-audio --disable-video-opengl --disable-x11 $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl2=custom:$(call o7_CENTER,build_sdl2,critical);cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --enable-video --enable-audio --disable-video-opengl $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_sdl_image=custom:$(call o7_CENTER,build_sdl_image,critical);cd $(BUILD_DIR)/SDL2_image-$(VERSIONS[sdl_image]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --with-sdl-prefix=$(PREFIX) --disable-jpg-shared --disable-png-shared $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_cmake=custom:$(call o7_CENTER,build_cmake,critical);cd $(BUILD_DIR)/cmake-$(VERSIONS[cmake]) && ./bootstrap --prefix=$(PREFIX) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gcc=custom:$(call o7_CENTER,build_gcc,critical);cd $(BUILD_DIR)/gcc-$(VERSIONS[gcc]) && CFLAGS="$(CFLAGS)" CC=$(PREFIX)/bin/m68k-amigaos-gcc CXX=$(PREFIX)/bin/m68k-amigaos-g++ ./configure --prefix=$(PREFIX) --target=m68k-amigaos --enable-languages=c,c++ --with-gmp=$(PREFIX) --with-mpfr=$(PREFIX) --with-mpc=$(PREFIX) --enable-profiling $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_gdb=custom:$(call o7_CENTER,build_gdb,critical);cd $(BUILD_DIR)/gdb-$(VERSIONS[gdb]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vasm=custom:$(call o7_CENTER,build_vasm,critical);cd $(BUILD_DIR)/vasm && $(MKDIR) $(BUILD_DIR)/vasm/objects && $(MAKE) CPU=m68k SYNTAX=mot && $(MKDIR) $(PREFIX)/m68k/bin && $(CP) $(BUILD_DIR)/vasm/vasmm68k_mot $(BUILD_DIR)/vasm/vobjdump $(PREFIX)/m68k/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vbcc-bin=custom:$(call o7_CENTER,build_vbcc-bin,critical);$(MKDIR) $(PREFIX)/{bin,vbcc} && $(CP) $(BUILD_DIR)/vbcc/bin/* $(PREFIX)/bin >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_vbcc-target=custom:$(call o7_CENTER,build_vbcc-target,critical);$(MKDIR) $(PREFIX)/vbcc && $(CP) $(BUILD_DIR)/vbcc-target/* $(PREFIX)/vbcc >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_zlib=custom:$(call o7_CENTER,build_zlib,critical);cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)
BUILD_binutils=custom:$(call o7_CENTER,build_binutils,critical);cd $(BUILD_DIR)/binutils-$(VERSIONS[binutils]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos --disable-nls --enable-profiling $(STATIC_FLAGS) && $(MAKE) YACC=$(BISON) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7)

#AI: Notes for adding components
#AI: - VERSIONS[component]=version=url=filename=m68k-amigaos (e.g., VERSIONS[zlib]=1.3.2=https://zlib.net/zlib-1.3.2.tar.gz=zlib-1.3.2.tar.gz=m68k-amigaos)
#AI: - BUILD_component=custom:<commands> (e.g., BUILD_zlib=custom:$(call o7_CENTER,build_zlib,critical);cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) --target=m68k-amigaos $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_o7))
#AI: - Use $(PREFIX), $(BUILD_DIR), $(LOG_FILE), $(STATIC_FLAGS) for consistency
#AI: - Wrap build commands with $(call o7_CENTER,build_<component>,critical) and $(call STOP_o7)
#AI: - Target-specific variables: $(m68k-amigaos)_PREFIX, $(m68k-amigaos)_BUILD, $(m68k-amigaos)_DOWNLOAD, $(m68k-amigaos)_STAMPS
#AI: - See ppc-amigaos.mk for examples
#AI: - Components requiring >2MB RAM (e.g., cmake, gcc) are included; comment out if RAM is limited
#AI: - Find stable URLs at https://ftp.gnu.org, https://libsdl.org, https://aminet.net, etc.