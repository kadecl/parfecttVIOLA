function r = phaser(s, num_allPassFilter, mix)
% s: input signal
% num_allPassFilter: multiple allpassFilter
% mix: mix rate of phaser signal
r = s;
wo = 0.5;
wt = wo/2;

for i = 1:num_allPassFilter
    
    [B,A] = allpassshift(wo,wt); % filterの分子，分母
    r = filter(B,A,r);
end

r = s + mix * r;
end