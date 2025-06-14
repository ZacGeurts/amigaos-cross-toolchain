#AI: Core macros for cross-compilation toolchain, (c) 2025 Zachary Geurts, MIT License
#AI: Used by Makefile; optimized for AI parsing, not human modification
#AI: On critical error, o7_CENTER_ERROR dumps status with "o7" salute, including task, severity, error message, last message, first error, recent error, and current file

CURRENT_TIMESTAMP:=$(shell $(TIMESTAMP))
CURRENT_FILE?=

define LOG_MESSAGE
$(ECHO) [$(CURRENT_TIMESTAMP)] $1
$(if $(filter 0,$(DISPLAY_AS_LOG)),$(MKDIR) "$(LOGS)";$(ECHO) [$(CURRENT_TIMESTAMP)] $1>>"$(LOGS)/summary.log")
$(eval LAST_MESSAGE:=[$(CURRENT_TIMESTAMP)] $1)
endef

define LOG_ERROR
$(ECHO) [$(CURRENT_TIMESTAMP)] ERROR: $1
$(if $(filter 0,$(DISPLAY_AS_LOG)),$(MKDIR) "$(LOGS)";$(ECHO) [$(CURRENT_TIMESTAMP)] ERROR: $1>>"$(LOGS)/summary.log")
$(eval RECENT_ERROR:=[$(CURRENT_TIMESTAMP)] ERROR: $1)
$(if $(filter-out $(FIRST_ERROR),),$(eval FIRST_ERROR:=[$(CURRENT_TIMESTAMP)] ERROR: $1))
$(call o7_CENTER_ERROR,$1)
endef

# o7 is a head and an arm saluting.
# We are the message center. We either salute messages through and salute errors as the ship sinks.
# You should see us show up every 60 seconds at maximum with what is going on.
define o7_CENTER
$(eval O7_TASK:=$1)
$(eval O7_SEVERITY:=$2)
$(eval O7_LOG:=$(LOGS)/o7_center_$(O7_TASK).log)
$(call LOG_MESSAGE,o7 Center started for task: $(O7_TASK) [Severity: $(O7_SEVERITY)])
$(eval MAKE_WARNINGS:=$(shell $(MAKE) -n $(MAKECMDGOALS) 2>&1 | grep "warning: overriding recipe" || true))
$(if $(MAKE_WARNINGS),$(call LOG_ERROR,Makefile warnings detected: $(MAKE_WARNINGS)))
$(if $(filter Windows_NT,$(OS)),\
	$(eval O7_PID:=$(shell start /b cmd /c "echo [$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK) >\"$(subst /,\,$(O7_LOG))\" && for /l %n in () do (timeout /t 60 /nobreak >nul && echo [$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK) >>\"$(subst /,\,$(O7_LOG))\")" && echo $$!)),\
	$(eval O7_PID:=$(shell bash -c 'echo "[$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK)" >> "$(O7_LOG)"; while true; do sleep 60; echo "[$(CURRENT_TIMESTAMP)] [o7] Monitoring $(O7_TASK)" >> "$(O7_LOG)"; done & echo $$!')))
$(eval O7_PID_FILE:=$(TMPDIR)/o7_$(O7_TASK).pid)
$(ECHO) "Starting O7_PID: $(O7_PID) for task $(O7_TASK)" >> "$(O7_LOG)"
$(ECHO) $(O7_PID) > $(O7_PID_FILE)
endef

define STOP_o7
$(if $(O7_PID),\
	$(call LOG_MESSAGE,Stopping o7 Center for task: $(O7_TASK) with PID: $(O7_PID))\
	$(if $(filter Windows_NT,$(OS)),\
		taskkill /PID $(O7_PID) /F >nul 2>&1 || true,\
		kill -TERM $(O7_PID) 2>/dev/null || true; wait $(O7_PID) 2>/dev/null || true)\
	$(ECHO) "Stopped O7_PID: $(O7_PID) for task $(O7_TASK)" >> "$(O7_LOG)"\
	$(RM) $(O7_PID_FILE)\
	$(eval O7_PID:= )$(eval O7_TASK:= )$(eval O7_SEVERITY:= )$(eval O7_LOG:= ))
endef

define o7_CENTER_ERROR
$(eval ERROR_MSG:=$1)
$(call LOG_MESSAGE,o7 Center caught error: $(ERROR_MSG) for task: $(O7_TASK) [Severity: $(O7_SEVERITY)])
$(if $(filter critical,$(O7_SEVERITY)),\
	$(call LOG_MESSAGE,CRITICAL error detected. Terminating task: $(O7_TASK))\
	$(ECHO) "o7 Status Dump on Exit:" >> "$(O7_LOG)"\
	$(ECHO) "  Task: $(O7_TASK)" >> "$(O7_LOG)"\
	$(ECHO) "  Severity: $(O7_SEVERITY)" >> "$(O7_LOG)"\
	$(ECHO) "  Error Message: $(ERROR_MSG)" >> "$(O7_LOG)"\
	$(ECHO) "  Last Message: $(LAST_MESSAGE)" >> "$(O7_LOG)"\
	$(ECHO) "  First Error: $(FIRST_ERROR)" >> "$(O7_LOG)"\
	$(ECHO) "  Recent Error: $(RECENT_ERROR)" >> "$(O7_LOG)"\
	$(ECHO) "  Current File: $(CURRENT_FILE)" >> "$(O7_LOG)"\
	$(call STOP_o7)\
	$(error o7: $(ERROR_MSG)),\
	$(call LOG_MESSAGE,NON-CRITICAL error detected. Continuing task: $(O7_TASK) with logged error))
endef

define UPDATE_CURRENT_FILE
$(eval CURRENT_FILE:=$1)
$(call LOG_MESSAGE,Processing file: $1)
endef

define HANDLE_DOWNLOAD_FAILURE
$(call LOG_ERROR,Download failed: $(URL) (3 retries). Place $(TARGET) in $(DOWNLOAD_DIR). Restart: make $(PLATFORM))
$(call STOP_o7)
endef

define BUILD_AUTOTOOLS
$(call o7_CENTER,build_autotools_$1,critical)
$(call LOG_MESSAGE,Building $1 in $2)
$(MKDIR) "$2"
cd "$2" && $(if $(wildcard $2/autogen.sh),,$(ECHO) "#!/bin/bash\nset -e\nlibtoolize --force --copy\naclocal -I m4\nautoconf\nautoheader\n[ -f Makefile.am ] && automake --add-missing --copy --foreign">autogen.sh && $(CHMOD) +x autogen.sh)$(if $(wildcard $2/bootstrap),,$(CP) autogen.sh bootstrap)
cd "$2" && ./bootstrap && ./configure --prefix="$3" $(STATIC_FLAGS) $4 && $(MAKE) && $(MAKE) install $(if $(filter 0,$(DISPLAY_AS_LOG)),>"$(LOGS)/$1.log" 2>&1,) || $(call LOG_ERROR,Failed to build $1)
$(call STOP_o7)
$(TOUCH) "$5/$1"
$(call LOG_MESSAGE,Built/installed $1. $(if $(filter 0,$(DISPLAY_AS_LOG)),Log: $(LOGS)/$1.log,Screen output))
endef

define BUILD_AUTOTOOLS_RULE
$1_STAMPS/$2: $(addprefix $1_STAMPS/,$(DEPEND_$1_$2)) $(call BUILD_COMPONENT_DEPS,$2,$1)|$1_BUILD
	$(call BUILD_UNPACK,$(call BUILD_COMPONENT_DEPS,$2,$1),$2$(if $(VERSIONS[$2]),-$(VERSIONS[$2])),$1_BUILD)
	$(call BUILD_AUTOTOOLS,$2,$($1_BUILD)/$2$(if $(VERSIONS[$2]),-$(VERSIONS[$2])),$($1_PREFIX),$(CONFIG_FLAGS[$2]),$1_STAMPS)
endef

define BUILD_COMPONENT
$1_STAMPS/$2: $(addprefix $1_STAMPS/,$(DEPEND_$1_$2)) $(call BUILD_COMPONENT_DEPS,$2,$1)|$1_BUILD
	$(MKDIR) "$1_BUILD/$2"
	$(call LOG_MESSAGE,Created $1_BUILD/$2)
	$(call BUILD_COMPONENT_BUILD,$2,$1)
	$(TOUCH) "$@"
	$(call LOG_MESSAGE,Processed $2 for $1)
endef

define BUILD_COMPONENT_BUILD
$(eval BUILD_RULE:=$(BUILD_$1))
$(eval BUILD_TYPE:=$(word 1,$(subst :, ,$(BUILD_RULE))))
$(eval BUILD_CMD:=$(patsubst custom:%,%,$(BUILD_RULE)))
$(eval BUILD_DIR:=$($2_BUILD))
$(eval PREFIX:=$($2_PREFIX))
$(eval LOG_FILE:=$(LOGS)/$1.log)
$(if $(BUILD_RULE),$(call LOG_MESSAGE,Building $1 for $2 (type: $(BUILD_TYPE))),$(call LOG_MESSAGE,No custom rule for $1, trying autotools))
$(call o7_CENTER,build_component_$1,critical)
$(call BUILD_UNPACK,$(call BUILD_COMPONENT_DEPS,$1,$2),$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1])),$2_BUILD)
cd "$(BUILD_DIR)/$1$(if $(VERSIONS[$1]),-$(VERSIONS[$1]))" && $(if $(BUILD_RULE),$(BUILD_CMD),./configure --prefix="$(PREFIX)" $(STATIC_FLAGS) $(CONFIG_FLAGS[$1]) && $(MAKE) && $(MAKE) install) $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOG_FILE)" 2>&1,) || $(call LOG_ERROR,Failed to build $1)
$(call STOP_o7)
$(call LOG_MESSAGE,Built/installed $1. $(if $(filter 0,$(DISPLAY_AS_LOG)),Log: $(LOG_FILE),Screen output))
endef

define BUILD_COMPONENT_DEPS
$(call FIND_COMPONENT_FILE,$1,$2)
endef

define FIND_COMPONENT_FILE
$(eval NAME:=$1)
$(eval URL_DATA:=$(URL_$1))
$(eval VERSION:=$(word 2,$(subst =, ,$(URL_DATA))))
$(eval URL:=$(word 3,$(subst =, ,$(URL_DATA))))
$(eval TARGET:=$(word 4,$(subst =, ,$(URL_DATA))))
$(eval PLATFORM:=$(word 5,$(subst =, ,$(URL_DATA))))
$(eval DOWNLOAD_DIR:=$(DOWNLOAD)/$2)
$(eval EXTENSION:=$(if $(filter git,$(VERSION)),git,$(suffix $(TARGET))))
$(eval MATCHING_FILES:=$(wildcard $(DOWNLOAD_DIR)/$1-$(VERSIONS[$1]).{tar.gz,tgz,tar.bz2,tbz2,tar.xz,zip,lha}))
$(eval SELECTED_FILE:=$(if $(filter git,$(VERSION)),$(DOWNLOAD_DIR)/$1,$(if $(MATCHING_FILES),$(firstword $(MATCHING_FILES)),$(DOWNLOAD_DIR)/$(TARGET))))
$(if $(MATCHING_FILES),$(call LOG_MESSAGE,Found $1: $(firstword $(MATCHING_FILES))),$(call LOG_MESSAGE,No $1 in $(DOWNLOAD_DIR). Downloading $(TARGET)))
$(call UPDATE_CURRENT_FILE,$(SELECTED_FILE))
$(SELECTED_FILE)
endef

define PROCESS_URL
$(eval NAME:=$(word 1,$(subst =, ,$1)))
$(eval VERSION:=$(word 2,$(subst =, ,$1)))
$(eval URL:=$(word 3,$(subst =, ,$1)))
$(eval TARGET:=$(word 4,$(subst =, ,$1)))
$(eval PLATFORM:=$(word 5,$(subst =, ,$1)))
$(eval DOWNLOAD_DIR:=$(DOWNLOAD)/$(PLATFORM))
$(eval EXTENSION:=$(if $(filter git,$(VERSION)),git,$(suffix $(TARGET))))
$(if $(filter git,$(VERSION)),$(if $(wildcard $(DOWNLOAD_DIR)/$(TARGET)),$(call LOG_MESSAGE,Repo $(TARGET) exists in $(DOWNLOAD_DIR)),$(call o7_CENTER,git_clone_$(TARGET),critical)$(call LOG_MESSAGE,Cloning $(URL))$(call UPDATE_CURRENT_FILE,$(DOWNLOAD_DIR)/$(TARGET))$(GIT) clone "$(URL)" "$(DOWNLOAD_DIR)/$(TARGET)" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$(TARGET).log" 2>&1,) && (cd "$(DOWNLOAD_DIR)/$(TARGET)" && $(GIT) submodule update --init --recursive $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/(TARGET).log" 2>&1,)) && $(MKDIR) "$(SOURCES)/$(TARGET)" && $(CP) -r "$(DOWNLOAD_DIR)/(TARGET)/"/* "$(SOURCES)/(TARGET)/" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/(TARGET).log" 2>&1,) || $(call LOG_ERROR,Failed to clone $(TARGET))$(call STOP_o7)),$(eval MATCHING_FILES:=$(wildcard $(DOWNLOAD_DIR)/$(NAME)-$(VERSION).{tar.gz,tgz,tar.bz2,tbz2,tar.xz,zip,lha}))$(if $(MATCHING_FILES),$(call LOG_MESSAGE,Using $(NAME): $(firstword $(MATCHING_FILES))),$(call o7_CENTER,download_$(TARGET),critical)$(call LOG_MESSAGE,Downloading $(URL) to $(DOWNLOAD_DIR)/(TARGET))$(call UPDATE_CURRENT_FILE,$(DOWNLOAD_DIR)/(TARGET))$(call DOWNLOAD_FILE,$(URL),$(DOWNLOAD_DIR)/(TARGET),$(NAME),$(DOWNLOAD_DIR),$(PLATFORM))$(call STOP_o7)))
endef

define FETCH_SOURCE
$(call LOG_MESSAGE,Fetching $1)
$(MKDIR) "$2"
$(foreach p,$1,$(call PROCESS_URL,$(p)))
$(TOUCH) "$2"
$(call LOG_MESSAGE,Fetched $1)
endef

define RETRY_DOWNLOAD
$(eval CURL_RESULT:=$(shell $(CURL) -L -f -o "$2" "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$3.log" 2>&1,) && echo success || echo fail))
$(if $(filter success,$(CURL_RESULT)),$(eval SUCCESS:=1)$(call LOG_MESSAGE,Downloaded $2),$(call LOG_MESSAGE,Retry $5 failed: $1)$(if $(filter $5,$(RETRIES)),$(call HANDLE_DOWNLOAD_FAILURE),sleep 2))
endef

define DOWNLOAD_FILE
$(eval RETRIES:=3)
$(eval SUCCESS:=0)
$(foreach i,1 2 3,$(if $(SUCCESS),,$(call RETRY_DOWNLOAD,$1,$2,$3,$4,$i)))
$(if $(SUCCESS),,$(eval URL:=$1)$(eval TARGET:=$(notdir $2))$(eval DOWNLOAD_DIR:=$4)$(eval PLATFORM:=$5)$(call HANDLE_DOWNLOAD_FAILURE))
endef

define BUILD_UNPACK
$(call o7_CENTER,unpack_$2,critical)
$(call LOG_MESSAGE,Unpacking $2 to $3)
$(MKDIR) "$3"
cd "$3" && $(eval EXT:=$(suffix $1))$(if $(filter .lha,$(EXT)),$(call UPDATE_CURRENT_FILE,$3/$2/lha.h)$(ARCHIVE_TOOL_LHA) x "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),$(if $(filter .tar.gz .tgz,$(EXT)),$(call UPDATE_CURRENT_FILE,$3/$2/configure)$(GZIP) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),$(if $(filter .tar.bz2 .tbz2,$(EXT)),$(call UPDATE_CURRENT_FILE,$3/$2/configure)$(BZIP2) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),$(if $(filter .tar.xz,$(EXT)),$(call UPDATE_CURRENT_FILE,$3/$2/configure)$(XZ) -d "$1" -c | tar -x $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),$(if $(filter .zip,$(EXT)),$(call UPDATE_CURRENT_FILE,$3/$2/7z.h)$(ARCHIVE_TOOL_7Z) x "$1" $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),$(if $(filter .git,$(EXT)),$(call UPDATE_CURRENT_FILE,$3/$2/README)$(MKDIR) "$2" && $(CP) -r "$1"/* "$2"/ $(if $(filter 0,$(DISPLAY_AS_LOG)),>>"$(LOGS)/$2.log" 2>&1,) || $(call LOG_ERROR,Failed to unpack $1),$(call LOG_ERROR,Bad ext: $(EXT))))))))
$(call STOP_o7)
$(call LOG_MESSAGE,Unpacked $2 to $3)
endef

define CACHE_VERSIONS
$(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(eval URL_$(patsubst VERSIONS[%,%,$(subst ],,$(c))):=$(value $(c))))
endef

define SET_TARGET_VARS
$(foreach t,$(TARGETS),\
	$(eval $(t)_TARGET:=$(if $(filter ppc-amigaos m68k-amigaos,$(t)),$(subst -amigaos,,$(t))-amigaos,$(t))) \
	$(eval $(t)_BUILD:=$(BUILD)/$(t)) \
	$(eval $(t)_DOWNLOAD:=$(DOWNLOAD)/$(t)) \
	$(eval $(t)_PREFIX:=$(if $(PREFIX),$(PREFIX)/$(t),$(BUILD)/install/$(t))) \
	$(eval $(t)_STAMPS:=$(STAMPS)/$(t)) \
	$(eval $(t)_COMPONENTS:=$(sort $(foreach c,$(filter VERSIONS[%],$(.VARIABLES)),$(if $(filter $(t),$(word 5,$(subst =, ,$(value $(c))))),$(patsubst VERSIONS[%,%,$(subst ],,$(c))))))) \
	$(call LOG_MESSAGE,Set target vars for platform: $(t)))
endef

define VALIDATE_COMPONENTS
$(foreach t,$(TARGETS),$(foreach c,$($(t)_COMPONENTS),$(if $(VERSIONS[$(c)]),,$(call LOG_ERROR,No version for '$(c)' in platform/$(t).mk))))
endef

define SET_DEPENDENCIES
$(foreach t,$(TARGETS),$(foreach c,$($(t)_COMPONENTS),$(eval DEPEND_$(t)_$(c):=$(foreach d,$(DEPEND[$c]),$(if $(filter $(d),$($(t)_COMPONENTS)),$(d))))))
endef

define SET_DOWNLOAD_FILES
$(foreach t,$(TARGETS),$(eval $($(t)_DOWNLOAD)/%:|$($(t)_DOWNLOAD)$(call FETCH_SOURCE,$(filter %=$*,$(URLS)),$($(t)_DOWNLOAD))))
endef

define SET_DOWNLOADED_FILES
$(foreach t,$(TARGETS),$(eval $(t)_DOWNLOAD/.downloaded: $(filter $($(t)_DOWNLOAD)/%,$(DOWNLOAD_FILES))|$($(t)_DOWNLOAD)$(TOUCH) $@$(call LOG_MESSAGE,Marked $($(t)_DOWNLOAD) processed)))
endef

define APPLY_BUILD_RULES
$(foreach t,$(TARGETS),$(foreach c,$(filter $(AUTOTOOLS_COMPONENTS),$($(t)_COMPONENTS)),$(eval $(call BUILD_AUTOTOOLS_RULE,$(t),$(c)))))
$(foreach t,$(TARGETS),$(foreach c,$(filter-out $(AUTOTOOLS_COMPONENTS),$($(t)_COMPONENTS)),$(eval $(call BUILD_COMPONENT,$(t),$(c)))))
endef