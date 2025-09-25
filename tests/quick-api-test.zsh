#!/usr/bin/env zsh

# ************
# This assumes that the server is already running and listening on port 8000.
# ************

cat <<EOF

***************************************************

Make sure that the server is running on port 8000 before running these tests.

***************************************************

First running some tests on the /test/random API...

EOF

set -e

url="http://localhost:8000"

get () {
  local pathname=$argv[1]
  local full_url="$url$pathname"
  print ">>>" "GET" $full_url
  wget --timeout 2 -O - -q $full_url | jq .
}

post () {
  local pathname=$argv[1]
  local full_url="$url$pathname"
  print ">>>" POST $full_url
  curl --max-time 2 -H "Content-Type: application/json" -d $argv[2] -X "POST" $full_url
}

# Test the /test (random) API.
#
get "/test/maximum"
post "/test/maximum" '{"maximum": 20}'
get "/test/maximum"
get "/test/random"
get "/test/random"
get "/test/random"

# Test the RPN API.
#

cat <<EOF

***************************************************

Now running some tests on the /rpn API...

EOF

post "/push" '{"values": [150, 46, 3, 9, 3]}'

fail () {
  print "***** that test failed!" >&2
  exit 1
}

print
print "test initial stack, expecting 3 at top..."
get "/peek"
get "/peek" | grep -w -q 3 || fail

print
print "test add, expecting 12 at top..."
get "/add"
get "/peek"
get "/peek" | grep -w -q 12 || fail

print
print "test multiply, expecting 36 at top..."
get "/multiply"
get "/peek"
get "/peek" | grep -w -q 36 || fail

print
print "test subtract, expecting 10 at top..."
get "/subtract"
get "/peek"
get "/peek" | grep -w -q 10 || fail

print
print "test divide, expecting 15 at top..."
get "/divide"
get "/peek"
get "/peek" | grep -w -q 15 || fail

print
print "test pop, expecting 15 at top..."
get "/pop" | grep -w 15 || fail
