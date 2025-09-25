const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const port = process.env.PORT || 8000;


var maxRandom = 10;

app.use(bodyParser.json());

app.post("/test/maximum", function(req, res) {
  if ( req.body
       && req.body.hasOwnProperty("maximum")
       && Number.isInteger(req.body.maximum)
       && 0 < req.body.maximum ) {
    maxRandom = req.body.maximum;
    console.log("server: setting maximum to", maxRandom);
    res.setHeader("Content-Type", "text/plain");
    res.send(`server... ok, setting maximum: ${maxRandom}\n`);
  }
  else {
    res.status(400).send("bad request (invalid maximum value)\n");
  }
});

app.get("/test/maximum", function(req, res) {
  console.log("server: getting maximum", maxRandom);
  res.setHeader("Content-Type", "application/json");
  response = { maximum: maxRandom };
  res.send(JSON.stringify(response));
});

app.get("/test/random", function(req, res) {
  if (maxRandom <= 0) {
    res.status(400).send("bad request (maximum not set)\n");
  }
  else {
    var r = Math.floor(Math.random() * maxRandom);
    console.log("server... sending random:", r);
    res.setHeader("Content-Type", "application/json");
    res.send(JSON.stringify(r) + "\n");
  }
});

app.use(express.static('./static'));

var stack = [];
const EMPTY_STACK_ERROR = "Error: Stack is empty";

// Helper function for responding to requests
function respond(res, status, message, isJsonResponse = false) {
  if (status !== 200) {
    res.status(status).send(message);
  } else {
    res.setHeader("Content-Type", isJsonResponse ? "application/json" : "text/plain");
    res.send(isJsonResponse ? JSON.stringify(message) : message);
  }
}

// Route to push values onto the stack
app.post("/push", function(req, res) {
  const values = req.body?.values;

  if (Array.isArray(values)) {
    stack = stack.concat(values); // Add values to the stack
    respond(res, 200, `Values pushed: ${values}`);
  } else {
    respond(res, 400, "Bad Request: Invalid or missing 'values'");
  }
});

// Route to get the current stack length
app.get("/length", function(req, res) {
  respond(res, 200, stack.length, true);
});

// Route to view the top value of the stack
app.get("/peek", function(req, res) {
  if (stack.length === 0) {
    respond(res, 400, EMPTY_STACK_ERROR);
  } else {
    respond(res, 200, stack[stack.length - 1], true);
  }
});

// Route to pop the top value from the stack
app.get("/pop", function(req, res) {
  if (stack.length === 0) {
    respond(res, 400, EMPTY_STACK_ERROR);
  } else {
    const poppedValue = stack.pop();
    respond(res, 200, poppedValue, true);
  }
});

// Route to add the top two values on the stack
app.get("/add", function(req, res) {
  if (stack.length < 2) {
    respond(res, 400, EMPTY_STACK_ERROR); // Check if there are at least two values to add
  } else {
    const a = stack.pop();
    const b = stack.pop();
    stack.push(b + a);
    respond(res, 200, "", true);
  }
});

// Route to subtract the top value from the second-to-top value on the stack
app.get("/subtract", function(req, res) {
  if (stack.length < 2) {
    respond(res, 400, EMPTY_STACK_ERROR);
  } else {
    const a = stack.pop();
    const b = stack.pop();
    stack.push(b - a);
    respond(res, 200, "", true); // Respond with success
  }
});

// Route to multiply the top two values on the stack
app.get("/multiply", function(req, res) {
  if (stack.length < 2) {
    respond(res, 400, EMPTY_STACK_ERROR);
  } else {
    const a = stack.pop();
    const b = stack.pop();
    stack.push(b * a);
    respond(res, 200, "", true); // Respond with success
  }
});

// Route to divide the second-to-top value by the top value on the stack
app.get("/divide", function(req, res) {
  if (stack.length < 2) {
    respond(res, 400, EMPTY_STACK_ERROR); // Check if there are at least two values to divide
  } else {
    const a = stack.pop();
    const b = stack.pop();
    if (a === 0) {
      respond(res, 400, "Bad Request: Cannot divide by zero"); // Handle division by zero
    } else {
      stack.push(b / a);
      respond(res, 200, "", true); // Respond with success
    }
  }
});


app.post("/*", function(req, res) { res.status(404).send("not found\n"); });
app.get("/*", function(req, res) { res.status(404).send("not found\n"); });

app.listen(port, function() {
  console.log("listening on port", port, "...");
});

module.exports = app
