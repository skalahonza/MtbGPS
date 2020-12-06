function cs = cumSpeed(X, Y, times)
distances = cumDistance(X, Y);
seconds = cumSeconds(times);

distances = accumulate(distances);
seconds = accumulate(seconds);

cs = distances./seconds;
end

function B = accumulate(A)
% normalize matrix dimension so it is divisible by 3
[m,~] = size(A);
diff = mod(m,3);
B = [A; zeros(diff,1)];

% accumulate matrix by 3
B = [B(1:3:end) B(2:3:end) B(3:3:end)];
B = mean(B,2);

% unfold accumulated values
B = repelem(B,3,1);

% without rows that served for normalization
B = B(1:end-diff,:);
end