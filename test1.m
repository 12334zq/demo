load('多样本.mat');

%InRandomdegs=linspace(0,180,1000);
% lambda1=[432e-9,532e-9,632e-9];
d=10e-2;
f1=10e-2;
lambda=532e-9;
degree=[12.0,34.0,56.0,45.5,76.9,89.9,103.2,134.5,156.7];

Einput=Einput1(:,:,1);
[M, N]=size(Einput);
L0=sqrt(min(lambda)*d*(N));
widex=L0;   widey=widex;
%degree=zeros([3,length(InRandomdegs)]);

   for i=1:length(degree)
       degree1=degree(i);
        
        
        Eouts(:,:,i)=abs( SCFR2(Einput,lambda, d, f1, f1, degree1, widex, widey) );
   end
       
%         degree(1,Ir)=Moment1(EinRDR);
%         degree(2,Ir)=180-RDR_Span(EinRDR,widex,widey,1, 0.001);
%         degree(3,Ir)=180-hough_Span(EinRDR,0.5, 0.001);
    
     

% error=degree-InRandomdegs;
 
%测角度
% for i=1:length(degree)
%     EinRDR=Eouts(:,:,i);
%     degree2(1,i)=Moment1(EinRDR);
%     degree2(2,i)=180-RDR_Span(EinRDR,widex,widey,1, 0.001);
%     degree2(3,i)=180-hough_Span(EinRDR,0.5, 0.001);
% end
% error=degree2-degree;
%恢复
for i=1:length(degree)
    degree2(1,i)=degree(i);
    degree2(2,i)=degree(i)+0.025;
    degree2(3,i)=degree(i)+0.05;
    degree2(4,i)=degree(i)+0.075;
    degree2(5,i)=degree(i)+0.1;
    degree2(6,i)=degree(i)+0.2;
    degree2(7,i)=degree(i)+0.5;
end
    Estart=ones(size(Einput));
    iteration=30;   
    for i=1:7
        for n=1:iteration
          
            for k=1:length(degree)
                degree1=degree2(i,k);
                
                Em=SCFR2(Estart, lambda, d, f1, f1, degree1, widex, widey);
                
                iEm(:,:,k)=SCFR2( Eouts(:,:,k).*exp(1i*angle(Em)), -lambda, f1,d, f1, degree1, widex, widey);
            end
          
         
    
        Estart=mean(iEm, 3); % 取平均值

%         MSE(1,n)=sum(sum(abs(mat2gray(abs(Einput))-mat2gray(abs( Estart ))).^2))./(size(Einput,1)* size(Einput,2));
        end
        E_retrieval(:,:,i)=Estart;
        NCC(i)=roundn(corr2(double(abs(Einput)),double(abs(Estart))), -5);
        s(i)=ssim(abs(Einput),abs(Estart));
    end
