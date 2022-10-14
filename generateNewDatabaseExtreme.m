% Given a time series, this function generates a new database with the
% evolution of the estimated parameters over time only for values greater
% than a threshold
function thresholds = generateNewDatabaseExtreme(serie, length_subserie, displacement, folder, filename)
    
    thresholds = [];
    i=1;
    
    trim = 1;
    while(i+length_subserie-1 < numel(serie))
        subserie = serie(i:i+length_subserie-1);
        [mu, sigma, delta, gamma] = estimateParameters(subserie);
        minimum = min(subserie);
        maximum = max(subserie);
        threshold = findThreshold(mu, sigma, delta, gamma, minimum, maximum, 0.95);
        thresholds = [thresholds threshold];
        data(trim).pot=subserie(subserie>threshold);
        i=i+displacement;
        trim = trim + 1;
    end
    subserie = serie(i:end);
    [mu, sigma, delta, gamma] = estimateParameters(subserie);
    minimum = min(subserie);
    maximum = max(subserie);
    threshold = findThreshold(mu, sigma, delta, gamma, minimum, maximum, 0.95);
    thresholds = [thresholds threshold];
    data(trim).pot=subserie(subserie>threshold);
    
    fidGPD=fopen([folder filesep 'database_GPD' filename],'wt');
%     fidGamma=fopen([folder filesep 'database_Gamma' filename],'wt');
%     fidWeibull=fopen([folder filesep 'database_Weibull' filename],'wt');
    for trim=1:numel(data),
        distributions = allfitdist(data(trim).pot);
        for dit=1:numel(distributions),
            if strcmp(distributions(dit).DistName,'generalized pareto'),
                fprintf(fidGPD,'%i %f %f %f %f %f\n',trim,distributions(dit).Params(1),distributions(dit).Params(2),distributions(dit).Params(3),distributions(dit).BIC,distributions(dit).AIC);
%             elseif strcmp(distributions(dit).DistName,'gamma'),
%                 fprintf(fidGamma,'%f %f %f %f\n', distributions(dit).Params(1),distributions(dit).Params(2),distributions(dit).BIC,distributions(dit).AIC);
%             elseif strcmp(distributions(dit).DistName,'weibull')
%                 fprintf(fidWeibull,'%f %f %f %f\n', distributions(dit).Params(2),distributions(dit).Params(1),distributions(dit).BIC,distributions(dit).AIC);
            end
        end
    end
    fclose(fidGPD);
%     fclose(fidGamma);
%     fclose(fidWeibull);
end