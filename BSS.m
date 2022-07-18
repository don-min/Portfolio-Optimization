function  [mu, Q] = BSS(returns, factRet, k) 

    % k is the cardinality constraint parameter in the input

    % Bounds. Very large in magnitude
    lb = -10000; 
    ub = 10000; 
    
    % Number of observations and factors
    [T, p] = size(factRet);
    
    % Number of Assets
    n = size(returns,2);
    
    % Temporary regression coefficients matrix including auxillary variable y
    B_y = zeros(2*(p+1),n);
    
    % Data matrix
    X = [ones(T,1), factRet];
    Q = [X.'*X zeros(p+1); zeros(p+1,2*(p+1))];
    
    % Defining the variable types: 'C' defines a continuous variable, 'B' defines
    % a binary variable
    varTypes = [repmat('C', p+1, 1); repmat('B', p+1, 1)];
    
    % Constraints
    A = [-eye(p+1)    lb*eye(p+1);
         eye(p+1)     -ub*eye(p+1);
         zeros(1,p+1) ones(1,p+1)];
    b = [zeros(2*(p+1),1); k];
    
    for i = 1:n
        clear model;

        % Gurobi accepts an objective function of the following form:
        % f(x) = (1/2) x' H x + c' x 

        % Define the Q matrix in the objective 
        model.Q = sparse(2*Q);

        % define the c vector in the objective
        c = [-2*(X.'*returns(:,i)); zeros(p+1,1)];
        model.obj = c;

        % Only inequality constraints; No equality constraints
        model.A = sparse(A);
        model.rhs = full(b);
        model.sense = repmat('<', (2*(p+1)+1), 1);

        % Define the variable type (continuous, integer, or binary)
        model.vtype = varTypes;

        % Set some Gurobi parameters to limit the runtime and to avoid printing the
        % output to the console. 
        clear params;
        params.TimeLimit = 100;
        params.OutputFlag = 0;

        results = gurobi(model,params);
        B_y(:,i) = results.x;

    end
    
    B = B_y(1:p+1,:);
    
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