function ms = speed(distance, times)
% ms = speed(distance, times) Given the distance and array of
% times, computes an average speed.
% distances is a scalar, the value is supposed to be in meters
% times is a Nx1 array of seconds
% ms meters per second

diff = seconds(abs(times(1) - times(end)));
ms = distance/diff;
end