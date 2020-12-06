function cs = cumSpeed(X, Y, times)
distances = cumDistance(X, Y);
seconds = cumSeconds(times);

accumulation = 20;
distances = accumulate(distances, accumulation);
seconds = accumulate(seconds, accumulation);

cs = distances./seconds;
end