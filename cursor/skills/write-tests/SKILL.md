---
name: write-tests
description: Write high-quality tests with required pre-writing analysis of logic, inputs, invariants, and failure modes.
disable-model-invocation: true
---

# Write Tests

## Required Pre-Writing Analysis

Before writing tests, answer:

1. What is the core logic or algorithm?
2. What are the inputs and outputs, including edge/boundary/invalid cases?
3. What invariants must always hold?
4. What failure modes are realistic (bad data, misuse, race conditions)?

## Test Rules

- Test behavior, not implementation details.
- Minimize mocking; mock only true external dependencies.
- Avoid tautological tests (mock X, assert X with no logic in between).
- Exercise real branches and error paths.
- Use concrete, realistic data.
- Name tests with clear hypotheses.

## Verification Checklist

- Could each test fail if corresponding logic were broken?
- Are core decisions being tested, not only wiring?
- Are happy path, edge cases, error conditions, and boundaries covered?
- If mocks were removed, would meaningful logic remain under test?

## Output

1. Present the pre-writing analysis.
2. Add or update tests based on that analysis.
3. Run tests and confirm pass/fail status.
4. Report the verification checklist with conclusions.
