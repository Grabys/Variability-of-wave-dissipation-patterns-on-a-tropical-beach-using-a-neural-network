%%%%%%%%%%%%%%%%%%%% UPDATE CLASSIFICATION WITH SUGGESTIONS %%%%%%%%%%%%%%%%%%%%
% Loads the classification data and replaces the assigned values with the
% suggested values (when available).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define base path (project root)
basePath = pwd;

% File path
dataFile = fullfile(basePath, 'data', 'processed', 'classEP_valid_posShort.mat');

% Load data
load(dataFile);

% Loop through all entries in the data structure
for i = 1:length(matriz_dados)
    % Check if there is a suggested value
    if ~isempty(matriz_dados(i).valor_sugerido)
        % Update assigned value using the suggested value
        matriz_dados(i).valor_atribuido = str2double(matriz_dados(i).valor_sugerido);
    end
end

% Save updated data
save(dataFile, 'matriz_dados');