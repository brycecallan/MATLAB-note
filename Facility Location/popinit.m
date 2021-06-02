function pop = popinit(n,length)
% *种群初始化函数
% n       input    种群数量
% length  input    种群长度
% pop     output   初始种群
    for i = 1 : n
        [~,b] = sort(rand(1,25));
        pop(i,:) = b(1:length);
    end
end