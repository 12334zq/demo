function deg1=RDR_Span(pattern0,widex,widey, span, d_deg)
% to calculate the most possible rotation degree or the angle of diffraction patterns 
% the pattern is the input image, which can be rgb or gray 
% widex/widey is the physical size of the image, which is defined by user
% the method is Radon, please see hlep radon for details
% the origin of both axes is the center pixel of the image, defined as floor((size(pattern)+1)/2)
% the output degree is defined by conuterclockwise from the positive x-axis
% degrees is a row vector 1x2, which is the span of the Scan degree
% d_deg is the scanning accuracy

% firstly edited at 2017.12.12 by Y.G in HIT

% judge the input image  rgb or gray
%计算角度deg1=180-柱透镜真实角度
pattern0=abs(pattern0);

if length(size(pattern0))>2
    pattern=rgb2gray(pattern0);
else
    pattern=pattern0;
end

[M, N]=size(pattern);
xm=1:M;
ym=1:N;

x=-widex/2+widex/M*xm;
y=-widey/2+widey/N*ym;

% Binary the gray image
%bwweight=0.5; % weight factor
%pattern1=im2bw(pattern,bwweight);

%after testing, cancle the binarization
se=strel('rectangle',[7,7]);
pattern1=pattern;

thetas=1:179;


pattern2=imerode(pattern1,se);

pattern2=pattern1;

%imshow(pattern2)
[R,xp]=radon(pattern2,thetas);
[a,b]=find(R==max(max(R)));


% fine Scanning ----------------------------------------------
thetas1=(b-span/2):d_deg:(b+span/2);

[R1,xp1]=radon(pattern2,thetas1);
[a1,b1]=find(R1==max(max(R1)));

%deg1=b1*d_deg+b-span/2;

%deg1=b/10+90;

deg1=b1*d_deg+ (b-span/2);

deg1=deg1+90;

if deg1>=180
    deg1=deg1-180;
end


%deg=b/100+90;
%if deg>=180
   % deg=deg-180; % the slope of the line
    %    deg=180-deg; % the rotation degree of the cylindrical lens
    %if deg==180
    %    deg=0;
        
    %end

%end

%figure(1)
%imshow(pattern0,'XData',x,'YData',y);








