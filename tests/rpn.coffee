# You should not make any changes to this file.
#
# This file uses Coffeescript instead if Javascript beause I (SB) just find
# Coffeescript more convenient.

chai = require "chai"
chai.use require "chai-http"
should = chai.should()
assert = chai.assert

# Set the environment variable DOCKER (see Makefile) to use a server hosted in
# docker for the tests; otherwise launch the server in "../index.js" (the default).
#
if process.env.DOCKER
  server = "http://localhost:8000"
else
  server = require "../index"

# Mocha can work either with promises or with callbacks (but not both).
# Some calls below are wrapped with this function to ensure that the
# the promises which chai functions return are discarded (we return null
# instead).
#
noReturnValue = (f) -> f(); null

validateHttpResponse = (err, res) ->
  assert.isNull err
  assert.equal res.status, 200

simpleIntegerEndpointTest = (path, expected) ->
  it "should suppport #{path} (GET) to retrieve:  #{expected}", (done) ->
    noReturnValue ->
      chai.request(server)
        .get(path)
        .end (err, res) ->
          validateHttpResponse err, res
          assert.isNotNull res.body
          assert.equal res.body, expected
          done()

simpleEmptyEndpointTest = (path) ->
  it "should suppport #{path} (GET) with an empty response", (done) ->
    noReturnValue ->
      chai.request(server)
        .get(path)
        .end (err, res) ->
          validateHttpResponse err, res
          assert.isNotNull res.body
          assert.equal res.body, ""
          done()

describe "Testing RPN API...", ->

  # ######################################################################
  # This tests the /push (POST) endpoint.
  #
  do ->
    for values in [[1], [2, 3]]
      do (values) ->
        it "should suppport /push (POST) to add values to the stack (#{values})", (done) ->
          noReturnValue ->
            chai.request(server)
              .post("/push")
              .send({ values })
              .end (err, res) ->
                validateHttpResponse err, res
                done()

  do ->
    for expected in [3, 2, 1]
      do (expected) ->
        # ######################################################################
        # This tests the /length (GET) endpoint.
        #
        simpleIntegerEndpointTest "/length", expected

        # ######################################################################
        # This tests the /peek (GET) endpoint.
        #
        simpleIntegerEndpointTest "/peek", expected

        # ######################################################################
        # This tests the /pop (GET) endpoint.
        #
        simpleIntegerEndpointTest "/pop", expected

        # ######################################################################
        # The length should now be one less.
        #
        simpleIntegerEndpointTest "/length", expected - 1

  # ######################################################################
  # Next, test the same endpoints again, less systematic values.
  #
  do ->
    values = [1001, 1002, 1003, 1004]
    it "should suppport /push (POST) to add values to the stack (#{values})", (done) ->
      noReturnValue ->
        chai.request(server)
          .post("/push")
          .send({ values })
          .end (err, res) ->
            validateHttpResponse err, res
            done()

    simpleIntegerEndpointTest "/length", 4
    simpleIntegerEndpointTest "/peek", 1004
    simpleIntegerEndpointTest "/pop", 1004

    simpleIntegerEndpointTest "/length", 3
    simpleIntegerEndpointTest "/peek", 1003
    simpleIntegerEndpointTest "/pop", 1003

    simpleIntegerEndpointTest "/length", 2
    simpleIntegerEndpointTest "/peek", 1002
    simpleIntegerEndpointTest "/pop", 1002

    simpleIntegerEndpointTest "/length", 1
    simpleIntegerEndpointTest "/peek", 1001
    simpleIntegerEndpointTest "/pop", 1001

    simpleIntegerEndpointTest "/length", 0

  # ######################################################################
  # Test the /add endpoint.
  #
  do ->
    values = [1001, 1002, 1003, 1004]
    it "should suppport /push (POST) to add values to the stack (#{values})", (done) ->
      noReturnValue ->
        chai.request(server)
          .post("/push")
          .send({ values })
          .end (err, res) ->
            validateHttpResponse err, res
            done()

    simpleEmptyEndpointTest "/add"
    simpleIntegerEndpointTest "/length", 3
    simpleIntegerEndpointTest "/peek", 2007

    simpleEmptyEndpointTest "/add"
    simpleIntegerEndpointTest "/length", 2
    simpleIntegerEndpointTest "/peek", 3009

    simpleEmptyEndpointTest "/add"
    simpleIntegerEndpointTest "/length", 1
    simpleIntegerEndpointTest "/peek", 4010

    simpleIntegerEndpointTest "/pop", 4010
    simpleIntegerEndpointTest "/length", 0

  # ######################################################################
  # Test the /subtract endpoint.
  #
  do ->
    values = [50, 20, 15, 1]
    it "should suppport /push (POST) to add values to the stack (#{values})", (done) ->
      noReturnValue ->
        chai.request(server)
          .post("/push")
          .send({ values })
          .end (err, res) ->
            validateHttpResponse err, res
            done()

    simpleEmptyEndpointTest "/subtract"
    simpleIntegerEndpointTest "/length", 3
    simpleIntegerEndpointTest "/peek", 14

    simpleEmptyEndpointTest "/subtract"
    simpleIntegerEndpointTest "/length", 2
    simpleIntegerEndpointTest "/peek", 6

    simpleEmptyEndpointTest "/subtract"
    simpleIntegerEndpointTest "/length", 1
    simpleIntegerEndpointTest "/peek", 44

    simpleIntegerEndpointTest "/pop", 44
    simpleIntegerEndpointTest "/length", 0

  # ######################################################################
  # Test the /multiply endpoint.
  #
  do ->
    values = [3, 10, 2, 3]
    it "should suppport /push (POST) to add values to the stack (#{values})", (done) ->
      noReturnValue ->
        chai.request(server)
          .post("/push")
          .send({ values })
          .end (err, res) ->
            validateHttpResponse err, res
            done()

    simpleEmptyEndpointTest "/multiply"
    simpleIntegerEndpointTest "/length", 3
    simpleIntegerEndpointTest "/peek", 6

    simpleEmptyEndpointTest "/multiply"
    simpleIntegerEndpointTest "/length", 2
    simpleIntegerEndpointTest "/peek", 60

    simpleEmptyEndpointTest "/multiply"
    simpleIntegerEndpointTest "/length", 1
    simpleIntegerEndpointTest "/peek", 180

    simpleIntegerEndpointTest "/pop", 180
    simpleIntegerEndpointTest "/length", 0

  # ######################################################################
  # Test the /divide endpoint.
  #
  do ->
    values = [420, 100, 35, 7]
    it "should suppport /push (POST) to add values to the stack (#{values})", (done) ->
      noReturnValue ->
        chai.request(server)
          .post("/push")
          .send({ values })
          .end (err, res) ->
            validateHttpResponse err, res
            done()

    simpleEmptyEndpointTest "/divide"
    simpleIntegerEndpointTest "/length", 3
    simpleIntegerEndpointTest "/peek", 5

    simpleEmptyEndpointTest "/divide"
    simpleIntegerEndpointTest "/length", 2
    simpleIntegerEndpointTest "/peek", 20

    simpleEmptyEndpointTest "/divide"
    simpleIntegerEndpointTest "/length", 1
    simpleIntegerEndpointTest "/peek", 21

    simpleIntegerEndpointTest "/pop", 21
    simpleIntegerEndpointTest "/length", 0

