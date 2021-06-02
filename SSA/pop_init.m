function pop = pop_init(sizepop)
% *初始化种群
% sizepop   input   种群规模
% pop       output  种群
for j = 1 : sizepop
    pop(j,1) = 4000 + round(4000*rand);   % 4k-8k的随机数
    pop(j,2) = (10 + 15 * rand)/100;      % 0.1-0.25的随机数
    pop(j,3) = (2 + round(2 * rand))/100; % 0.02-0.04的随机数
end
end