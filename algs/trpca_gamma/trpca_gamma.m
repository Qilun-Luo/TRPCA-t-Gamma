function [L,S,err,iter] = trpca_gamma(X, lambda, opts)

tol = 1e-8; 
max_iter = 500;
rho = 1.1;
mu = 1e-4;
max_mu = 1e10;
gamma = 0.01;
DEBUG = 0;

if ~exist('opts', 'var')
    opts = [];
end    
if isfield(opts, 'tol');         tol = opts.tol;              end
if isfield(opts, 'max_iter');    max_iter = opts.max_iter;    end
if isfield(opts, 'rho');         rho = opts.rho;              end
if isfield(opts, 'mu');          mu = opts.mu;                end
if isfield(opts, 'max_mu');      max_mu = opts.max_mu;        end
if isfield(opts, 'gamma');       gamma = opts.gamma;          end
if isfield(opts, 'DEBUG');       DEBUG = opts.DEBUG;          end

[n1,n2,n3] = size(X);
L = zeros(n1,n2,n3);
S = L;
Y = L;
sig = zeros(min(n1,n2), n3);

for iter = 1 : max_iter
    Lk = L;
    Sk = S;
    % update L
    [L, sig] = prox_tgamma(-S+X-Y/mu, mu, sig, gamma);
    % update S
    S = prox_l1(-L+X-Y/mu,lambda/mu);
    dY = L+S-X;
    chgL = max(abs(Lk(:)-L(:)));
    chgS = max(abs(Sk(:)-S(:)));
    chg = max([ chgL chgS max(abs(dY(:))) ]);
    if DEBUG
        if iter == 1 || mod(iter, 10) == 0
            err = norm(dY(:));
            disp(['iter ' num2str(iter) ', mu=' num2str(mu) ...
                    ', err=' num2str(err)]); 
        end
    end
    
    if chg < tol
        break;
    end 
    Y = Y + mu*dY;
    mu = min(rho*mu,max_mu);    
end
err = norm(dY(:));