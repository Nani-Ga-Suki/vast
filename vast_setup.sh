#!/bin/bash

# Exit on error
set -e

# Setup HF Token Header if available in instance environment
HEADER=""
if [ -n "$HF_TOKEN" ]; then
  echo "Using provided HF_TOKEN..."
  HEADER="--header=Authorization: Bearer $HF_TOKEN"
fi

# Modern user-agent to avoid Cloudflare/HF bot detection on cloud IPs
USER_AGENT="--header=User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64)"

# 1. Install dependencies & rgthree
echo "Installing aria2 and git..."
sudo apt-get update && sudo apt-get install -y aria2 git

echo "Installing rgthree-comfy custom nodes..."
CUSTOM_NODES_DIR="/workspace/ComfyUI/custom_nodes"
mkdir -p "$CUSTOM_NODES_DIR"
if [ ! -d "$CUSTOM_NODES_DIR/rgthree-comfy" ]; then
  git clone https://github.com/rgthree/rgthree-comfy.git "$CUSTOM_NODES_DIR/rgthree-comfy"
else
  echo "rgthree-comfy already exists, pulling latest updates..."
  git -C "$CUSTOM_NODES_DIR/rgthree-comfy" pull
fi

# 2. Download Diffusion Model (Krea-2 Turbo)
echo "Downloading Krea-2 Turbo Model..."
aria2c -x 8 -s 8 -k 1M --continue=true $HEADER $USER_AGENT \
  -d "/workspace/ComfyUI/models/diffusion_models" \
  -o "turbo.safetensors" \
  "https://huggingface.co/krea/Krea-2-Turbo/resolve/main/turbo.safetensors"

# 3. Download Text Encoder
echo "Downloading Text Encoder..."
aria2c -x 8 -s 8 -k 1M --continue=true $HEADER $USER_AGENT \
  -d "/workspace/ComfyUI/models/text_encoders" \
  -o "qwen3vl_4b_bf16.safetensors" \
  "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/text_encoders/qwen3vl_4b_bf16.safetensors"

# 4. Download VAE
echo "Downloading VAE..."
aria2c -x 4 -s 4 -k 1M --continue=true $HEADER $USER_AGENT \
  -d "/workspace/ComfyUI/models/vae" \
  -o "wan21-vae.safetensors" \
  "https://huggingface.co/wangkanai/wan21-vae/resolve/main/vae/wan/wan21-vae.safetensors"

# 5. Download LoRAs
echo "Downloading LoRAs..."
LORA_DIR="/workspace/ComfyUI/models/loras"

aria2c -x 8 -s 8 -k 1M --continue=true $HEADER $USER_AGENT -d "$LORA_DIR" -o "LoRa_Foxbaey.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Foxbaey.safetensors"

aria2c -x 8 -s 8 -k 1M --continue=true $HEADER $USER_AGENT -d "$LORA_DIR" -o "LoRa_Krea2_NSFW+.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Krea2_NSFW+.safetensors"

aria2c -x 8 -s 8 -k 1M --continue=true $HEADER $USER_AGENT -d "$LORA_DIR" -o "LoRa_Nayaceta.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Nayaceta.safetensors"

aria2c -x 8 -s 8 -k 1M --continue=true $HEADER $USER_AGENT -d "$LORA_DIR" -o "LoRa_Rosto_Darunfax.safetensors" \
  "https://huggingface.co/Thnesko/Krea2_Loras/resolve/main/LoRa_Rosto_Darunfax.safetensors"

echo "All models and custom nodes downloaded successfully!"