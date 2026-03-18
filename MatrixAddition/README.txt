These are 2 programs implementing matrix addition in cuda cpp

1. matrixAdd1.cu
    -spaws N threads one for each row and add the corresponding 
     two input matrices and stores in the result matrix
    
    -observed time -> ~1.5 milliseconds


2. matrixAdd2.cu

    -spaws N*N threads one for each element of the resultant 
     matrix

    -observed time -> ~0.1 - 0.2 milliseconds


Note:Programs are executed on Google Colab with T4 GPU
