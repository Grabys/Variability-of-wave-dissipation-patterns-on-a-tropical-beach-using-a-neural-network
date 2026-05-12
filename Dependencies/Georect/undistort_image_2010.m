function [xdata,ydata,nim]=undistort_image_2010(im,cmp)
% function [xdata,ydata,nim]=undistort_image_2010(im,cmp)
%Correct the image distortion using the extrinsic parameters (in Camera_model fuction) obtained by Matlab Calibraion
%Tollbox 

fn=fieldnames(cmp);

if ~isempty(strmatch('xdata',strvcat(fn),'exact'))
   
    xdata=cmp.xdata;
    ydata=cmp.ydata;
    
else
   
    xdata = [-1300,1300;];
    ydata = [-900,900;];
    
end

    

% ni = input ('Insert image number = '); %number of the image 
pxr = 1; 

% profile on
% tic
f = @(x, cmp) camera_model(x, cmp);

% xdata = [-1278.63900000000,826.413000000000;];
% ydata = [-722.361000000000,870.435000000000;];

tform = maketform('custom', 2, 2, [], f, cmp);
nim = imtransform(im, tform, 'xdata', xdata, 'ydata', ydata, 'xyscale', pxr);
