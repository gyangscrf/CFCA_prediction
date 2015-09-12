function bool = show_examples( realization_idx )

%show geologic realizations for showing purposes 

%2 examples to show in the presentation
realization_idx=264;
%realization_idx=7;

%paramter sample
%ParametersValues_Sample=ParametersValues(realization_idx,:);
%Get the realization
facies_Sample=show_property(realization_idx);

figure;
imagesc(reshape(facies_Sample,NX,NY));

end