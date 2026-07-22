#!/bin/bash

# Exit on error
set -e

# 1. Install aria2
sudo apt-get update && sudo apt-get install -y aria2

# 2. Download Diffusion Model (Krea-2 Turbo)
echo "Downloading Krea-2 Turbo Model..."
aria2c -x 8 -s 8 -k 1M --continue=true \
  -d "/workspace/ComfyUI/models/diffusion_models" \
  -o "turbo.safetensors" \
  "https://huggingface.co/krea/Krea-2-Turbo/resolve/main/turbo.safetensors"

# 3. Download Text Encoder
echo "Downloading Text Encoder..."
aria2c -x 8 -s 8 -d "/workspace/ComfyUI/models/text_encoders" \
  -o "qwen3vl_4b_bf16.safetensors" \
  "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/text_encoders/qwen3vl_4b_bf16.safetensors"

# 4. Download VAE
echo "Downloading VAE..."
aria2c -c -x 4 -s 4 -d "/workspace/ComfyUI/models/vae" \
  -o "wan21-vae.safetensors" \
  "https://huggingface.co/wangkanai/wan21-vae/resolve/main/vae/wan/wan21-vae.safetensors"

# 5. Download LoRAs (Explicitly specifying outputs for each file)
echo "Downloading LoRAs..."
LORA_DIR="/workspace/ComfyUI/models/loras"

aria2c -x 8 -s 8 -c -d "$LORA_DIR" -o "LoRa_Foxbaey.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Foxbaey.safetensors"

aria2c -x 8 -s 8 -c -d "$LORA_DIR" -o "LoRa_Krea2_NSFW+.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Krea2_NSFW+.safetensors"

aria2c -x 8 -s 8 -c -d "$LORA_DIR" -o "LoRa_Nayaceta.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Nayaceta.safetensors"

aria2c -x 8 -s 8 -c -d "$LORA_DIR" -o "LoRa_Rosto_Darunfax.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Rosto_Darunfax.safetensors"

echo "All models downloaded successfully with correct filenames!"