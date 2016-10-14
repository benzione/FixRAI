function [G]=exhustive(gstart,snodes,data)

    C=length(gstart);
    n=length(snodes);
    
    subs=my_mk_all_dags(n,C,snodes);
    
    node_size=max(data);
    bdeuScore=score_dags(data',node_size,subs);
    
    [~,I]=max(bdeuScore);
    
    Gend=subs{I};
    gstart(snodes,snodes)=Gend(snodes,snodes);
    G=gstart;
end