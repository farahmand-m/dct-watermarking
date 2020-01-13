function [NC] = NC_project(S, W1D)
d = (S - W1D).^ 2;
NC = 1 - mean(d);
end

