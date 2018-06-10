# Vagrant makefile
# ----------------
# Right now it only work with libvirt on debian.

# Check if VM is running.
# "The Libvirt domain is not running. Run `vagrant up` to start it."

# NOTE: $(APP_NAME) must be defined in main Makefile.
VAGRANT_STATUS = vagrant status | grep -E '$(APP_NAME).+\srunning'
VAGRANT_EXIST  = vagrant status | grep -E '$(APP_NAME).+\snot\screated'

.PHONY: user
user: # Force user creation first.

	@$(VAGRANT_EXIST) \
	&& (vagrant $(APP_NAME) up --no-provision &> /dev/null | true) \
	&& vagrant ssh -c \
		'id -u $(APP_NAME) > /dev/null 2>&1 \
		|| (sudo useradd $(APP_NAME) \
				--user-group \
				--groups users \
				--home-dir $(APP_DIR) \
				--shell /bin/bash \
			&& sudo cp -au /etc/skel/. "$(APP_DIR)" \
			&& sudo chown -R "$(APP_NAME)": "$(APP_DIR)")' \
	&& vagrant halt ||:

.PHONY: start
start: user # Start VM.

	@$(VAGRANT_STATUS) || vagrant up

.PHONY: stop
stop: # Stop VM.

	@$(VAGRANT_STATUS) && vagrant halt &> /dev/null ||:

# TODO: Update plugin list...
.PHONY: install
install: # Install vagrant.

	@which vagrant &> /dev/null \
	|| (echo -e "$(GREEN)--- Adding vagrant unofficial .deb repository ---" \
		&& sudo bash -c \
			'echo deb http://vagrant-deb.linestarve.com/ any main > \
			/etc/apt/sources.list.d/wolfgang42-vagrant.list' \
		&& sudo apt-key adv \
				--keyserver pgp.mit.edu \
				--recv-key AD319E0F7CFFA38B4D9F6E55CE3F3DE92099F7A4 \
		&& sudo apt-get update -qq \
		&& echo -e "$(GREEN)--- Installing vagrant ---" \
		&& sudo apt-get install vagrant -yq \
		&& echo -e "$(GREEN)--- Installing necessary vagrant plugins ---" \
		&& vagrant plugin install \
				vagrant-hostmanager \
				vagrant-timezone \
				vagrant-triggers \
				vagrant-libvirt \
				vagrant-scp \
		&& echo -e "$(GREEN)--- Adding vagrant bash completion ---" \
		&& sudo wget https://goo.gl/k3Ca8d \
			-O /etc/bash_completion.d/vagrant)

.PHONY: in
in: start # Connet to VM as app user.

	@vagrant ssh -c "$(SUDO_APP)" ||:

.PHONY: clean
clean: stop # Destroy the VM.

	@vagrant destroy -f

.PHONY: reset
reset: clean start # Recreate the VM.

.PHONY: vhelp
vhelp: # Show vagrantfile help.

	@awk \
		'/^##/ \
		{ \
			gsub(/^##/, "",$$0); \
			gsub(/^\s/, "",$$0); \
			printf "%s\n", $$0 \
		}' Vagrantfile
