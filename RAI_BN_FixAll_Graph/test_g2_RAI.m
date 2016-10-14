addpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));
% addpath(genpath('/fastspace/users/benzione/bnt'));
% addpath(genpath('/fastspace/users/benzione/RAI_BN'));
clear all;
clear clc;

% ss=[500,1000,5000];
% strnodes={'Child','Insurance','Alarm1'};
ss=[500,5000];
strnodes={'Child','Alarm1'};
SHD=zeros(4,5);
dags=cell(4,5);
% bdeuArr=zeros(5,800);


% alpha=[0.01,0.05,0.1];
% for w=alpha
    w=0.05;
    k=1;
    for j=strnodes
        str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
            ,j{1},'\',j{1},'_graph.txt');
%         str=strcat('/fastspace/users/benzione/DBs/'...
%             ,j{1},'/',j{1},'_graph.txt');
        dag=txt2mat(str,0);
        dag=dag_to_cpdag(dag);
        for i=ss
            for q=1:5
                str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
                    ,j{1},'\',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
%                 str=strcat('/fastspace/users/benzione/DBs/'...
%                     ,j{1},'/',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
                sdata=txt2mat(str,0);
                [~,C]=size(sdata); 
                training=sdata+1;
                
%                 for w=0.0015:0.0005:0.4
                    disp([w*10000,k,q]);
                    [x,~, ~]=learn_struct_pdag_rai(setdiag(ones(C),0),[],...
                            1:C,cell(C),0,'cond_indep_g2',training,w);
                    [shd,~,~,~,~,~]=SHD_parts_asaf(x, dag);
                    SHD(k,q)=shd;
                    dags{k,q}=x;
                    
%                 end
%                 node_size=max(training);
%                 bdeuScore=score_dags(training',node_size,dags(q,:));
%                 bdeuArr(q,:)=bdeuScore;
                
            end
            k=k+1;
        end
    end
% bdeuArr(:,1:2)=-99999999;
% SHD(:,1:2)=9999999;
% end
str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Outputs\test_RAI_g2_fix_'...
    ,num2str(w*10000),'.mat');
% str=strcat('/fastspace/users/benzione/Outputs/summary_RAI_test.mat');
save(str,'dags','SHD');
rmpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));
% rmpath(genpath('/fastspace/users/benzione/bnt'));
% rmpath(genpath('/fastspace/users/benzione/RAI_BN'));