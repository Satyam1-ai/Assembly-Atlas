# Real Mode: The 16-Bit Genesis of x86

## 1. Overview
Every modern x86_64 processor begins its life in **Real Mode**. This is a 16-bit operating mode that mimics the original Intel 8086. It is characterized by a 1MB memory limit, no built-in hardware security (no "Rings"), and the lack of virtual memory (no paging).

## 2. Memory Addressing (The Segment:Offset Math)
In Real Mode, registers are 16 bits wide, but the address bus is 20 bits wide (allowing for $2^{20}$ or 1MB of RAM). To bridge this gap, the CPU uses **Segmentation**.

### The Formula
The Physical Address is calculated by shifting the Segment register left by 4 bits (multiplying by 16) and adding the Offset.

**Physical Address = (Segment × 0x10) + Offset**

### Calculation Examples
*   **Example A: Accessing the IVT**
    *   Segment (`CS`): `0x0000`
    *   Offset (`IP`): `0x03FF`
    *   Calculation: `(0x0000 * 0x10) + 0x03FF = 0x003FF`
*   **Example B: The Bootloader Entry Point**
    *   Segment: `0x07C0`
    *   Offset: `0x0000`
    *   Calculation: `(0x07C0 * 0x10) + 0x0000 = 0x07C00`
*   **Example C: Maximum Reachable Address**
    *   Segment: `0xFFFF`
    *   Offset: `0xFFFF`
    *   Calculation: `(0xFFFF0) + 0xFFFF = 0x10FFEF` (This is the "HMA" or High Memory Area).

## 3. The Boot Flow Chart
This Mermaid diagram tracks the CPU from the first spark of power to the transition into Protected Mode.

```mermaid
graph TD
    A[Power On / Reset] --> B[CPU at Reset Vector 0xFFFFFFF0]
    B --> C[JMP to BIOS ROM]
    C --> D[POST: Power-On Self-Test]
    D --> E[BIOS scans Drives for Boot Signature 0xAA55]
    E --> F[BIOS loads Bootloader into 0x7C00]
    F --> G[Execution starts in 16-bit Real Mode]
    G --> H[Bootloader sets up GDT - Global Descriptor Table]
    H --> I[Flip PE Bit in CR0 Register]
    I --> J[LJMP to 32-bit Code Segment]
    J --> K[Protected Mode Enabled]
    K --> L[Optional: Enable Paging via CR0 Bit 31]

# x86 Real Mode Memory Layout and CR0 Register

## 4. Key Memory Locations

| Address Range     | Name      | Description                                      |
|-------------------|-----------|--------------------------------------------------|
| `0x00000`–`0x003FF` | IVT       | Interrupt Vector Table (256 pointers to ISRs)    |
| `0x00400`–`0x004FF` | BDA       | BIOS Data Area (Hardware state/Keyboard buffer)  |
| `0x00500`–`0x07BFF` | Free RAM  | Guaranteed "Scratch" space for the bootloader    |
| `0x07C00`–`0x07DFF` | Bootsector| The 512-byte "Magic Spot" where code starts      |
| `0xA0000`–`0xBFFFF` | VRAM      | Video RAM for text/graphics modes                |
| `0xFFFF0`          | Reset Vector | Where the CPU looks for the first instruction |

## 5. Breaking the Jail: The CR0 Register

To leave Real Mode, software must modify the **CR0** (Control Register 0).

| Bit | Flag | Description                                                                 |
|-----|------|-----------------------------------------------------------------------------|
| 0   | PE   | **Protection Enable**: When set to `1`, the CPU enters Protected Mode (segmentation changes from arithmetic-based to selector-based). |
| 31  | PG   | **Paging Enable**: When set to `1`, the CPU enables the MMU and uses page tables for address translation. |

> **Important Constraint**: Paging (`PG=1`) cannot be enabled without first enabling Protection (`PE=1`). The CPU requires Protected Mode to be active before paging functionality becomes available.
