function fitness = obj(pop)
% *Ŀ�꺯��ֵ�ļ��� 
% pop     input   ��Ⱥ
% fitness output  Ŀ�꺯��ֵ
global dic;
    for i = 1 : size(pop,1)
        dictance = 0;
        for j = 1 : size(pop,2)-1
            dictance = dictance + dic(pop(i,j),pop(i,j+1));
        end
        fitness(i) = dictance;
    end
end