function TD = travel_distance(VC,dist)
%%  *����ÿ��������ʻ�ľ��룬�Լ����г���ʻ���ܾ���
% ����VC   ÿ�����������Ĺ˿�
% ����dist                �������
% ���sumTD               ���г���ʻ���ܾ���
% ���everyTD             ÿ��������ʻ�ľ���
TD = 0;
for i = 1 : length(VC)
    for j = 1 : length(VC{i})
        if j == 1 | j == length(VC{i})
            TD = TD + dist(1,VC{i}(j)+1);
        else
            TD = TD + dist(VC{i}(j)+1,VC{i}(j+1)+1);
        end
    end
end