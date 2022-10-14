% Calculate u values
function u = calculate_u(serie, mu, k, x)
    serie = abs(serie - mu);
    ind = find(serie >= x);
    subserie = serie(ind);
    subserie = subserie .^ k;
    
    u = mean(subserie);
end