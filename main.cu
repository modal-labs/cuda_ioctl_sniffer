#include <cuda_runtime.h>
#include <iostream>

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

__global__ void addKernel(int *data, int value, int size) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  if (index < size) {
    data[index] += value;
  }
}

int main() {
  const int size = 10;
  int *data;

  // Allocate unified memory – accessible from CPU or GPU
  gpuErrchk(cudaMallocManaged(&data, size * sizeof(int)));

  // Initialize array on host
  for (int i = 0; i < size; ++i) {
    data[i] = i;
  }

  // Launch kernel to add 1 to each element in the array
  addKernel<<<1, size>>>(data, 1, size);
  gpuErrchk(cudaPeekAtLastError());
  
  // Wait for GPU to finish before accessing on host
  gpuErrchk(cudaDeviceSynchronize());

  // Print results
  for (int i = 0; i < size; ++i) {
    std::cout << "data[" << i << "] = " << data[i] << std::endl;
  }

  // Free memory
  gpuErrchk(cudaFree(data));

  return 0;
}
