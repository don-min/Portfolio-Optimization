function [c,ceq] = nonLinCon4(x, mu, alpha, delta)
    c = alpha + ((delta^0.5)*norm(x,2)) - (mu'*x);
    ceq = [];
end