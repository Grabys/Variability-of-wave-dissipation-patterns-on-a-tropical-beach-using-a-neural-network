%%%%%%%%%%%%%%%%%%%%%%%%     RECTIFICATION     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Transforms oblique images into plan-view images using collinearity equations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

basePath = pwd;

% PATHS
inputDir   = fullfile(basePath, 'data', 'sample_images', '03_Registradas');
resultDir  = fullfile(basePath, 'data', 'sample_images', '04_Retificadas');
rejectedDir = fullfile(resultDir, 'outliers');

geoDir = fullfile(basePath, 'data', 'calibration');

addpath(fullfile(basePath, 'dependencies', 'georect'));

if ~isfolder(resultDir)
    mkdir(resultDir);
end

if ~isfolder(rejectedDir)
    mkdir(rejectedDir);
end

% LOAD PARAMETERS
load(fullfile(geoDir,'georect_parameters_rot10_10_216_213_2013_09_24.mat'));

% FILE LIST
flist = dir(fullfile(inputDir, '*.png'));

xdatag_orig = geo_params.xdatag;
ydatag_orig = geo_params.ydatag;

% PROCESSING LOOP
for i = 1:length(flist)
    
    geo_params.xdatag = xdatag_orig;
    geo_params.ydatag = ydatag_orig;
    
    im0 = imread(fullfile(inputDir, flist(i).name));
    [~, fileName, ~] = fileparts(flist(i).name);

    media = nanmean(im0(:));
    
    if media >= 103 && media <= 145
        
        % Adjust domain
        geo_params.xdatag = geo_params.xdatag + [-100 700];
        geo_params.ydatag = geo_params.ydatag + [-150 1050];
        
        % Parameters
        Xc = geo_params.Xc;
        cmp = geo_params.cmp;
        m   = geo_params.R;
        ydatag = geo_params.ydatag;
        xdatag = geo_params.xdatag;
        pxr = 0.5;
        lev = 0;

        % Rectification
        [c, cpz] = im_georect_2014(im0, Xc, cmp, m, xdatag, ydatag, pxr, lev);
       
        outputFilename = fullfile(resultDir, [fileName '_rectified.png']);
        imwrite(c, outputFilename);
        
    else
        rejectedFilename = fullfile(rejectedDir, [fileName '_rejected.png']);
        imwrite(im0, rejectedFilename);
        
        disp(['Image ' flist(i).name ' rejected (mean out of range).']);
        
        delete(fullfile(inputDir, flist(i).name));
    end
end