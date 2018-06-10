# Todo makefile
# -------------

# List of code tags to search for.
# TODO: Externalize tags list
TAGS = TODO|FIXME|CHANGED|XXX|REVIEW|BUG|REFACTOR|IDEA|WARNING

.PHONY: todo
todo: # Show todos.

	@find . \
		-type f \
		-not -path "./.git/*" \
		-exec \
			awk '/[ ]($(TODO_TAGS)):/ \
				{ \
					gsub("# ","", $$0); \
					gsub("// ","", $$0); \
                    gsub(/\.\./,"", $$0); \
					gsub(/^[ \t]+/, "", $$0); \
					gsub(/:/, "", $$0); \
					gsub(/\.\//,"", FILENAME); \
					TYPE = $$1; $$1 = ""; \
					MESSAGE = $$0; \
					LINE = NR; \
					printf \
					"$(CYAN)%s|$(WHITE):%s|: $(CYAN)%s$(WHITE)($(BLUE)%s$(WHITE))\n"\
					, TYPE, MESSAGE, FILENAME, LINE \
				}' \
		{} \; | column -s '|' -t

.PHONY: tags
tags: # Show current tags list.

	@echo "$(TAGS)"