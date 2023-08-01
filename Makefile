check-install-inotifywait: # Check if the inotifywait command is installed
	@which inotifywait >/dev/null || (echo "Could not find inotifywait command, please install it (part of inotify-tools)" && false)

lint: # Run linter
	luacheck lua/neokit

watch-lint: check-install-inotifywait # Automatilcayy start linter when code is updated
	@inotifywait -m -r -e close_write --format %e lua/ | \
		while read events; do \
			make lint; \
		done

fmt-check: # Check if code format is up to date
	stylua --color always --check .

fmt: # Run code format
	stylua --color always .

doc: # Generate new version of the code documentation (public/)
	ldoc .

test: # Run tests on the project
	nvim --version
	nvim --headless -u tests/minimal_init.lua -c "PlenaryBustedDirectory tests/$(TEST_FILE) { minimal_init = 'tests/minimal_init.lua', sequential = true }"

watch-test: check-install-inotifywait # Automatically start tests when code is updated
	@inotifywait -m -r -e close_write --format %e lua/ tests/ | \
		while read events; do \
			make test; \
		done

help: # Print help on Makefile
	@grep '^[^.#]\+:\s\+.*#' Makefile | sed "s/\(.*\):\s*\( *\)\(.*\) #\s*\(.*\)/`printf "\033[93m"`\1`printf "\033[0m"`\t\4 [\3]/" | expand -t20

.PHONY: check-install-inotifywait lint watch-lint fmt-check fmt doc test help
