# Day 3: Combinational and Sequential Optimization

Welcome to Day 3 of the RTL Design and Synthesis Workshop. This day focuses on optimization techniques used during synthesis to improve area, timing, and power of digital circuits.

---

# 1. Constant Propagation

Constant propagation is a synthesis optimization technique in which constant values are substituted directly into the logic during compilation.

By replacing variables with known constant values, synthesis tools can simplify logic and eliminate unnecessary gates.

## Benefits

- Reduced circuit complexity
- Lower area utilization
- Improved timing performance
- Reduced power consumption


# 2. State Optimization

State optimization improves the efficiency of finite state machines (FSMs).

The goal is to reduce hardware requirements while maintaining the same functionality.

## Techniques

### State Reduction

Equivalent states are merged to reduce the total number of states.

### State Encoding

Assign efficient binary codes to states.

### Logic Minimization

Reduce combinational logic associated with next-state and output logic.

### Power Optimization

Clock gating and other techniques reduce switching activity.

---

# 3. Cloning

Cloning is the process of duplicating logic cells or modules to improve timing performance and reduce fanout loading.

## Steps

1. Identify critical timing paths.
2. Duplicate the heavily loaded cell.
3. Redistribute loads between original and cloned cells.
4. Perform placement and routing.
5. Verify timing improvements.


# 4. Retiming

Retiming is an optimization technique that moves flip-flops across combinational logic while preserving circuit functionality.

The objective is to balance path delays and improve maximum operating frequency.

## Steps

### Graph Representation

Represent the design as a directed graph.

### Register Repositioning

Move registers forward or backward through logic.

### Constraint Checking

Ensure functionality and timing requirements remain unchanged.

### Optimization

Reduce clock period and improve performance.


# 5. Labs on Optimization

---

# Lab 1

## Verilog Code

```verilog
module opt_check (
    input a,
    input b,
    output y
);

assign y = a ? b : 0;

endmodule
```

## Explanation

```text
If a = 1 → y = b
If a = 0 → y = 0
```

The logic simplifies to:

```text
y = a & b
```

## Yosys Commands

```tcl
read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_verilog opt_check.v

synth -top opt_check

abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib

opt_clean -purge

show
```

## Output 
<p align="center">
  <img width="1920" height="922" alt="opt_check_lab1" src="https://github.com/user-attachments/assets/c5ec720b-3b23-4152-b1f7-ead87e879878" />

# Lab 2

## Verilog Code

```verilog
module opt_check2 (
    input a,
    input b,
    output y
);

assign y = a ? 1 : b;

endmodule
```

## Explanation

Acts as a 2:1 Multiplexer.

```text
a = 1 → y = 1
a = 0 → y = b
```

Logic simplifies to:

```text
y = a + b
```

## Output

<p align="center">
 <img width="1920" height="922" alt="opt_check2_lab1" src="https://github.com/user-attachments/assets/3ba1943d-50a3-4b8e-a91c-715304d0e53b" />


# Lab 3

## Verilog Code

```verilog
module opt_check3 (
    input a,
    input b,
    output y
);

assign y = a ? 1 : b;

endmodule
```

## Explanation

Another example of optimization using constant propagation.

```text
y = a ? 1 : b
```

Optimized Logic:

```text
y = a + b
```

## Output

<p align="center">
  <img width="1920" height="922" alt="opt_check3_lab2" src="https://github.com/user-attachments/assets/86097e54-84a7-451a-a94c-06b04b4bf4f6" />

# Lab 4

## Verilog Code

```verilog
module opt_check4 (
    input a,
    input b,
    input c,
    output y
);

assign y = a ? (b ? (a & c) : c) : (!c);

endmodule
```

## Explanation

Original logic:

```text
If a = 1
    If b = 1
        y = a & c
    Else
        y = c
Else
    y = !c
```

Since inside the true branch `a = 1`:

```text
a & c = c
```

Therefore:

```text
y = a ? c : !c
```

Final simplified expression:

```text
y = a XNOR c
```

## Output

<p align="center">
  <img width="1920" height="922" alt="opt_check4_lab2" src="https://github.com/user-attachments/assets/ec2f884f-be19-47da-bae7-149281111c87" />

# Lab 5
# Lab: Constant Propagation Optimization using Multiple Modules

This lab demonstrates how synthesis tools optimize logic by propagating constant values through module hierarchies.

---

## Design 1: `multiple_module_opt.v`

### RTL Code

```verilog
module sub_module1(input a, input b, output y);
    assign y = a & b;
endmodule

module sub_module2(input a, input b, output y);
    assign y = a ^ b;
endmodule

module multiple_module_opt(
    input a,
    input b,
    input c,
    input d,
    output y
);

wire n1, n2, n3;

sub_module1 U1 (.a(a),  .b(1'b1), .y(n1));
sub_module2 U2 (.a(n1), .b(1'b0), .y(n2));
sub_module2 U3 (.a(b),  .b(d),    .y(n3));

assign y = c | (b & n1);

endmodule
```
# Output

<img width="1920" height="922" alt="multiple_module_opt_lab2" src="https://github.com/user-attachments/assets/98a09a55-2007-4275-85e6-d30b12ea0e11" />


## Design 2: `multiple_module_opt2.v`

### RTL Code

```verilog
module sub_module(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

module multiple_module_opt2(
    input a,
    input b,
    input c,
    input d,
    output y
);

wire n1, n2, n3;

sub_module U1 (.a(a),  .b(1'b0), .y(n1));
sub_module U2 (.a(b),  .b(c),    .y(n2));
sub_module U3 (.a(n2), .b(d),    .y(n3));
sub_module U4 (.a(n3), .b(n1),   .y(y));

endmodule
```
# Output

<img width="1920" height="922" alt="multiple_module_opt2_lab2" src="https://github.com/user-attachments/assets/069bd625-9342-4b00-ac5a-8d1b4229eb98" />


## Yosys Synthesis Commands

Start Yosys:

```bash
yosys
```

### For Design 1

```yosys
read_verilog multiple_module_opt.v
synth -top multiple_module_opt
flatten
opt_clean -purge
show
```

### For Design 2

```yosys
read_verilog multiple_module_opt2.v
synth -top multiple_module_opt2
flatten
opt_clean -purge
show
```

---

# Lab 6

## Verilog Code

```verilog
module dff_const1 (
    input clk,
    input reset,
    output reg q
);

always @(posedge clk,posedge reset)
begin
    if(reset)
        q <= 1'b0;
    else
        q <= 1'b1;
end

endmodule
```

## Explanation

D Flip-Flop with:

- Asynchronous Reset
- Constant D Input = 1

Behavior:

```text
reset = 1 → q = 0

reset = 0
On next clock edge → q = 1
```

## Output(Simulation & Synthesis)

<p align="center">

<img width="1920" height="922" alt="gtkwave_dff_const1" src="https://github.com/user-attachments/assets/35a98a4b-fb8e-43cc-937b-c0b5f3deef26" />


---
  <img width="1920" height="922" alt="dff_const1_netlist" src="https://github.com/user-attachments/assets/c2851320-f7ac-4301-9a74-caacb453add5" />

---

# Lab 7

## Verilog Code

```verilog
module dff_const2 (
    input clk,
    input reset,
    output reg q
);

always @(posedge clk,posedge reset)
begin
    if(reset)
        q <= 1'b1;
    else
        q <= 1'b1;
end

endmodule
```

## Explanation

Regardless of clock or reset:

```text
q = 1
```

The synthesizer recognizes that the output is permanently tied high and removes the flip-flop.

Optimized Result:

```text
assign q = 1'b1;
```

## Output(Simulation & Synthesis)

<p align="center">
---
  <img width="1920" height="922" alt="gtkwave dff_const2" src="https://github.com/user-attachments/assets/7ad8b7a4-eeec-4b6e-92f6-cec851a2a10d" />

---
<img width="1920" height="922" alt="dff_const2_netlist" src="https://github.com/user-attachments/assets/b32c9b11-dbb6-4098-9597-9327f48e3a0d" />


# Lab 8


# Summary

Day 3 introduced important optimization techniques used in RTL synthesis.





