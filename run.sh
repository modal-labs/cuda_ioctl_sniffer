#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

./make_sniff.sh

SOURCE="../main.cu"
BIN_NAME="main"
BIN="out/${BIN_NAME}"
ARCH="sm_52"

cd out
nvcc -I../open-gpu-kernel-modules/src/common/sdk/nvidia/inc -I../open-gpu-kernel-modules --keep -g "${SOURCE}" -o "${BIN_NAME}" -lcuda -v -arch="${ARCH}"
cd ../

LD_PRELOAD=out/sniff.so "${BIN}"
#LD_PRELOAD=out/sniff.so python3 -i -c "import torch; a = torch.zeros(256,256).cuda(); b = torch.zeros(256,256).cuda(); print('***********\n\n\n\n\n\n\n****MATMUL****'); c = a@b"
#LD_PRELOAD=out/sniff.so python3 -i -c "from tinygrad.runtime.ops_gpu import CLBuffer; import numpy as np; a = CLBuffer.fromCPU(np.zeros(4, np.float32))"

