.PHONY: check-install-inotifywait
check-install-inotifywait: # Check if the inotifywait command is installed
	@which inotifywait >/dev/null || (echo "Could not find inotifywait command, please install it (part of inotify-tools)" && false)

.PHONY: lint
lint: # Run linter
	luacheck lua/neokit
	luacheck tests/*_spec.lua

.PHONY: watch-lint
watch-lint: check-install-inotifywait # Automatically start linter when code is updated
	@inotifywait -m -r -e close_write --format %e lua/ tests/ | \
		while read events; do \
			make lint; \
		done

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

.PHONY: watch-test
watch-test: check-install-inotifywait # Automatically start tests when code is updated
	@inotifywait -m -r -e close_write --format %e lua/ tests/ | \
		while read events; do \
			make test; \
		done

.PHONY: help
help: # Print help on Makefile
	@grep '^[^.#]\+:\s\+.*#' Makefile | sed "s/\(.*\):\s*\( *\)\(.*\) #\s*\(.*\)/`printf "\033[93m"`\1`printf "\033[0m"`\t\4 [\3]/" | expand -t20
