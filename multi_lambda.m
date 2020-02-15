load('多样本.mat');

%InRandomdegs=linspace(0,180,1000);
lambda1=[432e-9,532e-9,632e-9];
d=10e-2;
f1=10e-2;
%InRandomdegs=[12.0,34.0,56.0,45.5,76.9,89.9,103.2,134.5,156.7];
degree=[45.5,65.5,89.7];
Einput=Einput1(:,:,1);
[M, N]=size(Einput);
L0=sqrt(min(lambda1)*d*(N));
widex=L0;   widey=widex;
%degree=zeros([3,length(InRandomdegs)]);
for Ir=1:length(lambda1) % calculate the diffraction images
   for i=1:length(degree)
       degree1=degree(i);
        lambda=lambda1(Ir);
        n=i+3*(Ir-1);
        Eouts(:,:,n)=abs( SCFR2(Einput,lambda, d, f1, f1, degree1, widex, widey) );
   end
       
%         degree(1,Ir)=Moment1(EinRDR);
%         degree(2,Ir)=180-RDR_Span(EinRDR,widex,widey,1, 0.001);
%         degree(3,Ir)=180-hough_Span(EinRDR,0.5, 0.001);
    
     
end
% error=degree-InRandomdegs;
 
%测角度
for i=1:length(degree)
    EinRDR=Eouts(:,:,i);
    degree2(1,i)=Moment1(EinRDR);
    degree2(2,i)=180-RDR_Span(EinRDR,widex,widey,1, 0.001);
    degree2(3,i)=180-hough_Span(EinRDR,0.5, 0.001);
end
error=degree2-degree;
%恢复
    Estart=ones(size(Einput));
    iteration=30;    
        for n=1:iteration
          for Ir=1:length(lambda1)
            for k=1:length(degree2(1,:))
                degree1=degree2(1,k);
                lambda=lambda1(Ir);
                Em=SCFR2(Estart, lambda, d, f1, f1, degree1, widex, widey);
                n1=k+3*(Ir-1);
                iEm(:,:,n1)=SCFR2( Eouts(:,:,n1).*exp(1i*angle(Em)), -lambda, f1,d, f1, degree1, widex, widey);
            end
          end
         
    
        Estart=mean(iEm, 3); % 取平均值

        MSE(1,n)=sum(sum(abs(mat2gray(abs(Einput))-mat2gray(abs( Estart ))).^2))./(size(Einput,1)* size(Einput,2));

        end
        E_retrieval(:,:,1)=Estart;
