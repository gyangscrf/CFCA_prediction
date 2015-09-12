function [ realization_ensemble] = collect_realization(scenario,CaseNum)


%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% %for debugging
% scenario=geologic_scenarios(1);
% CaseNum=CaseNum{1};

for i=1:length(CaseNum)
    
    input_realization=['Realizations/geology' num2str(scenario) '/Case' num2str(CaseNum(i)) 'perm'];

    %load the data
    temp=importdata(input_realization);
    perm_realization=temp.data;

    unique_permvalue=unique(perm_realization);
    %the facies realization
    facies_realization=zeros(length(perm_realization),1);
    for j=1:length(unique_permvalue)
        facies_realization(find(perm_realization==unique_permvalue(j)))=j*ones(length(find(perm_realization==unique_permvalue(j))),1);
    end
    realization_ensemble(:,i)=facies_realization;
end

% %visualize the realization ensemble (check)
% figure;
% for i=1:10:length(CaseNum)
%     imagesc(reshape(realization_ensemble(:,i),200,200));
%     pause();
% end



%reshpae it to store
    realization_ensemble=reshape(realization_ensemble,length(facies_realization)*length(CaseNum),1);
    

end

