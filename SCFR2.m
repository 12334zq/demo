function Eout=SCFR(Ein, lambda, d1,d2, f, degree, widex, widey)
% to achieve single cylindrical lens Fresnel diffraction with different rotation degree
% S- single  C-cylindrical lens  F- Fresnel diffraction  R-rotation 2-simplified version

% Ein is the input image or pattern, gray image,   'double type'
% lambda is the wavelength of the illumination source
% d1 is the distance of the first Fresnel diffraction between the input plane and the front plane of cylindrical lens
% d2 is the distance of the second Fresnel diffraction between the back plane of the cylindrical lens and CCD plane
% f is the focal length of the cylindrical lens
% degree is the rotation degree, degree system [0 360]
% widex and widey is the physical size of the input image, this version is availiable for that widex is equal to widey

% firstly edited at 2018.04.15
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=2*pi/lambda;      [M0,N0]=size(Ein); 
E1=Ang_spetrum(Ein, lambda, widex, widey, d1); %——————the first Fresnel diffraction, define plane 1, represent by E1 

%——————for rotation, to magnify phase item of the cylindrical lens plane, define plane 2, represent by phasefc2
nlarge=5;  % magnified factor, when nlarge = 3 satisfy conditions 
wide2=widex*nlarge;   % enlarge the physical size of plane 2
M2=M0*nlarge;  %enlarge the number points of the plane 2
N2=N0*nlarge;    

n2=1:N2;   x2=-wide2/2+wide2/N2*n2;
y2=x2;   
[yy2, xx2]=meshgrid(y2, x2);

theta=degree*pi/180; % turn degree system to the radian system 
phasefc2n=exp( -i*k*( xx2*cos(theta)-yy2*sin(theta) ).^2/(2*f) );  % to calculate the phase distributio of the enlarged cylindrical len phase

%——————to match the plane 1, crop the enlarged plane 2 
x2min=ceil( (M2-M0)/2 );   y2min=ceil( (N2-N0)/2 );

mid_pfc=zeros(size(phasefc2n));  % to achieve to crop, define the middle plane
mid_pfc(x2min:x2min+M0-1, y2min:y2min+N0-1)=1;  % in the middle plane, the center area is 1, the rest is 0
phasefc2=phasefc2n.*mid_pfc;
phasefc2( find(phasefc2==0) )=[];% 把0元素赋值为 [] 以便更改其尺寸
phasefc=reshape(phasefc2, M0, N0); %after rotation and trim, the final cylindrcial len phase plane

%——————the plane of going through the cylindrical lens, define plane 3,represnt by E3
E3=E1.*phasefc;

%——————the second Fresnel diffraction between the back of cylindrical lens and CCD plane
%Eout=Fresnel2c(E3,lambda,wide3x,wide3y,d2);% calculate the diffraction pattern wiht D-FFT method
Eout=Ang_spetrum(E3,lambda,widex,widey,d2);% calculate the diffraction pattern wiht Ang_spetrum
 %显示
%  figure,subplot 221,imshow(abs(Ein),[]),axis off,title('样本振幅');
%  subplot 222,imshow(abs(E1),[]),axis off,title('透镜前表面振幅');
%  subplot 223,imshow(abs(E3),[]),axis off,title('透镜后表面振幅');
%  subplot 224,imshow(abs(Eout),[]),axis off,title('cmos记录振幅');
%  
 
