function  x = RiskParity(Q, c)

    % Risk Parity approach to determining portfolio weights
   
    % Find the total number of assets
    n = size(Q, 1);
    
    % Basic Initial Feasbile Solution
    y0 = ones(n, 1);
    
    % Lower Bound of 0's
    lb = zeros(n,1); 
   
    % Objective Function
    obj = @(y) (0.5 * y.' * Q * y) - c*sum(log(y));

    % Set fmincon options
    options = optimoptions('fmincon','Display','off','Algorithm','sqp');
    
    y = fmincon(obj, y0, [], [], [], [], lb, [], [], options);

    % Recover the optimal asset weights (ie. normalization)
    x = y/sum(y);
   
end