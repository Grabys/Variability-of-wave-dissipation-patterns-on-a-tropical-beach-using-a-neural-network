%%%%%%%%%%%%%%%%%%%%%%%%%%%% IMAGE CLASSIFICATION (human) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

basePath = pwd;

% PATHS
inputDir = fullfile(basePath, 'data', 'sample_images', '04_Retificadas');

dataDir = fullfile(basePath, 'data', 'processed');
dataFile = fullfile(dataDir, 'classEP_valid_posShort.mat');

% FILE LIST
arquivo_imagem = dir(fullfile(inputDir, '*.png'));
num_imagens = length(arquivo_imagem);

% LOAD OR CREATE DATA
if exist(dataFile, 'file')
    load(dataFile, 'matriz_dados');
    
    % Encontrar última posição preenchida corretamente
    ultima_posicao = find(~cellfun('isempty', {matriz_dados.nome_arquivo}), 1, 'last');
    
    if isempty(ultima_posicao)
        ultima_posicao = 0;
    end
else
    matriz_dados = struct( ...
        'nome_arquivo', cell(num_imagens, 1), ...
        'valor_atribuido', cell(num_imagens, 1) ...
    );
    ultima_posicao = 0;
end  

% LOOP
for i = ultima_posicao+1:num_imagens
    
    path_arquivo = fullfile(inputDir, arquivo_imagem(i).name);
    nome_arquivo = arquivo_imagem(i).name;
    
    imagem = imread(path_arquivo);
    imshow(imagem);
    title('Assign a value to the image');
    
    valor = input('Assign a value (100 = exit): ');
    
    if valor == 100
        disp('Exiting loop.');
        break;
    end
    
    matriz_dados(i).nome_arquivo = nome_arquivo;
    matriz_dados(i).valor_atribuido = valor;
end

% SAVE
if ~isfolder(dataDir)
    mkdir(dataDir);
end

save(dataFile, 'matriz_dados');

disp('Classification saved successfully.');