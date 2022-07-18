function  x = MVO_3(mu, Q, lambda)
    
    % Find the total number of assets
    n = size(Q,1); 
    
    % Disallow short sales
    lb = zeros(n,1);

    %constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;

    % Set the quadprog options 
    options = optimoptions( 'quadprog', 'TolFun', 1e-9, 'Display','off');
    
    % Optimal asset weights
    x = quadprog(2*Q, (-1)*lambda*mu, [], [], Aeq, beq, lb, [], [], options);
    
end