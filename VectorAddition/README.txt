This program compares the vector addition of two vectors using a CPU function and a GPU Kernel
The GPU kernel spaws N threads one for each element to add 

N = 1 million

    Timings:
        CPU = ~7.5 ms
        GPU = ~0.15 ms

N = 10 million

    Timings:
        CPU = ~85 ms
        GPU = ~0.55 ms

n = 100 million

    Timings:
        CPU = ~950ms
        GPU = ~5ms

Note:Programs are executed on Google Colab with T4 GPU
