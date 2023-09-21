# Default target
.DEFAULT_GOAL := all

# ============================
# ===     OS Detection     ===
# ============================
.OS_WINDOWS = Windows
.OS_MACOS = MacOS
.OS_LINUX = Linux
.OS_UNKNOWN = Unknown
.CURRENT_OS = $(.OS_UNKNOWN)
ifeq ($(OS),Windows_NT)
	.CURRENT_OS = $(.OS_WINDOWS)
else
	.UNAME_S := $(shell uname -s)
	ifeq ($(.UNAME_S),Linux)
		.CURRENT_OS = $(.OS_LINUX)
	endif
	ifeq ($(.UNAME_S),Darwin)
		.CURRENT_OS = $(.OS_MACOS)
	endif
endif

.PHONY: check-install-inotifywait
.check-install-inotifywait: # Check if the inotifywait command is installed
	@which inotifywait >/dev/null || (echo "Could not find inotifywait command, please install it (part of inotify-tools)" && false)

.PHONY: .check-install-fswatch
.check-install-fswatch: # Check if the fswatch command is installed
	@which fswatch >/dev/null || (echo "Could not find fswatch command, please install it" && false)

.PHONY: lint
lint: # Run linter
	luacheck lua/neokit
	luacheck tests/*_spec.lua

.PHONY: .watch-lint-linux
.watch-lint-linux: .check-install-inotifywait
	@inotifywait -m -r -e close_write --format %e lua/ tests/ | \
		while read events; do \
			make lint; \
		done

.PHONY: .watch-lint-macos
.watch-lint-macos: .check-install-fswatch
	@fswatch -b -r --event=Updated lua/ tests/ | \
		while read; do \
			make lint; \
		done

.PHONY: watch-lint
watch-lint: # Launch linter scan everytime the code is updated
ifeq ($(.CURRENT_OS),$(.OS_MACOS))
	@make --no-print-directory .watch-lint-macos
else ifeq ($(.CURRENT_OS),$(.OS_LINUX))
	@make --no-print-directory .watch-lint-linux
endif

.PHONY: fmt-check
fmt-check: # Check if code format is up to date
	stylua --color always --check .

.PHONY: fmt
fmt: # Run code format
	stylua --color always .

.PHONY: doc
doc: # Generate new version of the code documentation (public/)
	ldoc .

.PHONY: test
test: # Run tests on the project
	nvim --version
	nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/$(TEST_FILE) { minimal_init = 'tests/minimal_init.lua', sequential = true }" || (echo "Tests failed" && false)
	@echo "Tests successful"

.PHONY: .watch-test-linux
.watch-test-linux: .check-install-inotifywait
	@inotifywait -m -r -e close_write --format %e lua/ tests/ | \
		while read events; do \
			make test; \
		done

.PHONY: .watch-test-macos
.watch-test-macos: .check-install-fswatch
	@fswatch -b -r --event=Updated lua/ tests/ | \
		while read; do \
			make test; \
		done

.PHONY: watch-test
watch-test: # Launch unit tests everytime the code is updated
ifeq ($(.CURRENT_OS),$(.OS_MACOS))
	@make --no-print-directory .watch-test-macos
else ifeq ($(.CURRENT_OS),$(.OS_LINUX))
	@make --no-print-directory .watch-test-linux
endif

.PHONY: help
help: # Print help on Makefile
	@grep '^[^.#]\+:\s\+.*#' Makefile | sed "s/\(.*\):\s*\( *\)\(.*\) #\s*\(.*\)/`printf "\033[93m"`\1`printf "\033[0m"`\t\4 [\3]/" | expand -t20
