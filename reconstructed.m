load MultiSamples_DataExp1221_ShiftData20181221.mat
    %  'M', 'N',  'RadonDegrees', 'NumChecks', 'SEs_HITs', 'SEs_TLs', 'ShiftHITs', 'ShiftTLs'

    iteration=50;   
    d1=12e-2;
    d2=12e-2;
    f=10e-2;
    lambda=532e-9;
    
    L0=sqrt(lambda*d1*(N)); %FFT计算时同时满足振幅及相位取样条件的物光场宽度!!!!!
    widex=L0;   widey=widex;
    
    k=2*pi/lambda; 
        
     Estart1=ones(M, N);      Estart2=Estart1; 
    iEout1=zeros(M, N, length(NumChecks));     iEout2=iEout1;
    
%     取振幅
   % SEs_HITs=sqrt(SEs_HITs);  SEs_TLs=sqrt(SEs_TLs); 
%NumChecks=a;%[ 5     7  8  11    12    13    14    15    16    17    23    25   ]
     for n=1:iteration % loop for phase retrieval
        for k=1:length(NumChecks)
            
             degOut=degree(2,NumChecks(k));  
             % 'SEs_Fs', 'SEs_34s', 'SEs_G34s', 'SEs_GG34s','SEs_HITs', 'SEs_R34s'
             %校准后衍射图重构 Fs
            shiftEm1=SCFR2(Estart1, lambda, d1, d2, f, degOut, widex, widey) ; 
             iEout1(:,:,k) = SCFR2(SEs_HITs(:,:, k).*exp(1i*angle(shiftEm1)), -lambda, d2, d1, f, degOut, widex, widey); 
% % %              
  %            shiftEm2=SCFR2(Estart2, lambda, d1, d2, f, degOut, widex, widey) ; 
 %            iEout2(:,:,k) = SCFR2(SEs_TLs(:,:, k).*exp(1i*angle(shiftEm2)), -lambda, d2, d1, f, degOut, widex, widey); 

        end

        Estart1=mean(iEout1, 3); n       
      % Estart2=mean(iEout2, 3); n         
                     
                
       % figure(4);  imshowpair(abs(Estart1), angle(Estart1), 'montage'); 
       % figure(2);  imshowpair(abs(Estart2), angle(Estart2),    'montage');  
    
%         filename='MultSample_DirectionReconstructionData20181221.mat';
%         save(filename, 'Estart1', 'Estart2',  'RadonDegrees', 'NumChecks', 'SEs_HITs', 'SEs_TLs','iteration');
         
     end      
                          
