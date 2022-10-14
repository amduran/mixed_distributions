% Function that calculates the empirical values of the CDF
function [value] = calculateEmpiricalValue(x,serie)
    value = zeros(1,numel(x));
    for i=1:numel(x),
       value(i)=numel(find(serie <= x(i)))/numel(serie);
    end
end