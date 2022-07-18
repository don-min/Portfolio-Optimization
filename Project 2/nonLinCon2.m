function [c,ceq] = nonLinCon2(y, mu, epsilon, theta_root)
    c = (-mu.'*y) - (epsilon*norm(theta_root*y,2)) + 1;
    ceq = [];
end