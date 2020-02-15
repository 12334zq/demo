function degree=Moment1(pattern0)
%计算角度theta=真实旋转角度
theta=Moment(pattern0);
%针对某些角度计算误差大采用旋转图像后再侧
if abs(theta-90)<5 || abs(theta-180)<5 || abs(theta-0)<5 || abs(theta-135)<0.4 || abs(theta-45)<3
    [m,n]=size(pattern0);
    pattern0=imrotate(pattern0,15,'bicubic');
    pattern0=imresize(pattern0,[m n]);
    degree=Moment(pattern0)+15;

else
    degree=theta;
end
end
function theta=Moment(pattern0)
%利用图像矩法测角度
pattern0=abs(pattern0);

if length(size(pattern0))>2
    pattern=rgb2gray(pattern0);
else
    pattern=pattern0;
end
im=pattern/max(pattern(:));%灰度值归一化
BW=im2bw(im);
%找到测量点集
% [Dx,Dy,Dxx,Dxy,Dyy] = Hessian2D(im,5);
% [eigenvalue1, eigenvalue2, eigenvectorx, eigenvectory]=eig2image(Dxx, Dxy, Dyy);
% temp1=max(abs(eigenvalue1), abs(eigenvalue2));
% temp2=min(abs(eigenvalue1), abs(eigenvalue2));
[m,n]=size(pattern0);
a=zeros(m,n);
for i=1:m
    for j=1:n
        if  BW(i,j)==1
            a(i,j)=im(i,j);
        end
    end
end

%利用hu矩计算角度
m00 = hu (0,0,a);
m10 = hu (1,0,a);
m01 = hu (0,1,a);
m11 = hu (1,1,a);
m02 = hu (0,2,a);
m20 = hu (2,0,a);
xc=m10/m00;
yc=m01/m00;
a=m20/m00-xc^2;
b=m11/m00-xc*yc;
c=m02/m00-yc^2;
theta=90-atan2(2*b,a-c)*90/pi;

if theta>180
    theta=theta-180;
end
end


function [Dx,Dy,Dxx,Dxy,Dyy] = Hessian2D(I,Sigma)

if nargin < 2, Sigma = 1; end

% Make kernel coordinates
[X,Y]   = ndgrid(-round(3*Sigma):round(3*Sigma));

% Build the gaussian 2nd derivatives filters
DGaussx  = 1/(2*pi*Sigma^4)*(-X).* exp(-(X.^2 + Y.^2)/(2*Sigma^2));
DGaussy  = 1/(2*pi*Sigma^4)*(-Y).* exp(-(X.^2 + Y.^2)/(2*Sigma^2));
DGaussxx = 1/(2*pi*Sigma^4) * (X.^2/Sigma^2 - 1) .* exp(-(X.^2 + Y.^2)/(2*Sigma^2));
DGaussxy = 1/(2*pi*Sigma^6) * (X .* Y)           .* exp(-(X.^2 + Y.^2)/(2*Sigma^2));
DGaussyy = DGaussxx';

Dx  = imfilter(I,DGaussx,'conv');
Dy  = imfilter(I,DGaussy,'conv');
Dxx = imfilter(I,DGaussxx,'conv');
Dxy = imfilter(I,DGaussxy,'conv');
Dyy = imfilter(I,DGaussyy,'conv');
end

function [Lambda1,Lambda2,Ix,Iy]=eig2image(Dxx,Dxy,Dyy)
% This function eig2image calculates the eigen values from the
% hessian matrix, sorted by abs value. And gives the direction
% of the ridge (eigenvector smallest eigenvalue) .
% 
% [Lambda1,Lambda2,Ix,Iy]=eig2image(Dxx,Dxy,Dyy)
%

%
% | Dxx  Dxy |
% |          |
% | Dxy  Dyy |


% Compute the eigenvectors of J, v1 and v2
tmp = sqrt((Dxx - Dyy).^2 + 4*Dxy.^2);
v2x = 2*Dxy; v2y = Dyy - Dxx + tmp;

% Normalize
mag = sqrt(v2x.^2 + v2y.^2); i = (mag ~= 0);
v2x(i) = v2x(i)./mag(i);
v2y(i) = v2y(i)./mag(i);

% The eigenvectors are orthogonal
v1x = -v2y; 
v1y = v2x;

% Compute the eigenvalues
mu1 = 0.5*(Dxx + Dyy + tmp);
mu2 = 0.5*(Dxx + Dyy - tmp);

% Sort eigen values by absolute value abs(Lambda1)<abs(Lambda2)
check=abs(mu1)>abs(mu2);

Lambda1=mu1; Lambda1(check)=mu2(check);
Lambda2=mu2; Lambda2(check)=mu1(check);

Ix=v1x; Ix(check)=v2x(check);
Iy=v1y; Iy(check)=v2y(check);
end


function [mpq,upq,npq] = hu (p,q,pattern0)
pattern0=double(pattern0);
[width ,height]=size(pattern0);
mpq=0;upq=0;
m00=0;m10=0;m01=0;
for i=1:width
    for j=1:height
        m00=m00 +  pattern0(i,j);
        m10=m10 + i* pattern0(i,j);
        m01=m01 + j* pattern0(i,j);
    end
end
avei=m10/m00;avej=m01/m00;
for i=1:width
    for j=1:height
        mpq=mpq + (i^p)*(j^q)* pattern0(i,j);
        upq=upq + ((i-avei)^p)*((j-avej)^q)*pattern0(i,j);
    end
end
npq=upq/(m00^((p+q)/2));
end

