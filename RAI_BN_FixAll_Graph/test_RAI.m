addpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));
clear all;
clear clc;

% ss=[500,1000,5000];
% strnodes={'Child','Insurance','Alarm1'};
ss=5000;
strnodes={'Child'};



% alpha=[0.01,0.05,0.1];
% for w=alpha
    w=0.05;
    
    for j=strnodes
%         str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
%             ,j{1},'\',j{1},'_graph.txt');        
%         dag=txt2mat(str,0);
%         dag=dag_to_cpdag(dag);
        for i=ss
            for q=1:1
                str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
                    ,j{1},'\',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
                sdata=txt2mat(str,0);
%                 str=strcat('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\Source\DBs\'...
%                     ,j{1},'\',j{1},'_s',num2str(i),'_v',num2str(q),'.mat');
%                 load(str);
                [~,C]=size(sdata); 
                training=sdata+1;
                [x,~, ~]=learn_struct_pdag_rai(setdiag(ones(C),0),[],...
                    1:C,cell(C),0,'cond_indep_g2',training,w,'savefile','C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\RAI DBN\RAI_BN_FixAll\fix3.txt');
               
            end
        end
    end
fclose('all');