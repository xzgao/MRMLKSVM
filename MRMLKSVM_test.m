function [pre] = MRMLKSVM_test(Classnum,Picnum,xxx,Xtest,phi,v,b,number1,number2,Xtrain,c,ker,r)

huaX=Xtrain;
pre=zeros();
a=Picnum-xxx;
for i1=1:a*Classnum
    guodu=[];
    for j1=1:r
        guodu=[guodu;M_v(huaX,Xtest{i1},v(:,j1),ker)*v(:,j1)];
    end
    F=guodu;
    clear guodu;
    phi_lie=reshape(phi,[c,1]);
    phi_hang=phi_lie';
    f=phi_hang*F+b;
    if(f>=0)
        pre(i1,1)=number1;
    else
        pre(i1,1)=number2;
    end
end

%acc=sum(pre==Ytest)/numel(Ytest);