section .bss


section .data
  a dq 10
  b dq 21



section .text

main:
  mov rax, [a]
  mov rbx, [b]
  cmp rax, rbx     ;could also write something like ..cmovg rdi,rax and cmovl rdi, rbx to make quicker
  jg greater
  
lesser:
  mov rdi,rbx
  jmp finish


greater:
  mov rdi,rax

finish:
  mov rax, 60
  syscall


