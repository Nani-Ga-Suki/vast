#!/bin/bash
set -e

# Setup Hugging Face token header if available
AUTH=""
[ -n "$HF_TOKEN" ] && AUTH="--header=Authorization:Bearer $HF_TOKEN"

# 1. Install dependencies & custom nodes
sudo apt-get update && sudo apt-get install -y aria2 git

NODE_DIR="/workspace/ComfyUI/custom_nodes/rgthree-comfy"
git clone https://github.com/rgthree/rgthree-comfy.git "$NODE_DIR" 2>/dev/null || git -C "$NODE_DIR" pull

# Shorthand download command
DL="aria2c -x8 -s8 -k1M -c $AUTH"

# 2. Download Diffusion Model
$DL -d "/workspace/ComfyUI/models/diffusion_models" -o "turbo.safetensors" \
  "https://huggingface.co/krea/Krea-2-Turbo/resolve/main/turbo.safetensors"

# 3. Download Text Encoder
$DL -d "/workspace/ComfyUI/models/text_encoders" -o "qwen3vl_4b_bf16.safetensors" \
  "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/text_encoders/qwen3vl_4b_bf16.safetensors"

# 4. Download VAE
$DL -d "/workspace/ComfyUI/models/vae" -o "wan21-vae.safetensors" \
  "https://huggingface.co/wangkanai/wan21-vae/resolve/main/vae/wan/wan21-vae.safetensors"

# 5. Download LoRAs
LORA_DIR="/workspace/ComfyUI/models/loras"
LORA_URL="https://huggingface.co/Thnesko/Krea2_Loras/resolve/main"

$DL -d "$LORA_DIR" -o "LoRa_Foxbaey.safetensors" "$LORA_URL/LoRa_Foxbaey.safetensors"
$DL -d "$LORA_DIR" -o "LoRa_Krea2_NSFW+.safetensors" "$LORA_URL/LoRa_Krea2_NSFW+.safetensors"
$DL -d "$LORA_DIR" -o "LoRa_Nayaceta.safetensors" "$LORA_URL/LoRa_Nayaceta.safetensors"
$DL -d "$LORA_DIR" -o "LoRa_Rosto_Darunfax.safetensors" "$LORA_URL/LoRa_Rosto_Darunfax.safetensors"

echo "All models and custom nodes downloaded successfully!"