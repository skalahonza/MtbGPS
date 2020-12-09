function cs = cumSeconds(times)
% cumSeconds Compute second differences between neighbours.
% cs = cumSeconds(times) Compute second differences between neighbours.
% times is a Nx1 array of datetimes
% cs = (N-1)x1 array of seconds

a = times(1:end-1);
b = times(2:end);
cs = seconds(abs(a-b));
end