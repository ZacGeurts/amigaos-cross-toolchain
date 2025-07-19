# defines.mk
#AI: Core macros for cross-compilation toolchain, (c) 2025 Zachary Geurts, MIT License
#AI: Used by Makefile; optimized for AI parsing, not human modification
#AI: On critical error, o7_CENTER_ERROR dumps status with "o7" salute, including task, severity, error message, last message, first error, recent error, and current file

# Get current timestamp for logging using the TIMESTAMP variable defined in Makefile
CURRENT_TIMESTAMP:=$(shell $(TIMESTAMP))
# Track the currently processed file (optional, defaults to empty)
CURRENT_FILE?=

# Log a message to console and optionally to a summary log file
define LOG_MESSAGE
# Output message with timestamp to console
$(ECHO) [$(CURRENT_TIMESTAMP)] $1
# If DISPLAY_AS_LOG is 0, create logs directory and append message to summary.log
$(if $(filter 0,$(DISPLAY_AS_LOG)),$(MKDIR) "$(LOGS)";$(ECHO) [$(CURRENT_TIMESTAMP)] $1>>"$(LOGS)/summary.log")
# Store the last logged message for error reporting
$(eval LAST_MESSAGE:=[$(CURRENT_TIMESTAMP)] $1)
endef

# Log an error to console, summary log, and trigger o7_CENTER_ERROR
define LOG_ERROR
# Output error with timestamp to console
$(ECHO) [$(CURRENT_TIMESTAMP)] ERROR: $1
# If DISPLAY_AS_LOG is 0, create logs directory and append error to summary.log
$(if $(filter 0,$(DISPLAY_AS_LOG)),$(MKDIR) "$(LOGS)";$(ECHO) [$(CURRENT_TIMESTAMP)] ERROR: $1>>"$(LOGS)/summary.log")
# Store the most recent error for status reporting
$(eval RECENT_ERROR:=[$(CURRENT_TIMESTAMP)] ERROR: $1)
# If no first error is set, store this as the first error
$(if $(filter-out $(FIRST_ERROR),),$(eval FIRST_ERROR:=[$(CURRENT_TIMESTAMP)] ERROR: $1))
# Call o7_CENTER_ERROR to handle error logging and potential termination
$(call o7_CENTER_ERROR,$1)
endef

# Initialize the o7 Center for monitoring a task with periodic logging
# o7 is a head and an arm saluting.
# We are the message center. We either salute messages through and salute errors as the ship sinks.
# You should see us show up every 60 seconds at maximum with what is going on.
define o7_CENTER
# Set task name and severity for monitoring
$(eval O7_TASK:=$1)
$(eval O7_SEVERITY:=$2)
# Define log file path for this task
$(eval O7_LOG:=$(LOGS)/o7_center_$(O7_TASK).log)
# Log the start of o7 Center for the task
$(call LOG_MESSAGE,o7 Center started for task: $(O7_TASK) [Severity: $(O7_SEVERITY)])
# Check for Makefile warnings (e.g., overriding recipes)
$(eval MAKE_WARNINGS:=$(shell $(MAKE) -n $(MAKECMDGOALS) 2>&1 | grep "warning: overriding recipe" || true))
# Log any Makefile warnings as errors
$(if $(MAKE_WARNINGS),$(call LOG_ERROR,Makefile warnings detected: $(MAKE_WARNINGS)))
# Handle OS-specific background process for periodic task monitoring
$(if $(filter Windows_NT,$(OS)),\
	# On Windows, start a background cmd process to log task status every 60 seconds
	$(eval O7_PID:=$(shell start /b cmd /c "echo [$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK) >\"$(subst /,\,$(O7_LOG))\" && for /l %n in () do (timeout /t 60 /nobreak >nul && echo [$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK) >>\"$(subst /,\,$(O7_LOG))\")" && echo $$!)),\
	# On non-Windows, start a bash background process to log task status every 60 seconds
	$(eval O7_PID:=$(shell bash -c 'echo "[$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK)" >> "$(O7_LOG)"; while true; do sleep 60; echo "[$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK)" >> "$(O7_LOG)"; done & echo $$!')))
# Define PID file path for tracking the background process
$(eval O7_PID_FILE:=$(TMPDIR)/o7_$(O7_TASK).pid)
# Log the start of the monitoring process
$(ECHO) "Starting O7_PID: $(O7_PID) for task $(O7_TASK)" >> "$(O7_LOG)"
# Save the PID to a file
$(ECHO) $(O7_PID) > $(O7_PID_FILE)
endef

# Stop the o7 Center monitoring process and clean up
define STOP_o7
# Check if a monitoring process is running
$(if $(O7_PID),\
	# Log the stopping of the o7 Center
	$(call LOG_MESSAGE,Stopping o7 Center for task: $(O7_TASK) with PID: $(O7_PID))\
	# Terminate the process based on OS
	$(if $(filter Windows_NT,$(OS)),\
		# On Windows, forcefully terminate the process
		taskkill /PID $(O7_PID) /F >nul 2>&1 || true,\
		# On non-Windows, send TERM signal and wait for process to exit
		kill -TERM $(O7_PID) 2>/dev/null || true; wait $(O7_PID) 2>/dev/null || true)\
	# Log the stopping of the process
	$(ECHO) "Stopped O7_PID: $(O7_PID) for task $(O7_TASK)" >> "$(O7_LOG)"\
	# Remove the PID file
	$(RM) $(O7_PID_FILE)\
	# Clear o7 Center variables
	$(eval O7_PID:= )$(eval O7_TASK:= )$(eval O7_SEVERITY:= )$(eval O7_LOG:= ))
endef

# Handle errors caught by o7 Center, with critical errors triggering termination
define o7_CENTER_ERROR
# Store the error message
$(eval ERROR_MSG:=$1)
# Log the error for the current task
$(call LOG_MESSAGE,o7 Center caught error: $(ERROR_MSG) for task: $(O7_TASK) [Severity: $(O7_SEVERITY)])
# Handle critical vs. non-critical errors
$(if $(filter critical,$(O7_SEVERITY)),\
	# For critical errors, log termination and dump status
	$(call LOG_MESSAGE,CRITICAL error detected. Terminating task: $(O7_TASK))\
	$(ECHO) "o7 Status Dump on Exit:" >> "$(O7_LOG)"\
	$(ECHO) "  Task: $(O7_TASK)" >> "$(O7_LOG)"\
	$(ECHO) "  Severity: $(O7_SEVERITY)" >> "$(O7_LOG)"\
	$(ECHO) "  Error Message: $(ERROR_MSG)" >> "$(O7_LOG)"\
	$(ECHO) "  Last Message: $(LAST_MESSAGE)" >> "$(O7_LOG)"\
	$(ECHO) "  First Error: $(FIRST_ERROR)" >> "$(O7_LOG)"\
	$(ECHO) "  Recent Error: $(RECENT_ERROR)" >> "$(O7_LOG)"\
	$(ECHO) "  Current File: $(CURRENT_FILE)" >> "$(O7_LOG)"\
	# Stop the o7 Center process
	$(call STOP_o7)\
	# Terminate the build with an error
	$(error o7: $(ERROR_MSG)),\
	# For non-critical errors, log and continue
	$(call LOG_MESSAGE,NON-CRITICAL error detected. Continuing task: $(O7_TASK) with logged error))
endef

# Update the current file being processed
define UPDATE_CURRENT_FILE
# Set the CURRENT_FILE variable to the specified file
$(eval CURRENT_FILE:=$1)
# Log the file being processed
$(call LOG_MESSAGE,Processing file: $1)
endef

# Handle download failures after retries, providing user instructions
define HANDLE_DOWNLOAD_FAILURE
# Log download failure and provide instructions to manually place the file
$(call LOG_ERROR,Download failed: $(URL) (3 retries). Place $(TARGET) in $(DOWNLOAD_DIR). Restart: make $(PLATFORM))
# Stop the o7 Center process
$(call STOP_o7)
endef

# Build a component using autotools
define BUILD_AUTOTOOLS
# Start o7 Center for the build task
$(call o7_CENTER,build_autotools_$1,critical)
# Log the start of the build for the component
$(call LOG_MESSAGE,Building $1 in $2)
# Create the build directory
$(MKDIR) "$2"
# Generate autogen.sh if it doesn't exist, then copy to bootstrap if needed
cd "$2" && $(if $(wildcard $2/autogen.sh),,$(ECHO) "#!/bin/bash\nset -e\nlibtoolize --force --copy\naclocal -I m4\nautoconf\nautoheader\n[ -f Makefile.am ] && automake --add-missing --copy --foreign">autogen.sh && $(CHMOD) +x autogen.sh)$(if $(wildcard $2/bootstrap),,$(CP) autogen.sh bootstrap)
# Run bootstrap, configure, make, and install, logging output if DISPLAY_AS_LOG is 0
cd "$2" && ./bootstrap && ./configure --prefix="$3" $(STATIC_FLAGS) $4 && $(MAKE) && $(MAKE) install $(if $(filter 0,$(DISPLAY_AS_LOG)),>"$(LOGS)/$1.log" 2>&1,) || $(call LOG_ERROR,Failed to build $1)
# Stop the o7 Center process
$(call STOP_o7)
# Create a stamp file to mark successful build
$(TOUCH) "$5/$1"
# Log completion, indicating log file or screen output
$(call LOG_MESSAGE,Built/installed $1. $(if $(filter 0,$(DISPLAY_AS_LOG)),Log: $(LOGS)/$1.log,Screen output))
endef

# Define a build rule for an autotools-based component
define BUILD_AUTOTOOLS_RULE
# Rule to build component $2 for platform $1, depending on its dependencies
$1_STAMPS/$2: $(addprefix $1_STAMPS/,$(DEPEND_$1_$2)) $(call BUILD_COMPONENT_DEPS,$2,$1)|$1_BUILD
	# Unpack dependencies and component source
	$(call BUILD_UNPACK,$(call BUILD_COMPONENT_DEPS,$2,$1),$2$(if $(VERSIONS[$2]),-$(VERSIONS[$2])),$1_BUILD)
	# Build the component using autotools
	$(call BUILD_AUTOTOOLS,$2,$($1_BUILD)/$2$(if $(VERSIONS[$2]),-$(VERSIONS[$2])),$($1_PREFIX),$(CONFIG_FLAGS[$2]),$1_STAMPS)
endef

# Define a generic build rule for a component
define BUILD_COMPONENT
# Rule to build component $2 for platform $1, depending on its dependencies
$1_STAMPS/$2: $(addprefix $1_STAMPS/,$(DEPEND_$1_$2)) $(call BUILD_COMPONENT_DEPS,$2,$1)|$1_BUILD
	# Create the build directory for the component
	$(MKDIR) "$1_BUILD/$2"
	# Log directory creation
	$(call LOG_MESSAGE,Created $1_BUILD/$2)
	# Build the component
	$(call BUILD_COMPONENT_BUILD,$2,$1)
	# Create a stamp file to mark successful build
	$(TOUCH) "$@"
	# Log completion
	$(call LOG_MESSAGE,Processed $2 for $1)
endef

# Build a component, using custom or autotools build rules
define BUILD_COMPONENT_BUILD
# Extract build rule and type for the component
$(eval BUILD_RULE:=$(BUILD_$1))
$(eval BUILD_TYPE:=$(word 1,$(subst :, ,$(BUILD_RULE))))
$(eval BUILD_CMD:=$(patsubst custom:%,%,$(BUILD_RULE)))
# Set build directory and prefix
$(eval BUILD_DIR:=$($2_BUILD))
$(eval PREFIX:=$($2_PREFIX))
# Define log file for the component
$(eval LOG_FILE:=$(LOGS)/$1.log)
# Log the build type or fallback to autotools
$(if $(BUILD_RULE),$(call LOG_MESSAGE,Building $1 for $2 (type: $(BUILD_TYPE))),$(call LOG_MESSAGE,No custom rule for $1, trying autotools))
# Start o7 Center for the build task
$(call o7_CENTER,build_component_$1,critical)
# Unpack dependencies and component source
$(call BUILD_UNPACK,$(call BUILD_COMPONENT_DEPS,$1,$2),$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1])),$2_BUILD)
# Execute build command (custom or autotools), logging output if DISPLAY_AS_LOG is 0
cd "$(BUILD_DIR)/$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1]))" && $(if $(BUILD_RULE),$(BUILD_CMD),./configure --prefix="$(PREFIX)" $(STATIC_FLAGS) $(CONFIG_FLAGS[$1]) && $(MAKE) && $(MAKE) install) $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOG_FILE)" 2>&1,) || $(call LOG_ERROR,Failed to build $1)
# Stop the o7 Center process
$(call STOP_o7)
# Log completion, indicating log file or screen output
$(call LOG_MESSAGE,Built/installed $1. $(if $(filter 0,$(DISPLAY_AS_LOG)),Log: $(LOG_FILE),Screen output))
endef

# Resolve dependencies for a component
define BUILD_COMPONENT_DEPS
# Find the component file (source or archive) for the given component and platform
$(call FIND_COMPONENT_FILE,$1,$2)
endef

# Locate or download a component's source file
define FIND_COMPONENT_FILE
# Extract component name
$(eval NAME:=$1)
# Extract URL data (version, URL, target, platform)
$(eval URL_DATA:=$(URL_$1))
$(eval VERSION:=$(word 2,$(subst =, ,$(URL_DATA))))
$(eval URL:=$(word 3,$(subst =, ,$(URL_DATA))))
$(eval TARGET:=$(word 4,$(subst =, ,$(URL_DATA))))
$(eval PLATFORM:=$(word 5,$(subst =, ,$(URL_DATA))))
# Set download directory for the platform
$(eval DOWNLOAD_DIR:=$(DOWNLOAD)/$2)
# Determine file extension (git or archive type)
$(eval EXTENSION:=$(if $(filter git,$(VERSION)),git,$(suffix $(TARGET))))
# Find matching archive files in the download directory
$(eval MATCHING_FILES:=$(wildcard $(DOWNLOAD_DIR)/$1-$(VERSIONS[$1]).{tar.gz,tgz,tar.bz2,tbz2,tar.xz,zip,lha}))
# Select the source file (git repo or first matching archive)
$(eval SELECTED_FILE:=$(if $(filter git,$(VERSION)),$(DOWNLOAD_DIR)/$1,$(if $(MATCHING_FILES),$(firstword $(MATCHING_FILES)),$(DOWNLOAD_DIR)/$(TARGET))))
# Log whether the file was found or needs downloading
$(if $(MATCHING_FILES),$(call LOG_MESSAGE,Found $1: $(firstword $(MATCHING_FILES))),$(call LOG_MESSAGE,No $1 in $(DOWNLOAD_DIR). Downloading $(TARGET)))
# Update the current file being processed
$(call UPDATE_CURRENT_FILE,$(SELECTED_FILE))
# Return the selected file path
$(SELECTED_FILE)
endef

# Process a URL for downloading or cloning a component
define PROCESS_URL
# Parse URL data (name, version, URL, target, platform)
$(eval NAME:=$(word 1,$(subst =, ,$1)))
$(eval VERSION:=$(word 2,$(subst =, ,$1)))
$(eval URL:=$(word 3,$(subst =, ,$1)))
$(eval TARGET:=$(word 4,$(subst =, ,$1)))
$(eval PLATFORM:=$(word 5,$(subst =, ,$1)))
# Set download directory for the platform
$(eval DOWNLOAD_DIR:=$(DOWNLOAD)/$(PLATFORM))
# Determine file extension (git or archive type)
$(eval EXTENSION:=$(if $(filter git,$(VERSION)),git,$(suffix $(TARGET))))
# Handle git repositories
$(if $(filter git,$(VERSION)),\
	# If git repo exists, log it; otherwise, clone it
	$(if $(wildcard $(DOWNLOAD_DIR)/$(TARGET)),\
		$(call LOG_MESSAGE,Repo $(TARGET) exists in $(DOWNLOAD_DIR)),\
		$(call o7_CENTER,git_clone_$(TARGET),critical)\
		$(call LOG_MESSAGE,Cloning $(URL))\
		$(call UPDATE_CURRENT_FILE,$(DOWNLOAD_DIR)/$(TARGET))\
		# Clone the repository and initialize submodules
		$(GIT) clone "$(URL)" "$(DOWNLOAD_DIR)/$(TARGET)" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$(TARGET).log" 2>&1,) && \
		(cd "$(DOWNLOAD_DIR)/$(TARGET)" && $(GIT) submodule update --init --recursive $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/(TARGET).log" 2>&1,)) && \
		# Copy cloned files to the sources directory
		$(MKDIR) "$(SOURCES)/$(TARGET)" && $(CP) -r "$(DOWNLOAD_DIR)/(TARGET)/"/* "$(SOURCES)/(TARGET)/" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/(TARGET).log" 2>&1,) || $(call LOG_ERROR,Failed to clone $(TARGET))\
		$(call STOP_o7)),\
	# Handle archive files
	$(eval MATCHING_FILES:=$(wildcard $(DOWNLOAD_DIR)/$(NAME)-$(VERSION).{tar.gz,tgz,tar.bz2,tbz2,tar.xz,zip,lha}))\
	$(if $(MATCHING_FILES),\
		# If archive exists, log it
		$(call LOG_MESSAGE,Using $(NAME): $(firstword $(MATCHING_FILES))),\
		# Otherwise, download the file
		$(call o7_CENTER,download_$(TARGET),critical)\
		$(call LOG_MESSAGE,Downloading $(URL) to $(DOWNLOAD_DIR)/(TARGET))\
		$(call UPDATE_CURRENT_FILE,$(DOWNLOAD_DIR)/(TARGET))\
		$(call DOWNLOAD_FILE,$(URL),$(DOWNLOAD_DIR)/(TARGET),$(NAME),$(DOWNLOAD_DIR),$(PLATFORM))\
		$(call STOP_o7)))
endef

# Fetch source files for a list of components
define FETCH_SOURCE
# Log the start of fetching sources
$(call LOG_MESSAGE,Fetching $1)
# Create the download directory
$(MKDIR) "$2"
# Process each URL in the list
$(foreach p,$1,$(call PROCESS_URL,$(p)))
# Create a stamp file to mark completion
$(TOUCH) "$2"
# Log completion
$(call LOG_MESSAGE,Fetched $1)
endef

# Retry downloading a file up to three times
define RETRY_DOWNLOAD
# Attempt to download the file using curl
$(eval CURL_RESULT:=$(shell $(CURL) -L -f -o "$2" "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$3.log" 2>&1,) && echo success || echo fail))
# If download succeeds, log it and set SUCCESS flag
$(if $(filter success,$(CURL_RESULT)),$(eval SUCCESS:=1)$(call LOG_MESSAGE,Downloaded $2),$(call LOG_MESSAGE,Retry $5 failed: $1)$(if $(filter $5,$(RETRIES)),$(call HANDLE_DOWNLOAD_FAILURE),sleep 2))
endef

# Download a file with retries
define DOWNLOAD_FILE
# Set maximum retries to 3
$(eval RETRIES:=3)
# Initialize SUCCESS flag
$(eval SUCCESS:=0)
# Attempt download up to three times
$(foreach i,1 2 3,$(if $(SUCCESS),,$(call RETRY_DOWNLOAD,$1,$2,$3,$4,$i)))
# If all retries fail, trigger download failure handling
$(if $(SUCCESS),,$(eval URL:=$1)$(eval TARGET:=$(notdir $2))$(eval DOWNLOAD_DIR:=$4)$(eval PLATFORM:=$5)$(call HANDLE_DOWNLOAD_FAILURE))
endef

# Unpack a source file to the build directory
define BUILD_UNPACK
# Start o7 Center for the unpack task
$(call o7_CENTER,unpack_$2,critical)
# Log the start of unpacking
$(call LOG_MESSAGE,Unpacking $2 to $3)
# Create the build directory
$(MKDIR) "$3"
# Handle different archive types
cd "$3" && $(eval EXT:=$(suffix $1))$(if $(filter .lha,$(EXT)),\
	# Unpack .lha archives
	$(call UPDATE_CURRENT_FILE,$3/$2/lha.h)$(ARCHIVE_TOOL_LHA) x "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),\
	$(if $(filter .tar.gz .tgz,$(EXT)),\
		# Unpack .tar.gz or .tgz archives
		$(call UPDATE_CURRENT_FILE,$3/$2/configure)$(GZIP) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),\
		$(if $(filter .tar.bz2 .tbz2,$(EXT)),\
			# Unpack .tar.bz2 or .tbz2 archives
			$(call UPDATE_CURRENT_FILE,$3/$2/configure)$(BZIP2) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),\
			$(if $(filter .tar.xz,$(EXT)),\
				# Unpack .tar.xz archives
				$(call UPDATE_CURRENT_FILE,$3/$2/configure)$(XZ) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),\
				$(if $(filter .zip,$(EXT)),\
					# Unpack .zip archives
					$(call UPDATE_CURRENT_FILE,$3/$2/7z.h)$(ARCHIVE_TOOL_7Z) x "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),\
					$(if $(filter .git,$(EXT)),\
						# Copy git repository files
						$(call UPDATE_CURRENT_FILE,$3/$2/README)$(MKDIR) "$2" && $(CP) -r "$1"/* "$2"/ $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),\
						# Log error for unsupported extensions
						$(call LOG_ERROR,Bad ext: $(EXT))))))))
# Stop the o7 Center process
$(call STOP_o7)
# Log completion
$(call LOG_MESSAGE,Unpacked $2 to $3)
endef

# Cache version information from VERSIONS variables
define CACHE_VERSIONS
# Convert VERSIONS[component] variables to URL_component format
$(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(eval URL_$(patsubst VERSIONS[%,%,$(subst ],,$(c))):=$(value $(c))))
endef

# Set platform-specific variables for each target
define SET_TARGET_VARS
# For each platform target
$(foreach t,$(TARGETS),\
	# Set target name, adjusting for AmigaOS platforms
	$(eval $(t)_TARGET:=$(if $(filter ppc-amigaos m68k-amigaos,$(t)),$(subst -amigaos,,$(t))-amigaos,$(t))) \
	# Set build directory
	$(eval $(t)_BUILD:=$(BUILD)/$(t)) \
	# Set download directory
	$(eval $(t)_DOWNLOAD:=$(DOWNLOAD)/$(t)) \
	# Set install prefix (custom or default)
	$(eval $(t)_PREFIX:=$(if $(PREFIX),$(PREFIX)/$(t),$(BUILD)/install/$(t))) \
	# Set stamps directory
	$(eval $(t)_STAMPS:=$(STAMPS)/$(t)) \
	# List components for the platform
	$(eval $(t)_COMPONENTS:=$(sort $(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(if $(filter $(t),$(word 5,$(subst =, ,$(value $(c))))),$(patsubst VERSIONS[%,%,$(subst ],,$(c))))))) \
	# Log variable setup
	$(call LOG_MESSAGE,Set target vars for platform: $(t)))
endef

# Validate that all components have version information
define VALIDATE_COMPONENTS
# Check each platform's components for missing version data
$(foreach t,$(TARGETS),$(foreach c,$($(t)_COMPONENTS),$(if $(VERSIONS[$(c)]),,$(call LOG_ERROR,No version for '$(c)' in platform/$(t).mk))))
endef

# Set dependencies for each component per platform
define SET_DEPENDENCIES
# Define dependencies for each component in each platform
$(foreach t,$(TARGETS),$(foreach c,$($(t)_COMPONENTS),$(eval DEPEND_$(t)_$(c):=$(foreach d,$(DEPEND[$c]),$(if $(filter $(d),$($(t)_COMPONENTS)),$(d))))))
endef

# Generate download rules for each platform
define SET_DOWNLOAD_FILES
# Create rules to download files for each platform
$(foreach t,$(TARGETS),$(eval $($(t)_DOWNLOAD)/% : | $($(t)_DOWNLOAD)\n\t$$(call o7_CENTER,download,=$$*,critical)\n\t$$(call FETCH_SOURCE,$$(filter %=$$*,$$(URLS)),$($(t)_DOWNLOAD))\n\t$$(call STOP_o7)))
endef

# Mark downloaded files as processed
define SET_DOWNLOADED_FILES
# Create rules to mark download directories as processed
$(foreach t,$(TARGETS),$(eval $(t)_DOWNLOAD/.downloaded: $(filter $($(t)_DOWNLOAD)/%,$(DOWNLOAD_FILES))|$($(t)_DOWNLOAD)$(TOUCH) $@$(call LOG_MESSAGE,Marked $($(t)_DOWNLOAD) processed)))
endef

# Apply build rules for autotools and non-autotools components
define APPLY_BUILD_RULES
# Generate autotools build rules for applicable components
$(foreach t,$(TARGETS),$(foreach c,$(filter $(AUTOTOOLS_COMPONENTS),$($(t)_COMPONENTS)),$(eval $(call BUILD_AUTOTOOLS_RULE,$(t),$(c)))))
# Generate generic build rules for non-autotools components
$(foreach t,$(TARGETS),$(foreach c,$(filter-out $(AUTOTOOLS_COMPONENTS),$($(t)_COMPONENTS)),$(eval $(call BUILD_COMPONENT,$(t),$(c)))))
endef