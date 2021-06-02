% 每批实验里抽取1个进行按顺序存储
data_real = [];
for i = 1 : 10
    % i 为同一批次不同实验间
    for j = 1 : 9
        % j 为不同批次间
        data_real = [data_real;data(10*j-10+i,1:9)];
    end
end