#!/bin/bash
set -e

# 1. Install dependencies & custom nodes
sudo apt-get update && sudo apt-get install -y aria2 git

NODE_DIR="/workspace/ComfyUI/custom_nodes/rgthree-comfy"
git clone https://github.com/rgthree/rgthree-comfy.git "$NODE_DIR" 2>/dev/null || git -C "$NODE_DIR" pull

# Helper function to handle aria2c and space-safe headers
dl() {
  local auth=()
  [ -n "$HF_TOKEN" ] && auth=(--header="Authorization: Bearer $HF_TOKEN")
  aria2c -x8 -s8 -k1M -c --file-allocation=falloc "${auth[@]}" "$@"
}

# 2. Download Diffusion Model
dl -d "/workspace/ComfyUI/models/diffusion_models" -o "turbo.safetensors" \
  "https://huggingface.co/krea/Krea-2-Turbo/resolve/main/turbo.safetensors"

# 3. Download Text Encoder
dl -d "/workspace/ComfyUI/models/text_encoders" -o "qwen3vl_4b_bf16.safetensors" \
  "https://huggingface.co/Comfy-Org/Krea-2/resolve/main/text_encoders/qwen3vl_4b_bf16.safetensors"

# 4. Download VAE
dl -d "/workspace/ComfyUI/models/vae" -o "wan21-vae.safetensors" \
  "https://huggingface.co/wangkanai/wan21-vae/resolve/main/vae/wan/wan21-vae.safetensors"

# 5. Download LoRAs
LORA_DIR="/workspace/ComfyUI/models/loras"
LORA_URL="https://huggingface.co/Thnesko/Krea2_Loras/resolve/main"

dl -d "$LORA_DIR" -o "LoRa_Foxbaey.safetensors" "$LORA_URL/LoRa_Foxbaey.safetensors"
dl -d "$LORA_DIR" -o "LoRa_Krea2_NSFW+.safetensors" "$LORA_URL/LoRa_Krea2_NSFW+.safetensors"
dl -d "$LORA_DIR" -o "LoRa_Nayaceta.safetensors" "$LORA_URL/LoRa_Nayaceta.safetensors"
dl -d "$LORA_DIR" -o "LoRa_Rosto_Darunfax.safetensors" "$LORA_URL/LoRa_Rosto_Darunfax.safetensors"

# 6. Save Workflow to Workflows Tab
curl -fsSL "https://raw.githubusercontent.com/Nani-Ga-Suki/vast/refs/heads/main/krea2.json" \
  -o "/workspace/ComfyUI/user/default/workflows/krea2.json"

echo "All models, custom nodes, and workflow downloaded successfully!"