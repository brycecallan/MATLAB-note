function SelCh = LocalSearch(SelCh,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij)
%%  *�ֲ���������
% ���룺SelCh               ��ѡ��ĸ���
% ���룺cusnum              �˿���Ŀ
% ���룺cap                 ���������
% ���룺demands             ������
% ���룺a                   �˿�ʱ�䴰��ʼʱ��[a[i],b[i]]
% ���룺b                   �˿�ʱ�䴰����ʱ��[a[i],b[i]]
% ���룺L                   ��������ʱ�䴰����ʱ��
% ���룺s                   �ͻ���ķ���ʱ��
% ���룺dist                ��������������ǹ�ϵ�����þ����ʾ����c[i][j] = dist[i][j]
% �����SelCh               ������ת��ĸ���
D = 15;                     % Remove�����е����Ԫ��
toRemove = 8;               % ��Ҫ�Ƴ��˿͵�����
[row,N] = size(SelCh);
for i = 1 : row
    CF = obj_fun(SelCh(i,:),cusnum,cap,demands,ET,LT,L,service_t,dist,Iij);
    [VC,~,~,~,~] = decode(SelCh(i,:),cusnum,cap,demands,ET,LT,L,service_t,dist);
    [removed,rfvc] = Remove(cusnum,toRemove,D,dist,VC);                            % ɾ��
    [ReIfvc,~] = Re_inserting(removed,rfvc,L,ET,LT,service_t,dist,demands,cap);    % ���²���
    chrom = change(ReIfvc,N,cusnum);
    % if length(chrom) ~= N
    %     record = ReIfvc;
    %     break;
    % end
    RCF = obj_fun(chrom,cusnum,cap,demands,ET,LT,L,service_t,dist,Iij);          % ����Ŀ�꺯��
    if RCF < CF
        SelCh(i,:) = chrom;
    end
end
