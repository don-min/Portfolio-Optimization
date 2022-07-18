function  x = boxRobustSharpe(mu, Q, T)
    
    % Box robust method on maxSharpe approach using 95% confidence interval
    
    % Calculate epsilon for 95% confidence interval
    epsilon = 1.96;
    
    % Find the total number of assets
    n = size(Q, 1); 
    
    % Calculate theta
    theta = (1/T)*diag(Q);
    theta_root = theta.^(1/2);
    
    % Calculate delta vector
    delta = epsilon*theta_root;
    
    % Modify Q matrix to account for auxillary variable z
    Q = [Q zeros(n,n);
         zeros(n,2*n)];
    
    % Disallow short sales
    lb = [zeros(n,1);
          zeros(n,1)];
    
    % Inequality constraints
    A = [-mu.' delta.';
         eye(n) -eye(n);
         -eye(n) -eye(n);
         -ones(1,n) zeros(1,n)];
    b = [-1;
         zeros(2*n,1);
         0];
         
    % Set options for quadprog
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display', 'off');
    
    % Quadprog to solve for y
    results = quadprog(2*Q, [], A, b, [], [], lb, [], [], options);
    y = results(1:n);
    
    % To get weights
    x = y/sum(y);
    
end