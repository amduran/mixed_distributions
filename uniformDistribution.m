% Distribution Function of a uniform variable
function [value] = uniformDistribution(x, mu, delta)
    value = (x - mu + delta)/(2*delta);
    ind1=find(value<0);
    value(ind1)=0;
    ind2=find(value>1);
    value(ind2)=1;
end