NAME = civil_number

.PHONY: all build release

all: build

build:
	/bin/bash -c "source /usr/local/rvm/scripts/rvm && gem build *.gemspec"

release:
	sudo /usr/sbin/push-gem *.gem
