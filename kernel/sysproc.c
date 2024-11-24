#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "syscall.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int
sys_cps(void)
{
    struct proc *p;

    printf("name \t pid \t state \t \n");
    for(p = &proc[0]; p < &proc[NPROC]; p++)
    {
        if(p->state == SLEEPING)
            printf("%s \t %d  \t SLEEPING \t \n ", p->name, p->pid);
        else if(p->state == RUNNING)
            printf("%s \t %d  \t RUNNING \t \n ", p->name, p->pid);
        else if(p->state == RUNNABLE)
            printf("%s \t %d  \t RUNNABLE \t \n ", p->name, p->pid);
    }
    return 22;
}

uint64
sys_signal(void) {
    int signum;
    uint64 handler;
  
    // Retrieve the signal number and the handler address
    argint(0, &signum);
    argaddr(1, &handler);

    printf("\nIn sys_signal function value of signum : %d\n", signum);
    // Only handle SIGINT for now
    if (signum != SIGINT)
        return -1;
    
    if(handler == 0){
      printf("NULL Handler\n");
    }
    // Set the signal handler for the process
    struct proc *p = myproc();
    p->sig_handlers[SIGINT] = (void (*)(int))handler;

    return 0;
}
uint64 sys_thread_create(void)
{
    uint64 fn, arg, stack;
    argaddr(0, &fn);
    argaddr(1, &arg);
    argaddr(2, &stack);

    if(fn == 0 || arg == 0) 
        return -1;
    printf("\n");
    return thread_create(fn, arg, stack);
}


uint64 sys_thread_exit(void)
{
    uint64 retval;
    argaddr(0, &retval);  // Get return value from user space
    exit((int)retval);    // Cast to int as exit expects an int
    return 0;             // Never reaches here
}

uint64 sys_thread_join(void)
{
    uint64 addr;
    argaddr(0, &addr);  // addr is pointer to where return value should be stored
    return thread_join((uint64*)addr);
}
