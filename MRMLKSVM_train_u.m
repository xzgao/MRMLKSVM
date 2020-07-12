function [beta,G,Q,GQ] = MRMLKSVM_train_u(Xtrain,Ytrain,phi,xxx,r,C,m2,opt,v,ker)
train_num=2*xxx; 
huaX=Xtrain;
%%% %Construct G=[g_1,...,g_n]
a=r*m2;
Qu(1:a)=0;
for i1=1:r
    Qu((i1-1)*m2+1:i1*m2)=(phi(:,i1))'*ker_v(huaX,v(:,i1),ker)*phi(:,i1);
end
clear i1;
Q=diag(Qu);

G(1:a,1:train_num)=0;
%for i1=1:train_num
%    G(:,i1)=[(M_v(huaX,Xtrain{i1},v(:,1),ker))'*phi(:,1);(M_v(huaX,Xtrain{i1},v(:,2),ker))'*phi(:,2)];
%end
for i1=1:train_num
    guodu=[];
    for j1=1:r
        guodu=[guodu;(M_v(huaX,Xtrain{i1},v(:,j1),ker))'*phi(:,j1)];
    end
    G(:,i1)=guodu;
    clear guodu;
end
%%% %end

%%% %ππ‘ÏGQ.
GQ(1:train_num,1:a)=0;
for i1=1:train_num
    GQ(i1,:)=(G(:,i1))'*(Q')^(-1);
end
%%% %end

K=GQ*G;
YY=diag(Ytrain);
H=YY*K*YY;
H=(H+H')/2;


e=ones(train_num,1);
f=-e;
Aeq=Ytrain';
Beq=0;
A=[];
B=[];
LB=zeros(train_num,1);
UB=C*ones(train_num,1);


[beta]=quadprog(H,f,A,B,Aeq,Beq,LB,UB,[],opt);


