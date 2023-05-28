# PS 

### Computing speedup
```
S(n, p) = t_serial(n) / t_parallel(n, p)
...

S(n,p) = (t_serial(n) + t_operations_that_can_be_parallelized)) / (t_serial(n) + t_operations_that_can_be_parallelized(n) / p + communication(n, p))
```

### Computing efficency

```
E(n,p) = t_serial(n) / (p * t_parallel(n, p)
E(n,p) = S(n,p) / p
```
linear speedup: `0 <= E(n,p) <= 1`
above-linear-speedup: E(n,p) > 1

### Computation price

```
P(n,p) = p * t_parallel(n) = (p * t_serial(n)) / S(n,p) = t_serial(n) / E(n,p)
```

### Amdhals law
```
S(n,p) <= 1 / (f  + (1-f)/p)

f-> the code that cannot be parallelized
```

## Pthreads

### Address space

```
[code       ]
[init data  ]
[uninit data]
[heap       ]
[    |      ]
[    .      ]
[   free    ]
[    .      ]
[    |      ]
[stack  (T1)]
[stack  (T2)]
    ...
[stack  (Tn)]
[args + env ]
```

* Every thread has its own stack, stack pointer (SP), and program counter(PC)


### Example

Creates N structs, each thread processes it and returns it. No locks or anything fancy like that, just an example how 
somebody would start with pthreads in c.
```c
#include <stdio.h>
#include <pthread.h>
#include <stdlib.h>

typedef struct {
    int x;
    int y;
} thread_data;

void *thread_func(void *arg) {
    thread_data *data = (thread_data *)arg; // cast arguments to correct type

    printf("thread id = %lu\n", pthread_self()); // Get unique thread id, type: pthread_t
    
    // Perform complex operations here
    printf("x = %d, y = %d\n", data->x, data->y);
    data->x += 10;
    data->y += 10;
    //
    
    //return NULL; // if you do not need to return anything
    pthread_exit((void *)data);
}

int main(int argc, char *argv[]) {
    
    if (argc != 2) {
        printf("Usage: %s <nthreads>", argv[0]);
        exit(1);
    }

    int nthreads = atoi(argv[1]);
    pthread_t threads[nthreads];
    thread_data data[nthreads];
    thread_data *ret_data[nthreads];

    for (int i = 0; i < nthreads; i++) {
        data[i].x = i;
        data[i].y = i + 1;
        pthread_create(&threads[i], NULL, thread_func, (void *)&data[i]); // Creaate thread with arguments
    } // If main thread is killed, then all the
      // threads are also killed
    
    for (int i = 0; i < nthreads; i++) {
        pthread_join(threads[i], (void **)&ret_data[i]); // Wait for every thread to finish
        printf("x = %d, y = %d\n", ret_data[i]->x, ret_data[i]->y);
    }

    return 0;
}
```


### Few properties:

* Memory is shared between the threads (basically heap is shared)
* Global variables are seen by every thread
* Communication between threads is therefore through global variables, or pointers to same structures


### Synchronization of access to same variables
* We want to limit acces to some variable, that all the threads are accessing, so that only single one will be addressed ( avoiding race condition )
* We solve this problem by using p_thread_mutexes or in other words **locks** and introduce a "critical section"
* So one threads reveserves execution of that part of the code for itself, and prevents  other threads from accessing that part of the code
* When lock is released then the next thread can continue with execution of that part of the code
* **locks** are created using atomic asm instructions (eg. test-and-set, fetch-and-add, compare-and-swap), that way a thread can lock part of a code using single instruction, preventing other threads from interrupting this behaivour.

### Deadlock

```bash
        T1                                  T2
pthread_mutex_lock_(&m1)            pthread_mutex_lock_(&m2)
pthread_mutex_lock_(&m2)            pthread_mutex_lock_(&m1)
...

pthread_mutex_unlock(&m2)           pthread_mutex_unlock(&m1)
pthread_mutex_unlock(&m1)           pthread_mutex_unlock(&m2)
```
T1 locks m1, Before it locks m2, thread T2 locks m2, T2 is now waiting for m1 to 
be unclocked, but the T1 wound release it until m2 is not free --> DEADLOCK.

### Semaphore
A counting semaphore is a generalization of a binary semaphore that can have a maximum value greater than 1. 
It is used to control access to a common resource that can be shared by multiple threads. 
When a thread wants to use the resource, it decrements the value of the semaphore. 
If the semaphore's value is greater than 0, the thread can proceed. 
If the semaphore's value is 0, the thread is blocked until the semaphore is incremented by another thread. 
When the thread is finished using the resource, it increments the semaphore's value to allow other threads to use the resource.

```c
int sem_init(sem_t * semaphore_p, int shared,unsigned initial_value);
int sem_wait(sem_t * semaphore_p);      // called on enter of critical section
                                        // if value in sem > 0:
                                        //   -> decrease value in sem
                                        //   -> continue execution
                                        // else:
                                        //   -> wait for value in sem to be > 0
int sem_post(sem_t *semaphore_p)        // This is called on exit of critical section, it incrememts the semaphore value by one 
int sem_destroy(sem_t * semaphore_p);   // destroy the semaphore
```

### Conditional variables
A conditional variable has the following operations:

- `pthread_cond_wait`: This function causes the calling thread to block until the specified condition is met. The thread must hold the mutex lock when calling this function, and it will be released while the thread is blocked. When the function returns, the mutex lock is reacquired by the thread.

- `pthread_cond_signal`: This function unblocks one thread that is blocked on the specified condition variable. If no threads are blocked on the condition variable, the function has no effect.

- `pthread_cond_broadcast`: This function unblocks all threads that are blocked on the specified condition variable. If no threads are blocked on the condition variable, the function has no effect.

example:
```c
#include <pthread.h>

pthread_mutex_t mutex;
pthread_cond_t cond;
int shared_data = 0;

void *thread_func(void *arg)
{
    pthread_mutex_lock(&mutex);
    while (shared_data == 0) {
        pthread_cond_wait(&cond, &mutex);
    }
    printf("shared_data is now %d\n", shared_data);
    pthread_mutex_unlock(&mutex);
    return NULL;
}

int main(int argc, char *argv[])
{
    pthread_t thread;
    pthread_mutex_init(&mutex, NULL);
    pthread_cond_init(&cond, NULL);
    pthread_create(&thread, NULL, thread_func, NULL);
    sleep(1);
    pthread_mutex_lock(&mutex);
    shared_data = 42;
    pthread_cond_signal(&cond);
    pthread_mutex_unlock(&mutex);
    pthread_join(thread, NULL);
    pthread_mutex_destroy(&mutex);
    pthread_cond_destroy(&cond);
    return 0;
}
```
In this example, the main thread creates a new thread and then waits for 1 second before setting the value of shared_data to 42 
and signaling the condition variable. The new thread blocks on the condition variable until it is signaled, at which point it wakes up, 
acquires the mutex lock, and prints the value of shared_data.

#### Implementation of semaphore using conditional variables and mutexes 

```c
typedef struct {
    int value;
    pthread_cond_t cond;
    pthread_mutex_t lock;
} Sem_t;

void Sem_init(Sem_t *s, int value) {
    s->value = value;
    pthread_cond_init(&s->cond, NULL);
    pthread_mutex_init(&s->lock, NULL);
}

void Sem_wait(Sem_t *s) {
    pthread_mutex_lock(&s->lock);
    while(s->value <= 0)
        pthread_cond_wait(&s-> cond, &s-> lock); // unlocks the &s->lock and waits for signal 
    s->value--;
    pthread_mutex_unlock(&s-> lock);
}


void Sem_post(Sem_t *s) {
    pthread_mutex_lock(&s->lock);
    s->value++;

    pthread_cond_signal(&s->cond);
    pthread_mutex_unlock(&s->lock);
}
```

### Barrier

A point in code, where all the threads wait for eachother.

Implementation using conditional  vars:

```c
//pthread_mutex_init(&lock, NULL);
//pthread_cond_init(&condition, NULL);
void* barrier(void* arg) 
{
	int i;
	int myid = (int)arg;	

	for(i=0; i<NPRINTS; i++)
	{
		if( myid == 0 )
			shared++;

		// barrirer -> start 
		pthread_mutex_lock(&lock);
		threads++;
		if( threads < NTHREADS )
			while( pthread_cond_wait(&condition, &lock) != 0 );
		else
		{
			threads = 0; // when the last thread arrives, broadast the signal to other threads to continue execution
			pthread_cond_broadcast(&condition);
		}
		pthread_mutex_unlock(&lock);
		// barrier -> end 

		printf("Nit %d: vrednost: %d\n", myid, shared);
	}

	return NULL;
}
// pthread_mutex_destroy(&lock);
// pthread_cond_destroy(&condition);
```


```c
// pthread_barrier_t b;
// pthread_barrier_init( &b, NULL, NTHREADS );

void* barrier(void* arg) 
{
	int i;
	int myid = (int)arg;

	for(i=0; i<NPRINTS; i++)
	{
		if( myid == 0 )
			shared++;

		pthread_barrier_wait( &b );
		printf("%d %d\n", myid, shared );
	}

	return NULL;
}
// pthread_barrier_destroy( &b );
```

## Models of parallelization

- **Manager / worker**
    - Manager:
        - Dynamically spawns worker on need
        - Workers should be independent of eachother
    - Worker:
        - Processes data passed by the Manager
        - Saves the result or returns it to the Manager
cons: dynamic creation of threads and not using the thread pool (large cost of creating new threads and destroying them)
solution: use thread pool

- **Equaly weighted threads**
    - Main thread spawns all the threads
    - All the threads are working concurrently and are weighted equaly
    - Each thread may be doing some different
    - Usually there is a lot of communication and waits between threads, which can lead to performance decreases 

- **Pipeline**
    - Thread 0 takes care for the inputs and passes it to threads
    - Thread N takes care of the output
    - Threads are exchanig work
    - Every thread uses resources if needed
    - Pipeline speed is determined by the slowest stage 
    - Each stage can spawn multiple threads if needed

## OpenMP

### Compiling

```bash
gcc -fopenmp -DOMP_NUM_THREADS=<nthreads> main.c -o main
```

### Pragmas

#### `#pragma omp parallel`
A block of code, which all threads should execute

#### `#pragma omp sections` & `#pragma omp section`
Split code into sections.

Example:
```c
#pragma omp parallel
#pragma omp sections
{
    #pragma omp section
    v = func1();
    # pragma omp section 
    w = func2()
}
// by default, barrier is used here
// if you do not need a barrirer:
// #pragma omp sections nowait
```

#### `#pragma omp parallel for`
For loop should be in a [canonical](https://www.openmp.org/spec-html/5.0/openmpsu40.html) form.
Basically should not include any function calls. 

##### `schedule` addon

- `schedlue(static, [,N])`
    - every thread gets N iters in series
    - default

- `schedule(dynamic[,N])`
    - every thread does N iters in series
    - sum of all N < problem
    - so when one thread computes N iters, if there are still things to proces, it processes it

- `schedule(guided[,N])`
    - Same as dynamic but blocks are getting smaller and smaller

### Variables
Default:
    - Most of the variables are shared
    - Threads share global variables
    - Variables that are in parallel blocks, are not shared
    - Variables of the forked programs that are called from parrallel sections, are local for every thread

#### OpenMp variable addons

- `shared(vars)`
    - Explicitly set global variables to be shared inside a block
    - default, not needed
- `private(vars)`
    - Not initialized, so you must set it a value
    - It is per thread private, and does not affect the variable defined in program or any other thread
- `firstprivate(vars)`
    - Copies local variable value and does not need to be initialized
    - It is per thread private, and does not affect the variable defined in program or any other thread
- `lastprivate(vars)`
    - Stores the result to the local variable on finish of the block
- `threadprivate(vars)`
    - Makes vars local per thread
    - They are not freed after block execution
    - That means if we call that block again, the value of the variable will remain from previous call
- `reduction(op:var)`
    - Every thread gets a local copy of variable var
    - Local copies are initialized specified by op
    - When they are done, they are grouped together into one group var

```c
#pragma omp parallell for reduction(+:counter)
for(i = 0; i < N; i++)
    counter++;
```

| op   | initial value |
|------|---------------|
| +    | 0             |
| *    | 1             |
| &    | 1             |
| \|   | 0             |
| ^    | 0             |
| &&   | 1             |
| \|\| | 0             |


### Synchronization between threads

- `critical(name)`
    -  basically locked section like in pthreads
    - If critical section is not enough for you, you can also use `omp_lock_t` for more flexibilty. But watchout becouse the thread that locks the lock must be the one that also unlocks it!

- `atomic`
    - A faster critical section (only for `x <op> = n`) -> `op = +, -, *, /, &, |, <<, >>`

- `barrier`
    - threads wait for eachother

- `ordered`
    - code is executed in sequentiall matter

- `single`
    - code is executed by a single thread

- `master`
    - code is executed by the main thread

- `collapse(n)`
    - `n` is the number of nested for loops that are executed concurrently

- `flush(vars)`
    - When a thread executes a flush directive, it forces any updates that the thread has made to its own cache to be written back to the main memory, so that other threads can see the updated data. 
    - This is useful when multiple threads are accessing and updating shared data, as it ensures that the changes made by one thread are visible to other threads in a timely manner.

### Tasks
The task construct in OpenMP is a mechanism for expressing parallelism in your code that allows you to specify units of work (called tasks) that can be executed concurrently. 
It provides a way to create parallelism that is more dynamic and flexible than the traditional OpenMP constructs, such as parallel and for.


## OpenMPI (message passing interface)
It is designed to allow multiple computers to work together as a single system 
and to enable the efficient exchange of data between them.

### Functions

- `int MPI_Init(int *argc, char **argv);`
    - initializes MPI and sets up connections between processes
    - CLI arguments are passed only to process 0!

- `int MPI_Comm_size(MPI_Comm, int *size)` 
    - returns number of nodes/processes in comunication

- `int MPI_Comm_rank(MPI_Comm, int *rank)`
    - returns process id

- `MPI_Finalize(void)`
    - closes connections
    - It is the last function call to MPI in our program.
    - cleans up

- `MPI_Send(void *message, int count, MPI_Datatype datatype, int destination, int tag, MPI_Comm comm)`
    -  send message to process, using its id(`destination`)
    - < 16kB `MPI_Bsend()`
    - > 16kB `MPI_Ssend()`

- `MPI_Ssend()`
    - returns information about message transmission
    - waits for reciever confirmation of data
    - Blocking function

- `MPI_Bsend()`
    - The message is buffered.
    - Function ends when message is written into a buffer
    - No clue if the message was recieved or not.

- `MPI_Isend(&buf, count, datatype, dest, tag, comm, request)`
    - Nonblocking send fucntion
    - We can test its success by executing `MPI_Test(&request, &done, MPI_STATUS_IGNORE)`
    - Faster execution of code

- `MPI_Recv(void *message, int count, MPI_Datatype datatype, int source, int tag, MPI_Comm comm, MPI_Status status)`
    - recv message, from predefined source or use  `MPI_ANY_SOURCE` to listen for all messages

- `MPI_Barrier(MPI_Comm comm)`
    - Classic barrier

- `MPI_Bcast(void *buf, int count, MPI_Datatype, int root, MPI_Comm comm)`
    - `root` broadcasts its message to all other participants
    - `root` process sets the `*buf, all other processes read from it
    - All the processes should call this function

- `MPI_Reduce(void *sendbuf, void *recvbuf, int count, MPI_Datatype datatype, MPI_Op op, int root, MPI_Comm comm)`
    - All the sendbufs are joined on the root recvbuf using operation op
    - op can be max, min, sum, product, land, lor,...

- `MPI_Scatter(void *sendbuf, int sendcount, MPI_Datatype sendtype, void *recvbuf, int recvcount, MPI_Datatype recvtype, int root, MPI_Comm comm)`
    - Array / string / buffer gets equaly splitteed to all the processes from the root process, root process also gets its piece

- `MPI_Gather(void *sendbuf, int sendcount, MPI_Datatype sendtype, void *recvbuf, int recvcount, MPI_Datatype recvtype, int root, MPI_Comm comm)`
    - Array / string / buffer gets equaly gathered to the root process

- `MPI_Gatherv` and `MPI_Scatterv`
    - Same as Scatter and gather, but you have control over displacenents and send counts for each process
    - basically you can control how larg chunk everey process will handle

## CUDA C

Cuda program consists:
- Code thet runs on host(CPU)
- Kernel that runs on GPU
- Threads are organized in block, which make up grid
- Every kernel executes single grid

Code execution:
- Copy data to GPU
- request for computation
- compute
- copu data from GPU memory to main system memory

### Streaming multiprocessor(SM)

```
|      I cache        | 
|      MT issue       |
|      C cache        |
| SP       | SP       |
| SP       | SP       |
| ...      | ...      |
| SP       | SP       |
| SFU      | SFU      |
|      registers      |
|  Shared    Memory   |
|  Local     Memory   |
```

Consists of:
- `SP` ~ streaming processors -> 2times the clock speed (fast clock)
- `SFU` ~ special function units
- `Shared memory`
- `cache`

Properties:
- A block of thread is executed by single streaming multiprocessor.
- SM can process many blocks concurrently.
- Threads that are in the same block are easily synchronized.
- Threads that are executed on different SM **cannot** be synchronized ((efficently)) -> hence faster computation!
- All the threads in the same block execute the same code
- Every SM has 8 SP, and a warp has 32 threads, so threads are executed in four steps (pipeline)
- Each instruction in ALE/MAD unit takes about 4 ticks(fast clock), So it lines up with warp pipeline execution (each fast tick 8 threads are created and computed)

Function units:
- 8 32bit FP(floating point) ALU/MAD(multiply and add)
- 8 integer units for jump instructions
- 2 SFUs, trigonometric functions,..
- 1 64 bit MAD unit (allows 64 bit operations), that means that computation with 64bit values will be at least 8-12 times slower than 32bit

Shared memory:
- Really fast memory, but very limited in size.
- It is meant for communication between threads in the same SM.
- Meant for saving some value (example counter sum for all threads)
- All data is lost when the kernel finishes.
- Data from and into shared memory is transfered to and from registers using `LOAD/STORE`.

Registers:
- Each SM has a few registers(static), faster than shared memory
- Then each SP has a few dynamically allocated registers

Local memory:
- private for each thread
- used when there are no registers left
- a bit slower

Warp (micro architecture):
- consists of 32 parallel threads, that execute the same code
- each SM can execute 32 warps


### Global & constant & texture memory:
- It is slower
- All threads can access it
- CPU can write and read from it.
- Memory stays there when the kernel finishes (You must clean it up after usage).
- constant memory: small, around 64KB, used for instructions
- texture memory: used for storing constatns and textures in graphichal applications


### CUDA kernel

- Does not return anything
- Accepts arguments, but pointers from device memory

Compiler function labels:
    - `__global__` ~ Function is ran on device, and the one calling it is the host
    - `__device__` ~ Function is ran on device, and can be called only from within device
    - `__host__` ~ Function is ran on the host ( default )

### Some CUDA functions

- `cudaMalloc()`
    - Allocate memory on the GPU
- `cudaFree()`
    - Free memory on the GPU
- `cudaMemcpy(p1, p2, ssize_t, cudaMemcpyDeviceToHost | cudaMemcpyHostToDevice)`
    - Copy from main memory to gpu memory and vice versa.

## Cuda on fedora

Follow the instructions [here](https://rpmfusion.org/Howto/CUDA)


