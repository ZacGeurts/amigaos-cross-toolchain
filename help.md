# AmigaOS Cross-Toolchain Builder

This repository contains scripts to build cross-toolchains for AmigaOS on two targets:
- **m68k-amigaos**: For AmigaOS <= 3.9 (Motorola 68k-based systems).
- **ppc-amigaos**: For AmigaOS 4.x (PowerPC-based systems).

The scripts automate downloading, configuring, and building the necessary tools, libraries, and headers to develop software for these platforms.

## Produced Tools

### For `m68k-amigaos`
- **GCC 2.95.3**: C compiler.
- **G++ 2.95.3**: C++ compiler.
- **libstdc++ 2.10**: C++ standard library.
- **Binutils 2.14**: Assembler, linker, and other utilities.
- **libnix 2.2**: Standard ANSI/C library replacement for AmigaOS.
- **libm 5.4**: Math library for non-FPU Amigas.
- **AmigaOS Headers & Libraries**: NDK 3.9 headers, libraries, and autodocs, installed to `{prefix}/m68k-amigaos/ndk`.
- **vbcc Toolchain**: Latest release, including:
  - `vasm`: Assembler.
  - `vlink`: Linker.
  - C standard library.
- **IRA**: Reassembler for AmigaOS hunk-format executables, libraries, devices, and raw binary files.
- **vda68k**: Disassembler for M68k (68000-68060, 68851, 68881, 68882).
- **amitools**: Includes `vamos`, an AmigaOS emulator compatible with SAS/C.

### For `ppc-amigaos`
- **GCC 4.2.4**: C compiler.
- **G++ 4.2.4**: C++ compiler.
- **Binutils 2.18**: Assembler, linker, and other utilities.
- **newlib**: C standard library.
- **clib2 2.2**: Alternative C library for AmigaOS.
- **AmigaOS Headers & Libraries**: SDK 53.24 headers, libraries, and autodocs for AmigaOS 4.1, installed to `{prefix}/ppc-amigaos/SDK`.

## Prerequisites

The build process requires specific tools and libraries. The scripts are designed for Linux (e.g., Ubuntu 24.04) or macOS (with MacPorts or Homebrew). The following packages are required:

### Linux (Ubuntu/Debian)
Run the following command to install all necessary system packages:

`sudo apt update`
`sudo apt install -y build-essential gcc g++ flex bison make git subversion curl python3-dev libncurses-dev gperf perl`<BR />
<BR />
For 32-bit compatibility on 64-bit systems (required for GCC 5.x 32-bit builds):<BR />
`sudo apt install -y gcc-multilib g++-multilib`<BR />
<BR />
### Verify installations:
`gcc --version  # Should show GCC 13.3.0 or similar`<BR />
`g++ --version`<BR />
`flex --version`<BR />
`bison --version`<BR />
`python3 --version  # Should show Python 3.12.3 or similar`<BR />
<BR />
# macOS
Install Xcode Command Line Tools:<BR />
`xcode-select --install`<BR />
Use Homebrew to install dependencies:<BR />
`brew install gcc g++ flex bison make git subversion curl python3 ncurses gperf perl`<BR />
<BR />
For 32-bit compatibility, ensure a compatible GCC version is installed (e.g., gcc@13).<BR />
<BR />
# Python Dependencies<BR />
The scripts require the lhafile Python package to handle .lha archives. Install it using pip:<BR />
`pip3 install --user -r requirements.txt`<BR />
<BR />
# Notes on Prerequisites
Python Version: The scripts use Python 3.12.3 (not Python 2.7, despite older documentation). Ensure Python 3.6 or later is installed.

32-bit Compatibility: The scripts use -m32 flags for some builds (e.g., GCC 4.2.4 in toolchain-ppc). On 64-bit systems, gcc-multilib is required.

# AmigaOS Headers & Libraries:
m68k-amigaos: The NDK_3.9.lha file is automatically downloaded from http://www.haage-partner.de/download/AmigaOS/NDK39.lha and installed to {prefix}/m68k-amigaos/ndk (default: ./m68k-amigaos/ndk).

ppc-amigaos: The SDK_53.24.lha file is automatically downloaded from http://hyperion-entertainment.biz/index.php/downloads?view=download&format=raw&file=69 and installed to {prefix}/ppc-amigaos/SDK (default: ./ppc-amigaos/SDK).

No manual download or placement is required; the scripts handle these steps.
