function seconds = cumSeconds(times)
s = times*[3600 60 1]';
a = s(1:end-1);
b = s(2:end);
seconds = abs(a-b);
end