function [alpha,F,D,FD] = MRMLKSVM_train_v(Xtrain,Ytrain,v,xxx,r,C,opt,ker)
%m1: row number of samples.
train_num=2*xxx;  
huaX=Xtrain;
%%%  %Construct F=[f_1,...,f_(train_num)]
a=r*train_num;
D(1:a,1:a)=0;
for i1=1:r
    D((i1-1)*train_num+1:i1*train_num,(i1-1)*train_num+1:i1*train_num)=ker_v(huaX,v(:,i1),ker)*((v(:,i1))'*v(:,i1));
end
clear i1;
F(1:a,1:train_num)=0;
%for i1=1:train_num
%    F(:,i1)=[M_v(huaX,Xtrain{i1},v(:,1),ker)*v(:,1);M_v(huaX,Xtrain{i1},v(:,2),ker)*v(:,2)]; 
%end
for i1=1:train_num
    guodu=[];
    for j1=1:r
        guodu=[guodu;M_v(huaX,Xtrain{i1},v(:,j1),ker)*v(:,j1)];
    end
    F(:,i1)=guodu;
    clear guodu;
end
%%%  %end

%%%% %Construct FD¡£
FD(1:train_num,1:a)=0;
for i1=1:train_num
    FD(i1,:)=(F(:,i1))'*(D')^(-1);
end
%%%%


K=FD*F;  %F=[f1£¬f2£¬...£¬fn];
YY=diag(Ytrain);
H=YY*K*YY; %It should be YY*K*YY',but we use YY instead of YY'.
H=(H+H')/2;

%e=ones(train_num,1);
f=-ones(train_num,1);
Aeq=Ytrain';
Beq=0;
A=[];
B=[];
LB=zeros(train_num,1);
UB=C*ones(train_num,1);

[alpha]=quadprog(H,f,A,B,Aeq,Beq,LB,UB,[],opt);


