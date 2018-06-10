# Git makefile
# ------------

HOOK_DIR = ./git-hooks

GIT_FLOW_INSTALLER = ./bin/gitflow-installer.sh
GIT_FLOW_TMP_DIR   = /tmp/gitflow

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
	
.PHONY: flow
flow: # Install and activate git flow avh edition: https://goo.gl/MywkLQ.

	@echo "--- Installing git flow AVH version ---" \
    && sudo REPO_NAME=$(GIT_FLOW_TMP_DIR) \
        bash $(GIT_FLOW_INSTALLER) install stable \
    && sudo rm -rf $(GIT_FLOW_TMP_DIR) \
    && echo "--- Activating git flow with default configuration ---" \
    && git flow init -fd \
    && echo -e "--- Git flow enabled ---"
