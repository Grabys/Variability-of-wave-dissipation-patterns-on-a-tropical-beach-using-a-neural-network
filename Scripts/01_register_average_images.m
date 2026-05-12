%%%%%%%%%%%%%%%%%%%%%%% REGISTRATION OF AVERAGE IMAGES %%%%%%%%%%%%%%%%%%%%%%%
% Accesses the previously generated average images and performs a new
% registration, now between one average image and another.
% The registration is based on geometries defined for each year, and an
% additional geometry defined for the last two hours of the day (16h and 17h).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

basePath = pwd;

imagesFolder = fullfile(basePath, 'data', 'sample_images', '02_Medias');
outputFolder = fullfile(basePath, 'data', 'sample_images', '03_Registradas');

addpath(fullfile(basePath, 'dependencies', 'register'));

if ~isfolder(outputFolder)
    mkdir(outputFolder);
end

files = dir(fullfile(imagesFolder, '*.png'));

%%%%%%%%% Reference images for registration function %%%%%%%%% 
fixedImageMed3File = 'PTG1_10_10_216_213_2013_09_17_13_05_27_379_registred_imMed.png'; % 2013
fixedImageMed3Path = fullfile(imagesFolder, fixedImageMed3File);
fixedImage3 = imread(fixedImageMed3Path);
                                                                                                    
fixedImageMed31617hFile = 'PTG1_10_10_216_213_2013_09_18_16_10_58_256_registred_imMed.png';
fixedImageMed31617hPath = fullfile(imagesFolder, fixedImageMed31617hFile);
fixedImage31617h = imread(fixedImageMed31617hPath);

fixedImageMed4File = 'PTG1_10_10_216_213_2014_01_01_06_10_59_729_registred_imMed.png'; % 2014
fixedImageMed4Path = fullfile(imagesFolder, fixedImageMed4File);
fixedImage4 = imread(fixedImageMed4Path);

fixedImageMed41617hFile = 'PTG1_10_10_216_213_2014_01_02_16_10_59_525_registred_imMed.png';
fixedImageMed41617hPath = fullfile(imagesFolder, fixedImageMed41617hFile);
fixedImage41617h = imread(fixedImageMed41617hPath);

fixedImageMed5File = 'PTG1_10_10_216_213_2015_01_12_14_10_59_672_registred_imMed.png'; % 2015
fixedImageMed5Path = fullfile(imagesFolder, fixedImageMed5File);
fixedImage5 = imread(fixedImageMed5Path);
                                                                                                    
fixedImageMed51617hFile = 'PTG1_10_10_216_213_2015_06_18_16_10_59_746_registred_imMed.png';
fixedImageMed51617hPath = fullfile(imagesFolder, fixedImageMed51617hFile);
fixedImage51617h = imread(fixedImageMed51617hPath);

fixedImageMed6File = 'PTG1_10_10_216_213_2016_01_18_14_10_59_678_registred_imMed.png'; % 2016
fixedImageMed6Path = fullfile(imagesFolder, fixedImageMed6File);
fixedImage6 = imread(fixedImageMed6Path);
                                                                                                    
fixedImageMed61617hFile = 'PTG1_10_10_216_213_2016_01_18_16_10_59_603_registred_imMed.png';
fixedImageMed61617hPath = fullfile(imagesFolder, fixedImageMed61617hFile);
fixedImage61617h = imread(fixedImageMed61617hPath);

fixedImageMed7File = 'PTG1_10_10_216_213_2017_01_01_11_10_59_760_registred_imMed.png'; % 2017
fixedImageMed7Path = fullfile(imagesFolder, fixedImageMed7File);
fixedImage7 = imread(fixedImageMed7Path);
                                                                                                    
fixedImageMed71617hFile = 'PTG1_10_10_216_213_2017_01_01_16_10_59_777_registred_imMed.png';
fixedImageMed71617hPath = fullfile(imagesFolder, fixedImageMed71617hFile);
fixedImage71617h = imread(fixedImageMed71617hPath);

for i = 1:length(files)                                                       % Loop for registering average images
    filePath = fullfile(imagesFolder, files(i).name);                          
    
    image = imread(filePath);                                                 
    
    fileInfo = split(files(i).name, '_');                                     % Extract date information from filename
    year = str2double(fileInfo{6});                                           % Year
    
    if year == 2013                                                           % Conditional registration by year
        try                                                                  
            movingReg = f_registerImagesMed3(image, fixedImage3);             
        catch ME
            try
                movingReg = f_registerImagesMed367(image,fixedImage31617h);   
            catch ME2
                continue
            end
        end
    elseif year == 2014
        try
            movingReg = f_registerImagesMed4(image, fixedImage4);             
        catch ME
            try
                movingReg = f_registerImagesMed467(image,fixedImage41617h);   
            catch ME2
                continue
            end
        end
    elseif year == 2015
        try
            movingReg = f_registerImagesMed5(image, fixedImage5);             
        catch ME
            try
                movingReg = f_registerImagesMed567(image,fixedImage51617h);   
            catch ME2
                continue
            end
        end
    elseif year == 2016
        try
            movingReg = f_registerImagesMed6(image, fixedImage6);             
        catch ME
            try
                movingReg = f_registerImagesMed667(image,fixedImage61617h);   
            catch ME2
                continue
            end
        end 
    elseif year == 2017
        try
            movingReg = f_registerImagesMed7(image, fixedImage7);             
        catch ME
            try
                movingReg = f_registerImagesMed767(image,fixedImage71617h);   
            catch ME2
                continue
            end
        end    
    else
        disp(['Error processing image ' files(i).name]);
        continue;                                                            
    end
    
    [~, fileName, ~] = fileparts(files(i).name);                              
    outputFileName = [fileName '_registred.png'];                             
    outputFilePath = fullfile(outputFolder, outputFileName);   
    
    imwrite(movingReg.RegisteredImage, outputFilePath);                       
end