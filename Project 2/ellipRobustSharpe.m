function x = ellipRobustSharpe(mu, Q, T, alpha)

    % Ellipsoidal robust method on Sharpe using alpha as confidence interval
    
    % number of assets
    n = size(Q, 1);

    % Calculate theta
    theta = (1/T)*diag(Q).*eye(n);
    theta_root = theta.^(1/2);

    % Calculate epsilon
    epsilon = (chi2inv(alpha, n))^(1/2);
    
    % Set fmincon options
    options = optimoptions('fmincon','Display','off','Algorithm','sqp');

    % f_mincon
    y0 = ones(n,1);
    A = -ones(1,n);
    b = 0;
    lb = zeros(n,1);
    obj = @(y) (y.'*Q*y);
    nonlcon = @(y)nonLinCon2(y, mu, epsilon, theta_root);
    y = fmincon(obj, y0, A, b, [], [], lb, [], nonlcon, options);
    
    % To get weights
    x = y/sum(y);

end