
#include <iostream>
#include <vector>
#include <chrono>
#include <cuda_runtime.h>


__global__ void vectorAdd(const int* a, const int* b, int* c, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        c[i] = a[i] + b[i];
        
    }
}

void cpuAdd(const std::vector<int>& a, const std::vector<int>& b, std::vector<int>& c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    int n = 100000000; 
    size_t bytes = n * sizeof(int);

    std::vector<int> h_a(n, 1);
    std::vector<int> h_b(n, 2);
    std::vector<int> h_c_cpu(n);
    std::vector<int> h_c_gpu(n);

    auto start_cpu = std::chrono::high_resolution_clock::now();
    cpuAdd(h_a, h_b, h_c_cpu, n);
    auto end_cpu = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double, std::ratio<1, 1000>> cpu_time = end_cpu - start_cpu;

    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, bytes);
    cudaMalloc(&d_b, bytes);
    cudaMalloc(&d_c, bytes);

    cudaMemcpy(d_a, h_a.data(), bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b.data(), bytes, cudaMemcpyHostToDevice);

    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    int threads = 1024;
    int blocks = (n + threads - 1) / threads;

    cudaEventRecord(start);
    vectorAdd<<<blocks, threads>>>(d_a, d_b, d_c, n);
    cudaEventRecord(stop);
    
    cudaMemcpy(h_c_gpu.data(), d_c, bytes, cudaMemcpyDeviceToHost);
    cudaEventSynchronize(stop);

    float gpu_time = 0;
    cudaEventElapsedTime(&gpu_time, start, stop);

    std::cout << "n = " << n << std::endl;
    std::cout << "CPU Time: " << cpu_time.count() << " ms" << std::endl;
    std::cout << "GPU Kernel Time: " << gpu_time << " ms" << std::endl;

    cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
    cudaEventDestroy(start); cudaEventDestroy(stop);

    return 0;
}
