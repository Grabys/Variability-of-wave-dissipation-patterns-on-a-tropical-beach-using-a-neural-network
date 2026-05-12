import cv2
import os
import glob

base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

input_dir = os.path.join(base_path, 'data', 'sample_images', '04_Retificadas')
output_dir = os.path.join(base_path, 'data', 'sample_images', '05_Redimensionadas')

# CREATE OUTPUT DIR
os.makedirs(output_dir, exist_ok=True)

# ROI (Region of Interest)
left, top, right, bottom = 248, 1784, 2048, 4515

# LOAD IMAGES
image_paths = glob.glob(os.path.join(input_dir, '*.png'))

if not image_paths:
    print("No images found in input directory.")

# PROCESSING LOOP
for image_path in image_paths:
    
    img = cv2.imread(image_path)
    
    if img is None:
        print(f'Error loading {image_path}')
        continue
    
    h_img, w_img = img.shape[:2]

    # Validate ROI
    if right > w_img or bottom > h_img:
        print(f'Skipping (ROI out of bounds): {image_path}')
        continue

    # Crop
    cropped_img = img[top:bottom, left:right]

    # Resize
    resized_img = cv2.resize(cropped_img, (640, 640))

    # Output name
    file_name = os.path.basename(image_path)
    name, ext = os.path.splitext(file_name)
    new_file_name = f'{name}_resized{ext}'
    
    output_path = os.path.join(output_dir, new_file_name)
    
    cv2.imwrite(output_path, resized_img)

    print(f'Processed: {file_name}')

print('Processing complete.')