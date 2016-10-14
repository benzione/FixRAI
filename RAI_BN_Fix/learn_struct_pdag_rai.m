function [Gend, seps, Nci] = learn_struct_pdag_rai(Gstart,ex_nodes,...
    s_nodes,seps_start,n,cond_indep,sdata,varargin)
global data
global NCI
if strcmp(cond_indep,'dsep')
    disp('NOTE!!! Using ideal d-sep function');
end
% global MI % NxN matrix of mutual information values

data = sdata;
[Nc,nn] = size(sdata);
NCI=zeros(1,nn-1);

% MI = zeros(nn,nn);
% for k = 1:(nn-1)
%     for kk = (k+1):nn
%         MI([k+(kk-1)*nn, kk+(k-1)*nn]) = mutualC_e(k,kk,[],sdata);
%     end
% end

[Gend, seps] = learn_struct_rai(Gstart,ex_nodes,s_nodes,[],seps_start,n...
    ,cond_indep,varargin{:});
Gend = create_cpdag(Gend,seps);

Nci = NCI;

clear global data
clear global NCI
clear global MI