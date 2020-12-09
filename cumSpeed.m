function cs = cumSpeed(X, Y, times)
% cumSpeed Computes accumulated speed between set of points. Returns
% Average speed for every set of 20 points.
% cs = cumSpeed(X, Y, times)
%
% X is Nx1 array of x coordinates
% Y is Nx1 array of y coordinates
% times is a Nx1 array of datetimes
% cs = (N-1)x1 array of meters per second

distances = cumDistance(X, Y);
seconds = cumSeconds(times);

accumulation = 20;
distances = accumulate(distances, accumulation);
seconds = accumulate(seconds, accumulation);

cs = distances./seconds;
end