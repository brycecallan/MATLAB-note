%% ��˿�i��˿�j֮��������
%����i,j    �˿�
%����dist   �������
%����vehicles_customer        ÿ�����������Ĺ˿ͣ������ж�i��j�Ƿ���һ��·����
%�����һ��·����Ϊ0������һ��·����Ϊ1
%���Rij      �˿�i�͹˿�j�������
function Rij=Relatedness( i,j,dist,vehicles_customer )
n=size(dist,1)-1;           %�˿�������-1����Ϊ��ȥ��������
NV=size(vehicles_customer,1);       %���ͳ�����
%����cij'
d=dist(i+1,j+1);
[md,mindex]=max((dist(i+1,2:end)));
c=d/md;
%�ж�i��j�Ƿ���һ��·����
V=1;                %���ʼ�˿�i��˿�j����ͬһ��·����
for k=1:NV
    route=vehicles_customer{k};         %����·���Ͼ����Ĺ˿�
    findi=find(route==i,1,'first');     %�жϸ���·�����Ƿ񾭹��˿�i
    findj=find(route==j,1,'first');     %�жϸ���·�����Ƿ񾭹��˿�j
    %���findi��findjͬʱ�ǿգ���֤������·����ͬʱ�����˿�i�͹˿�j����V=0
    if ~isempty(findi)&&~isempty(findj)
        V=0;
    end
end
%����˿�i��˿�j�������
Rij=1/(c+V);

end

