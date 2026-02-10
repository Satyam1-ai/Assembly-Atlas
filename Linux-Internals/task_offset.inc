;Different states of the process ......Macro Style 
RUNNING equ 0
BLOCKED equ 1
ZOMBIE equ 2




;Different fields ...of the task_struct ...each field is linked via a linked list type structure 
;Will be naming all the offserts here ...Becasue the kernel uses a similar style to iterate ..
;If we used normal ....integers instead of %type macros ...then for any small change we would have to 
;do some weird stuff ......weird changes ...mind could get a bit fucked ..


%define TASK_KSTACK
%define STATE 
%define TASK_PID
%define TASK_FILES
%define TASK_MM
%define TASK_NEXT
%define TASK_SIZE 



