# 🛡️ Low-Level Internals: Segmentation, TSS, and the Kernel Stack

This document summarizes the mechanics of x86 Protected Mode, focusing on how the hardware manages memory, privilege, and the transition between User and Kernel modes.

## 1. Memory Segmentation (The Pre-Paging Era)
In legacy systems, memory was organized into **Segments**. To find a physical address, the CPU used **Selectors** (16-bit) to look up **Descriptors** in the **GDT (Global Descriptor Table)**.

### Register Categorization
| Register | Name | Content / Purpose |
| :--- | :--- | :--- |
| **CS** | Code Segment | Contains the executable instructions. |
| **DS** | Data Segment | Contains the program's data/variables. |
| **SS** | Stack Segment | Contains the User-mode stack. |

**The Address Calculation:**  
`Linear Address = Segment Base (from GDT) + Offset (from General Purpose Register)`

---

## 2. Hardware Optimization: Shadow Registers
To avoid constant memory lookups in the GDT, CPUs use **Shadow Registers**.
*   **Hardwired:** These are built directly into the silicon.
*   **Function:** They cache the descriptor data (Base, Limit, Attribute) so the CPU doesn't have to "drop everything" to check the GDT for every instruction.

---

## 3. Privilege Levels & Security
Privilege is determined by the last 2 bits of the Selector. The hardware enforces security using the **DPL (Descriptor Privilege Level)**.

**The Validation Equation:**
`max(CPL, RPL) <= DPL`

If the Current Privilege Level (CPL) is numerically higher (less privileged) than the DPL, the CPU blocks access. This is how Ring 3 is kept out of Ring 0.

---

## 4. The TSS (Task State Segment)
The TSS has evolved from a "Task Manager" to a "Stack Switcher."

*   **Legacy Systems:** Used to store the entire state of a task. The **Busy Bit** (switching between type 9 and 11) prevented the CPU from entering a recursive loop by trying to call a task that was already running.
*   **Modern Systems:** Modern Kernels (like Linux) use **one TSS entry per CPU**. Its primary job now is to provide the **RSP0** (the pointer to the Kernel Stack).

---

## 5. The Syscall & The Kernel Stack
When a `syscall` or interrupt occurs, the CPU must switch from the **User Stack** to the **Kernel Stack**.

### Why the Switch?
1.  **Trust:** The User Stack could be corrupted or point to invalid memory.
2.  **Security:** The Kernel needs a private workspace that User-land cannot read or write.

### The Atomic Hardware Push
Immediately upon a privilege change, the CPU looks at the **TSS**, grabs the **RSP0**, and automatically pushes these 5 registers onto the Kernel Stack:
1.  **SS** (User Stack Segment)
2.  **RSP** (User Stack Pointer)
3.  **RFLAGS** (Status bits)
4.  **CS** (User Code Segment)
5.  **RIP** (Return Instruction Pointer)

*Note: After this, the Kernel manually pushes other registers (RAX, RBX, etc.) to complete the "Snapshot" of the user's process.*

