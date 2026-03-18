
#include <iostream>
#include <random>
using namespace std;

__global__ void add(const int* a, const int* b,int* c,int n){
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    for(int i = 0;i < n;i++){
      int ind = id * n + i;
      c[ind] = a[ind] + b[ind];
    }
                                                           

}

int main(){
    int n = 1000;
    int size = n*n*sizeof(int);
    int *h_a = (int*) malloc(size);
    int *h_b = (int*) malloc(size);
    int *h_c = (int*) malloc(size);

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            h_a[i * n + j] = i + j;
            h_b[i * n + j] = i - j;
        }
    }
    
    cudaEvent_t start, stop;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);

    int threads = 256;
    
    int blocks = 4;

    size_t byte = n*n * sizeof(int);

    int* d_a, *d_b,*d_c;
    cudaMalloc(&d_a,byte);
    cudaMalloc(&d_b,byte);
    cudaMalloc(&d_c,byte);
    
    cudaMemcpy(d_a,h_a,byte,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,h_b,byte,cudaMemcpyHostToDevice);
    
    cudaEventRecord(start);

    add<<<blocks,threads>>>(d_a,d_b,d_c,n);
    cudaEventRecord(stop);

    cudaMemcpy(d_c,d_c,byte,cudaMemcpyDeviceToHost);

    cudaEventSynchronize(stop);
    float milliseconds = 0;
    cudaEventElapsedTime(&milliseconds, start, stop);
    cout << "TIME: "<<milliseconds<< "ms "<<endl;
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

     return 0;      
}


