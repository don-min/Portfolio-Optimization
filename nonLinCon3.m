function [c,ceq] = nonLinCon3(x,s)
    c = norm(x,2)^2 - s;
    ceq = [];
end