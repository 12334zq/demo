load('¶àÑù±¾.mat');

%InRandomdegs=linspace(0,180,1000);
lambda=532e-9;
d=10e-2;
f1=10e-2;
InRandomdegs=[12.0,34.0,56.0,45.5,76.9,89.9,103.2,134.5,156.7];
Einput=Einput1(:,:,5);
[M, N]=size(Einput);

Einput=Einput;
L0=sqrt(lambda*d*(N));
widex=L0;   widey=widex;
degree=zeros([3,length(InRandomdegs)]);
for Ir=1:length(InRandomdegs) % calculate the diffraction images
       
        degree1=InRandomdegs(Ir);
        Eouts(:,:,Ir)=abs( SCFR2(Einput,lambda, d, f1, f1, degree1, widex, widey) );
        EinRDR=Eouts(:,:,Ir);
       
        degree(1,Ir)=Moment1(EinRDR);
        degree(2,Ir)=180-RDR_Span(EinRDR,widex,widey,1, 0.001);
        degree(3,Ir)=180-hough_Span(EinRDR,0.5, 0.001);
    
     
end
error=degree-InRandomdegs;
Estart=ones([M,N]);
for i=1:30
    
    for n=1:length(InRandomdegs) 
        degree1=InRandomdegs(n);
        Em=SCFR2(Estart, lambda, d, f1, f1, degree1, widex, widey);
        iEm(:,:,n)=SCFR2( Eouts(:,:,n).*exp(1i*angle(Em)), -lambda, f1,d, f1, degree1, widex, widey);
    end

    Estart=mean(iEm,3);
    

end
subplot 121,imshow(abs(Estart),[]);
subplot 122,imshow(angle(Estart),[]);

 

