%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VALIDATION OF IMAGE CLASSIFICATION (human)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

basePath = fullfile(pwd, 'data');

diret = fullfile(basePath, '04_Retificadas');
arquivo_imagem = dir(fullfile(diret, '*.png'));

matFile = fullfile(basePath, 'processed', 'classEP_valid_posShort.mat');

% LOAD DATA
if exist(matFile, 'file')
    
    load(matFile, 'matriz_dados');
    
    % Garantir que o campo exista
    if ~isfield(matriz_dados, 'valor_sugerido')
        [matriz_dados.valor_sugerido] = deal([]);
    end

    % Encontrar último validado
    ultima_posicao = find(~cellfun('isempty', {matriz_dados.valor_sugerido}), 1, 'last');
    
    if isempty(ultima_posicao)
        ultima_posicao = 0;
    end

else
    error('File classEP_valid_posShort.mat not found in data/processed/');
end

% LOOP DE VALIDAÇÃO
for i = ultima_posicao+1:length(matriz_dados)
    
    nome_arquivo = matriz_dados(i).nome_arquivo;
    path_arquivo = fullfile(diret, nome_arquivo);
    
    if ~isfile(path_arquivo)
        warning(['Image not found: ', nome_arquivo]);
        continue;
    end
    
    imagem = imread(path_arquivo);
    imshow(imagem);

    valor_atribuido = matriz_dados(i).valor_atribuido;
    title(sprintf('Assigned value: %.1f', valor_atribuido));
    
    prompt = sprintf('Is the assigned value (%.1f) correct? (y/n/p): ', valor_atribuido);
    resposta = input(prompt, 's');

    if strcmpi(resposta, 'p')
        disp('Stopping validation process.');
        break;

    elseif strcmpi(resposta, 'n')
        valor_sugerido = input('Enter new suggested value: ', 's');
        matriz_dados(i).valor_sugerido = valor_sugerido;

    elseif strcmpi(resposta, 'y')
        % mantém valor original

    else
        disp('Invalid response! Use "y", "n", or "p".');
        continue;
    end

    % Salva progresso a cada iteração
    save(matFile, 'matriz_dados');
end