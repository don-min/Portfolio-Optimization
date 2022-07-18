function  [mu, Q] = RidgeReg(returns, factRet, s) 

    % lambda is the penalization parameter in the input
    
    % Number of observations and factors
    [T, p] = size(factRet);
    
    % Number of Assets
    n = size(returns, 2);
    
    % Temporary regression coefficients matrix
    B = zeros(p+1,n);
    
    % Data matrix
    X = [ones(T,1) factRet];
    
    for i = 1:n
        
        % objective
        obj = @(x) (norm(returns(:,i) - X*x, 2))^2;
        
        % Set the fmincon options 
        options = optimoptions('fmincon','Display','off','Algorithm','sqp');

        % Optimal asset weights
        x0 = ((s/(p+1))^(1/2))*ones(p+1,1);
        nonlcon = @(x) nonLinCon3(x,s);
        x = fmincon(obj, x0, [], [], [], [], [], [], nonlcon, options);
        B(:,i) = x;

    end
    
    % Separate B into alpha and betas
    a = B(1,:).';
    V = B(2:end,:);
    
    % Residual variance
    ep = returns - X * B;
    sigma_ep = (vecnorm(ep).^2)/(T-p-1);
    D = diag(sigma_ep);
    
    % Factor covariance matrix
    F = cov(factRet);
    
    % Calculate the asset expected returns and covariance matrix
    mu = a + V.'*(geomean(factRet+1)-1).'; % n x 1 vector of asset exp. returns
    Q = V.'*F*V + D; % n x n asset covariance matrix
    
    % Sometimes quadprog shows a warning if the covariance matrix is not
    % perfectly symmetric.
    Q = (Q + Q')/2;
    %----------------------------------------------------------------------
    
end