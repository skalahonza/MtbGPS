function distances = cumDistance(X, Y)
points = [X(1:end-1) Y(1:end-1)];
points2 = [X(2:end) Y(2:end)];
distances = sqrt(sum((points-points2).^2,2));
end