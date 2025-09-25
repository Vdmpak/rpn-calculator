# You shouldn't have to make changes here, other than perhaps changing the default target.
#
# Flip the order of the assignments below to change the default target.
#
default_target = rpn
default_target = random

test:
	@$(MAKE) $(default_target)

# This tests the "random" API by bringing up a local server, running the tests, then stopping
# the server.
#
random:
	../node_modules/.bin/mocha ./random.coffee --exit --bail --require coffeescript/register

# This tests the "rpn" API by bringing up a local server, running the tests, then stopping the
# server.
#
rpn:
	../node_modules/.bin/mocha ./rpn.coffee --exit --bail --require coffeescript/register

# This runs an ad hoc, homebrew test written in zsh; it assumes that the server
# is already running.
#
quick:
	zsh ./quick-api-test.zsh

# This tests the "rpn" API by using an *existing server* on port 8000, possibly a docker container;
# it is used for task 3.
#
docker:
	env DOCKER=yes ../node_modules/.bin/mocha ./rpn.coffee --exit --bail --require coffeescript/register

.PHONY: test random rpn docker quick
