
#include <iostream>

using namespace std;

__global__ void mul(int* a, int* b,int* c,int n){
    int id = blockIdx.x * blockDim.x + threadIdx.x;
    if(id < n*n){
    
    
  
      c[id] = 0;
      for(int j = 0;j < n;j++){
        c[id] += (a[(id/n)*n+j] * b[j*n+(id%n)]) ;  
      }

    

    }
}


int main(){
  int n = 1000;
  int size = n*n*sizeof(int);
  int* h_a = (int*)malloc(size);
  int* h_b = (int*)malloc(size);
  int* h_c = (int*)malloc(size);

  for(int i =0;i < n;i++){
      for(int j =0;j < n;j++){
          h_a[i*n+j] = i+j;
          h_b[i*n+j] = i-j;
      }
  }

  int *d_a,*d_b,*d_c;
  cudaMalloc(&d_a,size);
  cudaMalloc(&d_b,size);
  cudaMalloc(&d_c,size);

  cudaMemcpy(d_a,h_a,size,cudaMemcpyHostToDevice);
  cudaMemcpy(d_b,h_b,size,cudaMemcpyHostToDevice);

  
  cudaEvent_t s,e;
  cudaEventCreate(&s);
  cudaEventCreate(&e);

  int threads =256;
  int blocks = ((n*n)+threads-1)/threads;

  cudaEventRecord(s);
  mul<<<blocks,threads>>>(d_a,d_b,d_c,n);
  cudaEventRecord(e);


  cudaEventSynchronize(e);
  cudaMemcpy(h_c,d_c,size,cudaMemcpyDeviceToHost);


  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, s, e);
  cout << "TIME: "<<milliseconds<< "ms "<<endl;
  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);





  return 0;
}
