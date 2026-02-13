# Write Tests

Write high-quality tests for the specified code. Before writing any test, analyze systematically.

## Pre-Writing Analysis (Required)

Answer these questions before writing tests:

### 1. What is the core logic/algorithm?
Identify the actual computation, transformation, or decision-making the code performs—not the I/O or framework glue around it.

### 2. What are the inputs and outputs?
Map the full input space, including edge cases:
- Empty/null/undefined inputs
- Boundary values (0, 1, -1, MAX_INT, empty string, single character)
- Invalid or malformed inputs
- Inputs at the edges of valid ranges
- Unusual but valid combinations

### 3. What invariants should always hold?
What properties must be true regardless of input?

### 4. What could go wrong?
Think adversarially—how could a user, bad data, or race condition break this?

## Test Writing Rules

### Test behavior, not implementation
If you refactored the internals but kept the same contract, your tests should still pass.

### Minimize mocking
Only mock true external dependencies (databases, APIs, filesystem). Never mock the code under test or its core collaborators. If you need extensive mocking, consider whether you're testing at the wrong level of abstraction.

### No tautological tests
If a test passes by definition (e.g., "mock returns X, assert result is X" with no logic in between), delete it. Every test should be capable of failing if the code has a bug.

### Test the actual logic paths
Trace through conditionals, loops, and error handling. Each branch should have a test that exercises it with realistic data.

### Use concrete, realistic test data
Avoid generic placeholders. Use data that exposes edge cases and makes failures obvious.

### Each test should have a clear hypothesis
Name it descriptively: `rejects_negative_quantities` not `test_validation_3`.

## Verification Checklist

Before finalizing tests, verify:

- [ ] Could each test fail if there were a bug in the corresponding logic?
- [ ] Are you testing the code's actual decisions, or just its wiring?
- [ ] Have you covered: happy path, edge cases, error conditions, boundary values?
- [ ] If you deleted all mocks, what would remain? That's what you're actually testing.

## Output

1. Present the pre-writing analysis
2. Write tests following the rules above
3. Run the tests and ensure they pass
4. Show the verification checklist with your assessment
