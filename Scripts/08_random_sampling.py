import os
import shutil
import random

base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# CONFIG
class_name = 'refletivo'

input_dir = os.path.join(base_path, 'data', 'sample_images', f'Selec_{class_name}')
output_dir = os.path.join(base_path, 'data', 'sample_images', 'Random', class_name)
    
# NUMBER OF SAMPLES
num_samples = 97

# REPRODUCIBILITY
random.seed(42)

# CHECK INPUT
if not os.path.isdir(input_dir):
    raise FileNotFoundError(f"Input folder not found: {input_dir}")

# CREATE OUTPUT DIR
os.makedirs(output_dir, exist_ok=True)

# LIST IMAGES
images = [
    f for f in os.listdir(input_dir)
    if os.path.isfile(os.path.join(input_dir, f))
]

if not images:
    print("No images found in input directory.")

# RANDOM SAMPLING
selected_images = random.sample(images, min(num_samples, len(images)))

# COPY
for image in selected_images:
    shutil.copy2(
        os.path.join(input_dir, image),
        os.path.join(output_dir, image)
    )
    print(f"Copied: {image}")

print(f"{len(selected_images)} images selected for class '{class_name}'.")
print("Random selection completed!")