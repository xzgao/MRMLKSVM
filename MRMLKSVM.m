function [pre] = MRMLKSVM(number1,number2,xxx,Temp,opt,sigma)
%%%%%%%
%number1£ºThe first class data.
%number2£ºThe second class data.
%xxx£ºThe number of training samples.
%%%%%%%%

r = 6;
ker.type = 'rbf'; %poly
%sigma=0.1768;
ker.pars = sigma;
I1=Temp(number1,:);
J1=Temp(number2,:);

%%%%
%ker='linear'
[Classnum,Picnum]=size(Temp);
c = 0.07;
%c=0.125;
%%%%
NUM = 20 % Number of iterations
[n,m]=size(J1{1});   % The size of each element. Where n represents the row number of each sample, m represents the column number of each sample.
myeps=1e-3;
train_num=2*xxx;     % Total number of training samples.

%%% ½»²æÑéÖ¤
I=I1(:,1:xxx);   % Extract the first "xxx" samples as the training set. 
J=J1(:,1:xxx);

%%%%%%
%Initialization
v0=0.1*ones(m,r);
phi0=zeros(train_num,r);
Xtrain=[I,J];          %Note: this is cell data.
Ytrain=[ones(xxx,1);-ones(xxx,1)];
%%%%%%

for xx1=1:NUM
    %%%%%%
    [alpha_v0,F_v0,D_v0,FD_v0] = MRMLKSVM_train_v(Xtrain,Ytrain,v0,xxx,r,c,opt,ker);
    %%%%%%
    
    %%%  %Solve phi1
    Fd(1:r*train_num,1:train_num)=0; %Fd=[D^-1*f1_mao,...,D^-1*fn_mao];
    for i1=1:train_num
        Fd(:,i1)=(D_v0)^(-1)*F_v0(:,i1);
    end
    phi1_lie=Fd*((alpha_v0)'*diag(Ytrain))';
    phi1=reshape(phi1_lie,[train_num,r]);
    %%%  %end
    
    [beta_u1,G_u1,Q_u1,GQ_u1] = MRMLKSVM_train_u(Xtrain,Ytrain,phi1,xxx,r,c,m,opt,v0,ker);
    
    %%% %Solve v1
    Gq(1:r*m,1:train_num)=0;
    for i1=1:train_num
        Gq(:,i1)=(Q_u1)^(-1)*G_u1(:,i1);
    end
    v1_lie=Gq*((beta_u1)'*diag(Ytrain))';
    v1=reshape(v1_lie,[m,r]);
    %%% %end
    
    %%%
    %
    
    if((norm(phi1-phi0)<myeps) && (norm(v1-v0)<myeps))
        break;
    end
    
    phi0=phi1;                                                                     
    v0=v1;
    
    
    
end
%%%
fprintf('The number of iterations is: \n',xx1);  
%%%
nnn=r*train_num;

phi=phi1;
v=v1;
alpha=alpha_v0;
beta=beta_u1;
F=F_v0;
G=G_u1;
%%%%
%Solve b.
epsilon=1e-12;
%%%
[id]=find(alpha>=epsilon);
x1=id(1);
fprintf('The first %d element in alpha is non-zero\n',x1);
b_alpha=Ytrain(x1)-alpha'*diag(Ytrain)*FD_v0*F(:,x1);
%%%
[idd]=find(beta>=epsilon);
x2=idd(1);
fprintf('The first %d element in beta is non-zero\n',x2);
b_beta=Ytrain(x2)-beta'*diag(Ytrain)*GQ_u1*G(:,x2);
%%%
b=(b_alpha+b_beta)/2;
%%%%

%%%  test
%%%  test
Xtest={};
Temp_test=Temp(:,xxx+1:Picnum);
for i1=1:Classnum
    B=Temp_test(i1,:);
    Xtest=[Xtest,B];
end

[pre] = MRMLKSVM_test(Classnum,Picnum,xxx,Xtest,phi,v,b,number1,number2,Xtrain,nnn,ker,r);


