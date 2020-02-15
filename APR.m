function Fi = APR(ft,Lambda,L,z0,d,number,I)
N=size(ft,1);
image_num=size(ft,3);

test=zeros(N,N,image_num);
ob=zeros(N,N,image_num);

for k=1:number
    for n=1:image_num   
        test(:,:,n)=Ang_spetrum(I,Lambda,L,L,z0+d*(n-1));
        ob(:,:,n)=Ang_spetrum(abs(ft(:,:,n)).*exp(1i*angle(test(:,:,n))),Lambda,L,L,-(z0+d*(n-1)));
    end

    I=mean(ob,3);
    if (mod(k,10)==0)
            fprintf('APR当前迭代次数:%d\r\n',k);
    end

end
Fi=I;