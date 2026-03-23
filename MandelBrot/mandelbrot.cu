#include <iostream>
#include <cuda_runtime.h>
#include <fstream>
#define N 4192

__global__ void calculate(float* a){
    int row = threadIdx.y + blockIdx.y * blockDim.y;
    int col = threadIdx.x + blockIdx.x * blockDim.x;

    float step = 4.0/(float)N;
    
    float r = -2.0 + col * step; 
    float i = 2.0 - row * step;

    float real = 0.0f;
    float img = 0.0f;
    float temp;
    int done = 0;
    for(int ite = 0;ite < 500;ite++){
        temp = real;
        real = real*real - img*img + r;
        img = 2*temp*img + i;

        if(real*real + img*img > 4){
            a[row * N + col] = (ite + 1) * 255 / 500;
            done = 1;
            break;
        }
    }
    if(!done){
    a[row * N + col] = 0.0;
    }
    
}


int main(){

    int byte = N*N*sizeof(float);
    
    dim3 threads(16,16);
    dim3 blocks(N/16,N/16);

    //brightness for each pixel
    float* h_brightness = (float*)malloc(byte);
    float* d_brightness;
    cudaMalloc(&d_brightness,byte);
    calculate<<<blocks,threads>>>(d_brightness);
    
    cudaMemcpy(h_brightness,d_brightness,byte,cudaMemcpyDeviceToHost);
    

    std::ofstream imgFile("mandelbrot.ppm");
    imgFile << "P3\n" << N << " " << N << "\n255\n";
    for (int i = 0; i < N * N; i++) {
        int val = (int)h_brightness[i];
        // Writing R G B (Greyscale for now)
        imgFile << val << " " << val << " " << val << " ";
    }
    imgFile.close();

    std::cout << "Image saved as mandelbrot.ppm" << std::endl;





    free(h_brightness);
    cudaFree(d_brightness);

    return 0;



    
}


