[← Project overview](README.md)

# Selected Code Excerpts

Verilog coursework associated with Petros Charalampidis. The public examples focus on ALU arithmetic and register-bank writes. Original module interfaces and course scaffolding are not reproduced in full.

These are short extracts from the original project, selected for this public
portfolio. Imports, surrounding modules, helper implementations, data and
execution setup are outside the displayed context. The extracts are not
standalone programs. Source paths identify their origin in the complete project.

## Signed arithmetic and overflow detection

These branches appear inside the ALU operation-selection case statement. They compute signed addition/subtraction and flag sign-related overflow.

Source excerpt: `Άσκηση 1/alu.v`, lines 41–53.

```verilog
// ADD
ALUOP_ADD : begin
  result = sop1 + sop2;
  ovf = (sop1[31] == sop2[31]) &&
        (result[31] != sop1[31]);
end

// SUB
ALUOP_SUB : begin
  result = sop1 - sop2;
  ovf = (sop1[31] != sop2[31]) &&
        (result[31] != sop1[31]);
end
```

## Register-bank reset and writes

The register bank has an asynchronous active-low reset and two write addresses. The shown block gives the first write priority when both addresses coincide; the read/forwarding logic is outside the excerpt.

Source excerpt: `Άσκηση 3/regfile.v`, lines 25–35.

```verilog
always @(posedge clk or negedge resetn) begin
  if (!resetn) begin
    for( i = 0; i < 16; i = i + 1)
      register[i] <= {DATAWIDTH{1'b0}};
  end
  else if (write) begin
    register[writeReg1] <= writeData1;
    if (writeReg2 != writeReg1)
    register[writeReg2] <= writeData2;
  end
end
```
