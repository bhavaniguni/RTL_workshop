# Day 2: Timing Libraries, Synthesis Approaches, and Efficient Flip-Flop Coding

## Overview

Day 2 of the RTL Workshop focuses on three important concepts in digital VLSI design:

- Understanding SKY130 timing libraries (.lib files)
- Comparing Hierarchical and Flattened synthesis
- Efficient coding styles for D Flip-Flops

---


# Timing Libraries

## What is a Timing Library?

A Liberty (.lib) file contains:

- Standard Cell Information
- Timing Data
- Power Data
- Area Information
- Process Corner Information

Synthesis tools use these libraries to convert RTL code into technology-specific gates.

---

## SKY130 PDK Overview

The SKY130 PDK is an open-source 130nm CMOS Process Design Kit developed by SkyWater Technology and Google.

It provides:

- Standard Cell Libraries
- SPICE Models
- Timing Libraries
- Physical Design Data

These resources enable complete ASIC design using open-source tools.

---

## Understanding sky130_fd_sc_hd__tt_025C_1v80.lib

| Parameter | Meaning |
|------------|----------|
| tt | Typical Process Corner |
| 025C | Temperature = 25°C |
| 1v80 | Supply Voltage = 1.8V |

This library models circuit behavior at:

- Typical Manufacturing Conditions
- 25°C Temperature
- 1.8V Supply Voltage

---

## Opening the Liberty File

### Install gedit

```bash
sudo apt install gedit
```

### Open the Library

```bash
gedit sky130_fd_sc_hd__tt_025C_1v80.lib
```

### Output

<img width="1920" height="922" alt="files" src="https://github.com/user-attachments/assets/089b8254-2f8e-45c9-a093-e9dc2dd49bbb" />

---

# Hierarchical vs Flattened Synthesis

## Hierarchical Synthesis

### Definition

Hierarchical synthesis preserves the RTL module hierarchy during synthesis.

### Advantages

- Faster synthesis for large designs
- Easier debugging
- Better design readability
- Maintains modular structure

### Disadvantages

- Limited cross-module optimization
- Slightly larger area possible


### Output

<img width="1920" height="922" alt="hierarchical" src="https://github.com/user-attachments/assets/c3975c4b-a0e3-4484-8cc0-ae1bf6c930be" />


---

## Flattened Synthesis

### Definition

Flattened synthesis removes all module hierarchy and creates a single unified design.

### Advantages

- Better optimization
- Reduced logic duplication
- Potentially smaller area

### Disadvantages

- Harder debugging
- Increased runtime
- Loss of hierarchy information


### Output

<img width="1920" height="922" alt="flatten png" src="https://github.com/user-attachments/assets/00ab611c-6e1f-4941-8d0c-641a025fb5a0" />


---
 ### Sub Module
  sub module is preferred when we have multiple instances of same module.
 It's like Divide & conquer approach, let's say design is massive instead of giving entire thing we give such module

  <img width="1920" height="922" alt="submodule" src="https://github.com/user-attachments/assets/01befc14-81c7-427f-804c-e9eb8857329d" />

## Comparison

| Feature | Hierarchical | Flattened |
|----------|-------------|------------|
| Hierarchy | Preserved | Removed |
| Optimization | Module Level | Whole Design |
| Runtime | Faster | Slower |
| Debugging | Easier | Difficult |
| Area | Slightly Larger | Potentially Smaller |

---

# Flip-Flops

If i have continuous combinational circuits, the output will get glitch due to their(combinational circuits) propagation delay. To avoid these glitchs flipflops are used. 
Flip-Flops are sequential storage elements that store one bit of information.

# Applications:

### Data Storage

Stores binary information.

### Registers

Registers are constructed using multiple flip-flops.

### Finite State Machines

Used for state storage in FSMs.

### Pipelines

Used extensively in processors and DSP architectures.

### Synchronization

Synchronizes signals with the system clock.

Without flip-flops, digital systems cannot remember previous states.

---

# D Flip-Flop Coding Styles

---

# 1. Asynchronous Reset D Flip-Flop

## RTL Code

```verilog
module dff_asyncres(
input clk,
input async_reset,
input d,
output reg q
);

always @(posedge clk,posedge async_reset)
begin
    if(async_reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule
```

### Explanation

- Reset acts immediately.
- Does not wait for clock edge.
- Output becomes 0 whenever reset is asserted.

---

## Simulation

### Compile

```bash
iverilog dff_asyncres.v tb_dff_asyncres.v
```

### Run

```bash
./a.out
```

### View Waveform

```bash
gtkwave tb_dff_asyncres.vcd
```

### GTKWave Output

<img width="1920" height="922" alt="asyncres" src="https://github.com/user-attachments/assets/57f1281f-5a88-4953-8a9c-bcfa941e6fcc" />


---

# 2. Asynchronous Set D Flip-Flop

## RTL Code

```verilog
module dff_async_set(
input clk,
input async_set,
input d,
output reg q
);

always @(posedge clk,posedge async_set)
begin
    if(async_set)
        q <= 1'b1;
    else
        q <= d;
end

endmodule
```

### Explanation

- Set acts immediately.
- Does not wait for clock.
- Output becomes 1 whenever set is asserted.

---

## Simulation

### Compile

```bash
iverilog dff_async_set.v tb_dff_async_set.v
```

### Run

```bash
./a.out
```

### View Waveform

```bash
gtkwave tb_dff_async_set.vcd
```

### GTKWave Output

<img width="1920" height="922" alt="dff_async_set" src="https://github.com/user-attachments/assets/b0c35e21-1733-4ad6-b447-360514ef4df3" />


---

# 3. Synchronous Reset D Flip-Flop

## RTL Code

```verilog
module dff_syncres(
input clk,
input sync_reset,
input d,
output reg q
);

always @(posedge clk)
begin
    if(sync_reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule
```

### Explanation

- Reset works only on clock edge.
- Output changes on positive edge of clock.
- Commonly used in synchronous digital systems.

---

## Simulation

### Compile

```bash
iverilog dff_syncres.v tb_dff_syncres.v
```

### Run

```bash
./a.out
```

### View Waveform

```bash
gtkwave tb_dff_syncres.vcd
```

### GTKWave Output

<img width="1920" height="922" alt="dff_syncres" src="https://github.com/user-attachments/assets/de45d6c3-29f7-48d5-8eaa-c2da145d738e" />


---

# Synthesis Using Yosys

## Launch Yosys

```bash
yosys
```

## Read Liberty Library

```tcl
read_liberty -lib ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

## Read Verilog Design

```tcl
read_verilog dff_asyncres.v
```

## Synthesize

```tcl
synth -top dff_asyncres
```

## Map Flip-Flops

```tcl
dfflibmap -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

## Technology Mapping

```tcl
abc -liberty ../lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

## View Netlist

```tcl
show
```

### Output

<img width="1920" height="922" alt="synth_dff_async_set" src="https://github.com/user-attachments/assets/1ba5cc3a-2bc7-476c-93ac-89f29221a55a" />

---
<img width="1920" height="922" alt="synth_dff_asyncres" src="https://github.com/user-attachments/assets/17ec5c46-4dbc-44ec-8f63-5b73dcd6ecc5" />

---

<img width="1920" height="922" alt="synth_dff_syncres" src="https://github.com/user-attachments/assets/a5a5e832-276e-47c3-8183-45a8d6a98d79" />




## Async Reset vs Sync Reset

| Feature | Async Reset | Sync Reset |
|----------|------------|------------|
| Clock Required | No | Yes |
| Response | Immediate | On Clock Edge |
| Speed | Faster Reset Action | Depends on Clock |
| Common Usage | Control Logic | Datapath Logic |

### Observation

When reset is asserted:

- Async Reset changes output immediately.
- Sync Reset waits until next clock edge.


# Special Case Optimizations in RTL Synthesis

## Overview

During synthesis, certain arithmetic operations can be optimized into simpler hardware. Multiplication by powers of 2 is implemented as a left-shift operation, eliminating the need for dedicated multiplier hardware and reducing area.

---

## Special Case 1: Multiplication by 2

### RTL Code

```verilog
module mult_2 (
    input [2:0] a,
    output [3:0] y
);

assign y = a * 2;

endmodule
```

### Optimization

Multiplication by 2 is equivalent to shifting left by 1 bit.

```text
y = a << 1
```

### Bit Mapping

```text
a = a[2] a[1] a[0]

y = a[2] a[1] a[0] 0
```

A zero is appended at the Least Significant Bit (LSB).

### Truth Table

| a[2:0] | y[3:0] |
|---------|---------|
| 000 | 0000 |
| 001 | 0010 |
| 010 | 0100 |
| 011 | 0110 |
| 100 | 1000 |
| 101 | 1010 |
| 110 | 1100 |
| 111 | 1110 |

### Hardware Realization

```text
y[3] = a[2]
y[2] = a[1]
y[1] = a[0]
y[0] = 1'b0
```

No multiplier hardware is required.

### Netlist

<img width="1920" height="922" alt="specialcase1" src="https://github.com/user-attachments/assets/06c0d0bd-b220-40d8-9f14-728970484d76" />


---

## Special Case 1a: Multiplication by 4

Multiplication by 4 is equivalent to shifting left by 2 bits.

```text
y = a << 2
```

### Example

```text
a = 0101 (5)

a × 4 = 10100 (20)
```

Two zeros are appended at the LSB.

---

## Special Case 1b: Multiplication by 8

Multiplication by 8 is equivalent to shifting left by 3 bits.

```text
y = a << 3
```

### Example

```text
a = 0101 (5)

a × 8 = 101000 (40)
```

Three zeros are appended at the LSB.

---

## Special Case 2: Multiplication by 9

### RTL Expression

```verilog
assign y = a * 9;
```

### Mathematical Simplification

```text
9 = 8 + 1
```

Therefore,

```text
a × 9 = a × (8 + 1)

      = (a × 8) + (a × 1)

      = (a << 3) + a
```


### Advantages

- Eliminates dedicated multiplier hardware
- Uses simple wiring and one adder
- Reduces area
- Improves timing performance
- Generates an efficient synthesized netlist


## Synthesis Observation

Constant multiplications by powers of two are automatically converted into shift operations during synthesis.

```text
a × 2  → a << 1
a × 4  → a << 2
a × 8  → a << 3
a × 16 → a << 4
```

This optimization significantly reduces hardware complexity and area.

---

## Results


### Synthesized Netlist

<img width="1920" height="922" alt="specialcase2" src="https://github.com/user-attachments/assets/7470f391-e3be-440f-922e-634bbc8fef96" />



Synthesis tools recognize constant multiplications and optimize them into efficient shift-and-add implementations. Multiplication by powers of two requires only wire connections, while multiplication by constants such as 9 can be implemented using shift and add operations. These optimizations reduce hardware area and improve overall design efficiency.
# Summary

In this lab, we learned:

- SKY130 Timing Libraries
- Process, Voltage and Temperature Corners
- Hierarchical Synthesis
- Flattened Synthesis
- Efficient D Flip-Flop Coding Styles
- GTKWave Simulation Flow
- Yosys Synthesis Flow
- Technology Mapping using SKY130 Standard Cells

These concepts form the foundation of RTL design, simulation, synthesis, and ASIC implementation workflows.
