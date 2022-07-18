function  x = DistRobustMVO(mu, Q, mktRets)

    % Implementing Distributionally Robust Mean-Variance Portfolio
    % Selection with Wasserstein Distances based on a paper by 
    % Jose Blanchet, Lin Chen, Xun Yu Zhou. Additional clarificatiion
    % provided by David.
    
    % Calculate delta for 95% confidence interval
    delta = 0.00000001;
    
    % Target excess return alpha by taking the geometric mean of the excess market
    % returns
    alpha = mean(mu);

    % number of assets
    n = size(Q,1);
    
    % Disallow short sales
    lb = zeros(n,1);

    % constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;
    
    % Set fmincon options
    options = optimoptions('fmincon', 'Display', 'off','Algorithm','sqp');
    
    % Get index of max of mu vector
    [m, i] = max(mu);
    
    % Optimal asset weights using fmincon
    x0 = zeros(n,1);
    x0(i) = 1;
    obj = @(x) (((x'*Q*x)^(0.5)) + ((delta^(0.5))*norm(x,2)))^2;
    nonlcon = @(x)nonLinCon4(x, mu, alpha, delta);
    x = fmincon(obj, x0, [], [], Aeq, beq, lb, [], nonlcon, options);

end