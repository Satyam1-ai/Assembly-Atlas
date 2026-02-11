section .data
  initial_task:
    dq 0
    dd RUNNING
    dq 0
    dq 0
    dq 0
    dq 0
    dq 0

  current_task_ptr=initial_task
