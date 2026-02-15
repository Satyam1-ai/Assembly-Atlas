# Modern Linux Syscall Workflow (The Fast Path)

This document outlines the high-performance system call mechanism in modern 64-bit Linux, moving away from legacy interrupts (`int 0x80`) to the `syscall` instruction.

## 1. The Architectural Problem

In User Mode (Ring 3), the CPU uses a User Stack. When jumping to Kernel Mode (Ring 0), the kernel cannot safely use the user's stack. It needs its own Kernel Stack immediately. However, the `syscall` instruction is "lazy" and does not automatically switch the Stack Pointer (RSP).

## 2. Hardware "Prime" (The Setup)

Before any syscalls occur, the kernel initializes specific Model Specific Registers (MSRs):

| Register            | Name                     | Purpose                                              |
|---------------------|--------------------------|------------------------------------------------------|
| MSR_LSTAR           | Long System Target Address | Stores the address of the kernel entry point (`entry_SYSCALL_64`) |
| MSR_KERNEL_GS_BASE  | Hidden GS Base           | Stores the address of the Per-CPU Data Area (The "Cheat Sheet") |
| MSR_STAR            | System Call Target       | Stores the target Code/Stack segment selectors       |

## 3. The Workflow Pipeline

### Phase A: The User-to-Kernel Jump

- **Instruction**: User program executes `syscall`.
- **State Saving**: CPU copies current Instruction Pointer (RIP) → RCX and Flags (RFLAGS) → R11.
- **The Jump**: CPU loads RIP from MSR_LSTAR. We are now in Kernel code, but still on the User Stack.

### Phase B: The swapgs Magic

Since we are in Ring 0 but have no stack, we cannot push or call.

- **The Flip**: Kernel executes `swapgs`.
- **The Result**: The "Hidden" GS base (pointing to the Per-CPU area) is swapped into the active GS register.
- **The Grab**: The kernel reads the current task's Kernel Stack address from the Per-CPU area and moves it into RSP.

### Phase C: Saving the Context

The kernel creates a `pt_regs` structure on the new stack. It manually pushes the "Big 5" registers required to return home:

| Order | Register | Description                              |
|-------|----------|------------------------------------------|
| 1     | SS       | User Stack Segment                       |
| 2     | RSP      | User Stack Pointer (saved from earlier)  |
| 3     | R11      | User RFLAGS (saved by hardware)          |
| 4     | CS       | User Code Segment                        |
| 5     | RCX      | User Return Address (RIP saved by hardware) |

## 4. Visual Flowchart

```mermaid
graph TD
    A[User Space: syscall instruction] -->|Hardware| B(CPU Jumps to MSR_LSTAR)
    B --> C{State: Ring 0, but User Stack}
    C --> D[swapgs: Flip GS to Per-CPU Area]
    D --> E[Load Kernel RSP from GS Cheat Sheet]
    E --> F[Push pt_regs: Save RCX, R11, etc. to Stack]
    F --> G[Execute System Call Logic]
    G --> H[Pop pt_regs: Restore State]
    H --> I[swapgs: Flip GS back to User]
    I --> J[sysret: Jump back to User Space]
