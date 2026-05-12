function xypm= camera_model(xym, cmp)
% CAMERA_MODEL defines image distortion model 
%   CAMERA_MODEL(XYM, CMP)defines image distortion model using camera  
%   intrinsic parameters obtained by the Matlab Calibration Toolbox stored 
%   in CMP structure (see Description of the calibration parameters from  
%   Camera Calibration Toolbox for Matlab):
%        FOCAL LENGTH: The focal length in pixels is stored in the 2x1 
%        vector fc. 
%        PRINCIPAL POINT: The principal point coordinates are stored in 
%        the 2x1 vector cc. 
%        SKEW COEFFICIENT: The skew coefficient defining the angle between 
%        the x and y pixel axes is stored in the scalar alpha_c. 
%        DISTORTIONS: The image distortion coefficients (radial and 
%        tangential distortions) are stored in the 5x1 vector kc. 
 
%   This function is used to define a tform structure in MAKETFORM function
%   using a custom model
%   Application example: 
%         load ('mobotix_m10') % read distortion parameters
%         f = @(x, cmp) camera_model(x, cmp);
%         tform = maketform('custom', 2, 2, [], f, cmp);
%         a = imread('E00001.jpg');
%         b = imtransform(a, tform, 'xdata', xdata, 'ydata', ydata);


fc = cmp.tdata.fc;
cc = cmp.tdata.cc;
kc = cmp.tdata.kc;
alpha_c = cmp.tdata.alpha_c;


xym2(:,1)= xym(:,1)/fc(1);
xym2(:,2)= xym(:,2)/fc(2);
n = length(xym2);
kk = [fc(1) alpha_c*fc(1) cc(1); 0 fc(2) cc(2); 0 0 1];

r = sqrt(sum(xym2'.^2));
x = xym2(:,1)';
y = xym2(:,2)';
mr= [1;1]*r;
dx = [2*kc(3).* x.* y + kc(4)*(r.^2+2*x.^2); kc(3)*(r.^2+2*y.^2)+2*kc(4).*x.*y];
xd = (1+ kc(1)*mr.^2 + kc(2)*mr.^4 + kc(5)*mr.^6).*xym2' + dx;

xypm = kk*[xd; ones(1,n)];
xypm = xypm(1:2, :)';

