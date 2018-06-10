# Python tools makefile
# ---------------------

PYENV_ROOT 		= $$HOME/.pyenv
PYENV_INSTALLER	= ./bin/pyenv-installer.sh
PYTHON_VERSION = $$(cat .python-version)

PY ?= $${$PY:-"3.6.4"}

.PHONY: install-pyenv
install-pyenv: # Install python version manager.

	@which pyenv \
	|| (echo "--- Installing Pyenv ---" \
		&& sudo apt-get install -y \
			libssl-dev \
			zlib1g-dev \
			libbz2-dev \
			libreadline-dev \
			libsqlite3-dev \
			wget \
			curl \
			llvm \
			libncurses5-dev \
			libncursesw5-dev \
			xz-utils \
			tk-dev \
		&& PYENV_ROOT=$(PYENV_ROOT) bash $(PYENV_INSTALLER) \
		&& echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> $$HOME/.bashrc \
		&& echo 'eval "$(pyenv init -)"' >> $$HOME/.bashrc \
		&& echo 'eval "$(pyenv virtualenv-init -)"' >> $$HOME/.bashrc \
		&& source $$HOME/.bashrc)

.PHONY: update-pyenv
update-pyenv: install-pyenv # Update pyenv to get latest versions.

	@cd $(PYENV_ROOT) && git pull


.PHONY: python
python: update-pyenv # Install python as PY=3.5.2(default to 3.6.4 or from .python-version).

	@pyenv install -s "$(PY)"