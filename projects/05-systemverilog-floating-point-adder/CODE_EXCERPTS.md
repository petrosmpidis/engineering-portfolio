[← Project overview](README.md)

# Selected Code Excerpts

SystemVerilog coursework associated with Petros Charalampidis. The complete RTL, testbench and third-party HardFloat reference library are outside this public version.

These are short extracts from the original project, selected for this public
portfolio. Imports, surrounding modules, helper implementations, data and
execution setup are outside the displayed context. The extracts are not
standalone programs. Source paths identify their origin in the complete project.

## Rounding inputs and inexact flag

The normalized mantissa carries guard, round and sticky bits. Their combination records whether information would be discarded during rounding.

Source excerpt: `round_adder.sv`, lines 20–26.

```systemverilog
mant_to_round = norm_mant[26:3];
lsb = norm_mant[3];
guard = norm_mant[2];
round_bit = norm_mant[1];
sticky = norm_mant[0];

inexact_bit = guard | round_bit | sticky;
```

## Checking zero-status consistency

A concurrent assertion checks that a zero-status result has an all-zero exponent. The surrounding module supplies the clock, reset, status and result signals.

Source excerpt: `test_status_z_combinations.sv`, lines 13–18.

```systemverilog
property p_zero_exp;
    @(posedge clk) disable iff (!resetn)
    status[0] |-> (result[30:23] == 8'h00);
endproperty
assert_zero_exp: assert property (p_zero_exp)
    else $error("FAIL [zero]: exponent of z is not 0");
```
