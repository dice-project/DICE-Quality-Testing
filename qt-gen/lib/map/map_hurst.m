function H = map_hurst(MAP,t,display)
% Estimates the Hurst coefficient for a MAP by performing regression on the
% count ACF of the MAP.
% INPUT
% - MAP: the arrival process
% - t: (default=1) time scale
% - display: (default=0) if plot=1, plot count ACF
% OUTPUT
% - H: Hurst coefficient

if nargin < 2
   t = 1; 
end

if nargin < 3
   display = 0; 
end

k = logspace(0,6);
gamma =  map_count_cov(MAP,t,k)/map_count_var(MAP,t);
last = find(gamma > 1e-4, 1, 'last');
klast = k(last);
k = logspace(0,log10(klast)); 

gamma = map_count_cov(MAP,t,k)/map_count_var(MAP,t);
rho = gamma(1);
beta= -log(k)' \ (log(abs(gamma)) - log(rho))';
H = 1 - beta/2;

kextra = logspace(log10(klast), log10(klast)+2, 5);
gammaextra = map_count_cov(MAP,t,kextra)/map_count_var(MAP,t);
k = [k kextra];
gamma = [gamma gammaextra];

if display
    figure;
    % loglog
    subplot(1,2,1);
    hold all;
    plot(k, gamma);
    plot(k, rho*k.^(-beta));
    set(gca, 'XScale', 'log');
    set(gca, 'YScale', 'log');
    legend('MAP', '\psi k^{-\beta}');
    title(sprintf('H = 1 - \\beta / 2 = %f', H));
    % semilogx
    subplot(1,2,2);
    hold all;
    plot(k, gamma);
    plot(k, rho*k.^(-beta));
    set(gca, 'XScale', 'log');
    legend('MAP', '\psi k^{-\beta}');
    title(sprintf('H = 1 - \\beta / 2 = %f', H));
end