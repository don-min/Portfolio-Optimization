function  [mu, Q] = FF_5_factor(returns, factRet)

    % Fama & French Model:
    %   - excess return on the market
    %   - size
    %   - value
    %   - profitability (most v.s. least)
    %   - investment (conservative v.s. aggressive)
    %----------------------------------------------------------------------
    % take only first five columns of factor data
    factRet_FF = factRet(:,1:5);
    
    % Perform multiple linear regression
    [mu, Q] = OLS(returns, factRet_FF);
    %----------------------------------------------------------------------
    
end