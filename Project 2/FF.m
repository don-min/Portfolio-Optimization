function  [mu, Q] = FF(returns, factRet)

    % Fama & French Model:
    %   - excess return on the market
    %   - size
    %   - value
    %----------------------------------------------------------------------
    % take only first three columns of factor data
    factRet_FF = factRet(:,1:3);

    % Perform multiple linear regression
    [mu, Q] = OLS(returns, factRet_FF);
    %----------------------------------------------------------------------
    
end