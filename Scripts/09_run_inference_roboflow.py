import json
import os
from inference_sdk import InferenceHTTPClient

# USER CONFIGURATION
API_KEY = "your_API_here"                                                # Replace with your Roboflow API key
MODEL_ID = "v3-97-1/1"                                                   # Replace with your model ID

input_directory = os.path.join("data", "sample_images", "05_Redimensionadas")    # Directories (relative to project)

output_directory = os.path.join("data", "processed", "inference_results")

# INITIALIZATION
if API_KEY == "your_API_here":
    raise ValueError("Replace 'your_API_here' with your actual Roboflow API key.")

CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key=API_KEY
)

os.makedirs(output_directory, exist_ok=True)

# PROCESSING
for image_file in os.listdir(input_directory):
    if image_file.endswith('.png'):

        image_path = os.path.join(input_directory, image_file)

        try:
            result = CLIENT.infer(image_path, model_id=MODEL_ID)

            filename = f"inferencia_{os.path.splitext(image_file)[0]}.json"
            json_output_path = os.path.join(output_directory, filename)

            with open(json_output_path, "w") as json_file:
                json.dump(result, json_file, indent=4)

            print(f"Processed: {image_file}")

        except Exception as e:
            print(f"Error processing {image_file}: {e}")

print("Inference completed.")