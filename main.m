function [acc]=main(Temp,xxx,opt,sigma)
%one vs one
%%%%%

[Classnum,Picnum]=size(Temp);
Test_num = Picnum-xxx;   % Number of test samples.
a=0;
pre_all=[];
for loop1=1:(Classnum-1)
    for loop2=(loop1+1):Classnum
        a=a+1;
        [pre] = MRMLKSVM(loop1,loop2,xxx,Temp,opt,sigma);
        pre_all(:,a)=pre;
    end
end
%%%%%
pre_final=[];
for i1=1:Classnum*Test_num                                                             
    table=tabulate(pre_all(i1,:));
    [maxCount,idx]=max(table(:,2));
    pre_final(i1,1)=table(idx);
end
%%%
Ytest=[];
for i1=1:Classnum
    A=i1*ones(Test_num,1);
    Ytest=[Ytest;A];
end
%%%
acc=sum(pre_final==Ytest)/numel(Ytest);