function  x = CVaR(rets, mktRets, alpha)

    % Number of assets and number of historical scenarios
    [S, n] = size(rets);

    % Estimate the asset exp. returns by taking the geometric mean
    mu = (geomean(rets + 1) - 1 )';

    % Set our target excess return by taking the geometric mean of the excess market
    % returns
    R = geomean(mktRets + 1) - 1;

    % Define the lower and upper bounds to our portfolio
    lb = [zeros(n,1); zeros(S,1); -Inf];
    ub = [];

    % Define the inequality constraint matrices A and b
    A = [(-1)*transpose(mu), zeros(1,S+1);
          (-1)*rets, (-1)*eye(S), (-1)*ones(S,1)];
    b = [(-1)*R;
          zeros(S,1)];

    % Define the equality constraint matrices A_eq and b_eq
    Aeq = [ones(1,n), zeros(1,S+1)];
    beq = [1];

    % Define our objective linear cost function c
    c = [zeros(1,n), ones(1,S)*(1/((1-alpha)*S)), 1];

    % Set the linprog options to increase the solver tolerance
    options = optimoptions('linprog','TolFun',1e-9, 'Display', 'off');

    % Use 'linprog' to find the optimal portfolio
    results = linprog(c, A, b, Aeq, beq, lb, ub, [], options);

    % Retrieve the optimal portfolio weights
    x = results(1:n);

end