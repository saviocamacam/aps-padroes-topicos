function z=dist(w,p)
    for i=1:size(p,2)
        for j=1:size(p,2)
            u=p(:,i);
            v=p(:,j);
            z(i,j)=sum((u-v).^2).^0.5;
        end
    end
end