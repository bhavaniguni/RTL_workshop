# Day 4: Gate-Level Simulation (GLS), Blocking vs Non-Blocking Assignments, and Synthesis-Simulation Mismatch

Welcome to **Day 4** of the RTL Design Workshop!

Today’s session focuses on understanding how synthesized hardware behaves compared to RTL simulation and learning the correct coding styles for combinational and sequential logic in Verilog.

---


# 1. Introduction

During RTL design, simulation verifies the functionality of Verilog code.

However, after synthesis, the RTL is converted into logic gates. The synthesized circuit may behave differently if coding guidelines are not followed correctly.

Day 4 covers:

✅ Verification after synthesis using Gate-Level Simulation

✅ Understanding synthesis-simulation mismatches

✅ Correct usage of blocking and non-blocking assignments

---

# 2. Gate-Level Simulation (GLS)

Gate-Level Simulation is the process of simulating the synthesized gate-level netlist instead of the RTL code.

## Why GLS is Important?

- Verifies synthesized netlist functionality
- Detects synthesis-induced issues
- Checks timing behavior
- Validates scan chains and DFT structures
- Identifies setup and hold violations

---

## Types of GLS

### Functional GLS

- No timing delays
- Checks logic correctness only

### Timing GLS

- Uses SDF delay information
- Detects timing violations
- More realistic simulation

---

## Advantages of GLS

- Finds mismatches between RTL and synthesized netlist
- Improves design reliability
- Verifies optimization performed by synthesis tools
- Ensures design works before physical implementation

---

# 3. Synthesis-Simulation Mismatch

A synthesis-simulation mismatch occurs when RTL simulation results differ from synthesized hardware behavior.

## Common Causes

### 1. Incomplete Sensitivity Lists

Bad Example:

```verilog
always @(sel)
```

Correct:

```verilog
always @(*)
```

### 2. Incorrect Assignment Types (Blocking Vs Non - Blocking)

Using blocking assignments in sequential logic may produce unexpected results.

### 3. Latch Inference (Non Standard Verilog Coding)

Missing else branches can infer latches unintentionally.

Example:

```verilog
always @(*) begin
    if(sel)
        y = a;
end
```


## Best Practices

- Use `always @(*)` for combinational logic
- Use non-blocking assignments (`<=`) in sequential logic
- Avoid delays inside synthesizable RTL
- Review synthesis warnings carefully

---

# 4. Blocking vs Non-Blocking Assignments

Verilog provides two procedural assignment operators.

---

## 4.1 Blocking Assignments (=)

### Syntax

```verilog
=
```

### Example

```verilog
always @(*) begin
    a = b;
    c = a;
end
```

### Characteristics

- Immediate execution
- Sequential behavior
- Used in combinational logic
- Suitable for temporary variables

---

## 4.2 Non-Blocking Assignments (<=)

### Syntax

```verilog
<=
```

### Example

```verilog
always @(posedge clk)
begin
    q <= d;
end
```

### Characteristics

- Concurrent update
- Models flip-flops accurately
- Used in sequential logic
- Avoids race conditions

---

## 4.3 Comparison Table

| Feature | Blocking (=) | Non-Blocking (<=) |
|----------|-------------|-------------------|
| Execution | Immediate | Scheduled |
| Behavior | Sequential | Parallel |
| Used For | Combinational Logic | Sequential Logic |
| Hardware Inference | Gates | Flip-Flops |
| Race Conditions | Possible | Reduced |
| Typical Block | always @(*) | always @(posedge clk) |

---

## Rule of Thumb

```text
Combinational Logic  → Blocking (=)

Sequential Logic     → Non-Blocking (<=)
```

---

# 5. Labs

---

## Lab 1: Ternary Operator MUX

### Verilog Code

```verilog
module ternary_operator_mux (
input i0,
input i1,
input sel,
output y
);

assign y = sel ? i1 : i0;

endmodule
```

### Truth Table

| sel | y |
|------|---|
| 0 | i0 |
| 1 | i1 |

### Output

<img width="1920" height="922" alt="gtkwave_ternary_operator_mux" src="https://github.com/user-attachments/assets/771e3c99-4218-4249-b418-963e019b303d" />

---

## Lab 2: Synthesis Using Yosys

Synthesize the above MUX using Yosys.
Follow the standard Yosys synthesis flow.

### Output

<img width="1920" height="922" alt="netlist_ternary_operator_mux" src="https://github.com/user-attachments/assets/5fd7255c-974d-457b-b96a-01c00b000390" />

---

## Lab 3: Gate-Level Simulation (GLS)

### Compile

```bash
iverilog /path/to/primitives.v /path/to/sky130_fd_sc_hd.v ternary_operator_mux_net.v tb_mux.v
```

### Run

```bash
./a.out
```

### View Waveform

```bash
gtkwave tb_ternary_operator_mux.vcd
```

### Output

<img width="1920" height="922" alt="gls_ternary_operator" src="https://github.com/user-attachments/assets/9327bee5-08bd-4fa2-ae3f-e7626594e563" />


---

## Lab 4: Bad MUX Example

### Incorrect RTL

```verilog
module bad_mux(
input i0,
input i1,
input sel,
output reg y
);

always @(sel)
begin
    if(sel)
        y <= i1;
    else
        y <= i0;
end

endmodule
```

### Problems

❌ Incomplete sensitivity list

❌ Non-blocking assignment in combinational logic

### Correct RTL

```verilog
always @(*) begin
    if(sel)
        y = i1;
    else
        y = i0;
end
```

### Output

<img width="1920" height="922" alt="gtkwave bad_mux" src="https://github.com/user-attachments/assets/b9f45fa2-c48f-4689-89d7-a49480c1ae20" />

---

## Lab 5: GLS of Bad MUX

Observe differences between:

- RTL Simulation
- Gate-Level Simulation

Potential issues:

- Incorrect output updates
- Simulation mismatch warnings

### Output

<img width="1920" height="922" alt="gls_bad_mux" src="https://github.com/user-attachments/assets/60a6c9b4-a759-427e-82c2-2258be624036" />


---

## Lab 6: Blocking Assignment Caveat

### Problematic RTL

```verilog
module blocking_caveat(
input a,
input b,
input c,
output reg d
);

reg x;

always @(*) begin
    d = x & c;
    x = a | b;
end

endmodule
```

### Problem

`d` uses the old value of `x`.

This causes unintended behavior.

### Corrected Version

```verilog
always @(*) begin
    x = a | b;
    d = x & c;
end
```

### Output

<img width="1920" height="922" alt="gtkwave blocking_caveat" src="https://github.com/user-attachments/assets/41d4ad20-7226-4e40-8246-dd191ab96332" />

---

## Lab 7: Synthesis of Blocking Caveat Module

Synthesis the module using proper commands and observe the output

### Output

<img width="1920" height="922" alt="blocking_caveat_netlist" src="https://github.com/user-attachments/assets/454d5c77-e786-4354-b87b-267d5331a3a0" />


---
## Lab 8: GLS of Blocking Caveat Module

<img width="1920" height="922" alt="gls blocking_caveat" src="https://github.com/user-attachments/assets/080ea436-99c9-4fa0-b49e-2b37c5fbcfd4" />


---


# 8. Summary

✔ Learned Gate-Level Simulation (GLS)

✔ Understood functional and timing GLS

✔ Studied synthesis-simulation mismatches

✔ Learned proper usage of blocking and non-blocking assignments

✔ Performed synthesis and GLS experiments

✔ Explored common RTL coding mistakes and their fixes

---

## Key Takeaway

> Always verify both RTL and synthesized netlist behavior. Correct coding practices prevent synthesis-simulation mismatches and ensure reliable hardware implementation.
