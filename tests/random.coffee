# You should not make any changes to this file.
#
# This file uses Coffeescript instead if Javascript beause I (SB) just find
# Coffeescript more convenient.

chai = require "chai"
chai.use require "chai-http"
should = chai.should()
assert = chai.assert

server = require "../index"

# Mocha can work either with promises or with callbacks (but not both).
# Some calls below are wrapped with this function to ensure that the
# the promises which chai functions return are discarded (we return null
# instead).
#
noReturnValue = (f) -> f(); null

validateHttp = (err, res) ->
  assert.isNull err
  assert.equal res.status, 200

describe "Test random number API...", ->
  it "should have maximum set to 10 initially", (done) ->
    noReturnValue ->
      chai.request(server)
        .get("/test/maximum")
        .end (err, res) ->
          validateHttp err, res
          assert.isNotNull res.body
          assert.equal res.body.maximum, 10
          done()

  it "should be able to set the maximum to 20", (done) ->
    noReturnValue ->
      chai.request(server)
        .post("/test/maximum")
        .send({ maximum: 20 })
        .end (err, res) ->
          validateHttp err, res
          done()

  it "should have maximum set to 20 now", (done) ->
    noReturnValue ->
      chai.request(server)
        .get("/test/maximum")
        .end (err, res) ->
          validateHttp err, res
          assert.isNotNull res.body
          assert.equal res.body.maximum, 20
          done()


  # Next, we generate a sequence of tests to ensure that the random numbers which
  # are returned are indeed in the intended range.

  runRandomNumberTest = (done, maximum) ->
    noReturnValue ->
      chai.request(server)
        .get("/test/random")
        .end (err, res) ->
          validateHttp err, res
          assert.isNotNull res.body
          assert.operator 0, "<=", res.body
          assert.operator res.body, "<", maximum
          done()

  for max in [20, 5]
    do (max) ->
      it "should be able to set the maximum to #{max}", (done) ->
        noReturnValue ->
          chai.request(server)
            .post("/test/maximum")
            .send({ maximum: max })
            .end (err, res) ->
              validateHttp err, res
              done()

      for i in [0...20]
        it "should return random numbers in range 0 <= r < #{max} (test ##{i})", (done) ->
          runRandomNumberTest done, max

