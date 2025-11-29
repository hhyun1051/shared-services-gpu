from huggingface_hub import snapshot_download
import os

model_id = "Qwen/Qwen3-VL-8B-Thinking"
local_dir = "./models/Qwen/Qwen3-VL-8B-Thinking"

print(f"Downloading {model_id} to {local_dir}...")
snapshot_download(repo_id=model_id, local_dir=local_dir)
print("Download complete.")
