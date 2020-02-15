function deg1=hough_Span(pattern0,span,d_deg)
% to calculate the most possible rotation degree or the angle of diffraction patterns
% the pattern is the input image, which can be rgb or gray
% the method is hough, please see hlep hough for details
% judge the input image  rgb or gray
%计算角度deg1=180-柱透镜真实角度
pattern0=abs(pattern0);

if length(size(pattern0))>2
    pattern=rgb2gray(pattern0);
else
    pattern=pattern0;
end

pattern1=im2double(pattern);
pattern2=pattern1/max(pattern1(:));
[m,n]=size(pattern2);
BW=im2bw(pattern2);
%BW=bwmorph(pattern2,'skel',Inf);
%直线检测
[H,theta,rho] = hough(BW,'ThetaRes',1,'RhoRes',1);
P = houghpeaks(H,1,'threshold',ceil(0.8*max(H(:))));
deg1= theta(P(:,2));
if (deg1-span<= -90 || deg1-span>= 90);  
else
    [H,theta,rho] = hough(BW,'Theta',deg1-span:d_deg:deg1+span);
    P = houghpeaks(H,1,'threshold',ceil(0.8*max(H(:))));
    deg1= theta(P(:,2));
    
end

deg1=90-deg1;

if deg1 >= 180
    deg1 =deg1-180;
end

