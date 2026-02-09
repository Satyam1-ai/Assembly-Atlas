
section .data
  array dq 1,2,3,4,5,6,7,8,9
  len dq 9
section .text
  global _start

_start:
  mov rcx, 0 
  mov rbx, array
loop_one:
  mov rax, [rbx+rcx*8]
  add rax, 48
  push rax
  
  inc rcx
  cmp rcx,[len]
  jne loop_one
  
  
xor rcx, rcx
mov rcx, [len]
  
loop_next:
  mov rax, 1 ;Telling the CPU you wanna write something
  mov rdi, 1 ;Writing onto the standard output indicated by the destination index
  mov rsi, rsp ;Writing onto the source iNdex
  mov rdx, 1 ;1 byte to be written
  push rcx
  syscall
  pop rcx
  add rsp, 8
  dec rcx
  jnz loop_next
  
  
finish:
  mov rax, 60
  xor rdi, rdi
  syscall
