function  [mu, Q] = CAPM(returns, factRet)
    
    % CAPM as a factor model. Note stock returns are already excess.
    
    % simple linear regression with excess market returns as predictor
    [mu, Q] = OLS(returns, factRet(:,1));
    
end