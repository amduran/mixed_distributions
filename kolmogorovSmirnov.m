% Function that performs Komogorov Smirnov test
% It returns maximum difference of the theorical and empirical values and
% the critical difference from the kolmogorov test
function [maximum,CD] = kolmogorovSmirnov(theoricalValues, empiricalValues,alpha)
    empiricalValues_eps = zeros(1,numel(empiricalValues));
    empiricalValues_eps(2:end)=empiricalValues(1:end-1);
    
    d1 = abs(theoricalValues - empiricalValues);
    d2 = abs(theoricalValues - empiricalValues_eps);
    
    maximum = max(max(d1,d2));
    CD = sqrt(-0.5*log(alpha/2)/numel(empiricalValues));
end