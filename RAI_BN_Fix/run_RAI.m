function []=run_RAI(n)
    addpath(genpath('/fastspace/users/benzione/bnt'));
    addpath(genpath('/fastspace/users/benzione/RAI_BN_Fix'));
%     addpath(genpath('C:\Users\benzione\Dropbox\Research\RAI\RAI\bnt'));
    ss=[500,1000,5000];
    strnodes={'Alarm1'};
    pivot=zeros(3*5,11);
    i=ss(n);
    k=1;
    for j=strnodes
        str=strcat('/fastspace/users/benzione/DBs/'...
            ,j{1},'/',j{1},'_graph.txt');
%         str=strcat('C:\Users\benzione\Dropbox\Research\RAI\RAI\Source\DBs\'...
%             ,j{1},'\',j{1},'_graph.txt');
        dag=txt2mat(str,0);
        dag=dag_to_cpdag(dag);
        for q=1:5
            str=strcat('/fastspace/users/benzione/DBs/'...
                ,j{1},'/',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
%             str=strcat('C:\Users\benzione\Dropbox\Research\RAI\RAI\Source\DBs\'...
%                         ,j{1},'\',j{1},'_s',num2str(i),'_v',num2str(q),'.txt');
            sdata=txt2mat(str,0);
            [~,C]=size(sdata);
            disp([1,i,1,1,q]);
            training=sdata+1;
            [x,~, ~]=learn_struct_pdag_rai(setdiag(ones(C),0),[],...
                    1:C,cell(C),0,'mutualC_f_e',training,0.05);
            [SHD,ME,EE,MD,ED,WD]=SHD_parts_asaf(x, dag);
            pivot(k,:)=[1,i,1,1,q,SHD,ME,EE,MD,ED,WD];
            k=k+1;
        end  
    end
    str=strcat('/fastspace/users/benzione/Outputs/SHD_RAI_LSO_michal_'...
        ,num2str(1),'_',num2str(i),'.mat');
    save(str,'pivot');
%     rmpath(genpath('C:\Users\benzione\Dropbox\Research Eyal\RAI\RAI\bnt'));
    rmpath(genpath('/fastspace/users/benzione/bnt'));
    rmpath(genpath('/fastspace/users/benzione/RAI_BN_Fix'));
end