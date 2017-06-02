DEFAULT_GOAL: help

.PHONY: help docs-build docs-serve

# ========= MkDocs ========== #

## Build mkdocs
docs-build:
	@mkdocs build --clean

## Serve mkdocs. Change Port: OPTS=-a 0.0.0.0:9222 make docs-serve
docs-serve: docs-build
	@mkdocs serve ${OPTS}

## Show help screen.
help:
	@echo "Please use \`make <target>' where <target> is one of\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-30s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

