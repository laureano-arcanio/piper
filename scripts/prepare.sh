#!/bin/bash

echo "Setting up Python environment for preprocessing..."
cd /app/src/python
python -m venv .venv
source .venv/bin/activate

echo "Building monotonic alignment..."
./build_monotonic_align.sh

echo "Starting audio data preprocessing..."
# Preprocess audio data
python3 -m piper_train.preprocess \
  --language es-419 \
  --input-dir /workspace/audio_22050 \
  --output-dir /workspace/out_training \
  --dataset-format ljspeech \
  --single-speaker \
  --sample-rate 22050 \
  --max-workers 12

echo "Preprocessing complete!"