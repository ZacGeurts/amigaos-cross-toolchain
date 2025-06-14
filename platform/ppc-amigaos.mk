# ppc-amigaos.mk
#AI: Platform-specific versions and build rules for PPC-AmigaOS cross-compilation
#AI: Format: VERSIONS[component]=version=url=filename=platform
#AI: Machine-readable/writable; human-editable for adding versions and builds

# Copyright (c) 2025 Zachary Geurts, MIT License

#AI: Component Details
#AI: |Component|Description|Installed Size|Memory|Min CPU|
#AI: |---------|-----------|--------------|------|-------|
#AI:|autoconf|Generates configure scripts|2.1MB|1MB|200MHz|
#AI:|automake|Automates Makefile|1.8MB|1MB|200MHz|
#AI:|bison|Parser generator|1.3MB|512KB|200MHz|
#AI:|busybox|Lightweight Unix utilities|1MB|1MB|200MHz|
#AI:|expat|XML parsing library|256KB|256KB|200MHz|
#AI:|flex|Lexical analyzer|512KB|512KB|200MHz|
#AI:|gmp|Arbitrary-precision arithmetic|1MB|1MB|200MHz|
#AI:|libbz2|Compression library, bzip2 tool|256KB|256KB|200MHz|
#AI:|curl|Data transfer library and tool|1MB|1MB|200MHz|
#AI:|libffi|Foreign function interface|128KB|128KB|200MHz|
#AI:|libiconv|Character encoding conversion|1.2MB|512KB|200MHz|
#AI:|libintl|Internationalization library|1.5MB|512KB|200MHz|
#AI:|libpng|PNG image library|256KB|512KB|200MHz|
#AI:|libtool|Library building tool|1MB|512KB|200MHz|
#AI:|m4|Macro processor|512KB|256KB|200MHz|
#AI:|make|Build automation tool|1MB|512KB|200MHz|
#AI:|mpc|Complex arithmetic library|128KB|128KB|200MHz|
#AI:|mpfr|Floating-point arithmetic|1MB|1MB|200MHz|
#AI:|opengl|Warp3D OpenGL (needs 3)|512KB|800KB|400MHz|
#AI:|pkg-config|Package configuration|128KB|128KB|200MHz|
#AI:|sdl|SDL 1.2 video/audio|480KB|384KB|200MHz|
#AI:|sdl2|SDL 2.0 video/audio|1.9MB|2.3MB|400MHz|
#AI:|sdl_image|Image loading for SDL|512KB|384KB|200MHz|
#AI:|texinfo|Documentation system|2MB|1MB|200MHz|
#AI:|zlib|Compression library|128KB|128KB|200KB|
#AI:|binutils|Assembler, linker|20MB|4MB|2GHz|
#AI:|cmake|Modern build system|10MB|4MB|400MHz|
#AI:|clib2|C standard library|2MB|1MB|gcc|
#AI:|fd2pragma|FD to pragma converter|128KB|128KB|gcc|
#AI:|fd2sfd|FD to SFD converter|128KB|gcc|
#AI:|gcc|C/C++ compiler|10MB|4MB|gcc|
#AI:|gdb|Debugger for C/C++|3MB|2MB|gcc|
#AI:|ixemul|Unix compatibility library|gcc|gcc|
#AI:|libdebug|Debugging library|gcc|256KB|
#AI:|libnix|Unix-like C library|gcc|gcc|
#AI:|newlib|C standard library|2MB|gcc|
#AI:|sfdc|SFD compiler|256KB|gcc|
#AI:|vasm|PPC assembler|512KB|asm|
#AI:|vbcc-bin|VBCC compiler binaries|1MB|gcc|
#AI:|vbcc-target|VBCC PPC target config|512KB|
#AI:|codebench|IDE for AmigaOS|5MB|2MB|gcc|
#AI:|lha|Archive utility|256KB|512KB|
#AI:|p7zip|7z archive utility|2MB|1MB|
#AI:|gzip|Compression utility|256KB|512KB|

# Declare phony target
.PHONY: ppc-amigaos

# if you commonent out a VERSIONS line you will need to comment out from the BUILD_ section
# Versions: VERSIONS[component]=version=url=filename=platform
VERSIONS[autoconf]=2.72=https://ftp.gnu.org/gnu/autoconf/autoconf-2.72.tar.gz=autoconf-2.72.tar.gz=ppc-amigaos
VERSIONS[automake]=1.17=https://ftp.gnu.org/gnu/automake/automake-1.17.tar.gz=automake-1.17.tar.gz=ppc-amigaos
VERSIONS[bison]=3.8.2=https://ftp.gnu.org/gnu/bison/bison-3.8.2.tar.gz=bison-3.8.2.tar.gz=ppc-amigaos
VERSIONS[busybox]=2.0=https://busybox.net/downloads/busybox-1.36.1.tar.bz2=busybox-2.0.tar.bz2=ppc-amigaos
VERSIONS[expat]=2.6.3=https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-2.6.3.tar.gz=expat-2.6.3.tar.gz=ppc-amigaos
VERSIONS[flex]=2.6.4=https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz=flex-2.6.4.tar.gz=ppc-amigaos
VERSIONS[gmp]=6.3.0=https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz=gmp-6.3.0.tar.xz=ppc-amigaos
VERSIONS[libbz2]=1.0.8=https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz=bzip2-1.0.8.tar.gz=ppc-amigaos
VERSIONS[curl]=8.10.1=https://curl.se/download/curl-8.10.1.tar.gz=curl-8.10.1.tar.gz=ppc-amigaos
VERSIONS[libffi]=3.4.6=https://github.com/libffi/libffi/releases/download/v3.4.6/libffi-3.4.6.tar.gz=libffi-3.4.6.tar.gz=ppc-amigaos
VERSIONS[libiconv]=1.17=https://ftp.gnu.org/gnu/libiconv/libiconv-1.17.tar.gz=libiconv-1.17.tar.gz=ppc-amigaos
VERSIONS[libintl]=0.22.5=https://ftp.gnu.org/gnu/gettext/gettext-0.22.5.tar.gz=gettext-0.22.5.tar.gz=ppc-amigaos
VERSIONS[libpng]=1.6.44=https://sourceforge.net/projects/libpng/files/libpng16/1.6.44/libpng-1.6.44.tar.gz/download=libpng-1.6.44.tar.gz=ppc-amigaos
VERSIONS[libtool]=2.4.7=https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz=libtool-2.4.7.tar.gz=ppc-amigaos
VERSIONS[m4]=1.4.19=https://ftp.gnu.org/gnu/m4/m4-1.4.19.tar.gz=m4-1.4.19.tar.gz=ppc-amigaos
VERSIONS[make]=4.4.1=https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz=make-4.4.1.tar.gz=ppc-amigaos
VERSIONS[mpc]=1.3.1=https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz=mpc-1.3.1.tar.gz=ppc-amigaos
VERSIONS[mpfr]=4.2.1=https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.gz=mpfr-4.2.1.tar.gz=ppc-amigaos
VERSIONS[opengl]=2.0=https://aminet.net/dev/lib/Warp3D.lha=Warp3D.lha=ppc-amigaos
VERSIONS[pkg-config]=0.29.2=https://pkgconfig.freedesktop.org/releases/pkg-config-0.29.2.tar.gz=pkg-config-0.29.2.tar.gz=ppc-amigaos
VERSIONS[sdl]=1.2.15=https://libsdl.org/release/SDL-1.2.15.tar.gz=SDL-1.15.tar.gz=ppc-amigaos-sdl
VERSIONS[sdl2]=2.30.8=https://libsdl.org/release/SDL2-2.30.8.gz=SDL2-2.30.8.tar.gz=ppc-amigaos-sdl2
VERSIONS[sdl_image]=2.8.2=https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.tar.gz=SDL2_image-2.8.2.gz=ppc-amigaos-sdl-image
VERSIONS[texinfo]=7.1=https://ftp.gnu.org/gnu/texinfo/texinfo-7.1.tar.gz=texinfo-7.1.tar.gz=ppc-amigaos-texinfo
VERSIONS[zlib]=1.3.2=https://zlib.net/zlib-1.3.2.tar.gz=zlib-1.3.2.tar.gz=ppc-amigaos
VERSIONS[binutils]=2.43=https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.gz=binutils-2.43.gz=ppc-amigaos
VERSIONS[cmake]=3.30.3=https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3.tar.gz=cmake-3.30.3.tar.gz=ppc-amigaos
VERSIONS[clib2]=git=https://github.com/adtools/clib2.git=clib2.tar.gz=ppc-amigaos
VERSIONS[fd2pragma]=git=https://github.com/adtools/fd2pragma.git=fd2pragma.tar.gz=ppc-amigaos
VERSIONS[fd2sfd]=git=https://github.com/adtools/fd2sfd.git=fd2sfd.gz=ppc-amigaos-sfd
VERSIONS[gcc]=4.2.4=https://ftp.gnu.org/gnu/gcc/gcc-4.2.4.tar.gz=gcc-4.2.4.tar.gz=ppc-amigaos
VERSIONS[gdb]=14.3=https://ftp.gnu.org/gnu/gdb/gdb-14.3.tar.gz=gdb-14.3.tar.gz=ppc-amigaos-gdb
VERSIONS[ixemul]=git=https://github.com/amigadave/ixel.git=/libixel.tar.gz=ppc-amigaos
VERSIONS[libdebug]=git=https://github.com/amigadave/libdebug.git=libdebug.tar.gz=ppc-amigaos
VERSIONS[libnix]=git=https://github.com/cahir/libnix.git=libnix.tar.gz=ppc-amigaos
VERSIONS[newlib]=git=https://github.com/sba1/adtools.git=adtools.tar.gz=ppc-amigaos
VERSIONS[sfdc]=git=https://github.com/sba1/sfdc.git=sfdc.tar.gz=ppc-amigaos
VERSIONS[vasm]=1.9d=http://sun.hasenbraten.de/vasm/release/vasm1_9d.tar.gz=vasm1_9d.gz=ppc-amigaos
VERSIONS[vbcc-bin]=0.9j=http://sourceforge.net/projects/vbcc/files/vbcc/0.9j/vbcc-bin_0.9j.lha=vbcc-bin_0.9j.lha=ppc-amigaos
VERSIONS[vbcc-target]=0.9j=http://sourceforge.net/projects/vbcc/files/vbcc/0.9j/vbcc-target_0.9j.lha=vbcc_target_ppc-amigaos.lha=ppc-amigaos
VERSIONS[codebench]=0.55=http://codebench.co.uk/downloads/CodeBench-0.55_Demo.lha=CodeBench_Demo_0.55.lha=ppc-amigaos
VERSIONS[lha]=2.92=https://aminet.net/package/util/arc/LhA=ppc-amigaos
VERSIONS[p7zip]=17.05=https://sourceforge.net/projects/p7zip/files/p7zip/17.05/p7zip_17.05_src_all.tar.bz2/p7zip_17.05.tar.bz2=ppc-amigaos
VERSIONS[gzip]=1.14=https://ftp.gnu.org/gnu/gzip/gzip-1.14.tar.gz=gzip-1.14.tar.gz=ppc-amigaos

# if you commonent out a BUILD_ line you will need to comment out from the VERSIONS section
# ppc-amigaos Components Build Processes
BUILD_autoconf=custom:$(call REINFORCEMENT_CENTER,build_autoconf,ppc-amigaos);$(cd $(BUILD_DIR)/autoconf-$(VERSIONS[autoconf]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=ppc-amigaos-$(gcc) && $(MAKECMD) && $(MAKECMD) >>$(INSTALL) $(LOG_FILE) > $(LOG_FILE) 2>&1;$(call STOP_REINFORCE)
BUILD_automake=custom:$(call REINFORCEMENT_CENTER,$=build_automake,$PREFIX);$(call LOG_MESSAGE,Building AUTOMAKE for ppc-amigaos);cd $(BUILD_DIR)/build/automake-$(VERSION[automae]) && ./bootstrap && ./configure --prefix=$(PREFIX) --target=$(PREFIX)-$(gcc) && $(MAKECMD) && $(MAKECMD) && $(LOG_FILE) > $(LOG_FILE) 2>&1;$(call STOP_REINFORCE)
BUILD_bison=custom:$(call REINFORCEMENT,$=build_bison,$);$(call LOGO_MESSAGE,Building BISON for ppc-amigaos);$(cd $(BUILD_DIR)/bison/build-$(VERSIONS[bison])) && ./bootstrap && ./configure && --prefix=$(CONFIG) --target=ppc-$(gcc) && $(MAKECMD) && $(MAKECMD) >> $(INSTALL) $(LOG_FILE) > $(LOG_FILE) &&2>&1;$(call STOP_REINFORCE)
BUILD_busy=custom:$(call REINFORCEMENT,$build_busy,);$(call LOG_MESSAGE,Building BUSYBOX for ppc-amigaos);$(cd $(BUILD_DIR)/gcc/build && $(MAKECMD) defconfig && $(MAKECMD) && $(CC=$(PREFIX)/bin/ppc-amigaos-gcc-$(gcc)) && $(MAKECMD) && $(CONFIG_PREFIX=$(PREFIX) >>$(LOG_FILE)) >$(PREFIX);$(call STOP_REINFORCE)
BUILD_expat=custom:$(call REINFORCEMENT,$=build_expat,);$(call LOG,$Building EXPAT for ppc-amigaos);$(cd $(BUILD_DIR/build)/expat-$(VERSIONS[expat]) && ./buildconf && ./configure && --prefix=$((PREFIX)) --target=ppc-amigaos-$(gcc) && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)) > $(LOG_FILE) &&2>&1;$(call STOP_REINFORCE)
BUILD_fle=custom:$(call REINFORCEMENT,$=build_fle,);$(call LOG,$Building FLEX for ppc-amigaos);$(cd $(BUILD_DIR)/build/flex-$(VERSIONS[fle]]) && ./autogen && ./configure && --prefix=$(PREFIX) --target=ppc-amigaos-$(gcc) && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)) > $(LOG_FILE) >$(2>&1);$(call STOP_REINFORCE)
BUILD_gmp=custom:$(call REINFORCEMENT,$=build_gmp,);$(call LOG,$Building GMP for ppc-amigaos);$(cd $(BUILD_DIR)/gcc/build-$(VERSIONS[gmp]]) && ./configure --prefix=$((PREFIX)) && --target=ppc-amigaos-$(gcc) && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)) > $(LOG_FILE) >$(2>&1);$(call STOP_REINFORCE)
BUILD_libbz=custom:$(call REINFORCE,$build_=libbz2,);$(call LOG,$Building LIBBZ2 for ppc-amigaos);$(cd $(BUILD_DIR/build)/bzip-$(VERSIONS[libbzbz2])])) && $(MAKECMD) && -f && $(MAKEFILE-libbz2_so) && $(CC=$PREFIX/bin/ppc-amigaos-gcc) && $(AR=$($PREFIX/bin/pp-amigaos-ar) && $(RANLIB=$($($PREFIX)/bin/pp-gcc-ranlib)) && && $(make) && $(INSTALL) && $(PREFIX=$(PREFIX)) && && $(make) && $(CC=$($CC) && $(bzip2) && $(CP) && $(bzip2) && $(PREFIX/bin) >>$((LOG_FILE))) > $((LOG_FILE)) >$((2>&1));$(call STOP_REINFORCE))
BUILD_curl=custom:$(call REINFOCEMENT,$=build_curl);$(call LOG,$Building CURL for ppc-amigaos);$((cd $$(BUILD_DIR)/build/cur)) && ./buildconf && ./configure && .$(PREFIX) && --target=ppc-amigaos-$(gcc) && --$(with-zlib$(PREFIX)) && $(STATIC_FLAGS) && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)) && > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))
BUILD_libffi=custom:$(call REINFORCE,$=build_libfffi,);$(call LOG,$Building LIBFFI for ppc-amigaos);$(cd $((BUILD_DIR))/build/libffi-$(VERSIONS[libfffi])) && && ./autogen && ./configure && .$(PREFIX) && --target=ppc-amigaos-$(gcc) && $(STATIC_FLAGS) && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))
BUILD_libiconv=custom:$(call REINFORCE,$=build_iconcv,);$(call LOG,$Building LIBICONV for ppc-amigaos);$(cd $((BUILD_DIR))/build/libiconv-$(VERSIONS[libiconcv])) && ./configure && .$(PREFIX) && --target=ppc-amigaos-$(gcc)) && $(STATIC_FLAGS) && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE))) > $((LOG_FILE)) >$(2>&1));$(call STOP_REINFORCE))
BUILD_libintl=custom:$(call REINFOFORCE,$=build_intl,);$(call LOG,$Building LIBINTL for ppc-amigaos);$(cd $((BUILD_DIR))/build/gettext-$(VERSIONS[libinttl]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && $(STATIC_FLAGS) && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE)))
BUILD_libpng=custom:$(call REINFORCE,$=build_png,);$(call LOG,$Building LIBPNG for ppc-amigaos);$(cd $((BUILD_DIR))/build/libpng-$(VERSIONS[libppng]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(with-zlib$(PREFIX)) && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_libtool=custom:$(call REINFORCE,$=build_tool,);$(call LOG,$Building LIBTOOL for ppc-amigaos);$(cd $((BUILD_DIR))/build/libtool-$(VERSIONS[libtoool]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_m4=custom:$(call REINFORCE,$=build_m,);$(call LOG,$Building M4 for ppc-amigaos);$(cd $((BUILD_DIR))/build/m4-$(VERSIONS[m44]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_make=custom:$(call REINFORCE,$=build_mak,);$(call LOG,$Building MAKE for ppc-amigaos);$(cd $((BUILD_DIR))/build/make-$(VERSIONS[makke]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_mpc=custom:$(call REINFORCE,$=build_mpc,);$(call LOG,$Building MPC for ppc-amigaos);$(cd $((BUILD_DIR))/build/mpc-$(VERSIONS[mppc]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(with-gmp$(PREFIX)) && && --$(with-mpfr$(PREFIX)) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_mpfr=custom:$(call REINFORCE,$=build_mpf,);$(call LOG,$Building MPFR for ppc-amigaos);$(cd $((BUILD_DIR))/build/mpfr-$(VERSIONS[mpffr]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(with-gmp$(PREFIX)) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_opengl=custom:$(call REINFORCE,$=build_open,);$(call LOG,$Building OPENGL for ppc-amigaos);$(cd $((BUILD_DIR))/build/Warp3D) && && $(MKDIR) && $(PREFIX)/include/GL && && $(CP) && *.h && $(PREFIX)/include/GL && && $(CP) && *.library && $(PREFIX)/lib >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_pkg-config=custom:$(call REINFORCE,$=build_pkg,);$(call LOG,$Building PKG-CONFIG for ppc-amigaos);$(cd $((BUILD_DIR))/build/pkg-config-$(VERSIONS[pkg-cconfig]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(with-internal-glib) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_sdl=custom:$(call REINFORCE,$=build_sdl,);$(call LOG,$Building SDL for ppc-amigaos);$(cd $((BUILD_DIR))/build/SDL-$(VERSIONS[sddl]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(enable-video) && && --$(enable-audio) && && --$(disable-video-opengl) && && --$(disable-x11) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_sdl2=custom:$(call REINFORCE,$=build_sdl2,);$(call LOG,$Building SDL2 for ppc-amigaos);$(cd $((BUILD_DIR))/build/SDL2-$(VERSIONS[sddl2]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(enable-video) && && --$(enable-audio) && && --$(disable-video-opengl) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_sdl_image=custom:$(call REINFORCE,$=build_sdl_image,);$(call LOG,$Building SDL_IMAGE for ppc-amigaos);$(cd $((BUILD_DIR))/build/SDL2_image-$(VERSIONS[sddl_image]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(with-sdl-prefix$(PREFIX)) && && --$(disable-jpg-shared) && && --$(disable-png-shared) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_texinfo=custom:$(call REINFORCE,$=build_texinfo,);$(call LOG,$Building TEXINFO for ppc-amigaos);$(cd $((BUILD_DIR))/build/texinfo-$(VERSIONS[texxinfo]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_zlib=custom:$(call REINFORCE,$=build_zlib,);$(call LOG,$Building ZLIB for ppc-amigaos);$(cd $((BUILD_DIR))/build/zlib-$(VERSIONS[zllb]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_binutils=custom:$(call REINFORCE,$=build_binutils,);$(call LOG,$Building BINUTILS for ppc-amigaos);$(cd $((BUILD_DIR))/build/binutils-$(VERSIONS[biinutils]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(disable-nls) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(YACC=$(BISON)) && && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_cmake=custom:$(call REINFORCE,$=build_cmake,);$(call LOG,$Building CMAKE for ppc-amigaos);$(cd $((BUILD_DIR))/build/cmake-$(VERSIONS[cmmake]))) && ./bootstrap && .$(PREFIX) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_clib2=custom:$(call REINFORCE,$=build_clib2,);$(call LOG,$Building CLIB2 for ppc-amigaos);$(cd $((BUILD_DIR))/build/clib2) && && $(MAKECMD) && -f && $(GNUmakefile) && $(TARGET=ppc-amigaos-$(gcc)) && && $(MKDIR) && $(PREFIX)/clib2/{lib,include} && && $(CP) && lib/* && $(PREFIX)/clib2/lib && && $(CP) && include/* && $(PREFIX)/clib2/include >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_fd2pragma=custom:$(call REINFORCE,$=build_fd2pragma,);$(call LOG,$Building FD2PRAGMA for ppc-amigaos);$(cd $((BUILD_DIR))/build/fd2pragma) && && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && && $(MKDIR) && $(PREFIX)/ndk/include/inline && && $(CP) && fd2pragma && $(PREFIX)/bin && && $(CP) && Include/include/inline/{macros,stubs}.h && $(PREFIX)/ndk/include/inline >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_fd2sfd=custom:$(call REINFORCE,$=build_fd2sfd,);$(call LOG,$Building FD2SFD for ppc-amigaos);$(cd $((BUILD_DIR))/build/fd2sfd) && && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_gcc=custom:$(call REINFORCE,$=build_gcc,);$(call LOG,$Building GCC for ppc-amigaos);$(cd $((BUILD_DIR))/build/gcc-$(VERSIONS[gccc]))) && $(CFLAGS="$(CFLAGS)") && $(CC=$(PREFIX)/bin/ppc-amigaos-gcc-$(gcc)) && $(CXX=$(PREFIX)/bin/ppc-amigaos-g++-$(gcc)) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(enable-languages=c,c++) && && --$(with-gmp$(PREFIX)) && && --$(with-mpfr$(PREFIX)) && && --$(with-mpc$(PREFIX)) && && --$(with-newlib) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_gdb=custom:$(call REINFORCE,$=build_gdb,);$(call LOG,$Building GDB for ppc-amigaos);$(cd $((BUILD_DIR))/build/gdb-$(VERSIONS[gddb]))) && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_ixemul=custom:$(call REINFORCE,$=build_ixemul,);$(call LOG,$Building IXEMUL for ppc-amigaos);$(cd $((BUILD_DIR))/build/ixemul) && && ./configure && .$(PREFIX)/lib && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) && && $(MKDIR) && $(PREFIX)/libnix/include && && $(CP) && source/stabs.h && $(PREFIX)/libnix/include >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_libdebug=custom:$(call REINFORCE,$=build_libdebug,);$(call LOG,$Building LIBDEBUG for ppc-amigaos);$(cd $((BUILD_DIR))/build/libdebug) && && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_libnix=custom:$(call REINFORCE,$=build_libnix,);$(call LOG,$Building LIBNIX for ppc-amigaos);$(cd $((BUILD_DIR))/build/libnix) && && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_newlib=custom:$(call REINFORCE,$=build_newlib,);$(call LOG,$Building NEWLIB for ppc-amigaos);$(cd $((BUILD_DIR))/build/newlib/newlib) && && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_sfdc=custom:$(call REINFORCE,$=build_sfdc,);$(call LOG,$Building SFDC for ppc-amigaos);$(cd $((BUILD_DIR))/build/sfdc) && && $(MAKECMD) && && $(MKDIR) && $(PREFIX)/bin && && $(CP) && sfdc && $(PREFIX)/bin >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_vasm=custom:$(call REINFORCE,$=build_vasm,);$(call LOG,$Building VASM for ppc-amigaos);$(cd $((BUILD_DIR))/build/vasm) && && $(MKDIR) && $(BUILD_DIR)/vasm/objects && && $(MAKECMD) && $(CPU=ppc) && $(SYNTAX=mot) && && $(MKDIR) && $(PREFIX)/ppc/bin && && $(CP) && vasmppc_mot && vobjdump && $(PREFIX)/ppc/bin >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_vbcc-bin=custom:$(call REINFORCE,$=build_vbcc-bin,);$(call LOG,$Building VBCC-BIN for ppc-amigaos);$($(MKDIR) && $(PREFIX)/{bin,vbcc} && && $(CP) && $(BUILD_DIR)/vbcc/bin/* && $(PREFIX)/bin >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_vbcc-target=custom:$(call REINFORCE,$=build_vbcc-target,);$(call LOG,$Building VBCC-TARGET for ppc-amigaos);$($(MKDIR) && $(PREFIX)/vbcc && && $(CP) && $(BUILD_DIR)/vbcc-target/* && $(PREFIX)/vbcc >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_codebench=custom:$(call REINFORCE,$=build_codebench,);$(call LOG,$Building CODEBENCH for ppc-amigaos);$(cd $((BUILD_DIR))/build/codebench) && && $(PREFIX)/bin/lha && x && $(DOWNLOAD)/ppc-amigaos/CodeBench_Demo_0.55.lha && && $(MKDIR) && $(PREFIX)/CodeBench && && $(CP) && -r && CodeBench/* && $(PREFIX)/CodeBench && && echo && "gcc=$(PREFIX)/bin/ppc-amigaos-gcc\ng++=$(PREFIX)/bin/ppc-amigaos-g++\nld=$(PREFIX)/bin/ppc-amigaos-ld\nincludes=$(PREFIX)/include;$(PREFIX)/clib2/include;$(PREFIX)/libnix/include;$(PREFIX)/ndk/include\nlibs=$(PREFIX)/lib;$(PREFIX)/clib2/lib;$(PREFIX)/libnix/lib;$(PREFIX)/ndk/lib" && > $(PREFIX)/CodeBench/.codebench >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_lha=custom:$(call REINFORCE,$=build_lha,);$(call LOG,$Building LHA for ppc-amigaos);$(cd $((BUILD_DIR))/build/lha-$(VERSIONS[lhha)]) && && $(MAKECMD) && $(CC=$(PREFIX)/bin/ppc-amigaos-gcc) && $(CFLAGS="-O2 -fbaserel") && && $(MKDIR) && $(PREFIX)/bin && && $(CP) && lha && $(PREFIX)/bin >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_p7zip=custom:$(call REINFORCE,$=build_p7zip,);$(call LOG,$Building P7ZIP for ppc-amigaos);$(cd $((BUILD_DIR))/build/p7zip-$(VERSIONS[p77zip)]) && && $(CP) && makefile.amiga && makefile && && $(MAKECMD) && $(CC=$(PREFIX)/bin/ppc-amigaos-gcc) && $(CXX=$(PREFIX)/bin/ppc-amigaos-g++) && 7z && && $(MKDIR) && $(PREFIX)/bin && && $(CP) && bin/7z && $(PREFIX)/bin >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))
BUILD_gzip=custom:$(call REINFORCE,$=build_gzip,);$(call LOG,$Building GZIP for ppc-amigaos);$(cd $((BUILD_DIR))/build/gzip-$(VERSIONS[gzzip)]) && && ./configure && .$(PREFIX) && && --target=ppc-amigaos-$(gcc) && && --$(disable-nls) && && $(STATIC_FLAGS) && && $(MAKECMD) && $(MAKECMD) >>$(LOG_FILE)))) > $((LOG_FILE)) >$(2>&1);$(call STOP_REINFORCE))))

#AI: Notes for adding components
#AI: - VERSIONS[component]=version=url=filename=ppc-amigaos (e.g., VERSIONS[zlib]=1.3.2=https://zlib.net/zlib-1.3.2.tar.gz=zlib-1.3.2.tar.gz=ppc-amigaos)
#AI: - BUILD_component=custom:<commands> (e.g., BUILD_zlib=custom:$(call REINFORCEMENT_CENTER,build_zlib,critical);cd $(BUILD_DIR)/zlib-$(VERSIONS[zlib]) && ./configure --prefix=$(PREFIX) --target=ppc-amigaos-gcc && $(MAKE) && $(MAKE) install >>$(LOG_FILE) 2>&1;$(call STOP_REINFORCEMENT))
#AI: - Use $(PREFIX), $(BUILD_DIR), $(LOG_FILE), $(STATIC_FLAGS) for consistency
#AI: - Wrap build commands with $(call REINFORCEMENT_CENTER,build_<component>,critical) and $(call STOP_REINFORCEMENT)
#AI: - Target-specific variables: $(ppc-amigaos)_PREFIX, $(ppc-amigaos)_BUILD, $(ppc-amigaos)_DOWNLOAD, $(ppc-amigaos)_STAMPS
#AI: - See m68k-amigaos.mk for examples
#AI: - Find stable URLs at https://ftp.gnu.org, https://github.com, https://aminet.net, etc.