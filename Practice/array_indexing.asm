section .data
    my_array dd 10,20,30,40
    empty_array dd 100 dup(0)          
    
    
section .text
  main:
    lea rsi, [rel my_array]
    mov rbx, 2
    mov eax, [rsi + rbx*4].  ;Here be very careful how you are using the ...eax and not the rbx ...
