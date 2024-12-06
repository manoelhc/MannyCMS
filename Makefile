export RUBY_VERSION := "3.2.6"
export RAILS_VERSION := "6.1.4.4"
export SPINA_VERSION := "2.6.2"

setup-debian: setup-dev-debian setup-ruby-tools
setup-mac: setup-dev-mac setup-ruby-tools

setup-dev-debian:
	sudo apt-get install -y nodejs autoconf patch build-essential rustc libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libgmp-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev uuid-dev || true
	npm install --global yarn

setup-dev-mac:
	xcode-select --install || true
	brew install openssl@3 readline libyaml gmp autoconf rust "node@20" || true

setup-ruby-tools:
	curl https://mise.run | sh
	sh -c "~/.local/bin/mise activate" >> ~/.zshrc
	sh -c "~/.local/bin/mise activate" >> ~/.bashrc
	sh ~/.bashrc; \
	       mise use --global "ruby@${RUBY_VERSION}"; \
		   gem update --system; \
		   gem install bundler; \
	       gem install rails -v "${RAILS_VERSION}"; \
		   gem install spina -v "${SPINA_VERSION}"; \
		   bundler install

run:
	SPINA_VERSION=${SPINA_VERSION} RAILS_VERSION=${RAILS_VERSION} docker-compose up -d

stop:
	docker-compose down

build: stop
	SPINA_VERSION=${SPINA_VERSION} RAILS_VERSION=${RAILS_VERSION} docker-compose build
