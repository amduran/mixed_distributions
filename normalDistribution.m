% Distribution Functions of a normal variable
function [value] = normalDistribution(x, mu, sigma)
    value = (x-mu)/(sqrt(2)*sigma);
    value = (erf(value)+1)/2;
end