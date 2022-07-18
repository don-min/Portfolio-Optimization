function x = boxRobustMVO_3(mu, Q, T, lambda)

    % Box robust method on MVO_3 using 95% confidence interval
    
    % Calculate epsilon for 95% confidence interval
    epsilon = 1.96;

    % number of assets
    n = size(Q,1);

    % Calculate theta
    theta = (1/T)*diag(Q);
    theta_root = theta.^(1/2);
    
    % Calculate delta vector
    delta = epsilon*theta_root;
    
    % Tweak vector sizes for quadprog to account for auxillary variable y
    delta = [zeros(n,1);
             delta];
    mu = [mu;
          zeros(n,1)];
    Q = [Q zeros(n,n);
         zeros(n,2*n)];
     
    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
        
    % quadprog
    A = [eye(n) -eye(n);
         -eye(n) -eye(n)];
    b = zeros(2*n,1);
    Aeq = [ones(1,n) zeros(1,n)];
    beq = [1];
    lb = zeros(2*n, 1);
    results = quadprog(2*lambda*Q, delta - mu, A, b, Aeq, beq, lb, [], [], options);
    x = results(1:n);

end