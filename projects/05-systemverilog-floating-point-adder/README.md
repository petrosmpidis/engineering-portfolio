[← Portfolio index](../../README.md)


# Single-Precision Floating-Point Adder in SystemVerilog

**SystemVerilog · Floating-Point Arithmetic · Rounding · Assertions**

Academic coursework associated with Petros Charalampidis implementing
an adder for 32-bit IEEE-754-format inputs and an accompanying
verification setup.

## Design and verification topics

- Exponent comparison and mantissa alignment/arithmetic.
- Normalization and rounding decisions.
- Exception/status processing.
- Randomized and corner-case test stimulus.
- Reference-model comparisons and SystemVerilog Assertions.

The [code excerpts](CODE_EXCERPTS.md) show guard/round/sticky extraction
and one concurrent assertion relating a status bit to the result encoding.

## Numerical scope

The coursework includes simplified handling of exceptional inputs,
including subnormals and NaNs. Its verification setup does not establish
full IEEE-754 conformance.

## Public contents

Only the overview and two short excerpts are included. The full RTL,
testbench, source lists, third-party reference library and report remain
with the complete project. The excerpts depend on surrounding module
signals and are not a standalone simulation target.
