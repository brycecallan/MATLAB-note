function SelCh=Mutate(SelCh,Pm)
%% *�������
%���룺
%SelCh  ��ѡ��ĸ���
%Pm     �������
%�����
% SelCh �����ĸ���
[NSel,L]=size(SelCh);
for i=1:NSel
    if Pm>=rand
        R=randperm(L);
        SelCh(i,R(1:2))=SelCh(i,R(2:-1:1));
    end
end
