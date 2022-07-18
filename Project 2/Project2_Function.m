function x = Project2_Function(periodReturns, periodFactRet, x0)

    % Use this function to implement your algorithmic asset management
    % strategy. You can modify this function, but you must keep the inputs
    % and outputs consistent.
    %
    % INPUTS: periodReturns, periodFactRet, riskFree, x0 (current portfolio weights)
    % OUTPUTS: x (optimal portfolio)
    %
    % An example of an MVO implementation with OLS regression is given
    % below. Please be sure to include comments in your code.
    %
    % *************** WRITE YOUR CODE HERE ***************
    %----------------------------------------------------------------------

    % Example: subset the data to consistently use the most recent T months
    % for parameter estimation
    T = 60;
    returns = periodReturns(end-(T-1):end,:);
    factRet = periodFactRet(end-(T-1):end,:);
    
    % Example: Use an OLS regression to estimate mu and Q
    %[mu, Q] = OLS(returns, factRet);
    %[mu, Q] = BSS(returns, factRet, 5); % k = 1 to 7
    [mu, Q] = Lasso(returns, factRet, 3);
    %[mu, Q] = RidgeReg(returns, factRet, 3); 
    %[mu, Q] = FF_5_factor(returns, factRet);
    %[mu, Q] = FF(returns, factRet);
    %[mu, Q] = CAPM(returns, factRet);
    
    % Optimize portfolio using estimates of mu and Q
    % x = MVO(mu, Q);
    % x = MVO_2(mu, Q, 0.15);
    % x = MVO_3(mu, Q, 3);
    % x = boxRobustMVO_3(mu, Q, T, 3);
    % x = ellipRobustMVO_3(mu, Q, T, 3, 0.95);
    % x = maxSharpe(mu, Q);
    % x = CVaR(returns, factRet(:,5), 0.95);
    % x = RiskParity(Q, 1); % c > 0
    % x = boxRobustSharpe(mu, Q, T);
    % x = ellipRobustSharpe(mu, Q, T, 0.90);
    % x = DistRobustMVO(mu, Q, factRet(:,1));
    % x = equalWeight(mu);
     x = minAvTurn(mu, Q, x0, 100);

    %----------------------------------------------------------------------
end
