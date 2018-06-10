# Python tools makefile
# ---------------------

PYENV_ROOT 		= $$HOME/.pyenv
PYENV_INSTALLER	= ./bin/pyenv-installer.sh
PYTHON_VERSION = $$(cat .python-version)

PY ?= $${$PY:-"3.6.4"}

.PHONY: pyenv
pyenv: # Install python version manager.

	@which pyenv \
	|| (echo -e "$(YELLOW)--- Installing Pyenv ---" \
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

.PHONY: python
python: pyenv # Install python as PY=3.5.2(default to 3.6.4 or from .python-version).

	@pyenv install -s "$(PY)"