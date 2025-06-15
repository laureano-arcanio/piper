#!/bin/bash

# Check if workspace exists and create if not
if [ ! -d "/workspace" ]; then
    echo "Creating /workspace directory..."
    mkdir -p /workspace/
else
    echo "/workspace directory already exists"
fi

cd /workspace

# Download audio file from Mega.nz (mozilla dataset already formatted)
echo "Downloading audio dataset from Mega.nz..."
megadl "https://mega.nz/file/2F1znB6D#pIXkkI8AseZi9OKVQSXQMkdeR37A3yebznXT7ExkmhU" --path audio_22050.tar.gz
echo "Extracting audio files..."
tar -xvzf audio_22050.tar.gz --no-same-owner

echo "Creating output training directories..."
mkdir -p out_training/epoch
cd out_training/epoch
echo "Downloading checkpoint file..."
wget -O epoch.ckpt "https://huggingface.co/datasets/rhasspy/piper-checkpoints/resolve/main/en/en_US/lessac/high/epoch%3D2218-step%3D838782.ckpt"
echo "Setup complete!"

