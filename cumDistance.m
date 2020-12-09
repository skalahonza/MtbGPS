function distances = cumDistance(X, Y)
% cumDistance Compute distance differences between neighbours.
% distances = cumDistance(X, Y) Compute distance differences between 
% neighbours.
% X is a Nx1 array of x coordinates
% Y is a Nx1 array of y coordinates
% distances = (N-1)x1 array of distances

points = [X(1:end-1) Y(1:end-1)];
points2 = [X(2:end) Y(2:end)];
distances = sqrt(sum((points-points2).^2,2));
end