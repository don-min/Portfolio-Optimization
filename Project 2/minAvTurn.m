function  x = minAvTurn(mu, Q, x0, lambda)

    % Minimizing average turnover
    
    % Find the total number of assets
    n = size(Q,1); 
    
    % Disallow short sales
    lb = zeros(n,1);

    % constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;
    
    % Set the target as the average expected return of all assets
    targetRet = mean(mu);
    
    % Set inequality constraint on target return
    A = -mu.';
    b = -targetRet;
    
    % Get max asset return and index from mu
    [m, i] = max(mu);
    
    % Set fmincon options
    options = optimoptions('fmincon', 'Display', 'off', 'Algorithm','sqp','MaxFunEvals',1000000);
    
    % Optimal asset weights using fmincon
    ip = zeros(n,1);
    ip(i) = 1;
    obj = @(x) (norm(x-x0,2)) + (lambda*(x.'*Q*x)^(0.5));
    x = fmincon(obj, ip, A, b, Aeq, beq, lb, [], [], options);

end