%

%load woman;
X=abs(c(:,:));
% x1=572;x2=533;
% y1=251;y2=292;
%  x1=557;x2=586;
%  y1=288;y2=320;
x1=501;x2=545;
y1=279;y2=223;
figure,imshow(X,[]);axis off
hold on
plot([x1,x2],[y1,y2],'r');
N=round(abs([x1-x2]+1i*[y1-y2]));
xn=linspace(x1,x2,N+1);
yn=linspace(y1,y2,N+1);

[M1,N1]=size(X);
[x,y]=meshgrid(1:N1,1:M1);
Vn=interp2(x,y,X,xn,yn);
zn=xn+1i*yn;
Ang1=angle([x1-x2]+1i*[y1-y2]);
Vnd=Vn-min(Vn);Vnd=Vnd+max(Vnd)/20;
zn=zn+Vnd*exp(1i*[Ang1-pi/2])/4;
plot(zn,'b','Linewidth',0.5);

A1=axes('Position',[315,673,121,515]);
figure,plot(Vnd,'Linewidth',1.5,'Color','b');
set(A1,'Color','None');
