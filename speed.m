function s = speed(distance, times)
diff = seconds(abs(times(1) - times(end)));
s = distance/diff;
end