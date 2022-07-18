function  x = MVO_2(mu, Q, epsilon)

    % Version 2 of MVO as per lecture notes. Max return.
    
    % Find the total number of assets
    n = size(Q,1); 
    
    % Disallow short sales
    lb = zeros(n,1);

    % constrain weights to sum to 1
    Aeq = ones(1,n);
    beq = 1;
    
    % Set fmincon options
    options = optimoptions('fmincon','Display','off','Algorithm','sqp');
    
    % Optimal asset weights using fmincon
    x0 = (1/n)*ones(n,1);
    obj = @(x) (-mu.'*x);
    nonlcon = @(x)nonLinCon(x,Q,epsilon);
    x = fmincon(obj, x0, [], [], Aeq, beq, lb, [], nonlcon, options);

end