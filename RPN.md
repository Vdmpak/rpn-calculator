## API

This is a node/express-based RPN calculator.

You must add the following HTTP endpoints.

```
POST /push

data (JSON encoded):
  {
    "values": [ 2, 89, 4, 329, 17 ]
  }

Explanation:
  Each value is pushed onto the stack in turn.

  Values are pushed from left to right (so, in the example, 2 is pushed first
  and 17 is pushed last.

Note:
  This is a simplification.  It simply means that the entire list can be
  concatenated onto the stack.

Tip:
  stack = stack.concat(data.values);

  (That's how you implement /push.)
```

```
GET /length

result (JSON encoded):
  "5"

Explanation:
  Return the length of the stack.  (There are currently five elements on the stack.)

Tip:
  res.send(JSON.stringify(stack.length))
```

```
GET /peek

result (JSON encoded):
  "329"

Explanation:
  The value 329 is at the top of the stack, so it is  returned as the result of the
  GET request.  The stack is *unchanged*.
```

```
GET /pop

result (JSON encoded):
  "17"

Explanation:
  The value 17 is at the top of the stack, so it is *removed* from the stack and
  returned as the result of the GET request.

Tip:
  res.send(JSON.stringify(stack.pop()))

  (But you had better check first that the array/stack isn't empty.)
```

```
GET /add

result:
  ""

Explanation:
  The two elements at the top of the stack are removed and the result of adding them
  together is pushed onto the stack.

Example:
  before: 674, 20, 5
  after: 674, 25
```

```
GET /subtract

result:
  ""

Explanation:
  The two elements at the top of the stack are removed and the result of subtracting
  them is pushed onto the stack.

Example:
  before: 674, 20, 5
  after: 674, 15
```

```
GET /multiply

result:
  ""

Explanation:
  The two elements at the top of the stack are removed and the result of multiplying
  them together is pushed onto the stack.

Example:
  before: 674, 20, 5
  after: 674, 100
```

```
GET /divide

result:
  ""

Explanation:
  The two elements at the top of the stack are removed and the result of dividing them
  is pushed onto the stack.

  Division should be integer division, with floating-point results rounded down to the
  nearest integer.

Example:
  before: 674, 20, 5
  after: 674, 4
```

## Errors

In the case of errors (e.g. insufficient arguments on the stack, or invalid
arguments), an HTTP response of 400 (bad request) should be returned.

Otherwise, an HTTP response 200 (ok) should be returned.
