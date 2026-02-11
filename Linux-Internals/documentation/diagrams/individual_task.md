## task_struct Layout (40 bytes total)

| Offset | Size  | Field        | Description                                | Example Value          |
|--------|-------|--------------|--------------------------------------------|------------------------|
| 0      | 8 B   | `TASK_KSTACK`| Kernel stack pointer                       | `0x0000000000000000`   |
| 8      | 4 B   | `STATE`      | Process state (`RUNNING=0`, `BLOCKED=1`, `ZOMBIE=2`) | `0` (`RUNNING`) |
| 12     | 4 B   | `TASK_PID`   | Process ID                                 | `0`                    |
| 16     | 8 B   | `TASK_FILES` | Pointer to file descriptor table           | `0x0000000000000000`   |
| 24     | 8 B   | `TASK_MM`    | Pointer to memory management structure     | `0x0000000000001000`   |
| 32     | 8 B   | `TASK_NEXT`  | Pointer to next `task_struct` (linked list)| `0x0000000000000000` (NULL = end) |
