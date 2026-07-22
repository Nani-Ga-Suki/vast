#!/bin/bash

# 1. Install aria2
sudo apt-get update && sudo apt-get install -y aria2

# 2. Download Diffusion Model
echo "Downloading Diffusion Model..."
aria2c -x 16 -s 16 -k 1M --continue=true \
  -d "/workspace/ComfyUI/models/diffusion_models" \
  -o "krea-2-turbo-bf16.safetensors" \
  "https://huggingface.co/KREA/krea-2-turbo/resolve/main/krea-2-turbo-bf16.safetensors"

# 3. Download Text Encoder
echo "Downloading Text Encoder..."
aria2c -x 16 -s 16 -d "/workspace/ComfyUI/models/text_encoders" \
  -o "qwen3vl_4b_bf16.safetensors" \
  "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/text_encoders/qwen3vl_4b_bf16.safetensors"

# 4. Download VAE
echo "Downloading VAE..."
aria2c -c -x 4 -s 4 -d "/workspace/ComfyUI/models/vae" \
  -o "wan21-vae.safetensors" \
  "https://huggingface.co/wangkanai/wan21-vae/resolve/main/vae/wan/wan21-vae.safetensors"

# 5. Download LoRAs
echo "Downloading LoRAs..."
aria2c -x 8 -s 8 -k 1M -j 2 -c --auto-file-renaming=false --allow-overwrite=true \
  -d "/workspace/ComfyUI/models/loras" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Foxbaey.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Krea2_NSFW+.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Nayaceta.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Rosto_Darunfax.safetensors"

echo "All models downloaded successfully!"