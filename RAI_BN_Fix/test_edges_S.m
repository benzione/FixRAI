function [Gend,seps] = test_edges_S(P,C,G,ex_nodes,s_nodes,class_node,Seps,n,cond_indep,data,varargin)
global NCI
%global MI

len_p = length(P);
%len_MI = length(MI);

% % sort edges to be tested according to their mutual information value -----
% MInf = MI(P+(C-1)*len_MI);
% [MIs, I] = sort(MInf);
% P = P(I);
% C = C(I);
% % -------------------------------------------------------------------------

sv=find(strcmp(varargin,'savefile'));
if length(sv>0)
    sv=sv(1);
    sfname=varargin{sv+1};
    varargin=varargin([1:(sv-1),sv+2:end]);
    fid=fopen(sfname,'at');
else
    fid=-1;
end
Gend=G;
Gs = zeros(size(G));
r_nodes = union(ex_nodes,s_nodes);
Gs(r_nodes,r_nodes) = G(r_nodes,r_nodes);

seps=Seps;

CI_tests=cell(max([P;C;0])); % record of conducted CI test. Used to eliminate redundant tests.

for k = 1:len_p
    if (n~=0)
%         pa = find(Gend(:,C(k)));% identify the parents of the child node % G->Gend
%         par=mysetdiff(pa,P(k));
        par=unique(mysetdiff(neighbors(Gend, C(k)), P(k)));


%         Gp = Gs; Gp(C(k),:)=0; Gp(:,C(k))=0; % remove the child node
%         RG = reachability_graph(double(Gp | Gp')); % identify the nodes connected to the parent node
%         par = intersect(setdiff(find(RG(P(k),:)),P(k)),pa);
%         par=mysetdiff(pa,P(k));
        
        S = subsets1(sort(par),n); % select a condition set with size n from the parents group
    else
        S = {[]};
    end
    for si = 1:length(S)
        if ((Gend(P(k),C(k))==1) || (Gend(C(k),P(k))==1))
            % % %         fprintf('CI test: %d and %d given\t',P(k),C(k));
            % % %         fprintf('%d ',S{si});
            % % %         fprintf('\n');
            ci_record=sprintf('%d,',sort(S{si}));
            s_pair=sort([P(k),C(k)]);
            if ~isempty(CI_tests{s_pair(1),s_pair(2)})
                a=sum(strcmp(CI_tests{s_pair(1),s_pair(2)}(:),ci_record)); % check if test was previously conducted
            else
                a=0;
                CI_tests{s_pair(1),s_pair(2)}{1}=ci_record;
            end
                
            if a==0
                CI_tests{s_pair(1),s_pair(2)}{end+1}=ci_record;
                NCI(length(S{si})+1) = NCI(length(S{si})+1) + 1;
                if (fid>0) & (n>0) % write to file
                    fprintf(fid,'%d,%d,%d',P(k),C(k),length(S{si}));
                    fprintf(fid,',%d',S{si});
                    fprintf(fid,',%f\n',0); % mutual information value (not supported yet)
                end
                [threshold_val,~]=s1cond(P(k),C(k), [S{si},class_node],data, varargin{:});
                [CI, ~]=mutual2_decision(P(k),C(k), [S{si},class_node], data,threshold_val);
%                 CI=feval(cond_indep,P(k),C(k), [S{si},class_node] ,data,varargin{:});
                if CI

                        seps{P(k),C(k)} = S{si};
                        seps{C(k),P(k)} = S{si};
                        Gend(P(k),C(k)) = 0;
                        Gend(C(k),P(k)) = 0;
                        Gs(P(k),C(k)) = 0;
                        Gs(C(k),P(k)) = 0;
                        lnk = 0;
                        %fprintf('edge(%d,%d) was removed\n',P(k),C(k));
                    
                    break
                end
            end
        end
    end
end
if fid>0
    fclose(fid);
end
clear NCI