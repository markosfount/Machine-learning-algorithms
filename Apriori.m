%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Implementation of Apriori algorithm %%%%%%
%% by @subdime (use of this code is allowed to anyone for any reason) %%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

disp('This is an implementation of the Apriori algorithm, to find association rules in customer behavior towards specific products \n')
supp=-1;
while (supp<0 || supp>100 || isnan(supp))   
    supp=str2double(input('Please enter desired support (%) \n','s'));
end

conf=-1;
while (conf<0 || conf>100 || isnan(conf))   
    conf=str2double(input('Please enter desired confidence (%) \n','s'));
end

%% 1st step
%Create C1, which is the set of all items in db

db=xlsread('apriori_input.xlsx');

%Create L1 (1-item frequent set)

L=[];
[l,w]=size(db);
for i=1:w
    freq(i)=size(db(db(:,i)==1),1);
    if (freq(i)/l>=supp/100)
        L=[L; i]
    end
end

%% 2nd - last step
flag2=0;
for step=2:w
    
    %Get all possible item combinations to generate C
    C=nchoosek(unique(L),step);         %join step, where Li is joined with Li to 
    if isempty(C)                       %formulate all Ci+1 possible combinations
        break
    end
    delC=[];
    for i=1:size(C,1);
        Crow=nchoosek(C(i,:),step-1);   %Ci+1 is broke down to all i sets that formulate it
        for k=1:size(Crow,1)                    
            flag=0;
            for j=1:size(L,1)                   %if an i set is not a member of Li
                if (all(Crow(k,:)==L(j,:)))     %we remove the corresponding Ci+1 
                    flag=1;                     %from which it derives
                    break
                end
            end
            if (~flag)
                delC=[delC; i];     %prune step, only frequent Ci+1 items remain
            end
        end
    end
    
    C(delC,:)=[];
    
    freq=zeros(1,size(C,1));
    Lprev=L;
    L=[];
    
    %Find which item combinations satisfy given support (L)
    for i=1:size(C,1)
        freq(i)=sum(all(db(:,C(i,:)),2));  
        if freq(i)/l>=supp/100
            L=[L; C(i,:)];
        end
    end
    
    %%Find all subset of L and calculate confidence
    
    for i=1:size(L,1)
        freqL=sum(all(db(:,L(i,:)),2));
        for j=1:size(L,2)-1
            subsets=nchoosek(L(i,:),j);
            for k=1:size(subsets,1)
                sub1=subsets(k,:);                  %find L subsets
                [f,pos]=(ismember(sub1,L(i,:)));
                sub2=L(i,:);
                sub2(pos)=[];
                
                freq1=sum(all(db(:,sub1),2));   %find subset frequency and
                dconf=freqL/freq1;              %compare with given confidence
                if dconf>=(conf/100)
                    flag2=flag2+1;
                    if flag2==1
                        fprintf('The following association rules are present: \n')
                    end
                    fprintf('%d ', sub1)
                    fprintf('-->')
                    fprintf('%d ', sub2)
                    fprintf(' \n')
                end
            end
        end
    end
    
    if isempty(L)
        L=Lprev;
        break
    end
    
end

%%Find all subset of Lmax and calculate confidence

if flag2==0
    fprintf('There are no association rules with the given support and confidence \n')
end







