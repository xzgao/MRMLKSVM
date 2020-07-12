function [K]=M_v(huaX,X,v,ker)

[~,n]=size(huaX);
[~,m2]=size(X);
K(1:n,1:m2)=0;
for i1=1:n
    K(i1,:)=v'*kernelfun(huaX{i1},ker,X);
end
