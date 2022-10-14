% Given a time series, this function:
% 1. Estimates the parameters of the mix distribution
% 2. Performs a kolmogorov smirnov test
% 3. Saves the results in a file
function [H, mu, sigma, delta, gamma] = main(serie, num_intervals,folder,filename)
    [mu, sigma, delta, gamma] = estimateParameters(serie);
    num_intervals=num_intervals-1;
    
    minimum = min(serie);
    maximum = max(serie);
    
    amplitude = (maximum - minimum)/num_intervals;
    x=minimum:amplitude:maximum;
    
    tv=calculateTheoricalValue(x,mu,sigma,delta,gamma);
    ev=calculateEmpiricalValue(x,serie);
    plotCDFs(x,tv,ev,[folder filesep 'CDFS_' filename]);
    
    [D,CD] = kolmogorovSmirnov(tv, ev, 0.05);
    
    fid=fopen([folder filesep 'results_' filename],'wt');
    fprintf(fid,'Parameters Estimation:\n');
    fprintf(fid,'Mu: %f\n', mu);
    fprintf(fid,'Sigma: %f\n', sigma);
    fprintf(fid,'Delta: %f\n', delta);
    fprintf(fid,'Gamma: %f\n', gamma);
    
    fprintf(fid,'\nTest results:\n');
    if (D < CD)
        fprintf(fid,'KS test accepts null hyphotesis with values:\n');
        H=0;
    else
        fprintf(fid,'KS test rejects null hyphotesis with values:\n');
        H=1;
    end
    fprintf(fid,'D value: %f\n',D);
    fprintf(fid,'CD value: %f\n',CD);
    fclose(fid);
end