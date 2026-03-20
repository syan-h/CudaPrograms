
#include <iostream>
#define size 16
using namespace std;

__global__ void mul(int* a, int* b,int* c,int n){

    __shared__ int A[size*size];
    __shared__ int B[size*size];

    int tx = threadIdx.x;
    int ty = threadIdx.y;

    int row = blockIdx.y * blockDim.y + ty;
    int col = blockIdx.x * blockDim.x + tx;

    
    int val = 0;
    
    for(int chunk =0;chunk < n/size;chunk++){

        A[ty*size + tx] = a[row * 1024 + chunk*size+tx ];
        B[ty*size + tx] = b[(chunk*1024*size)+(ty*1024)+ col];
        __syncthreads();
        for(int k = 0;k < size;k++){
            val += (A[ty*size + k] * B[k*size + tx]);
        }

        __syncthreads();

        
    }
    c[row*1024+col] = val;

    
}


int main(){
  int n = 1024;
  int byte = n*n*sizeof(int);
  int* h_a = (int*)malloc(byte);
  int* h_b = (int*)malloc(byte);
  int* h_c = (int*)malloc(byte);

  for(int i =0;i < n;i++){
      for(int j =0;j < n;j++){
          h_a[i*n+j] = i+j;
          h_b[i*n+j] = i-j;
      }
  }

  int *d_a,*d_b,*d_c;
  cudaMalloc(&d_a,byte);
  cudaMalloc(&d_b,byte);
  cudaMalloc(&d_c,byte);

  cudaMemcpy(d_a,h_a,byte,cudaMemcpyHostToDevice);
  cudaMemcpy(d_b,h_b,byte,cudaMemcpyHostToDevice);

  
  cudaEvent_t s,e;
  cudaEventCreate(&s);
  cudaEventCreate(&e);

  dim3 threads(16,16);
  dim3 blocks(16,16);
  
  cudaEventRecord(s);
  mul<<<blocks,threads>>>(d_a,d_b,d_c,n);
  cudaEventRecord(e);


  cudaEventSynchronize(e);
  cudaMemcpy(h_c,d_c,byte,cudaMemcpyDeviceToHost);


  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, s, e);
  cout << "TIME: "<<milliseconds<< "ms "<<endl;
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);





  return 0;
}
