function xy = colli(XYZ, cp)
% function xy = colli(XYZ, cp,varargin)
% Converts from world XYZ to undistorted image xy
% 
% XYZ-    a matrix with lines corresponding to x, y, z world coordinates of the points
% cp-  the camera parameters (cp.ext.Xc; cp.int.fc; cp.ext.m)
% 
% Ana N. Silva, Michalis Vousdoukas 2008

Xc = cp.ext.Xc;
fc = cp.int.fc;
m = cp.ext.m;

xi = m * (XYZ - Xc * ones(1, length(XYZ)));          % equation 1 Slightly modified (Holland, 1997)

xy(1,:) = (xi(1,:) ./ xi(3,:)*-fc(1));          % image coordinates equation 2 (Holland, 1997)
xy(2,:) = (xi(2,:) ./ xi(3,:)*-fc(2));       


xy = xy';
