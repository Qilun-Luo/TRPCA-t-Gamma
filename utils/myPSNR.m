function p = myPSNR(X,Y)
m = numel(X)*max(abs(X(:)))^2/sum((Y(:)-X(:)).^2);
p=10*log10(m);
end