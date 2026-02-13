# Segmentation Notes (Chapter 2)

*Learning this while reading "Understanding the Linux Kernel" — still on Chapter 2, just getting my head around how x86 segmentation actually works before paging kicks in.*

## What I got wrong at first (and fixed)

I was mixing up a few things when I first read about segment selectors. Here's what I *actually* learned after re-reading and sketching it out:

### Segment selector = 16 bits, but NOT the base address!

This tripped me up: the selector **doesn't contain the base address**. It's just a "key" to look up the real base address in a table (GDT/LDT). Here's the real breakdown:


- **Bits 15–3 (13 bits)** → Index into GDT/LDT  
  *(Example: selector `0x0008` → index = 0x0008 >> 3 = 1 → grabs descriptor #1)*
- **Bit 2 (TI bit)** → Table Indicator (**just 1 bit**, not 2!)  
  `0` = GDT (global), `1` = LDT (local per-process)
- **Bits 1–0 (RPL)** → Requested Privilege Level (not "theater permissions" 😅)  
  `00` = kernel (ring 0), `11` = user space (ring 3)

>  **My mistake**: I thought TI was 2 bits. Nope — it's 1 bit. Total: 13 + 1 + 2 = 16 bits. Duh.

## How the CPU actually gets the base address

1. Program does something like `mov eax, [0x1234]` → needs to read memory
2. CPU checks `DS` register → sees selector value (e.g., `0x0010`)
3. Extracts:
   - Index = `0x0010 >> 3 = 2`
   - TI = bit 2 = `0` → use GDT
4. CPU walks to GDT (address stored in `GDTR` register), grabs descriptor #2
5. **Descriptor** (8 bytes) contains the *real* 32-bit base address + limit + flags
6. Now it can calculate the linear address

## Linear address = base + offset (pre-paging)

Before paging is enabled (early boot), address translation is simple:

Example:
- `DS = 0x0010` → points to GDT entry with base = `0x08048000`
- Instruction: `mov eax, [0x1234]`
- Linear address = `0x08048000 + 0x1234 = 0x08049234`

That linear address goes straight to the bus (if paging is off) or gets fed into the paging unit (if paging is on — but that's Chapter 3 stuff).

## How does the compiler/assembler know code vs data segments?

Good question I asked myself:

- **Assembler** sees directives like `.text`, `.data`, `.bss` and tags instructions/data accordingly
- **Linker** packs them into sections but *doesn't* assign real segment registers yet
- **OS loader** (at runtime) is the one that:
  - Sets up GDT entries for this process
  - Loads selectors into `CS`, `DS`, `SS`, etc.
  - Jumps into user code with correct segments already loaded

So the binary itself doesn't "know" the selector values — the kernel sets them up when launching the program. Makes sense now.

## Linux's dirty secret: flat segmentation

Here's the kicker I found in the book: **Linux barely uses segmentation** on x86.

Instead of giving each process its own segments with different bases/limits, Linux sets up *four flat segments* that all cover the entire 4 GB address space with base=0:

| Segment      | Selector | Base   | Limit | RPL |
|--------------|----------|--------|-------|-----|
| Kernel code  | 0x10     | 0x0000 | 4 GB  | 0   |
| Kernel data  | 0x18     | 0x0000 | 4 GB  | 0   |
| User code    | 0x23     | 0x0000 | 4 GB  | 3   |
| User data    | 0x2b     | 0x0000 | 4 GB  | 3   |

→ So `linear address = 0 + offset = offset`  
→ Segmentation becomes a no-op  
→ Real memory protection happens via **paging** (next chapter)

Why even bother with selectors then? Because x86 *forces* you to use them — you can't disable segmentation. So Linux just makes it harmless and lets paging do the real work.

## My mental model now
[Instruction with offset] ↓ [Segment register (CS/DS/etc) holds selector] ↓ [CPU uses selector → index + TI → fetches descriptor from GDT/LDT] ↓ [Descriptor gives real base address + limit + perms] ↓ [Linear address = base + offset] ↓ [Paging unit (if enabled) translates linear → physical]


Segmentation = first step in address translation. But in Linux, it's basically a formality. Paging is where the magic happens.

---

*Notes taken while working through Chapter 2 of "Understanding the Linux Kernel" (3rd ed.).  
Might be messy — I'm learning as I go. Corrections welcome!*
