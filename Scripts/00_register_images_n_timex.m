%%%%%%%% RAW IMAGE REGISTRATION AND HOURLY AVERAGE GENERATION %%%%%%%%%
% This script originally accessed a remote server to download images.
%
% The dataset contains 1037 dates, each with 12 hourly folders.
% For each hour, an average image (timex) is generated.
%
% Before averaging, images are registered (aligned) to correct
% relative displacement caused by the acquisition system, minimizing errors.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

mainDir = fullfile(pwd, 'data', 'sample_images', '00_raw'); % Main directory (local data)

addpath(fullfile(pwd, 'Dependencies', 'Register'));

dateDirs = dir(mainDir);                                            
dateDirs = dateDirs([dateDirs.isdir]);
dateDirs = dateDirs(~ismember({dateDirs.name},{'.','..'}));

pastasHora = {'S_06', 'S_07', 'S_08', 'S_09', 'S_10', 'S_11', 'S_12',...
              'S_13', 'S_14', 'S_15', 'S_16', 'S_17'}; 

for dateIdx = 1:length(dateDirs)                                     % Loop through date folders
    dateDir = dateDirs(dateIdx).name;                                % Access current date folder
    tic;                                                             % Start timing

    for horaIdx = 1:12                                               % Loop through hourly folders
        pastaHora = pastasHora{horaIdx};                             
             
%%%%%%%%%%%%%%%%%%%%%%%%%%     REGISTRATION     %%%%%%%%%%%%%%%%%%%%%%%%%%%
        localDir = fullfile(mainDir, dateDir, pastaHora);            

        dirData = fullfile(mainDir);       

        files = dir(fullfile(localDir, '*.jpg'));                     % Get list of image files

        fixedImagePath = fullfile(localDir, files(1).name);           % Reference image (first image)
        fixedImage = imread(fixedImagePath);                          % Read reference image

        regDir = fullfile(localDir, 'Registradas');                % Create 'Registradas' folder
        if ~exist(regDir, 'dir')                                      
            mkdir(regDir);                                            
        end                                                           

        for i = 1:numel(files)                                        
            filePath = fullfile(localDir, files(i).name);             
            try
                image = imread(filePath);                             

                movingReg = f_registerImagesRet(image, fixedImage);   

                [~, fileName, ~] = fileparts(files(i).name);          
                outputFileName = [fileName '_registred.jpg'];         
                outputFilePath = fullfile(regDir, outputFileName);    

                imwrite(movingReg.RegisteredImage, outputFilePath);   

            catch exception
                disp(['Error processing file: ' files(i).name]);      
                disp(['Error message: ' exception.message]);          
            end                                                        
        end

%%%%%%%%%%%%%%%%%%%%%%%%     STATISTICS     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        resultDir = fullfile(pwd, 'data', 'sample_images', '01_Results');                % Output directory
        regFile = dir(fullfile(regDir, '*.jpg'));                     

        if isempty(regFile)                                           
            disp(['No files found in directory ' regDir]);            
            continue;                                                 
        end

        stImagem = imread(fullfile(regDir, regFile(1).name));         
        % sumMatrixMax = nan(size(stImagem));                          
        % sumMatrixMin = nan(size(stImagem));                          
        sumMatrixMed = zeros(size(stImagem));                         
        % sumMatrixStd = zeros(size(stImagem));                        
        % sumMatrix = zeros(size(stImagem));                           
        i=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%     MAXIMUM      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % for i = 1:numel(regFile)                                      
        %     imagemAtual = imread(fullfile(regDir, regFile(i).name));  
        %     sumMatrixMax = max(sumMatrixMax, double(imagemAtual));    
        % end                                                           
        % 
        % sumImage = uint8(sumMatrixMax);                               
        % [~, nomeImagem, ~] = fileparts(regFile(i).name);              
        % outputFilename = fullfile(resultDir, [nomeImagem '_imMax.png']);
        % imwrite(uint8(sumMatrixMax), outputFilename);                 

%%%%%%%%%%%%%%%%%%%%%%%%%%     MINIMUM    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % for i = 1:numel(regFile)                                      
        %     imagemAtual = imread(fullfile(regDir, regFile(i).name));  
        %     sumMatrixMin = min(sumMatrixMin, double(imagemAtual));    
        % end                                                           
        % 
        % [~, nomeImagem, ~] = fileparts(regFile(i).name);              
        % outputFilename = fullfile(resultDir, [nomeImagem '_imMin.png']);
        % imwrite(uint8(sumMatrixMin), outputFilename);                 

%%%%%%%%%%%%%%%%%%%%%%%%%%%     MEAN     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for i = 1:numel(regFile)                                      
            imagemAtual = imread(fullfile(regDir, regFile(i).name));  
            imAtualDB = double(imagemAtual);                          
            sumMatrixMed = sumMatrixMed + imAtualDB;                  
        end

        numIm = numel(regFile);                                       
        avgIm = uint8(sumMatrixMed/numIm);                            

        [~, nomeImagem, ~] = fileparts(regFile(i).name);              
        outputFilename = fullfile(resultDir, [nomeImagem '_imMed.png']);
        imwrite(uint8(avgIm), outputFilename);                        

%%%%%%%%%%%%%%%%%%%%%%%     STANDARD DEVIATION      %%%%%%%%%%%%%%%%%%%%%%%
        % for i = 1:numel(regFile)                                      
        %     imagemAtual = double(imread(fullfile(regDir,...          
        %                                          regFile(i).name))); 
        %     sumMatrix = sumMatrix + imagemAtual.^2;                   
        % end
        % 
        % stdIm = uint8(sqrt(sumMatrix/numIm - (sumMatrixMed/numIm).^2));
        % 
        % [~, nomeImagem, ~] = fileparts(regFile(i).name);              
        % outputFilename = fullfile(resultDir, [nomeImagem '_imDP.png']);
        % imwrite(uint8(stdIm), outputFilename);                        

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
deleteRawData = false; % Set true ONLY if you want to delete local raw data

if deleteRawData
    try
        dirToDelete = fullfile(dirData);
        rmdir(dirToDelete, 's');
        disp(['Directory ' dirToDelete ' successfully deleted.']);
    catch
        disp(['Error deleting directory ' dirToDelete '.']);
    end
end 