function [ifvc,iTD] = insert(fv,fviv,fvip,fvC,rfvc,dist)
%% *���ݲ���㽫Ԫ�ز�ص�ԭʼ����
% ����fv               ���Ԫ��
% ����fviv             �����Ԫ�ز�صĳ������
% ����fvip             �����Ԫ�ز�س�������в�����λ��
% rfvc                 �Ƴ�removed�еĹ˿ͺ��final_vehicles_customer
% ����dist             �������
% ���ifvc             ���Ԫ�غ��rfvc
% iTD                  ���Ԫ�غ��rfvc���ܾ���
    ifvc = rfvc;
    sumTD = travel_distance(rfvc,dist);     %���ǰ���ܾ���
    iTD = sumTD+fvC;                                  %��غ���ܾ���
    %% �����س�������rfvc�еĳ���
    if fviv <= size(rfvc,1)
        route = rfvc{fviv};                               %��Ԫ�ز�ص�·��
        len = length(route);
        if fvip == 1
            temp = [fv route];
        elseif fvip == len+1
            temp = [route fv];
        else
            temp = [route(1:fvip-1) fv route(fvip:end)];
        end
        ifvc{fviv} = temp;
    %����������һ����
    else 
        ifvc{fviv,1} = [fv];
    end
end

