;Different states of the process ......Macro Style 
RUNNING equ 0
BLOCKED equ 1
ZOMBIE equ 2




;Different fields ...of the task_struct ...each field is linked via a linked list type structure 
;Will be naming all the offserts here ...Becasue the kernel uses a similar style to iterate ..
;If we used normal ....integers instead of %type macros ...then for any small change we would have to 
;do some weird stuff ......weird changes ...mind could get a bit fucked ..


%define TASK_KSTACK  0
%define STATE  8
%define TASK_PID  12
%define TASK_FILES 16
%define TASK_MM  24
%define TASK_NEXT 32
%define TASK_SIZE 40



