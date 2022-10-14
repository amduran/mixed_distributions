% Function that calculates the theorical values of the CDF
function [value] = calculateTheoricalValue(x,mu,sigma,delta,gamma)

    value = gamma * normalDistribution(x,mu,sigma) + (1 - gamma) * uniformDistribution(x,mu,delta);

end