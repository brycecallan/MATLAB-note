function data = data_revise(data,judge)
% data    input   输入数据
% data    output  输出数据
    if judge == 1
        % 09:30 --> 09 * 60 + 30
        temp = data(2:end,4:5); % 待处理的数据
        for i = 1 : size(temp,1)
            for j = 1 : size(temp,2)
                num_1 = floor(temp(i,j)/100); % 两位数字
                num_2 = mod(temp(i,j),100); % 后两位数字
                temp(i,j) = num_1 * 60 + num_2;
            end
        end
        time_min = min(temp(2:end,1)); % 配送中心的左侧时间窗
        temp = temp - time_min; % 相减处理
        data(2:end,4:5) = temp;
    elseif judge == 0
        %   570 --> 09:30
        for i = 1 : size(temp,1)
            for j = 1 : size(temp,2)
                num_1 = floor(temp(i,j)/60); % 两位数字
                num_2 = mod(temp(i,j),60); % 后两位数字
                temp(i,j) = num_1 * 100 + num_2;
            end
        end
        time_min = min(temp(2:end,1)); % 配送中心的左侧时间窗
        temp = temp + time_min; % 相减处理
        data(:,4:5) = temp;
    end
end