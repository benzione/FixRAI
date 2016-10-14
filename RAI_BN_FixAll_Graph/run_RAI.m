% addpath(genpath('/fastspace/users/benzione/bnt'));
% addpath(genpath('/fastspace/users/benzione/RAI_BN_FixAll'));
addpath(genpath('C:\Users\benzione\Dropbox\Research\RAI\RAI\bnt'));
clear all;
clear clc;

ss=[500,1000,5000];
strnodes={'Asia'};
SHD=zeros(1,1);
dags=cell(1,5);

% alpha=[0.01,0.05,0.1];
% for w=alpha
    w=0.05;
    k=1;
    for j=strnodes
        str=strcat('C:\Users\benzione\Dropbox\Research\RAI\RAI\Source\DBs\'...
            ,j{1},'\',j{1},'_graph.mat');
        load(str);
%         dag=txt2mat(str,0);
%         dag=dag_to_cpdag(dag);
        dag=dag_to_cpdag(graph);
        for i=ss
            for q=1:5
                str=strcat('C:\Users\benzione\Dropbox\Research\RAI\RAI\Source\DBs\'...
                    ,j{1},'\',j{1},'_s',num2str(i),'_v',num2str(q),'.mat');
%                 sdata=txt2mat(str,0);
                load(str);
                [~,C]=size(sdata);
                disp([w*100,k,q]);
%                 training=sdata+1;
                training=sdata;
                [x,~, ~]=learn_struct_pdag_rai(setdiag(ones(C),0),[],...
                        1:C,cell(C),0,'cond_indep_g2',training,0.05,'savefile','C:\Users\benzione\Dropbox\Research\RAI\RAI\RAI DBN\RAI_BN_FixAll\fix3.txt');
                [shd,~,~,~,~,~]=SHD_parts_asaf(x, dag);
                SHD(k)=SHD(k)+shd;
                dags{k,q}=x;
            end
            
            k=k+1;
        end
    end
% end
SHD=SHD/5;
str=strcat('/fastspace/users/benzione/Outputs/SHD_RAI_fix_all_michal'...
                ,num2str(w*100),'.mat');
save(str,'SHD','dags');
rmpath(genpath('/fastspace/users/benzione/bnt'));
rmpath(genpath('/fastspace/users/benzione/RAI_BN_FixAll'));