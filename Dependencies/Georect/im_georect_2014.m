function [c,cpz]=im_georect_2014(im0,Xc,cmp,m,xdatag,ydatag,pxr,slevel)
% 
% function [c,cpz]=im_georect_undistorted(im,xdata,ydata,Xc,cmp,m,xdatag,ydatag,pxr,slevel)
% 
% % Version updated in November 2013
% im-image in MAtlab format
% xdata,ydata-for image coordinates
% xdatag,ydatag-projection domain limits
% Xc-camera coordinates
% cmp-calibration parameters
% m-Rotation matrix
% pxr-resolution in pixels
% slevel-projection -Z level (can be one level or a structure with x, y, z
% for a DTM
% 
% Michalis Vousdoukas 2008

% fc = cmp.fc;             %Focal length obtained using matlab calibration toolbox
% f = mean(fc); 

% % undistort image
% [xdata,ydata,im]=undistort_image_2010(im0,cmp);

fc = cmp.fc;             %Focal length obtained using matlab calibration toolbox
f = mean(fc); 

% % undistort image
[xdata0,ydata0,im1]=undistort_image_2010(im0,cmp);

[c,cpz]=im_georect_undistorted(im1,cmp.xdata,cmp.ydata,Xc,cmp,m,xdatag,ydatag,pxr,slevel);
 
% cp.ext.Xc = Xc(:);
% cp.ext.m = m;
% cp.int = cmp;
% 
% % generate desired grid in world coordinates
% x0=xdatag(1):pxr:xdatag(2);
% y0=ydatag(1):pxr:ydatag(2);
% 
% [x2,y2]=meshgrid(x0,y0);
% 
% [s1,s2]=size(x2);
% 
% % Define elevations according to projection surface case
% if ~isstruct(slevel)
% 
%     cpz.mdt.data.Z = slevel;
%     cpz.mdt.data.X = NaN;
%     cpz.mdt.data.Y = NaN;
%     cpz.mdt.method = 'zlevel';
% 
%     z2=slevel*ones(size(x2));
% 
% else
%     
%     cpz.mdt.data.X = slevel.x;
%     cpz.mdt.data.Y = slevel.y;
%     cpz.mdt.data.Z = slevel.z;
%     
%     cpz.mdt.method = 'linear';
%     
%     z2 = interp2(slevel.x, slevel.y, slevel.z, x2,y2);
%     
% end
%     
% cpz.camera = cp;
% 
% 
% % converting values from world to image
% 
% x3=reshape(x2,s1*s2,1);
% y3=reshape(y2,s1*s2,1);
% z3=reshape(z2,s1*s2,1);
% 
% XYZ=[x3 y3 z3]';
% 
% % convert to u,v
% xy = colli(XYZ, cp);
% 
% 
% [i,j]=uv2ij_Georectify(xy(:,1),xy(:,2),size(im0,1),size(im0,2),cmp);
% 
% u1=reshape(i,s1,s2);
% v1=reshape(j,s1,s2);
% 
% % sample pixel intensities from grid
% for i=1:size(im0,3)
%     
% %     nim(:,:,i)=interp2(1:size(im0,1),1:size(im0,2),double(im0(:,:,i)),u1,v1);
%         nim(:,:,i)=interp2(xdata(1):xdata(2),ydata(1):ydata(2),double(im0(:,:,i)),u1,v1);
% 
% end
% 
% % Final image
% c=uint8(nim);

