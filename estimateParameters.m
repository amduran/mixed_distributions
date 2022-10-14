% Function that estimates the parameters of the mix distribution
function [mu, sigma, delta, gamma] = estimateParameters(serie)
    % x(1) sigma x(2) delta x(3) gamma
    mu = mean(serie);
    u1=calculate_u(serie,mu,1,0);
    u2=calculate_u(serie,mu,2,0);
    u3=calculate_u(serie,mu,3,0);
    F=@(x) [sqrt(2/pi)*x(1)*x(3)+(1-x(3))*x(2)/2-u1, x(1)^2*x(3)+(1-x(3))*x(2)^2/3-u2, sqrt(8/pi)*x(1)^3*x(3)+(1-x(3))*x(2)^3/4-u3];
    
    x0=[0.5 0.5 0.5];
    [x,fval] = fsolve(F,x0);
    sigma=x(1);
    delta=x(2);
    gamma=x(3);
    
%     options = optimoptions('fsolve','MaxFunEvals',100000);
%     x0=[0.5 0.5 10];
%     [x,fval] = fsolve(F,x0,options);
end