function [K]=ker_xz(X,Z,ker)

[~,m2]=size(X);
K(1:m2,1:m2)=0;
for i1=1:m2
    for i2=1:m2
        K(i1,i2)=kernelfun((X(:,i1))',ker,(Z(:,i2))');
    end
end