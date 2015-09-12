function Facies = MakeFacies(filename)

disp(['reading' blanks(2) filename ]);
perm=importdata(filename);

perm_data=perm.data;

Facies=zeros(length(perm_data),1);
%check we have 3 facies or 2 facies,sorted is defaulted
N_facies=unique(perm_data);


%show the facies figure
%perm_3d=reshape(perm_data,200,200);
%figure;
%imagesc(perm_3d);

%clear idx_facies;
%find the indexes 
for i=1:length(N_facies)
    idx=find(perm_data==N_facies(i));
    Facies(idx)=i;
end



end
