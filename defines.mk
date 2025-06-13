# defines.mk - Core macro definitions for cross-compilation toolchain
# Copyright (c) 2025 Zachary Geurts, MIT License
# Used by Makefile; not intended for human modification.

# Cache timestamp
CURRENT_TIMESTAMP := $(shell $(TIMESTAMP))

# Logging: Output to console and logs/summary.log (if DISPLAY_AS_LOG=0)
define LOG_MESSAGE
$(ECHO) "[$(CURRENT_TIMESTAMP)] $1"
$(if $(filter 0,$(DISPLAY_AS_LOG)),\
	$(MKDIR) "$(LOGS)"; \
	$(ECHO) "[$(CURRENT_TIMESTAMP)] $1" >> "$(LOGS)/summary.log")
$(eval LAST_MESSAGE := [$(CURRENT_TIMESTAMP)] $1)
endef

define LOG_ERROR
$(ECHO) "[$(CURRENT_TIMESTAMP)] ERROR: $1"
$(if $(filter 0,$(DISPLAY_AS_LOG)),\
	$(MKDIR) "$(LOGS)"; \
	$(ECHO) "[$(CURRENT_TIMESTAMP)] ERROR: $1" >> "$(LOGS)/summary.log")
$(eval RECENT_ERROR := [$(CURRENT_TIMESTAMP)] ERROR: $1)
$(if $(filter-out $(FIRST_ERROR),),$(eval FIRST_ERROR := [$(CURRENT_TIMESTAMP)] ERROR: $1))
endef

# Progress ticker: Disabled on Windows
define PROGRESS_TICKER
$(if $(filter Linux Darwin,$(OS)),\
	$(eval TICKER_PID := $(shell (while true; do sleep 60; $(ECHO) "[$(CURRENT_TIMESTAMP)] [PROGRESS] Operation still running." | $(if $(filter 0,$(DISPLAY_AS_LOG)),tee -a "$(LOGS)/summary.log",cat); done) & echo $$!)) \
	$(call LOG_MESSAGE,Started progress ticker (PID $(TICKER_PID))),\
	$(call LOG_MESSAGE,Progress ticker disabled on $(OS_NAME)))
endef

define STOP_TICKER
$(if $(filter Linux Darwin,$(OS)),\
	$(if $(TICKER_PID),\
		kill $(TICKER_PID) 2>/dev/null || true; \
		wait $(TICKER_PID) 2>/dev/null || true; \
		$(eval TICKER_PID := ) \
		$(call LOG_MESSAGE,Stopped progress ticker)))
endef

# Download failure prompt
define HANDLE_DOWNLOAD_FAILURE
$(call LOG_ERROR,Download failed for $(URL) after 3 retries. Please place $(TARGET) in $(DOWNLOAD_DIR). Then restart with: make PLATFORM=$(PLATFORM))
$(STOP_TICKER)
$(error Download failed)
endef

# Build utilities
define BUILD_AUTOTOOLS
$(call LOG_MESSAGE,Configuring and building $1 in $2)
$(MKDIR) "$2"
cd "$2" && \
$(if $(wildcard $2/autogen.sh),, \
	$(ECHO) "#!/bin/bash\nset -e\nlibtoolize --force --copy\naclocal -I m4\nautoconf\nautoheader\n[ -f Makefile.am ] && automake --add-missing --copy --foreign" > autogen.sh && \
	$(CHMOD) +x autogen.sh) \
$(if $(wildcard $2/bootstrap),,$(CP) autogen.sh bootstrap) \
$(PROGRESS_TICKER) \
./bootstrap && \
./configure --prefix="$3" $(STATIC_FLAGS) $4 && \
$(MAKE) && \
$(MAKE) install $(if $(filter 0,$(DISPLAY_AS_LOG)),>"$(LOGS)/$1.log" 2>&1,) \
$(STOP_TICKER) \
$(TOUCH) "$5/$1" \
$(call LOG_MESSAGE,Successfully built and installed $1. $(if $(filter 0,$(DISPLAY_AS_LOG)),Log saved to $(LOGS)/$1.log,Output displayed on screen))
endef

define BUILD_AUTOTOOLS_RULE
$1_STAMPS/$2: $(addprefix $1_STAMPS/,$(DEPEND_$1_$2)) $(call BUILD_COMPONENT_DEPS,$2,$1) | $1_BUILD
	$(call BUILD_UNPACK,$(call BUILD_COMPONENT_DEPS,$2,$1),$2$(if $(VERSIONS[$2]),-$(VERSIONS[$2])),$1_BUILD)
	$(call BUILD_AUTOTOOLS,$2,$($1_BUILD)/$2$(if $(VERSIONS[$2]),-$(VERSIONS[$2])),$($1_PREFIX),$(CONFIG_FLAGS[$2]),$1_STAMPS)
endef

define BUILD_COMPONENT
$1_STAMPS/$2: $(addprefix $1_STAMPS/,$(DEPEND_$1_$2)) $(call BUILD_COMPONENT_DEPS,$2,$1) | $1_BUILD
	$(MKDIR) "$1_BUILD/$2"
	$(call LOG_MESSAGE,Created build directory $1_BUILD/$2)
	$(call BUILD_COMPONENT_BUILD,$2,$1)
	$(TOUCH) "$@"
	$(call LOG_MESSAGE,Completed processing $2 for $1)
endef

define BUILD_COMPONENT_BUILD
$(eval BUILD_RULE := $(BUILD_$1))
$(eval BUILD_TYPE := $(word 1,$(subst :, ,$(BUILD_RULE))))
$(eval BUILD_CMD := $(patsubst custom:%,%,$(BUILD_RULE)))
$(if $(BUILD_RULE),\
	$(call LOG_MESSAGE,Building $1 for $2 (type: $(BUILD_TYPE))) \
	$(call BUILD_UNPACK,$(call BUILD_COMPONENT_DEPS,$1,$2),$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1])),$2_BUILD) \
	$(PROGRESS_TICKER) \
	$(eval PREFIX := $($(2)_PREFIX)) \
	$(eval BUILD_DIR := $($(2)_BUILD)) \
	$(eval LOG_FILE := $(LOGS)/$1.log) \
	cd "$($(2)_BUILD)/$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1]))" && $(BUILD_CMD) $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOG_FILE)" 2>&1,) \
	$(STOP_TICKER) \
	$(call LOG_MESSAGE,Successfully built and installed $1. $(if $(filter 0,$(DISPLAY_AS_LOG)),Log saved to $(LOGS)/$1.log,Output displayed on screen)),\
	$(call LOG_MESSAGE,Warning: No build rule for $1, attempting autotools) \
	$(call BUILD_UNPACK,$(call BUILD_COMPONENT_DEPS,$1,$2),$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1])),$2_BUILD) \
	$(PROGRESS_TICKER) \
	cd "$($(2)_BUILD)/$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1]))" && \
	./configure --prefix="$($(2)_PREFIX)" $(STATIC_FLAGS) $(CONFIG_FLAGS[$1]) && \
	$(MAKE) && \
	$(MAKE) install $(if $(filter 0,$(DISPLAY_AS_LOG)),>"$(LOGS)/$1.log" 2>&1,) \
	$(STOP_TICKER) \
	$(call LOG_MESSAGE,Successfully built and installed $1. $(if $(filter 0,$(DISPLAY_AS_LOG)),Log saved to $(LOGS)/$1.log,Output displayed on screen)))
endef

define BUILD_COMPONENT_DEPS
$(call FIND_COMPONENT_FILE,$1,$2)
endef

define FIND_COMPONENT_FILE
$(eval NAME := $1)
$(eval URL_DATA := $(URL_$1))
$(eval VERSION := $(word 2,$(subst =, ,$(URL_DATA))))
$(eval URL := $(word 3,$(subst =, ,$(URL_DATA))))
$(eval TARGET := $(word 4,$(subst =, ,$(URL_DATA))))
$(eval PLATFORM := $(word 5,$(subst =, ,$(URL_DATA))))
$(eval DOWNLOAD_DIR := $(DOWNLOAD)/$2)
$(eval EXTENSION := $(if $(filter git,$(VERSION)),git,$(suffix $(TARGET))))
$(eval MATCHING_FILES := $(wildcard $(DOWNLOAD_DIR)/$1-$(VERSIONS[$1]).{tar.gz,tgz,tar.bz2,tbz2,tar.xz,zip,lha}))
$(eval SELECTED_FILE := $(if $(filter git,$(VERSION)),$(DOWNLOAD_DIR)/$1,$(if $(MATCHING_FILES),$(firstword $(MATCHING_FILES)),$(DOWNLOAD_DIR)/$(TARGET))))
$(if $(MATCHING_FILES),$(call LOG_MESSAGE,Found user-provided file for $1: $(firstword $(MATCHING_FILES))),\
	$(call LOG_MESSAGE,No file found for $1 in $(DOWNLOAD_DIR). Will attempt to download $(TARGET)))
$(SELECTED_FILE)
endef

define FETCH_SOURCE
$(call LOG_MESSAGE,Starting source fetch for $1)
$(MKDIR) "$2"
$(foreach pkg,$1,\
	$(eval NAME := $(word 1,$(subst =, ,$(pkg)))) \
	$(eval VERSION := $(word 2,$(subst =, ,$(pkg)))) \
	$(eval URL := $(word 3,$(subst =, ,$(pkg)))) \
	$(eval TARGET := $(word 4,$(subst =, ,$(pkg)))) \
	$(eval PLATFORM := $(word 5,$(subst =, ,$(pkg)))) \
	$(eval DOWNLOAD_DIR := $(DOWNLOAD)/$(PLATFORM)) \
	$(eval EXTENSION := $(if $(filter git,$(VERSION)),git,$(suffix $(TARGET)))) \
	$(if $(filter git,$(VERSION)),\
		$(if $(wildcard $(DOWNLOAD_DIR)/$(TARGET)),\
			$(call LOG_MESSAGE,Repository $(TARGET) already exists in $(DOWNLOAD_DIR)),\
			$(call LOG_MESSAGE,Cloning $(URL)) \
			$(PROGRESS_TICKER) \
			$(GIT) clone "$(URL)" "$(DOWNLOAD_DIR)/$(TARGET)" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$(TARGET).log" 2>&1,) && \
			(cd "$(DOWNLOAD_DIR)/$(TARGET)" && $(GIT) submodule update --init --recursive $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$(TARGET).log" 2>&1,)) && \
			$(MKDIR) "$(SOURCES)/$(TARGET)" && \
			$(CP) -r "$(DOWNLOAD_DIR)/$(TARGET)"/* "$(SOURCES)/$(TARGET)/" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$(TARGET).log" 2>&1,) \
			$(STOP_TICKER) \
			$(call LOG_MESSAGE,Successfully cloned $(TARGET))),\
		$(eval MATCHING_FILES := $(wildcard $(DOWNLOAD_DIR)/$(NAME)-$(VERSION).{tar.gz,tgz,tar.bz2,tbz2,tar.xz,zip,lha})) \
		$(if $(MATCHING_FILES),\
			$(call LOG_MESSAGE,Using existing file for $(NAME): $(firstword $(MATCHING_FILES))),\
			$(call LOG_MESSAGE,Downloading $(URL) to $(DOWNLOAD_DIR)/$(TARGET)) \
			$(PROGRESS_TICKER) \
			$(call DOWNLOAD_FILE,$(URL),$(DOWNLOAD_DIR)/$(TARGET),$(NAME)) \
			$(STOP_TICKER) \
			$(call LOG_MESSAGE,Successfully downloaded $(TARGET))))) \
$(TOUCH) "$2"
$(call LOG_MESSAGE,Completed source fetch for $1)
endef

define DOWNLOAD_FILE
$(eval RETRIES := 3) \
$(eval SUCCESS := 0) \
$(foreach i,1 2 3,\
	$(if $(SUCCESS),,\
		$(if $(shell $(CURL) -L -f -o "$2" "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$3.log" 2>&1,) && echo success),\
			$(eval SUCCESS := 1) \
			$(call LOG_MESSAGE,Successfully downloaded $2),\
			$(call LOG_MESSAGE,Retry $i failed for $1) \
			$(if $(filter $i,$(RETRIES)),$(call HANDLE_DOWNLOAD_FAILURE),sleep 2)))) \
$(if $(SUCCESS),,$(call HANDLE_DOWNLOAD_FAILURE))
endef

define BUILD_UNPACK
$(call LOG_MESSAGE,Unpacking $1 to $3)
$(MKDIR) "$3"
cd "$3" && \
$(eval EXT := $(suffix $1)) \
$(if $(filter .lha,$(EXT)),$(ARCHIVE_TOOL_LHA) x "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,),\
$(if $(filter .tar.gz .tgz,$(EXT)),$(GZIP) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,),\
$(if $(filter .tar.bz2 .tbz2,$(EXT)),$(BZIP2) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,),\
$(if $(filter .tar.xz,$(EXT)),$(XZ) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,),\
$(if $(filter .zip,$(EXT)),$(ARCHIVE_TOOL_7Z) x "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,),\
$(if $(filter .git,$(EXT)),$(MKDIR) "$2" && $(CP) -r "$1"/* "$2"/ $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,),\
	$(STOP_TICKER) \
	$(call LOG_ERROR,Unsupported extension: $(EXT)) \
	$(error Unpack failed))))))) \
$(STOP_TICKER) \
$(call LOG_MESSAGE,Successfully unpacked $2 to $3)
endef