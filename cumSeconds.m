function cs = cumSeconds(times)
a = times(1:end-1);
b = times(2:end);
cs = seconds(abs(a-b));
end