function Ld=leave_load( route,demands)
%% *����ĳһ��·�����뿪�������ĺ͹˿�ʱ���ػ���
%����route��               һ������·��
%����demands��             ��ʾ�ɼ����������͵��˿͵�������
%���Ld��                  ��ʾ�����뿪��������ʱ���ػ���
    n=length(route);                            %����·�߾����ӹ�����Ͱ�װ���ص�������
    Ld=0;                                       %��ʼ�����ڼ�������ʱ��װ����Ϊ0
    if n~=0
        for i=1:n
            if route(i)~=0
                Ld=Ld+demands(route(i));
            end
        end
    end
end

