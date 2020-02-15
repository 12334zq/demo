clc; clear all;      

%% simulation experiment 

         lambda=532e-9;
         d=10e-2;
         f1=10e-2; 
         ROI=imread('test1.jpg');ROI=rgb2gray(ROI);ROI=double(ROI);Amp1=zeros([512,512]);
         Einput1=imread('cameraman.tif');Einput1=double(Einput1);Amp1(1:100,1:256)=ROI(75:174,:);Amp1(101:end,1:512)=imresize(Einput1,[412,512]);
         Einput2=imread('wagon.jpg');Einput2=rgb2gray(Einput2);Einput2=double(Einput2);
         Amp2=zeros([512,512]);Amp2(1:100,1:256)=ROI(75:174,:);Amp2(101:end,1:512)=imresize(Einput2,[412,512]);
         Einput3=imread('laure.jpg');Einput3=rgb2gray(Einput3);Einput3=double(Einput3);
         Amp3=zeros([512,512]);Amp3(1:100,1:256)=ROI(75:174,:);Amp3(101:end,1:512)=imresize(Einput3,[412,512]);
         [M, N]=size(Amp1);
         x=[73,163];y=[89,170];%公共区域Einput1(89:170,73:163,1)
         L0=sqrt(lambda*d*(N));
         widex=L0;   widey=widex; 
         phase0=1;   phase=pi*phase0/max(max(phase0));
        amp1=0.7*(Amp1-(min(min(Amp1))))/max(max(Amp1))+0.3; 
        amp2=0.7*(Amp2-(min(min(Amp2))))/max(max(Amp2))+0.3;
        amp3=0.7*(Amp3-(min(min(Amp3))))/max(max(Amp3))+0.3;
        Einput(:,:,1)=amp1.*exp(1i*phase);
        Einput(:,:,2)=amp2.*exp(1i*phase);
        Einput(:,:,3)=amp3.*exp(1i*phase);
        [M, N,w]=size(Einput);
        
        %%  生成衍射图
        InRandomdegs=[12,56,76.9,103.2,156.7];
        Eouts=zeros([M,N,length(InRandomdegs),w]);
        for i=1:w
            for j=1:length(InRandomdegs)
                degree=InRandomdegs(j);
                Eouts(:,:,j,i)=abs( SCFR2(Einput(:,:,i),lambda, d, f1, f1, degree, widex, widey) );
                test_degree(i,j)=Moment1(Eouts(:,:,j,i));
            end
        end
       mean_degree=mean(test_degree(1:3,:)); 
       %%  重建样本振幅
       iteration=15; Estart=ones(size(Einput));
       for i=1:iteration
           for j=1:w
               for u=1:length(mean_degree)
                   degree1=mean_degree(u);
                   Em=SCFR2(Estart(:,:,j), lambda, d, f1, f1, degree1, widex, widey);
                   iEm(:,:,u)=SCFR2( Eouts(:,:,u,j).*exp(1i*angle(Em)), -lambda, f1,d, f1, degree1, widex, widey);
               end
                Estart(:,:,j)=mean(iEm, 3); % 取平均值
                NCC(j,i)=roundn(corr2(double(abs(Einput(:,:,j))),double(abs(Estart(:,:,j)))), -5);
                MSE(j,i)=sum(sum(abs(mat2gray(abs(Einput(:,:,j)))-mat2gray(abs(Estart(:,:,j)))).^2))./(size(Einput,1)* size(Einput,2));
                if j<w
                    Estart(1:100,1:256,j+1)=Estart(1:100,1:256,j);%%公共区域更新
                else
                    Estart(1:100,1:256,1)=Estart(1:100,1:256,w);
                end
           end
          if mod(i,5)==0
              figure,subplot 131,imshow(abs(Estart(:,:,1))),title(NCC(1,i));
               subplot 132,imshow(abs(Estart(:,:,2))),title(NCC(2,i));
               subplot 133,imshow(abs(Estart(:,:,3))),title(NCC(3,i));
          end
       end
       %%  单个重建样本振幅
       iteration=15; Estart1=ones(size(Einput));
       for i=1:iteration
           for j=1:w
               for u=1:length(mean_degree)
                   degree1=mean_degree(u);
                   Em=SCFR2(Estart1(:,:,j), lambda, d, f1, f1, degree1, widex, widey);
                   iEm(:,:,u)=SCFR2( Eouts(:,:,u,j).*exp(1i*angle(Em)), -lambda, f1,d, f1, degree1, widex, widey);
               end
                Estart1(:,:,j)=mean(iEm, 3); % 取平均值
                NCC1(j,i)=roundn(corr2(double(abs(Einput(:,:,j))),double(abs(Estart1(:,:,j)))), -5);
                MSE1(j,i)=sum(sum(abs(mat2gray(abs(Einput(:,:,j)))-mat2gray(abs(Estart1(:,:,j)))).^2))./(size(Einput,1)* size(Einput,2));
%                 if j<w
%                     Estart(89:170,73:163,j+1)=Estart(89:170,73:163,j);%%公共区域更新
%                 else
%                     Estart(89:170,73:163,1)=Estart(89:170,73:163,j);
%                 end
           end
          if mod(i,5)==0
              figure,subplot 131,imshow(abs(Estart1(:,:,1))),title(NCC1(1,i));
               subplot 132,imshow(abs(Estart1(:,:,2))),title(NCC1(2,i));
               subplot 133,imshow(abs(Estart1(:,:,3))),title(NCC1(3,i));
          end
       end
%      % figure,plot(1:15,log10(MSE1(3,:))),hold on,plot(1:15,log10(MSE1(6,:)))
figure,subplot 331,imshow(abs(Estart(:,:,1))),title(NCC(1,15));
subplot 332,imshow(abs(Estart1(:,:,1))),title(NCC1(1,15));
subplot 333,plot(1:15,log10(MSE(1,:)));hold on,plot(1:15,log10(MSE1(1,:)))

subplot 334,imshow(abs(Estart(:,:,2))),title(NCC(2,15));
subplot 335,imshow(abs(Estart1(:,:,2))),title(NCC1(2,15));
subplot 336,plot(1:15,log10(MSE(2,:)));hold on,plot(1:15,log10(MSE1(2,:)))

subplot 337,imshow(abs(Estart(:,:,3))),title(NCC(2,15));
subplot 338,imshow(abs(Estart1(:,:,3))),title(NCC1(2,15));
subplot 339,plot(1:15,log10(MSE(3,:)));hold on,plot(1:15,log10(MSE1(3,:)))