function SelCh=Recombin(SelCh,Pc)
%% *�������
% ����
%SelCh  ��ѡ��ĸ���
%Pc     �������
%�����
% SelCh �����ĸ���
NSel=size(SelCh,1);
for i=1:2:NSel-mod(NSel,2)
    if Pc>=rand %�������Pc
        [SelCh(i,:),SelCh(i+1,:)]=OX(SelCh(i,:),SelCh(i+1,:));
    end
end