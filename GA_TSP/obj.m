function fitness = obj(pop)
% *目标函数值的计算 
% pop     input   种群
% fitness output  目标函数值
global dic;
    for i = 1 : size(pop,1)
        dictance = 0;
        for j = 1 : size(pop,2)-1
            dictance = dictance + dic(pop(i,j),pop(i,j+1));
        end
        fitness(i) = dictance;
    end
end