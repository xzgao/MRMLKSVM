function [K]=ker_v(huaX,v,ker)

[~,n]=size(huaX);
K(1:n,1:n)=0;
for i1=1:n
    for i2=1:n
        K(i1,i2)=v'*kernelfun(huaX{i1},ker,huaX{i2})*v;
    end
end