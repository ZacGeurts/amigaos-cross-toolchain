# atari-st.mk
# Platform-specific versions and build rules for Atari ST cross-compiling
# Copyright (c) 2025 Zachary Geurts, MIT License
#
# Placeholder file for future expansion. Define VERSIONS and BUILD_ rules as needed.
# Uncommon components may be incompatible; specify platform-specific gcc, binutils, etc.
# Use SDK files where applicable.

# Enable uncommon components by default
INCLUDE_UNCOMMON=1

# Versions: VERSIONS[component]=version=url=filename=platform
# Example for OpenGL support:
# VERSIONS[opengl]=<version>=<url>=<filename>=atari-st
# Example for SDL support:
# VERSIONS[sdl]=<version>=https://libsdl.org/release/SDL-<version>.tar.gz=SDL-<version>.tar.gz=atari-st
# VERSIONS[sdl2]=<version>=https://libsdl.org/release/SDL2-<version>.tar.gz=SDL2-<version>.tar.gz=atari-st

# Build Processes
# Example for OpenGL:
# BUILD_opengl=custom:<commands>
# Example for SDL:
# BUILD_sdl=custom:cd $(BUILD_DIR)/SDL-$(VERSIONS[sdl]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
# BUILD_sdl2=custom:cd $(BUILD_DIR)/SDL2-$(VERSIONS[sdl2]) && ./configure --prefix=$(PREFIX) $(STATIC_FLAGS) && $(MAKE) && $(MAKE) install >$(LOG_FILE) 2>&1
