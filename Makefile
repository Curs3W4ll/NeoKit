lint:
	luacheck lua/neokit

fmt-check:
	stylua --color always --check .

fmt:
	stylua --color always .

.PHONY: lint format-check format
