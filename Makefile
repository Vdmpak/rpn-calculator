# This is a nodejs project.  It depends on a number of node modules.
# First install those modules with the "node-modules" target.
#
# The script "misc/check-for-node_modules.zsh" is just a wrapper around
# "npm install" to quickly check whether we have the

run:
	zsh misc/check-for-node_modules.zsh
	node index.js

# This runs the server, and restarts it whenever you save `index.js`.
#
watch:
	zsh misc/check-for-node_modules.zsh
	nodemon

node-modules:
	zsh misc/check-for-node_modules.zsh

# Perhaps flip the order of these to change the default test target.
#
default_test_target = docker
default_test_target = random
default_test_target = rpn

# Run the default test (above), and catch all of the output (stdout and stderr)
# in less.  "less" is a pager.
#
test:
	$(MAKE) -s $(default_test_target) 2>&1 | less

random:
	zsh misc/check-for-node_modules.zsh
	$(MAKE) -C tests random

rpn:
	zsh misc/check-for-node_modules.zsh
	$(MAKE) -C tests rpn

# This runs an ad hoc, homebrew test written in zsh; it assumes that the server
# is already running.
#
quick:
	zsh tests/quick-api-test.zsh

.PHONY: run node-modules random rpn test quick

# #################################################################
# These targets are for task 3.

up:
	docker compose build
	docker compose up --detach

docker:
	$(MAKE) -C tests docker

down:
	docker compose down -t 1

.PHONY: up docker down
