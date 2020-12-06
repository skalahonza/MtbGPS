function cs = cumSpeed(X, Y, times)
distances = cumDistance(X, Y);
seconds = cumSeconds(times);
cs = distances./seconds;
end