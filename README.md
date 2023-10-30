This repo works to launch a CUDA kernel without using the CUDA driver runtime.

## Prep

- Install the Python requirements
- Install clang, and update `pstruct.py` with location of libclang.


## Usage




### Original

```bash
git clone https://github.com/NVIDIA/open-gpu-kernel-modules.git
./cudaless.sh
```

`gpu_driver.cc` -- The thing that pushes the command queues and stuff
`tc_context.cc` -- GPU init, replacement for cuInit and cuCtxCreate
