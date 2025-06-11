# Hardcoded versions and URLs for AmigaOS toolchain
# Copyright (c) 2025 Zachary Geurts, MIT License
# These are the highest (stable) versions supported by AmigaOS
#
# Instructions: type make or make help for help.
# - If a build fails, make will show your download progress and check links.
# - It only checks links of files not yet downloaded. You can place files in downloads.
# - To enable an optional library, uncomment its line in the relevant section.
# - To disable, comment it out again or remove it.
# - it is your Amiga, take some time here.
#
# If storage is an issue, comment out components you do not need.
#
# Storage Requirements (Estimates for Common Components):
# - autoconf: 10 MB (build), 5 MB (installed)
# - automake: 15 MB (build), 6 MB (installed)
# - bison: 20 MB (build), 8 MB (installed)
# - busybox: 25 MB (build), 10 MB (installed)
# - clib2: 50 MB (build), 20 MB (installed)
# - cloog: 15 MB (build), 5 MB (installed)
# - flex: 15 MB (build), 7 MB (installed)
# - gawk: 20 MB (build), 8 MB (installed)
# - git: 50 MB (build), 20 MB (installed)
# - gmp: 30 MB (build), 10 MB (installed)
# - isl: 20 MB (build), 7 MB (installed)
# - libbz2: 10 MB (build), 4 MB (installed)
# - libjpeg: 15 MB (build), 6 MB (installed)
# - libmpg123: 20 MB (build), 8 MB (installed)
# - libogg: 10 MB (build), 4 MB (installed)
# - libpng: 15 MB (build), 6 MB (installed)
# - libsndfile: 20 MB (build), 8 MB (installed)
# - libtheora: 15 MB (build), 6 MB (installed)
# - libtool: 15 MB (build), 6 MB (installed)
# - libvorbis: 15 MB (build), 6 MB (installed)
# - m4: 10 MB (build), 4 MB (installed)
# - make: 15 MB (build), 6 MB (installed)
# - mpc: 10 MB (build), 4 MB (installed)
# - mpfr: 20 MB (build), 8 MB (installed)
# - perl: 50 MB (build), 20 MB (installed)
# - pkg-config: 10 MB (build), 4 MB (installed)
# - texinfo: 20 MB (build), 8 MB (installed)
# - vlink: 10 MB (build), 4 MB (installed)
# - zlib: 10 MB (build), 4 MB (installed)
# Total Common: 0.5 GB (build), 0.2 GB (installed)
#
# - see after versions for the rest of the install.

# Get an AI second opinion if you think there is better versioning for AmigaOS in 2025.
# I recommend building SDL1.2 and SDL2 for both m68k and ppc after your toolchain is built.
# OpenGL is also recommended. It is slow on m68k, but aftermarket overclock tools can help.
# Try building any SDL or OpenGL program/game that says they are portable. Have fun.

# Versions (alphabetized)
VERSIONS[autoconf] := 2.72
VERSIONS[automake] := 1.17
VERSIONS[bison] := 3.8.2
VERSIONS[binutils-m68k] := 2.14
VERSIONS[binutils-ppc] := 2.23
VERSIONS[busybox] := 1.36.2
VERSIONS[cmake] := 3.30.5
VERSIONS[cloog] := 0.18.1
VERSIONS[db101] := 2.1
VERSIONS[expat] := 2.6.3
VERSIONS[flex] := 2.6.4
VERSIONS[fontconfig] := 2.15.0
VERSIONS[freetype] := 2.13.3
VERSIONS[gawk] := 5.3.1
VERSIONS[gcc-m68k] := 2.95.3
VERSIONS[gcc-ppc] := 8.4.0
VERSIONS[gdb] := 7.5
VERSIONS[giflib] := 5.2.2
VERSIONS[git] := 2.46.2
VERSIONS[gmp] := 6.3.0
VERSIONS[isl] := 0.27
VERSIONS[libbz2] := 1.0.8
VERSIONS[libcurl-m68k] := 7.16.4
VERSIONS[libcurl-ppc] := 8.10.1
VERSIONS[libffi] := 3.4.6
VERSIONS[libiconv] := 1.17
VERSIONS[libintl] := 0.22.5
VERSIONS[libjpeg] := 9f
VERSIONS[liblzma] := 5.6.3
VERSIONS[libmpg123] := 1.32.7
VERSIONS[libogg] := 1.3.5
VERSIONS[libpng] := 1.6.44
VERSIONS[libsndfile] := 1.2.2
VERSIONS[libtheora] := 1.1.1
VERSIONS[libtool] := 2.5.3
VERSIONS[libuuid] := 1.0.3
VERSIONS[libvorbis] := 1.3.7
VERSIONS[libxml2] := 2.13.4
VERSIONS[m4] := 1.4.19
VERSIONS[make] := 4.4.1
VERSIONS[mpc] := 1.3.1
VERSIONS[mpfr] := 4.2.1
VERSIONS[perl] := 5.40.0
VERSIONS[pkg-config] := 0.29.2
VERSIONS[texinfo] := 7.1
VERSIONS[vasm] := 1.9d
VERSIONS[vbcc] := 0.9j
VERSIONS[vlink] := 0.17
VERSIONS[zlib] := 1.3.1

# Common URLs: format is name=version=url=target_file=platform (alphabetized)
URLS_COMMON := \
	autoconf=$(VERSIONS[autoconf])=https://ftp.gnu.org/gnu/autoconf/autoconf-$(VERSIONS[autoconf]).tar.gz=autoconf-$(VERSIONS[autoconf]).tar.gz=common \
	automake=$(VERSIONS[automake])=https://ftp.gnu.org/gnu/automake/automake-$(VERSIONS[automake]).tar.gz=automake-$(VERSIONS[automake]).tar.gz=common \
	bison=$(VERSIONS[bison])=https://ftp.gnu.org/gnu/bison/bison-$(VERSIONS[bison]).tar.xz=bison-$(VERSIONS[bison]).tar.xz=common \
	busybox=$(VERSIONS[busybox])=https://busybox.net/downloads/busybox-$(VERSIONS[busybox]).tar.bz2=busybox-$(VERSIONS[busybox]).tar.bz2=common \
	clib2=git=https://github.com/adtools/clib2.git=clib2=common \
	cloog=$(VERSIONS[cloog])=https://github.com/periscop/cloog/releases/download/cloog-$(VERSIONS[cloog])/cloog-$(VERSIONS[cloog]).tar.gz=cloog-$(VERSIONS[cloog]).tar.gz=common \
	flex=$(VERSIONS[flex])=https://github.com/westes/flex/releases/download/v$(VERSIONS[flex])/flex-$(VERSIONS[flex]).tar.gz=flex-$(VERSIONS[flex]).tar.gz=common \
	gawk=$(VERSIONS[gawk])=https://ftp.gnu.org/gnu/gawk/gawk-$(VERSIONS[gawk]).tar.xz=gawk-$(VERSIONS[gawk]).tar.xz=common \
	git=$(VERSIONS[git])=https://mirrors.edge.kernel.org/pub/software/scm/git/git-$(VERSIONS[git]).tar.xz=git-$(VERSIONS[git]).tar.xz=common \
	gmp=$(VERSIONS[gmp])=https://ftp.gnu.org/gnu/gmp/gmp-$(VERSIONS[gmp]).tar.xz=gmp-$(VERSIONS[gmp]).tar.xz=common \
	isl=$(VERSIONS[isl])=https://gcc.gnu.org/pub/gcc/infrastructure/isl-$(VERSIONS[isl]).tar.bz2=isl-$(VERSIONS[isl]).tar.bz2=common \
	libbz2=$(VERSIONS[libbz2])=https://sourceware.org/pub/bzip2/bzip2-$(VERSIONS[libbz2]).tar.gz=bzip2-$(VERSIONS[libbz2]).tar.gz=common \
	libjpeg=$(VERSIONS[libjpeg])=https://www.ijg.org/files/jpegsrc.v$(VERSIONS[libjpeg]).tar.gz=jpegsrc.v$(VERSIONS[libjpeg]).tar.gz=common \
	libmpg123=$(VERSIONS[libmpg123])=https://sourceforge.net/projects/mpg123/files/mpg123/$(VERSIONS[libmpg123])/mpg123-$(VERSIONS[libmpg123]).tar.bz2=mpg123-$(VERSIONS[libmpg123]).tar.bz2=common \
	libogg=$(VERSIONS[libogg])=https://downloads.xiph.org/releases/ogg/libogg-$(VERSIONS[libogg]).tar.xz=libogg-$(VERSIONS[libogg]).tar.xz=common \
	libpng=$(VERSIONS[libpng])=https://download.sourceforge.net/libpng/libpng-$(VERSIONS[libpng]).tar.xz=libpng-$(VERSIONS[libpng]).tar.xz=common \
	libsndfile=$(VERSIONS[libsndfile])=https://github.com/libsndfile/libsndfile/releases/download/$(VERSIONS[libsndfile])/libsndfile-$(VERSIONS[libsndfile]).tar.xz=libsndfile-$(VERSIONS[libsndfile]).tar.xz=common \
	libtheora=$(VERSIONS[libtheora])=https://downloads.xiph.org/releases/theora/libtheora-$(VERSIONS[libtheora]).tar.xz=libtheora-$(VERSIONS[libtheora]).tar.xz=common \
	libtool=$(VERSIONS[libtool])=https://ftp.gnu.org/gnu/libtool/libtool-$(VERSIONS[libtool]).tar.xz=libtool-$(VERSIONS[libtool]).tar.xz=common \
	libvorbis=$(VERSIONS[libvorbis])=https://downloads.xiph.org/releases/vorbis/libvorbis-$(VERSIONS[libvorbis]).tar.xz=libvorbis-$(VERSIONS[libvorbis]).tar.xz=common \
	m4=$(VERSIONS[m4])=https://ftp.gnu.org/gnu/m4/m4-$(VERSIONS[m4]).tar.xz=m4-$(VERSIONS[m4]).tar.xz=common \
	make=$(VERSIONS[make])=https://ftp.gnu.org/gnu/make/make-$(VERSIONS[make]).tar.gz=make-$(VERSIONS[make]).tar.gz=common \
	mpc=$(VERSIONS[mpc])=https://ftp.gnu.org/gnu/mpc/mpc-$(VERSIONS[mpc]).tar.gz=mpc-$(VERSIONS[mpc]).tar.gz=common \
	mpfr=$(VERSIONS[mpfr])=https://ftp.gnu.org/gnu/mpfr/mpfr-$(VERSIONS[mpfr]).tar.xz=mpfr-$(VERSIONS[mpfr]).tar.xz=common \
	perl=$(VERSIONS[perl])=https://www.cpan.org/src/5.0/perl-$(VERSIONS[perl]).tar.gz=perl-$(VERSIONS[perl]).tar.gz=common \
	pkg-config=$(VERSIONS[pkg-config])=https://pkgconfig.freedesktop.org/releases/pkg-config-$(VERSIONS[pkg-config]).tar.gz=pkg-config-$(VERSIONS[pkg-config]).tar.gz=common \
	texinfo=$(VERSIONS[texinfo])=https://ftp.gnu.org/gnu/texinfo/texinfo-$(VERSIONS[texinfo]).tar.xz=texinfo-$(VERSIONS[texinfo]).tar.xz=common \
	vlink=$(VERSIONS[vlink])=https://phx.de/ftp/vlink/vlink$(VERSIONS[vlink]).tar.gz=vlink$(VERSIONS[vlink]).tar.gz=common \
	zlib=$(VERSIONS[zlib])=https://zlib.net/zlib-$(VERSIONS[zlib]).tar.gz=zlib-$(VERSIONS[zlib]).tar.gz=common

# Optional PPC URLs: Uncommented lines are enabled by default (alphabetized)
# Storage Requirements (for PPC Optional Components):
# - expat: 3 MB (build), 3 MB (installed)
# - fontconfig: 4 MB (build), 2 MB (installed)
# - freetype: 6 MB (build), 2 MB (installed)
# - giflib: 2 MB (build), 2 MB (installed)
# - libcurl-ppc: 8 MB (build), 7 MB (installed)
# - libffi: 3 MB (build), 3 MB (installed)
# - libiconv: 6 MB (build), 5 MB (installed)
# - libintl: 6 MB (build), 3 MB (installed)
# - libxml2: 4 MB (build), 3 MB (installed)
# Total installed: 0.03 GB (build), 0.034 GB (installed)
URLS_OPTIONAL_PPC := \
	expat=$(VERSIONS[expat])=https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-$(VERSIONS[expat]).tar.gz=expat-$(VERSIONS[expat]).tar.gz=ppc \
	fontconfig=$(VERSIONS[fontconfig])=https://www.freedesktop.org/software/fontconfig/release/fontconfig-$(VERSIONS[fontconfig]).tar.gz=fontconfig-$(VERSIONS[fontconfig]).tar.gz=ppc \
	freetype=$(VERSIONS[freetype])=https://download.savannah.gnu.org/releases/freetype/freetype-$(VERSIONS[freetype]).tar.gz=freetype-$(VERSIONS[freetype]).tar.gz=ppc \
	giflib=$(VERSIONS[giflib])=https://sourceforge.net/projects/giflib/files/giflib-$(VERSIONS[giflib]).tar.gz=giflib-$(VERSIONS[giflib]).tar.gz=ppc \
	libcurl-ppc=$(VERSIONS[libcurl-ppc])=https://curl.se/download/curl-$(VERSIONS[libcurl-ppc]).tar.gz=curl-$(VERSIONS[libcurl-ppc]).tar.gz=ppc \
	libffi=$(VERSIONS[libffi])=https://github.com/libffi/libffi/releases/download/v$(VERSIONS[libffi])/libffi-$(VERSIONS[libffi]).tar.gz=libffi-$(VERSIONS[libffi]).tar.gz=ppc \
	libiconv=$(VERSIONS[libiconv])=https://ftp.gnu.org/gnu/libiconv/libiconv-$(VERSIONS[libiconv]).tar.gz=libiconv-$(VERSIONS[libiconv]).tar.gz=ppc \
	libintl=$(VERSIONS[libintl])=https://ftp.gnu.org/gnu/gettext/gettext-$(VERSIONS[libintl]).tar.gz=gettext-$(VERSIONS[libintl]).tar.gz=ppc \
	libxml2=$(VERSIONS[libxml2])=https://download.gnome.org/sources/libxml2/2.13/libxml2-$(VERSIONS[libxml2]).tar.gz=libxml2-$(VERSIONS[libxml2]).tar.gz=ppc

# PPC URLs: format is name=version=url=target_file=platform (alphabetized)
# Storage Requirements (for PPC Components):
# - binutils: 0.2 GB (build), 0.2 GB (installed)
# - cmake: 0.05 GB (build), 0.02 GB (installed)
# - gcc: 0.5 GB (build), 0.0 GB (GCC)
# - gdb: 0.05 GB (build), 0.02 GB (installed)
# - newlib: 0.1 GB (build), 0.2 GB (installed)
# - vbcc-ppc-bin: 2 MB (build), 10 MB (installed)
# - vbcc-ppc-target: 2.5 MB (build), 5 MB (installed)
# Total PPC: 0.9 GB (build), 0.6 GB (installed)
URLS_PPC := \
	binutils-ppc=$(VERSIONS[binutils-ppc])=https://ftp.gnu.org/gnu/binutils/binutils-$(VERSIONS[binutils-ppc]).tar.bz2=binutils-$(VERSIONS[binutils-ppc]).tar.bz2=ppc \
	cmake=$(VERSIONS[cmake])=https://github.com/Kitware/CMake/releases/download/v$(VERSIONS[cmake])/cmake-$(VERSIONS[cmake]).tar.gz=cmake-$(VERSIONS[cmake]).tar.gz=ppc \
	gcc-ppc=$(VERSIONS[gcc-ppc])=https://ftp.gnu.org/gnu/gcc/gcc-$(VERSIONS[gcc-ppc])/gcc-$(VERSIONS[gcc-ppc]).tar.gz=gcc-$(VERSIONS[gcc-ppc]).tar.gz=ppc \
	gdb=$(VERSIONS[gdb])=https://ftp.gnu.org/gnu/gdb/gdb-$(VERSIONS[gdb]).tar.xz=gdb-$(VERSIONS[gdb]).tar.xz=ppc \
	newlib=git=https://github.com/sba1/adtools.git=newlib=ppc \
	vbcc-ppc-bin=$(VERSIONS[vbcc])=https://phx.de/ftp/vbcc/vbcc$(VERSIONS[vbcc])_bin_amigaosppc.lha=vbcc$(VERSIONS[vbcc])_bin_amigaosppc.lha=ppc \
	vbcc-ppc-target=$(VERSIONS[vbcc])=https://phx.de/ftp/vbcc/vbcc_target_ppc-amigaos.lha=vbcc_target_ppc-amigaos.lha=ppc

# Optional M68K URLs: Uncommented lines are enabled by default (alphabetized)
# Storage Requirements (for M68K Optional Components):
# - expat: 3 MB (build), 3 MB (installed)
# - fontconfig: 4 MB (build), 2 MB (installed)
# - freetype: 5 MB (build), 2 MB (installed)
# - giflib: 2 MB (build), 2 MB (installed)
# - libcurl-m68k: 7 MB (build), 6 MB (installed)
# - libffi: 3 MB (build), 3 MB (installed)
# - libiconv: 5 MB (build), 4 MB (installed)
# - libintl: 5 MB (build), 3 MB (installed)
# - libxml2: 3 MB (build), 3 MB (installed)
# Total M68K Optional: 0.03 GB (build), 0.03 GB (installed)
URLS_OPTIONAL_M68K := \
	expat=$(VERSIONS[expat])=https://github.com/libexpat/libexpat/releases/download/R_2_6_3/expat-$(VERSIONS[expat]).tar.gz=expat-$(VERSIONS[expat]).tar.gz=m68k \
	fontconfig=$(VERSIONS[fontconfig])=https://www.freedesktop.org/software/fontconfig/release/fontconfig-$(VERSIONS[fontconfig]).tar.gz=fontconfig-$(VERSIONS[fontconfig]).tar.gz=m68k \
	freetype=$(VERSIONS[freetype])=https://download.savannah.gnu.org/releases/freetype/freetype-$(VERSIONS[freetype]).tar.gz=freetype-$(VERSIONS[freetype]).tar.gz=m68k \
	giflib=$(VERSIONS[giflib])=https://sourceforge.net/projects/giflib/files/giflib-$(VERSIONS[giflib]).tar.gz=giflib-$(VERSIONS[giflib]).tar.gz=m68k \
	libcurl-m68k=$(VERSIONS[libcurl-m68k])=https://curl.se/download/curl-$(VERSIONS[libcurl-m68k]).tar.gz=curl-$(VERSIONS[libcurl-m68k]).tar.gz=m68k \
	libffi=$(VERSIONS[libffi])=https://github.com/libffi/libffi/releases/download/v$(VERSIONS[libffi])/libffi-$(VERSIONS[libffi]).tar.gz=libffi-$(VERSIONS[libffi]).tar.gz=m68k \
	libiconv=$(VERSIONS[libiconv])=https://ftp.gnu.org/gnu/libiconv/libiconv-$(VERSIONS[libiconv]).tar.gz=libiconv-$(VERSIONS[libiconv]).tar.gz=m68k \
	libintl=$(VERSIONS[libintl])=https://ftp.gnu.org/gnu/gettext/gettext-$(VERSIONS[libintl]).tar.gz=gettext-$(VERSIONS[libintl]).tar.gz=m68k \
	libxml2=$(VERSIONS[libxml2])=https://download.gnome.org/sources/libxml2/2.13/libxml2-$(VERSIONS[libxml2]).tar.gz=libxml2-$(VERSIONS[libxml2]).tar.gz=m68k

# M68K URLs: format is name=version=url=target_file=platform (alphabetized)
# Storage Requirements (for M68K Components):
# - binutils: 0.08 GB (build), 0.03 GB (installed)
# - cmake: 0.04 GB (build), 0.02 GB (installed)
# - db101: 5 MB (build), 2 MB (installed)
# - fd2pragma: 10 MB (build), 4 MB (installed)
# - fd2sfd: 10 MB (build), 4 MB (installed)
# - gcc-m68k: 0.2 GB (build), 0.08 GB (installed)
# - gdb: 0.04 GB (build), 0.02 GB (installed)
# - ixemul: 20 MB (build), 8 MB (installed)
# - libdebug: 10 MB (build), 4 MB (installed)
# - libnix: 15 MB (build), 6 MB (installed)
# - newlib: 0.08 GB (build), 0.03 GB (installed)
# - sfdc: 10 MB (build), 4 MB (installed)
# - vasm: 10 MB (build), 4 MB (installed)
# - vbcc-m68k-bin: 2 MB (build), 5 MB (installed)
# - vbcc-m68k-target: 2 MB (build), 5 MB (installed)
# Total M68K: 0.5 GB (build), 0.2 GB (installed)
URLS_M68K := \
	binutils-m68k=$(VERSIONS[binutils-m68k])=https://ftp.gnu.org/gnu/binutils/binutils-$(VERSIONS[binutils-m68k]).tar.gz=binutils-$(VERSIONS[binutils-m68k]).tar.gz=m68k \
	cmake=$(VERSIONS[cmake])=https://github.com/Kitware/CMake/releases/download/v$(VERSIONS[cmake])/cmake-$(VERSIONS[cmake]).tar.gz=cmake-$(VERSIONS[cmake]).tar.gz=m68k \
	db101=$(VERSIONS[db101])=https://aminet.net/dev/debug/db101.lha=db101.lha=m68k \
	fd2pragma=git=https://github.com/adtools/fd2pragma.git=fd2pragma=m68k \
	fd2sfd=git=https://github.com/adtools/fd2sfd.git=fd2sfd=m68k \
	gcc-m68k=$(VERSIONS[gcc-m68k])=https://ftp.gnu.org/gnu/gcc/gcc-$(VERSIONS[gcc-m68k])/gcc-$(VERSIONS[gcc-m68k]).tar.bz2=gcc-$(VERSIONS[gcc-m68k]).tar.bz2=m68k \
	gdb=$(VERSIONS[gdb])=https://ftp.gnu.org/gnu/gdb/gdb-$(VERSIONS[gdb]).tar.xz=gdb-$(VERSIONS[gdb]).tar.xz=m68k \
	ixemul=git=https://github.com/amiga-gcc/ixemul.git=ixemul=m68k \
	libdebug=git=https://github.com/amiga-gcc/libdebug.git=libdebug=m68k \
	libnix=git=https://github.com/cahirwpz/libnix.git=libnix=m68k \
	newlib=git=https://github.com/sba1/adtools.git=newlib=m68k \
	sfdc=git=https://github.com/adtools/sfdc.git=sfdc=m68k \
	vasm=$(VERSIONS[vasm])=https://phx.de/ftp/vasm/vasm$(VERSIONS[vasm]).tar.gz=vasm$(VERSIONS[vasm]).tar.gz=m68k \
	vbcc-m68k-bin=$(VERSIONS[vbcc])=https://phx.de/ftp/vbcc/vbcc$(VERSIONS[vbcc])_bin_amigaos68k.lha=vbcc$(VERSIONS[vbcc])_bin_amigaos68k.lha=m68k \
	vbcc-m68k-target=$(VERSIONS[vbcc])=https://phx.de/ftp/vbcc/vbcc_target_m68k-amigaos.lha=vbcc_target_m68k-amigaos.lha=m68k

# Combined URLs for Makefile
URLS := $(URLS_COMMON) $(URLS_PPC) $(URLS_M68K) $(URLS_OPTIONAL_PPC) $(URLS_OPTIONAL_M68K)