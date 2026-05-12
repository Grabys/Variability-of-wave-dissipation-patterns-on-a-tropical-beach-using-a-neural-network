import pandas as pd
import os
import shutil

# BASE PATH
base_path = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# CONFIG
csv_file = os.path.join(base_path, 'data', 'processed', 'classEP_valid_posShort.csv')
input_dir = os.path.join(base_path, 'data', 'sample_images', '05_Redimensionadas')

# CHOICE OF CLASS
valor_interessante = 1.0
nome_classe = "refletivo"

output_dir = os.path.join(base_path, 'data', 'sample_images', f'Selec_{nome_classe}')

# LOAD CSV
if not os.path.isfile(csv_file):
    raise FileNotFoundError("CSV file not found in data/processed/")

data = pd.read_csv(csv_file)

data['Valor_atribuido'] = pd.to_numeric(data['Valor_atribuido'], errors='coerce')

# FILTER
selecionados = data.loc[
    data['Valor_atribuido'] == valor_interessante,
    'Nome_arquivo'
].dropna()

# CREATE OUTPUT DIR
os.makedirs(output_dir, exist_ok=True)

# COPY FILES
count = 0

for nome_arquivo in selecionados:
    
    nome_base, ext = os.path.splitext(nome_arquivo)
    nome_resized = f"{nome_base}_resized{ext}"

    arquivo_origem = os.path.join(input_dir, nome_resized)
    arquivo_destino = os.path.join(output_dir, nome_resized)

    if os.path.exists(arquivo_origem):
        shutil.copy2(arquivo_origem, arquivo_destino)
        count += 1
    else:
        print(f"File not found: {arquivo_origem}")

print(f"Copied {count} images to {output_dir}")
print("Process completed!")