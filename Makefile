export RUBY_VERSION := "3.2.6"
export RAILS_VERSION := "6.1.4.4"
export SPINA_VERSION := "2.6.2"

setup-debian: setup-dev-debian setup-ruby-tools
setup-mac: setup-dev-mac setup-ruby-tools

setup-dev-debian:
	sudo apt-get install -y autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev || true

setup-dev-mac:
	xcode-select --install || true
	brew install openssl@3 readline libyaml gmp autoconf rust || true

setup-ruby-tools:
	curl https://mise.run | sh
	sh -c "~/.local/bin/mise activate" >> ~/.zshrc
	sh -c "~/.local/bin/mise activate" >> ~/.bashrc
	sh ~/.bashrc; \
	       mise use --global "ruby@${RUBY_VERSION}"; \
		   gem update --system; \
		   gem install bundler; \
		   bundler install
