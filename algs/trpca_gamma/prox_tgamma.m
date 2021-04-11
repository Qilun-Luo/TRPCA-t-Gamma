function [X, sig] = prox_tgamma(Y, rho, sig, gamma)

[n1,n2,n3] = size(Y);
Y = fft(Y,[],3);     
m = min(n1, n2);
for i = 1:n3
    [L, sig(:, i)] = DC(Y(:, :, i), rho/2, sig(:, i),gamma);
    Y(:, :, i) = L;
end
X = ifft(Y, [], 3);
