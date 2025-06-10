### Down for repairs
Down for repairs! AmigaOS cross compiler for Linux / MacOSX / Windows

Go see the actual one at https://github.com/adtools/amigaos-cross-toolchain
===

These instructions I added are untested other than Linux.

# Requirements<BR />
Use make -j$(nproc) (Linux) or make -j$(sysctl -n hw.ncpu) (macOS) for faster builds.<BR />
If you have issues, verify the download links in the makefile.<BR />
## Linux (Ubuntu/Debian):<BR />
`sudo apt update`<BR />
`sudo apt install -y gcc g++ make curl patch bison flex subversion git perl gperf tar p7zip-full libncurses-dev`<BR />
<BR />
`make all`<BR />
or<BR />
`make ppc`<BR />
`make m68k`<BR />
before rebuilding `make clean`<BR />

ppc-amigaos-gcc -o hello hello.c  # PPC example<BR />
m68k-amigaos-gcc -o hello hello.c  # M68K example<BR />

## Windows (MSYS2):<BR />
Download MSYS2 from msys2.org<BR />
msys2_shell.cmd -mingw64<BR />
pacman -Syu<BR />
pacman -S --needed mingw-w64-x86_64-gcc mingw-w64-x86_64-g++ make curl patch mingw-w64-x86_64-bison mingw-w64-x86_64-flex mingw-w64-x86_64-subversion mingw-w64-x86_64-git perl mingw-w64-x86_64-gperf tar mingw-w64-x86_64-p7zip mingw-w64-x86_64-ncurses<BR />
gcc --version && g++ --version && make --version && curl --version && patch --version && bison --version && flex --version && svn --version && git --version && perl --version && gperf --version && tar --version && 7z<BR />
mkdir amiga-toolchain && cd amiga-toolchain<BR />
make<BR />
make ppc<BR />
make m68k<BR />
make clean  # Add to Makefile as above<BR />
export PATH=$PWD/install/ppc-amigaos/bin:$PATH  # For PPC<BR />
export PATH=$PWD/install/m68k-amigaos/bin:$PATH  # For M68K<BR />
ppc-amigaos-gcc -o hello hello.c  # PPC example<BR />
m68k-amigaos-gcc -o hello hello.c  # M68K example<BR />

## macOS:<BR />
Install Homebrew: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"<BR />
brew install gcc g++ make curl patch bison flex subversion git perl gperf p7zip ncurses<BR />
gcc --version && g++ --version && make --version && curl --version && patch --version && bison --version && flex --version && svn --version && git --version && perl --version && gperf --version && tar --version && 7z<BR />
mkdir amiga-toolchain && cd amiga-toolchain<BR />
make<BR />
make ppc<BR />
make m68k<BR />
make clean  # Add to Makefile as above<BR />
export PATH=$PWD/install/ppc-amigaos/bin:$PATH  # For PPC<BR />
export PATH=$PWD/install/m68k-amigaos/bin:$PATH  # For M68K<BR />
ppc-amigaos-gcc -o hello hello.c  # PPC example<BR />
m68k-amigaos-gcc -o hello hello.c  # M68K example<BR />
Notes:<BR />
Save Makefile in working directory.<BR />
<BR />
Toolchains install to ./install/ppc-amigaos and ./install/m68k-amigaos.<BR />
<BR />

<BR />
Custom PREFIX: make PREFIX=/custom/path<BR />
<BR />
Transfer binaries to AmigaOS or emulator (e.g., FS-UAE, WinUAE).<BR />
<BR />
If gcc is clang on macOS, use CC=gcc-14 CXX=g++-14 in Makefile.<BR />
<BR />
---------------------------------------------------------------

[![Build Status](https://circleci.com/gh/cahirwpz/amigaos-cross-toolchain.svg?&style=shield)](https://circleci.com/gh/cahirwpz/amigaos-cross-toolchain)

**Author:** [Krystian Bacławski](mailto:krystian.baclawski@gmail.com)

**This project is missing a maintainer!** Want to become one? Ask [adtools](https://github.com/orgs/adtools) developer team!

**Short description:** Cross toolchain build script for AmigaOS m68k and ppc targets. Supported host platforms are Linux, MacOSX and Windows (with [MSYS2](https://msys2.github.io/)).

### Overview

**amigaos-cross-toolchain** project provides an easy way to build AmigaOS 3.x (m68k) and ppc AmigaOS 4.x (ppc) target toolchain in a Unix-like environment.

Build process should produce following set of tools for **m68k-amigaos** target:

 * gcc 2.95.3
 * g++ 2.95.3
 * libstdc++ 2.10
 * binutils 2.14 (assembler, linker, etc.)
 * libnix 2.2 (standard ANSI/C library replacement for AmigaOS)
 * libm 5.4 (provides math library implementation for non-FPU Amigas)
 * AmigaOS headers & libraries & autodocs (for AmigaOS 3.9)
 * vbcc toolchain (most recent release) including vasm, vlink and C standard library
 * IRA: portable M68000/010/020/030/040 reassembler for AmigaOS hunk-format
   executables, libraries, devices and raw binary files
 * vda68k: portable M68k disassembler for 68000-68060, 68851, 68881, 68882
 * ~~[amitools](https://github.com/cnvogelg/amitools/blob/master/README.md#contents) with [vamos](https://github.com/cnvogelg/amitools/blob/master/doc/vamos.md) AmigaOS emulator which is proven to run SAS/C~~

... and following set of tools for **ppc-amigaos** target:

 * gcc 4.2.4
 * g++ 4.2.4
 * binutils 2.18 (assembler, linker, etc.)
 * newlib
 * clib 2.2
 * AmigaOS headers & libraries & autodocs (for AmigaOS 4.1)

**Note:** *Patches are welcome!*

### Downloads

There are no binary downloads provided for the time being. I do as much as possible to make the toolchain portable among Unix-like environments. Following platforms were tested and the toolchain is known to work for them:

 * Windows 7 SP1 32-bit (MSYS2 2.6.0, gcc 5.3.0)
 * Ubuntu 16.04 LTS 32-bit (gcc 5.4.0)
 * Ubuntu 16.04 LTS 64-bit (gcc 5.4.0) *Requires gcc-multilib package, and i386 libraries!*
 * MacOS X 10.9.5 (MacPorts - Apple's clang-600.0.57)
 
### Documentation

Documentation from Free Software Fundation:

 * [gcc 2.95.3](http://gcc.gnu.org/onlinedocs/gcc-2.95.3/gcc.html)
 * [binutils](http://sourceware.org/binutils/docs/)

Texinfo documents from GeekGadgets converted into HTML:

 * [libnix - a static library for GCC on the amiga](http://cahirwpz.users.sourceforge.net/libnix/index.html)
 * [AmigaOS-only features of GCC](http://cahirwpz.users.sourceforge.net/gcc-amigaos/index.html)

AmigaOS specific documents:

 * [Amiga Developer Docs](http://amigadev.elowar.com)

### Compiling

*Firstly… you should have basic understanding of Unix console environment, really* ;-)

#### Prerequisites

You have to have following packages installed in your system:

 * GNU gcc 5.x **32-bit version!** or Clang
 * Python 2.7.x
 * libncurses-dev
 * python-dev 2.7
 * GNU make 4.x
 * perl 5.22
 * git
 * GNU patch
 * GNU gperf
 * GNU bison

*For MacOSX users*: you'll likely need to have [MacPorts](http://www.macports.org) or [Homebrew](http://brew.sh) installed in order to build the toolchain.

#### How to build?

**Warning:** *Building with `sudo` is not recommended. I'm not responsible for any damage to your system.*

Follow steps listed below:

1. Fetch *amigaos-cross-toolchain* project to your local drive:  

```
    # git clone git://github.com/cahirwpz/amigaos-cross-toolchain.git
    # cd amigaos-cross-toolchain
```

2. Run `toolchain-m68k` or `toolchain-ppc` script (with `--prefix` option to specify where to install the toolchain). Note, that the destination directory must be writable by the user. 

```
    # ./toolchain-m68k --prefix=/opt/m68k-amigaos build
```

3. Wait for the result :-)

4. *(optional)* Install additional SDKs (e.g. AHI, CyberGraphX, Magic User Interface, etc.):

```
    # ./toolchain-m68k --prefix=/opt/m68k-amigaos install-sdk ahi cgx mui
```

#### What if something goes wrong?

If the build process fails, please write me an e-mail.  I'll try to help out. Don't forget to put into e-mail as much data about your environment as possible! 
It's **vitally important** to send me a full log from build process. You can capture it by redirecting output to a file with following command:

```
    # ./toolchain-m68k build 2>&1 | tee build.log
```

... but remember to cleanup your build environment beforehand with:

```
    # rm -rf .build-m68k
```
