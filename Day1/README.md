# RTL Design and Synthesis - Day 1

## Introduction

This day focused on understanding:

- RTL Design
- Simulation flow
- Testbench concepts
- Icarus Verilog (iverilog)
- GTKWave
- Yosys synthesis flow
- Standard cell libraries
- Timing concepts
- Faster vs slower cells
- Setup and hold concepts

---

# Simulator

RTL design is verified by simulating the design and checking whether it satisfies the required specifications.

- Simulator used: **Icarus Verilog (iverilog)**

## Notes

- Simulator monitors input signal changes
- Output is evaluated whenever inputs change
- No input change → No output change

---

# Design and Testbench

## Design

The design contains Verilog RTL code implementing the required functionality.

## Testbench

Testbench is the setup to apply stimulus to the design to check it's functionality.

---

# Design and Testbench Setup

<img width="1515" height="852" alt="image" src="https://github.com/user-attachments/assets/5a17b0d8-7f72-41b3-bbdd-a8def3a12675" />



# Iverilog Based Simulation Flow

<img width="1419" height="771" alt="image" src="https://github.com/user-attachments/assets/e39fc5bf-d967-4cfa-a454-5f0e78afdfdd" />


# Simulation Commands

```bash
iverilog good_mux.v tb_good_mux.v
./a.out
gtkwave tb_good_mux.vcd
```

---

##  Lab: Simulating a 2-to-1 Multiplexer

Let’s simulate a simple 2-to-1 multiplexer using **iverilog** and visualize the waveform using **GTKWave**.

---

### Step 1: Clone the Workshop Repository

```bash
git clone https://github.com/kunalg123/sky130RTLDesignAndSynthesisWorkshop.git
```

Move into the Verilog files directory:

```bash
cd sky130RTLDesignAndSynthesisWorkshop/verilog_files
```

---

### Step 2: Install Required Tools

Install Icarus Verilog:

```bash
sudo apt install iverilog
```

Install GTKWave:

```bash
sudo apt install gtkwave
```

---

### Step 3: Simulate the Design

Compile the design and testbench:

```bash
iverilog good_mux.v tb_good_mux.v
```

Run the simulation:

```bash
./a.out
```

View the waveform:

```bash
gtkwave tb_good_mux.vcd
```

---

## GTKWave Output

<img width="1920" height="922" alt="good_mux gtkwave" src="https://github.com/user-attachments/assets/e7ff832c-d9b1-4212-8265-f9f874d22853" />


#  Verilog Code Analysis

The RTL code for the multiplexer (`good_mux.v`) is shown below:

```verilog
module good_mux (
    input i0,
    input i1,
    input sel,
    output reg y
);

always @ (*)
begin
    if(sel)
        y <= i1;
    else
        y <= i0;
end

endmodule
```

---

## How the Multiplexer Works

### Inputs

- `i0` → Input 0
- `i1` → Input 1
- `sel` → Select signal

### Output

- `y` → Multiplexer output

---

## Working Principle

- When `sel = 0`, output `y` gets input `i0`
- When `sel = 1`, output `y` gets input `i1`

This behavior represents a standard **2-to-1 Multiplexer**.

---

## Truth Table

| sel | Output y |
|-----|-----------|
| 0   | i0        |
| 1   | i1        |

---

## Simulation Observation

The GTKWave waveform confirms that:

- Output follows `i0` when `sel = 0`
- Output follows `i1` when `sel = 1`

Hence, the RTL design functions correctly.





# Introduction to Yosys

Yosys is an open-source synthesis tool used for converting RTL Verilog designs into gate-level netlists. It is widely used in digital VLSI design flows for RTL synthesis, optimization, and formal verification.

Yosys takes RTL Verilog code along with standard cell libraries (.lib) as input and generates an optimized synthesized netlist.

---

## Features of Yosys

- Open-source RTL synthesis framework
- Supports Verilog HDL
- Converts RTL design into gate-level netlist
- Performs logic optimization
- Generates technology-mapped netlists
- Supports formal verification flows
- Compatible with Sky130 standard cell libraries
- Easy integration with open-source EDA tools
- Supports ASIC and FPGA synthesis flows

---
## Yosys Synthesis Flow

1. Read RTL Verilog design
2. Read standard cell library (.lib)
3. Perform synthesis and optimization
4. Map logic to available standard cells
5. Generate synthesized netlist



## Basic Yosys Commands

yosys

## Standard Cell Libraries

A standard cell library (`.lib`) contains different versions of logic gates such as AND, OR, NAND, NOR, and NOT gates. These different versions are called **gate flavors**.

Different gate flavors are optimized for:

- **Performance** → Faster gates for critical paths
- **Power** → Low-power gates for energy-efficient designs
- **Area** → Smaller gates to reduce chip size
- **Drive Strength** → Stronger gates to drive larger loads
- **Signal Integrity** → Better noise and reliability performance

During synthesis, tools like **Yosys** select the most suitable gate flavor based on timing, power, and area requirements.

# Synthesis Lab with Yosys

Let’s synthesize the `good_mux` design using Yosys!

---

# Step-by-Step Yosys Flow

## Start Yosys

```bash
yosys
```

---

## Read the liberty library

```bash
read_liberty -lib lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

---

## Read the Verilog code

```bash
read_verilog verilog_files/good_mux.v
```

---

## Synthesize the design

```bash
synth -top good_mux
```

---

## Technology mapping

```bash
abc -liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib
```

---

## Generate synthesized netlist

```bash
write_verilog good_mux_netlist.v
```

---

## Visualize the gate-level netlist

```bash
show
```

---







# Netlist output

<img width="1920" height="922" alt="good_mux netlist" src="https://github.com/user-attachments/assets/416b71fe-818e-48e2-9a36-94c2c076684a" />


---


# Conclusion

In Day 1 of the RTL Design and Synthesis workshop, the complete RTL-to-synthesis flow was successfully implemented using open-source EDA tools. The `good_mux` Verilog design was simulated using Icarus Verilog, and the waveform outputs were analyzed using GTKWave. The RTL design was then synthesized using Yosys with the SKY130 standard cell library. Technology mapping, gate-level netlist generation, and schematic visualization were completed successfully. This lab provided practical exposure to RTL simulation, synthesis flow, and open-source VLSI design methodologies.
