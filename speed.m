function s = speed(distance, times)
first = dot(times(1,:),[3600 60 1]);
second = dot(times(end,:),[3600 60 1]);
seconds = abs(first - second);
s = distance/seconds;
end