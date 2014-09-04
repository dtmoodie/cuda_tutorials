#include <iostream>

#include <cuda_runtime.h>
#include <math.h>
#include <boost/thread.hpp>


__global__ void myKernel(void)
{

}
__global__ void add(float* a, float* b, float* c, int n)
{
    int i = blockIdx.x*blockDim.x+threadIdx.x;
    if(i < n)
        c[i] = a[i] + b[i];
}
#define SIZE 10000000

int main(void)
{
    float *h_a, *h_b, *h_c;
    float *d_a, *d_b, *d_c;
    h_a = new float[SIZE];
    h_b = new float[SIZE];
    h_c = new float[SIZE];
    if(h_a == NULL || h_b == NULL || h_c == NULL) return -1;
    size_t size = SIZE*sizeof(float);
    cudaMalloc((void**)&d_a, size);
    cudaMalloc((void**)&d_b, size);
    cudaMalloc((void**)&d_c, size);
    for(int i = 0; i < SIZE; ++i)
    {
        h_a[i] = sin(i)*sin(i);
        h_b[i] = cos(i)*cos(i);
    }

    cudaMemcpy(d_a,h_a,size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,h_b,size,cudaMemcpyHostToDevice);

    int blockSize = 1024;
    int gridSize = (int)ceil((float)SIZE/blockSize);
    boost::posix_time::ptime start = boost::posix_time::microsec_clock::universal_time();
    add<<<gridSize,blockSize>>>(d_a,d_b,d_c,SIZE);
    boost::posix_time::ptime end = boost::posix_time::microsec_clock::universal_time();
    boost::posix_time::time_duration delta = end - start;
    std::cout << "Calculation on the GPU took: " << delta.total_microseconds() << std::endl;
    cudaMemcpy(h_c, d_c, size,cudaMemcpyDeviceToHost);
    start = boost::posix_time::microsec_clock::universal_time();
    for(int i = 0; i < SIZE; ++i)
    {
        if(fabs(h_a[i] + h_b[i] - h_c[i]) > 1e-5)
        {
            std::cout << "error " << i << std::endl;
        }
    }
    end = boost::posix_time::microsec_clock::universal_time();
    delta = end - start;
    std::cout << "Calculation on the CPU took: " << delta.total_microseconds() << std::endl;
    std::cout<< "Hello World!\n";
    return 0;
}
