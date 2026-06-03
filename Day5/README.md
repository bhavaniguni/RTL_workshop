# Day 5: Optimization in Synthesis

Welcome to **Day 5** of the RTL Design and Synthesis Workshop!

In this session, we explore how coding style affects synthesis results. We will learn about **if-else statements**, **case statements**, **for loops**, and **generate blocks**, while understanding how incomplete coding can lead to **inferred latches**. Through practical labs, we will analyze RTL and synthesized netlists to observe optimization techniques used by synthesis tools.

---

## 🎯 Learning Objectives

By the end of this session, you will be able to:

- Understand synthesis optimization techniques.
- Write efficient combinational logic using if-else and case statements.
- Identify and prevent inferred latches.
- Use for loops in synthesizable Verilog designs.
- Implement scalable hardware using generate blocks.
- Design an 8-bit Ripple Carry Adder (RCA).
- Compare RTL behavior with synthesized hardware.

---


# 1️⃣ Introduction to Synthesis Optimization

Synthesis optimization is the process of converting RTL code into efficient gate-level hardware while minimizing:

- Area
- Delay
- Power Consumption

The quality of synthesized hardware heavily depends on the RTL coding style. Poor coding practices can result in:

- Unnecessary logic
- Increased area
- Timing issues
- Latch inference
- Simulation-Synthesis mismatch

---

# 2️⃣ If-Else Statements in Verilog

If-else statements are used for conditional execution within procedural blocks.

## Syntax

```verilog
if(condition)
    statement1;
else
    statement2;
```

## Example

```verilog
always @(*) begin
    if(sel)
        y = a;
    else
        y = b;
end
```

### Nested If-Else

```verilog
always @(*) begin
    if(a)
        y = i0;
    else if(b)
        y = i1;
    else
        y = i2;
end
```

# 3️⃣ Inferred Latches

A latch is inferred when a signal is not assigned in every possible execution path of a combinational block.

## Example

```verilog
always @(*) begin
    if(sel)
        y = a;
end
```

### Why Does This Infer a Latch?

When `sel = 0`, the output `y` is not assigned a new value. Therefore, the hardware must remember the previous value of `y`, requiring storage.

```text
Incomplete Assignment
        ↓
Output Retains Previous Value
        ↓
Latch Inferred
```

### Avoiding Latches

Always assign outputs in all conditions:

```verilog
always @(*) begin
    if(sel)
        y = a;
    else
        y = b;
end
```

---

# 4️⃣ Complete vs Incomplete Coding Styles

## Incomplete Style

```verilog
always @(*) begin
    if(sel)
        y = a;
end
```

## Complete Style

```verilog
always @(*) begin
    if(sel)
        y = a;
    else
        y = b;
end
```

### Rule

✅ Every output must be assigned in every possible execution path.

---

# 5️⃣ Labs on If-Else and Case Statements

## Lab 1: Incomplete If Statement

```verilog
module incomp_if (
    input i0,
    input i1,
    input i2,
    output reg y
);

always @(*) begin
    if(i0)
        y <= i1;
end

endmodule
```

### RTL Output

<img width="1920" height="922" alt="gtkwave incomp_if" src="https://github.com/user-attachments/assets/4f1f2797-a29d-42c3-92fb-fe3321967abf" />

---

## Lab 2: Synthesis Result of Lab 1

<img width="1920" height="922" alt="netlist incomp_if" src="https://github.com/user-attachments/assets/3ef5161e-fd03-4013-8b3c-09f5e18b5c9b" />

**Observation:**
- Latch inferred
- Output retains previous state

---

## Lab 3: Nested If-Else

```verilog
module incomp_if2 (
    input i0,
    input i1,
    input i2,
    input i3,
    output reg y
);

always @(*) begin
    if(i0)
        y <= i1;
    else if(i2)
        y <= i3;
end

endmodule
```

### RTL Output

<img width="1920" height="922" alt="gtkwave incomp_if2" src="https://github.com/user-attachments/assets/4c33010d-ff2e-4c5d-b377-17a795cbadd0" />

---

## Lab 4: Synthesis Result of Lab 3

<img width="1920" height="922" alt="netlist_incomp_if2" src="https://github.com/user-attachments/assets/bb48c947-f008-4060-a48c-00b959b7f31b" />

**Observation:**
- Missing assignment path
- Latch inferred

---

## Lab 5: Complete Case Statement

```verilog
module comp_case(
    input i0,
    input i1,
    input i2,
    input [1:0] sel,
    output reg y
);

always @(*) begin
    case(sel)
        2'b00 : y = i0;
        2'b01 : y = i1;
        default : y = i2;
    endcase
end

endmodule
```

### RTL Output

<img width="1920" height="922" alt="gtkwave comp_case" src="https://github.com/user-attachments/assets/669c06a0-7ea8-4e0e-9c4e-db10dc9a2fa0" />


---

## Lab 6: Synthesis Result of Lab 5

<img width="1920" height="922" alt="netlist comp_case" src="https://github.com/user-attachments/assets/387fb445-70ab-4a39-b599-9fb043a9b28b" />

**Observation:**
- No latch inferred
- Pure combinational logic

---

## Lab 7: Incomplete Case Handling

```verilog
case(sel)
    2'b00 : y = i0;
    2'b01 : y = i1;
    2'b10 : y = i2;
endcase
```

### RTL Output

<img width="1920" height="922" alt="gtkwave incomp_case" src="https://github.com/user-attachments/assets/4321b79b-95b0-4520-a8bd-1d40f330c412" />


**Observation:**
- Missing case branch
- Possible latch inference

---

### Synthesis Report

<img width="1920" height="922" alt="netlist incomp_case" src="https://github.com/user-attachments/assets/2b9868fa-27a3-44cc-bfc0-e7e5cc601d37" />

---

## Lab 8: Partial Assignments in Case

<img width="1920" height="922" alt="netlist partial_case_assign" src="https://github.com/user-attachments/assets/e8a73d46-37a4-473b-80a3-8b9a26c38753" />

**Observation:**
- Partial assignments can infer latches
- Every output must be assigned in every branch

---

# 6️⃣ For Loops in Verilog

For loops allow repetitive hardware generation and reduce coding effort.

## Syntax

```verilog
for(initialization; condition; increment)
begin
    statements;
end
```

## Features

- Used inside procedural blocks
- Synthesizable when iteration count is fixed
- Generates replicated hardware

## Example: 4-to-1 Multiplexer

```verilog
integer i;

always @(*) begin
    y = 0;

    for(i=0;i<4;i=i+1)
    begin
        if(i == sel)
            y = data[i];
    end
end
```

---

# 7️⃣ Generate Blocks in Verilog

Generate blocks create hardware structures during elaboration.

## Syntax

```verilog
genvar i;

generate
    for(i=0;i<4;i=i+1)
    begin : gen_loop
        // Hardware Instances
    end
endgenerate
```

## Applications

- Adder Arrays
- Multipliers
- Memory Structures
- Parameterized Designs

---

# 8️⃣ Ripple Carry Adder (RCA)

A Ripple Carry Adder is formed by cascading multiple Full Adders.

```text
FA0 → FA1 → FA2 → FA3 → ... → FAn
```

Each carry output is connected to the carry input of the next stage.

### Advantages

- Simple design
- Easy implementation

### Disadvantages

- Carry propagation delay increases with bit width

---

# 9️⃣ Labs on Loops and Generate Blocks

## Lab 9: 4-to-1 MUX Using For Loop


<img width="1920" height="922" alt="netlist mux_generate" src="https://github.com/user-attachments/assets/18447003-26ae-4642-92fb-a8e17df3ca6b" />

---

<img width="1920" height="922" alt="gtkwave mux_generate" src="https://github.com/user-attachments/assets/10ba3fa5-292a-4847-9181-590ffb08867f" />


---

## Lab 10: 8-to-1 DEMUX Using Case Statement

<img width="1920" height="922" alt="gtkwave demux_case" src="https://github.com/user-attachments/assets/d5ae3837-5e0b-45af-a3b2-182c381298ac" />


---

## Lab 11: 8-to-1 DEMUX Using For Loop

<img width="1920" height="922" alt="gtkwave demux_generate" src="https://github.com/user-attachments/assets/ac8bf792-0293-419c-a2bc-d9204462bf73" />

---

## Lab 12: 8-bit Ripple Carry Adder Using Generate Block

### Full Adder

```verilog
module fa(
    input a,
    input b,
    input c,
    output co,
    output sum
);

assign {co,sum} = a+b+c;

endmodule
```

### RCA Design

```verilog
genvar i;

generate
for(i=1;i<8;i=i+1)
begin
    fa u_fa(
        .a(num1[i]),
        .b(num2[i]),
        .c(int_co[i-1]),
        .co(int_co[i]),
        .sum(int_sum[i])
    );
end
endgenerate
```

### RTL Output

<img width="1920" height="922" alt="gtkwave rca" src="https://github.com/user-attachments/assets/4b2199fd-729c-4265-a486-1bee564b8446" />

---

# 🔧 Simulation and Synthesis Commands

## Simulation

```bash
iverilog design.v testbench.v
./a.out
gtkwave dump.vcd
```

## Synthesis Using Yosys

```bash
yosys
```

```yosys
read_liberty -lib ../my_lib/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_verilog design.v

synth -top <top_module>

abc -liberty ../my_lib/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

show
```

---

# ✅ Best Coding Practices

- Use `always @(*)` for combinational logic.
- Assign outputs in all possible paths.
- Include default cases whenever possible.
- Avoid latch inference.
- Use generate blocks for scalable designs.
- Verify RTL before synthesis.
- Compare RTL and synthesized netlists regularly.
- Write clean and readable code.

---

# 📌 Key Takeaways

- Incomplete assignments cause latch inference.
- Complete case and if-else statements prevent unintended memory elements.
- For loops simplify repetitive hardware descriptions.
- Generate blocks enable scalable and reusable designs.
- Ripple Carry Adders demonstrate hierarchical hardware generation.
- Coding style directly impacts synthesis quality and performance.

---

# 🎯 Conclusion

Day 5 focused on synthesis-aware Verilog coding practices. We explored latch inference, complete and incomplete combinational logic, loops, generate blocks, and hierarchical design using Ripple Carry Adders. Understanding these concepts is essential for creating efficient, synthesizable, and scalable RTL designs used in modern digital systems.

