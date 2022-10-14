% Given a time series, this function:
% 1. Estimates the parameters of the mix distribution
% 2. Performs a kolmogorov smirnov test
% 3. Calculates the threshold
% 4. Obtains pot
% 5. Use allfitdist to fit extreme value distributions
% 6. Compare AIC and BIC
% 7. Calculate return values
% 8. Saves the results in a file
function mainExtreme(serie, num_intervals,folder,filename,n_years)
    addpath('FitDistribution_GUI/');
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
    
    threshold = findThreshold(mu, sigma, delta, gamma, minimum, maximum, 0.95);
    pot = serie(serie>threshold);
    distributions = allfitdist(pot);
    
    fid=fopen([folder filesep 'results_' filename],'wt');
    fprintf(fid,'Mix distribution ********************\n');
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
    
    fprintf(fid,'\n Extreme distributions ************\n');
    fprintf(fid,'Threshold: %f\n',threshold);
    fprintf(fid,'F(threshold): %f\n',calculateTheoricalValue(threshold,mu,sigma,delta,gamma));
    fprintf(fid,'Fit: \n');
    for dit=1:numel(distributions),
       fprintf(fid,'%s;%f;%f\n',distributions(dit).DistName,distributions(dit).BIC,distributions(dit).AIC);
       if strcmp(distributions(dit).DistName,'generalized pareto'),
           kappa = distributions(dit).Params(1); %shape
           alpha = distributions(dit).Params(2); %scale
           xi = distributions(dit).Params(3); %threshold
       end
    end
    
    lambda = numel(serie)/n_years;
    [H100, ci100] = calculateReturnValues(kappa,alpha,xi,lambda,100,numel(pot));
    [H50, ci50] = calculateReturnValues(kappa,alpha,xi,lambda,50,numel(pot));
    [H20, ci20] = calculateReturnValues(kappa,alpha,xi,lambda,20,numel(pot));
    [H10, ci10] = calculateReturnValues(kappa,alpha,xi,lambda,10,numel(pot));
    [H5, ci5] = calculateReturnValues(kappa,alpha,xi,lambda,5,numel(pot));
    [H2, ci2] = calculateReturnValues(kappa,alpha,xi,lambda,2,numel(pot));
    [H1, ci1] = calculateReturnValues(kappa,alpha,xi,lambda,1,numel(pot));
    
    fprintf(fid,'Return values and confidence intervals:\n');
    fprintf(fid,'H100: %.2f --> [%.2f - %.2f]\n', H100,ci100(1),ci100(2));
    fprintf(fid,'H50: %.2f --> [%.2f - %.2f]\n', H50,ci50(1),ci50(2));
    fprintf(fid,'H20: %.2f --> [%.2f - %.2f]\n', H20,ci20(1),ci20(2));
    fprintf(fid,'H10: %.2f --> [%.2f - %.2f]\n', H10,ci10(1),ci10(2));
    fprintf(fid,'H5: %.2f --> [%.2f - %.2f]\n', H5,ci5(1),ci5(2));
    fprintf(fid,'H2: %.2f --> [%.2f - %.2f]\n', H2,ci2(1),ci2(2));
    fprintf(fid,'H1: %.2f --> [%.2f - %.2f]\n', H1,ci1(1),ci1(2));
        
    fclose(fid);
end


function [Hx, confidence_interval] = calculateReturnValues(kappa,alpha,xi,lambda,T,N)
    Hx = xi + (alpha/kappa)*(1-(lambda*T)^(-kappa));
    array_Hx = zeros(1,100000);
    for i=1:100000,
        sample = gprnd(kappa,alpha,xi,[1 N]);
        dists = allfitdist(sample);
        encontrado=false;
        dit=1;
        while encontrado ==false,
            if strcmp(dists(dit).DistName,'generalized pareto'),
               kappa2 = dists(dit).Params(1); %shape
               alpha2 = dists(dit).Params(2); %scale
               xi2 = dists(dit).Params(3); %threshold
               encontrado = true;
            end
            dit=dit+1;
        end
        H = xi2 + (alpha2/kappa2)*(1-(lambda*T)^(-kappa2));
        array_Hx(i) = H;
    end
    confidence_interval = [prctile(array_Hx,5) prctile(array_Hx,95)];
end