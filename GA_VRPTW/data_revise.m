function data = data_revise(data,judge)
% data    input   ��������
% data    output  �������
    if judge == 1
        % 09:30 --> 09 * 60 + 30
        temp = data(2:end,4:5); % �����������
        for i = 1 : size(temp,1)
            for j = 1 : size(temp,2)
                num_1 = floor(temp(i,j)/100); % ��λ����
                num_2 = mod(temp(i,j),100); % ����λ����
                temp(i,j) = num_1 * 60 + num_2;
            end
        end
        time_min = min(temp(2:end,1)); % �������ĵ����ʱ�䴰
        temp = temp - time_min; % �������
        data(2:end,4:5) = temp;
    elseif judge == 0
        %   570 --> 09:30
        for i = 1 : size(temp,1)
            for j = 1 : size(temp,2)
                num_1 = floor(temp(i,j)/60); % ��λ����
                num_2 = mod(temp(i,j),60); % ����λ����
                temp(i,j) = num_1 * 100 + num_2;
            end
        end
        time_min = min(temp(2:end,1)); % �������ĵ����ʱ�䴰
        temp = temp + time_min; % �������
        data(:,4:5) = temp;
    end
end