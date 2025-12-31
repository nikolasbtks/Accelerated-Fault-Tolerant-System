# Accelerated Fault Tolerant System

## Overview

This project demonstrates an open-source, fault-tolerant acceleration systems designed for reliable high-performance computation of FPGA platforms. The systems implements a pipelined architecture combining error detection, correction mechanisms and redundacy, optimized for parallel execution. The design targets the **Xilinx Zynq Ultrascale+ ZCU104 FPGA**, leveraging its programmable logic to implement a scalable fault-tolerant computation pipeline.

## System Architecture

The system is organized as a pipelined, fault-tolerant architecture combining redundancy and error correction mechanism. Mote specifically, the systems accepts two 7 bits numerical inputs and a 3 bits encoded operation, and produces the result of the operation as output. This system consists of two modules, TMR and ECC, each of which is responsible for a specific function.

### Triple Modular Redundanct (TMR) Module

The `TMR module` is responsible for receiving the system input. It consists of `three identical ALUs`, each of which performs the same operation on the same input values in parallel. The three ALUs receive identical data, but from seperate registers, in order to achieve fault independence.

The output of all three ALUs are then forwared to the Voter module, which applies majority voting to determine the correct result. The selected output is forwared to the `ECC module` for further processing.

### Error-Correcting Code (ECC) Module

The `ECC module` receives the result which is produced by the Voter and then encodes it into a `13-bit Extended Hamming code` through the `Encoder module`. This encoded result is stored in BRAM via the `MemoryBlock module`. 

During read operations, the `Decoder module` detects and corrects single-bit errors and forwards the corrected data to the system output. If multi-bit errors are detected by the logic and treated as uncorretable.

In parallel, a background `Scrubber module` scans memory contents and rewrites corrected codewords. 

When a multi-bit error is detected, it is treated as uncorrectable and the corresponding output is forced to zero.

<img width="4313" height="1438" alt="Blank diagram" src="https://github.com/user-attachments/assets/f88b2d79-fdc8-40bd-9ad2-7d86d7d55ebc" />

## Timing, Power and Resources

The design was implemented with a target clock period of `1.550 ns`, corresponding to an operating frequency of approximately `645 MHz`.
  - `Worst Negative Slack (WNS):` +0.184 ns
  - `Worst Hold Slack (WHS):` +0.019 ns
    
The positive slack values indicate that both setup and hold timing constaints are satisfied.

The total on-chip power consumption is:
  - `Total Power`: 0.647 W
    - `Dynamic Power`: 0.055 W  (9%)
    - `Static Power`: 0.592 W (91%)
   
The power profile is dominated by static power, which is typical for modern FPGA architectures.

The design occupies a very small fraction of the available FPGA resources, leaving plenty headroom for future expansion

| Resource        | Usage       | Estimated Percentages        |
|----------------|-------------------|----------------|
|     LUTs     |     182     |     0,08 %     |
| Flip-Flops (FFs)   |     228     |     0,05 %     |
| BRAM  | 0.5 |  0,16 % |

## Design Considerations

This project is `actively under development and testing`. While functional validation and timing closure have been achieved, additional verification is still ongoing.

The current design is implemented entirely withing the `Programmable Logic (PL)` of the Zynq UltraScale+ device. All mechanisms are handled internally without direct interaction with the Processing System (PS).

If this design is to be integrated with the `Processing System (PS)`, special care must be taked due to clock domain differences between PS and PL. Since both of them typically operate on asychronous clocks, direct data exchange must be under decoupling memory or buffering mechanish such as:
  - Asychronous FIFO
  - Dual-port BRAM

## Setup

Below you can find a short guide on how to set up your system:
  
1. Open **Vivado 2025.1**
2. Create a new project and select **Xilinx Zynq Ultrascale+ ZCU104 FPGA**
3. Download the files from the project and place them into the appropriate projects folders
4. Run **Synthesis** and **Implementation**
5. Test the testbenches using **post-implementation functional timing simulation**

#### Note
If you find any bugs or issues, feel free to report them.
