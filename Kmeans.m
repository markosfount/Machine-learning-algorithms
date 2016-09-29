%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% This is an implementation of K-means algorithm %%%%%%
%% coded by @subdime (free use is allowed by anyone) %%%%%%%%%%%%%%%%%%%

close all
clear all
clc

%% Read Db and change data type %%

[num,str]=xlsread('Kmeans_input.xlsx',1,'A1:C200');
if size(num,2)==2
    data=[num str2num(cell2mat(str))];
else
    data=num;
end

%%Read number of clusters

nbclusters=0;
while (fix(nbclusters)~=nbclusters || nbclusters<=0 || nbclusters>size(data,1))
   nbclusters=str2double(input('Please enter number of teams \n','s'));
end

sel='p';
while (~strcmp(sel,'r') && ~strcmp(sel,'s'))
    sel=input('Press ''r'' to randomly select cluster centroids, or ''s'' to select them manually \n','s');
end

%%User enters a specific centroid for each cluster
centroid=zeros(nbclusters,1);
incents=[];
if (strcmp(sel,'s'))
    for i=1:nbclusters
        while (~ismember(centroid(i),[1:length(data)]) || ismember(centroid(i),incents))
            fprintf('Please enter desired center of Cluster %d ', i)
            centroid(i)=str2double(input('','s'));
        end
        incents=[incents centroid(i)];
    end
else
%%Centers of clusters are selected randomly
    rng('shuffle'); 
    for i=1:nbclusters
        temp=randi(200);
        while (ismember(temp,centroid))
            temp=randi(200);
        end
        centroid(i)=temp;
    end
end
means=data(centroid,:);
clusters_old={};
clusters=cell(nbclusters,1);

for k=1:100
    
    fprintf('Algorithm Step %d \n',k);
    fprintf('\n')
    
    %% We are using Euclidean distance without any weight factors
    %% Calculate distance from each cluster centroid and assign points to clusters
    for ab=1:nbclusters
        clusters{ab}=[];
    end
   
    %Calculate distances and find the minimum
    for i=1:length(data)
        for j=1:nbclusters
           distance(i,j)=sqrt(sum((data(i,:)-means(j,:)).^2)); 
        end
        [mindist(i,1),mindist(i,2)]=min(distance(i,:));
        clusters(mindist(i,2))={[clusters{mindist(i,2)} i]};
    end
    
    for i=1:nbclusters
        fprintf('Cluster %d : \n',i)
        fprintf('\n')
        fprintf('%d \n',clusters{i})
        fprintf('\n')
    end
    if (isequal(clusters,clusters_old))
        break
    end
    
    clusters_old=clusters;
    %%Calculate new center points
    for i=1:nbclusters
        means(i,:)=sum(data(clusters{i},:))./length(clusters{i});
    end
end

if nbclusters<=5
    color=['r';'k';'b';'g';'y'];
else
    color=hsv(nbclusters);
end

for i=1:nbclusters
    scatter3(data(clusters{i},1),data(clusters{i},2),data(clusters{i},3),40,color(i,:))
    hold on;
    scatter3(means(i,1),means(i,2),means(i,3),40,color(i,:),'x')
end

