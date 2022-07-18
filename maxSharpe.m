function  x = maxSharpe(mu, Q)
    
    % Maximize Sharpe ratio
    
    % Find the total number of assets
    n = size(Q, 1); 
    
    % Modify Q matrix to account for auxillary variable k
    Q = [Q zeros(n,1);
         zeros(1,(n+1))];
    
    % Disallow short sales
    lb = zeros(n+1,1);
    
    % Inequality constraints
    %A = 
    %b = 
    
    % Equality constraints
    Aeq = [ones(1,n) -1;
           mu' 0];
    beq = [0;
           1];
    
    % Set options for quadprog
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display', 'off');
    
    % Quadprog to solve for y
    results = quadprog(2*Q, [], [], [], Aeq, beq, lb, [], [], options);
    
    y = results(1:n);
    k = results(end);
    
    % To get weights
    x = y/k;
    
end