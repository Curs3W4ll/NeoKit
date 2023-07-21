check-install-inotifywait: # Check if the inotifywait command is installed
	@which inotifywait >/dev/null || (echo "Could not find inotifywait command, please install it (part of inotify-tools)" && false)

lint:
	luacheck lua/neokit

watch-lint: check-install-inotifywait # Restart linter everytime the code changes
	@inotifywait -m -r -e close_write --format %e lua/ | \
		while read events; do \
			make lint; \
		done

fmt-check:
	stylua --color always --check .

fmt:
	stylua --color always .

.PHONY: check-install-inotifywait lint watch-lint format-check format
