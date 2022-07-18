function x = ellipRobustMVO_3(mu, Q, T, lambda, alpha)

    % Ellipsoidal robust method on MVO_3 using alpha as confidence interval
    
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
    x0 = (1/n)*ones(n,1);
    Aeq = ones(1,n);
    beq = 1;
    lb = zeros(n,1);
    func = @(x) (lambda*transpose(x)*Q*x - (transpose(mu)*x - epsilon*norm(theta_root*x,2)));
    x = fmincon(func, x0, [], [], Aeq, beq, lb, [], [], options);

end
