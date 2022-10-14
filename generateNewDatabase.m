% Given a time series, this function generates a new database with the
% evolution of the estimated parameters over time
function generateNewDatabase(serie, length_subserie, displacement, num_intervals, folder, filename)
    
    i=1;
    fid=fopen([folder filesep 'database_' filename],'wt');
    
    while(i+length_subserie-1 < numel(serie))
        [mu, sigma, delta, gamma] = estimateParameters(serie(i:i+length_subserie-1));
        minimum = min(serie(i:i+length_subserie-1));
        maximum = max(serie(i:i+length_subserie-1));

        amplitude = (maximum - minimum)/num_intervals;
        x=minimum:amplitude:maximum;

        tv=calculateTheoricalValue(x,mu,sigma,delta,gamma);
        ev=calculateEmpiricalValue(x,serie(i:i+length_subserie-1));
        [D,CD] = kolmogorovSmirnov(tv, ev, 0.05);
        if (D < CD)
            H=0;
        else
            H=1;
        end
        fprintf(fid,'%f %f %f %f %f %f %d %d %d %d\n', mu, sigma, delta, gamma, D, CD, H, i,i+length_subserie-1, numel(serie(i:i+length_subserie-1)));
        i=i+displacement;
    end
    [mu, sigma, delta, gamma] = estimateParameters(serie(i:end));
        minimum = min(serie(i:end));
        maximum = max(serie(i:end));

        amplitude = (maximum - minimum)/num_intervals;
        x=minimum:amplitude:maximum;

        tv=calculateTheoricalValue(x,mu,sigma,delta,gamma);
        ev=calculateEmpiricalValue(x,serie(i:end));
        [D,CD] = kolmogorovSmirnov(tv, ev, 0.05);
        if (D < CD)
            H=0;
        else
            H=1;
        end
        fprintf(fid,'%f %f %f %f %f %f %d %d %d %d', mu, sigma, delta, gamma, D, CD, H, i, numel(serie), numel(serie(i:end)));
        fclose(fid);
end