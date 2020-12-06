function cs = cumSpeed(X, Y, times)
distances = cumDistance(X, Y);
seconds = cumSeconds(times);

accumulation = 20;
distances = accumulate(distances, accumulation);
seconds = accumulate(seconds, accumulation);

cs = distances./seconds;
end

function B = accumulate(A, n)
% normalize matrix dimension so it is divisible by n
[m,~] = size(A);
diff = n - mod(m,n);
B = [A; zeros(diff,1)];


C = zeros((m+diff)/n,n);
% accumulate matrix by n
for i = 1:n
    C(:,i) = B(i:n:end);
end
B = C;

% use mean as the accumulator function
B = mean(B,2);

% repeat accumulated values
B = repelem(B,n,1);

% without rows that served for normalization
B = B(1:end-diff,:);
end