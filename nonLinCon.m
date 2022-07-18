function [c,ceq] = nonLinCon(x,Q,epsilon)
    c = x'*Q*x - (epsilon^2);
    ceq = [];
end