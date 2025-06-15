#!/bin/bash

echo "Setting up Python environment for preprocessing..."
cd /app/src/python
python -m venv .venv
source .venv/bin/activate

echo "Starting trainning..."
python -m piper_train \
    --dataset-dir /workspace/out_training/ \
    --accelerator 'gpu' \
    --devices 1 \
    --batch-size 24 \
    --validation-split 0.0 \
    --num-test-examples 0 \
    --max_epochs 5000 \
    --resume_from_checkpoint /workspace/epoch/epoch.ckpt \
    --checkpoint-epochs 1 \
    --precision 32 \
    --quality high

