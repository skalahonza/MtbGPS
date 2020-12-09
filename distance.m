function d = distance(X, Y)
% d = distance(X, Y) Computes total distance between all points.
% X is Nx1 array of x coordinates
% Y is Nx1 array of y coordinates
% d is a scalar

distances = cumDistance(X, Y);
d = sum(distances);
end