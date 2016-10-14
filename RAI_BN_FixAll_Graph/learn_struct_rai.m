function [Gend,seps] = learn_struct_rai(Gstart,ex_nodes,s_nodes,class_node,seps_start,n,cond_indep,varargin)
% [Gend,seps] = learn_struct_rai(Gstart,ex_nodes,s_nodes,-1,seps_start,n,cond_indep,data,th)
% 
% Learn the structure of the domain enclosed by the nodes s_nodes starting with
%   n - separation resolution
% fprintf('Order %d\n',n);
% Gstart contains ex_nodes
global data
global NCI

Gend = Gstart;
seps = seps_start;

if ~exit_cond_rai(Gend,s_nodes,n);
    % remove spurious exogenous effect
    [Gend,seps] = remove_ex_effect(Gend,ex_nodes,s_nodes,class_node,seps,n,cond_indep,data,varargin{:});
    t=biograph(Gend);
    view(t);
    child_handles = allchild(0);
    names = get(child_handles,'Name');
    k = strncmp('Biograph Viewer', names, 15);
    str=strcat('C:\Users\benzione\Dropbox\Research\RAI\Fix RAI\Graph\n-',num2str(n),...
        ' ex_nodes-',num2str(length(ex_nodes)),'-',num2str(ex_nodes),...
        ' s_nodes-',num2str(length(s_nodes)),'-',num2str(s_nodes),' remove_ex_effect');
    print(child_handles(k),'-djpeg',str);
    close(child_handles(k));
   
    %Gend = minimal_pattern_data1(Gend,seps,data);
    %Gend = minimal_pattern(Gend,seps);
    Gend = create_cpdag1(Gend,seps);
    
    t=biograph(Gend);
    view(t);
    child_handles = allchild(0);
    names = get(child_handles,'Name');
    k = strncmp('Biograph Viewer', names, 15);
    str=strcat('C:\Users\benzione\Dropbox\Research\RAI\Fix RAI\Graph\n-',num2str(n),...
        ' ex_nodes-',num2str(length(ex_nodes)),'-',num2str(ex_nodes),...
        ' s_nodes-',num2str(length(s_nodes)),'-',num2str(s_nodes),' create_cpdag1');
    print(child_handles(k),'-djpeg',str);
    close(child_handles(k));
    % Remove edges between nodes in Gend
    [Gend,seps] = thin_structure(Gend,ex_nodes,s_nodes,class_node,seps,n,cond_indep,data,varargin{:});
    
    t=biograph(Gend);
    view(t);
    child_handles = allchild(0);
    names = get(child_handles,'Name');
    k = strncmp('Biograph Viewer', names, 15);
    str=strcat('C:\Users\benzione\Dropbox\Research\RAI\Fix RAI\Graph\n-',num2str(n),...
        ' ex_nodes-',num2str(length(ex_nodes)),'-',num2str(ex_nodes),...
        ' s_nodes-',num2str(length(s_nodes)),'-',num2str(s_nodes),' thin_structure');
    print(child_handles(k),'-djpeg',str);
    close(child_handles(k));
    %Gend = minimal_pattern_data1(Gend,seps,data);
    %Gend = minimal_pattern(Gend,seps);
    Gend = create_cpdag1(Gend,seps);
    
    t=biograph(Gend);
    view(t);
    child_handles = allchild(0);
    names = get(child_handles,'Name');
    k = strncmp('Biograph Viewer', names, 15);
    str=strcat('C:\Users\benzione\Dropbox\Research\RAI\Fix RAI\Graph\n-',num2str(n),...
        ' ex_nodes-',num2str(length(ex_nodes)),'-',num2str(ex_nodes),...
        ' s_nodes-',num2str(length(s_nodes)),'-',num2str(s_nodes),' create_cpdag2');
    print(child_handles(k),'-djpeg',str);
    close(child_handles(k));
    % Identify autonomous sub-structure
    Ga = zeros(size(Gend));
    Ga(s_nodes,s_nodes) = Gend(s_nodes,s_nodes);
    
%     d_nodes = intersect(lowest(Ga),s_nodes);%     d_nodes = intersect(lowest_order_set(Ga),s_nodes);
    d_nodes = LowestSet(Ga, s_nodes);
    
    a_nodes = setdiff(s_nodes,d_nodes);
    Ga(:,d_nodes) = 0;
    Ga(d_nodes,:) = 0;
    
    Gsub = unconnected_ancestors(Ga,a_nodes);
    
    clear data
    clear NCI
    
    % Recursive call for structure learning of each of the ancestor sub-structures
    for k = 1:length(Gsub)
        [Gend,seps] = learn_struct_rai(Gend,ex_nodes,Gsub{k},class_node,seps,n+1,cond_indep,varargin{:});
    end
    
    % Recursive call for descendants sub-structure structure learning
    [Gend,seps] = learn_struct_rai(Gend,[a_nodes ex_nodes],d_nodes,class_node,seps,n+1,cond_indep,varargin{:});
    
end

%%%%%% Exit condition %%%%%%
function res = exit_cond_rai(G,snodes,n)
if isempty(snodes)
    res = 1; % exit condition is met
else
    if (max(sum(G(:,snodes))) > n) && (n < 10)
        res = 0; % exit condition is not met
    else
        res = 1; % exit condition is met
    end
end