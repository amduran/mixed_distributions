% This function returns the value of x when looking for F(X)=0.95
function t = findThreshold(mu, sigma, delta, gamma, minimum, maximum, limit)
    t = minimum;
    encontrado = false;
    while (encontrado == false && t < maximum),
        [value] = calculateTheoricalValue(t,mu,sigma,delta,gamma);
        if value > limit,
            encontrado = true;
        else
            t = t + 0.001;
        end
    end
    t=t-0.001;
end