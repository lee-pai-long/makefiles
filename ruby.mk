# Ruby tools makefile
# -------------------

RVM_REPO = https://raw.githubusercontent.com/rvm/rvm/master/binscripts/
# Workaround for issue: https://goo.gl/tsjkRi
RUBY_VERSION = $$(cat .ruby-version)

.PHONY: rvm
rvm: # Install Ruby version manager.

	@which rvm &> /dev/null \
	|| (echo -e "--- Adding RVM(mpapis) public key ---" \
		&& gpg --keyserver hkp://keys.gnupg.net \
			--recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 \
						7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
		&& echo -e '--- Downloading RVM installer ---' \
		&& cd /tmp/ \
		&& curl -O $(RVM_REPO)/rvm-installer \
		&& curl -O $(RVM_REPO)/rvm-installer.asc \
		&& gpg --verify rvm-installer.asc \
		&& bash rvm-installer stable --auto-dotfiles)

.PHONY: ruby
ruby: rvm # Install ruby.

	@rvm install $(RUBY_VERSION) \
	&& rvm use $(RUBY_VERSION) \
	&& gem install bundler \
	&& bundle install
