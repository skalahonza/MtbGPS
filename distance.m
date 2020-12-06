function d = distance(X, Y)
distances = cumDistance(X, Y);
d = sum(distances);
end