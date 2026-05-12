import os
import json
import pandas as pd

input_directory = os.path.join("data", "processed", "inference_results")   # Directory containing inference results

output_csv = os.path.join("data", "processed", "inference_summary.csv")         # Output CSV file

# Mapping of model class_id to EP classification
class_id_map = {
    0: 1,
    1: 3.4,
    2: 2,
    3: 3,
    4: 4
}

# PROCESSING
data = []

for filename in os.listdir(input_directory):
    if filename.endswith(".json"):
        filepath = os.path.join(input_directory, filename)

        try:
            with open(filepath, 'r') as file:
                content = json.load(file)

            file_parts = filename.split("_")                           # Extract reference from filename
            reference = "_".join(file_parts[6:10])

            # Get class_id from prediction (if exists)
            raw_class_id = (
                content['predictions'][0]['class_id']
                if content.get('predictions')
                else None
            )

            class_id = class_id_map.get(raw_class_id, None)            # Apply mapping


            data.append({
                "reference": reference,
                "class_id": class_id
            })

        except Exception as e:
            print(f"Error processing {filename}: {e}")

# OUTPUT
df = pd.DataFrame(data)

print(df)

df.to_csv(output_csv, index=False)

print(f"Inference summary saved to: {output_csv}")