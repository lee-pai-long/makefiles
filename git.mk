# Git makefile
# ------------

# Git.
HOOK_DIR = ./git-hooks

.PHONY: helphook
helphook: # Show hooks help.

	@awk \
		'/^##/ \
		{ \
			gsub(/^##/, "",$$0); \
			gsub(/^\s/, "",$$0); \
			printf "%s\n", $$0 \
		}' $(HOOK_DIR)/*

.PHONY: rmhook
rmhook: # Delete hooks.

	@find .git/hooks -type l -exec rm {} \;

.PHONY: hook
hook: rmhook # Create hooks.

	@for f in $$(find $(HOOK_DIR) -type f ! -name "_*" -exec basename {} \;); do \
		chmod +x $(HOOK_DIR)/$$f; \
		ln -sf ../../$(HOOK_DIR)/$$f .git/hooks/$${f%.*}; \
	done

.PHONY: arch
arch: # Create artifact.

	@git archive HEAD | gzip > $(ARTIFACT) \
	&& echo "archive create: '$(ARTIFACT)'"