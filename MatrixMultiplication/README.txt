These programs implement the matrix multiplication 
using Cuda cpp.
The size of the matrix is 1000x1000


1. Matmul1.cu

    ->calculates the multiplication using only 1 thread
    
    ->No. of threads: 1
    
    ->timings: ~151181ms



2. Matmul2.cu

    ->calculates the multiplication by spawning a thread for 
       each row
    ->No. of threads: 1000

    ->timings: ~800ms


3. Matmul3.cu

    ->calculates the multiplication by spawning a thread
      for every element in the resultant matrix.
    
    ->No. of threads: 1 million

    ->timings: ~50ms
