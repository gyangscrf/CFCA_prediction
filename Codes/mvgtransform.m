function [harmscr_prediction_transformed,lamda_transformed,constant_transform]=mvgtransform(harmscr_prediction)
%This is a univariate gaussian transform
%   Detailed explanation goes here

% max_scores=max(harmscr_prediction);
% min_scores=min(harmscr_prediction);
% 
% figure;
% for i=1:size(harmscr_prediction,2)
%     
%     harmscr_prediction_norm(:,i) = (harmscr_prediction(:,i) - min_scores(i))/(max_scores(i) - min_scores(i));
% 
%     subplot(3,2,i)
%     hist(harmscr_prediction_norm(:,i));
%     title(['harmonic scores histogram in' blanks(1) num2str(i) 'th dimension']);
% end



%add the minimum positive constant
positive_constant=0.001;
harmscr_prediction_transformed=[];

for i=1:size(harmscr_prediction,2)
    %get ith column
    temp=harmscr_prediction(:,i);
    %maximum negative 
    temp_min=min(temp);
    %make sure all are positive
    temp_positive=temp-temp_min+positive_constant;
    %normal transformation
    [temp_transformed,temp_lamda]=boxcox(temp_positive);
    %inverse of square
    %temp_transformed=-1./temp;
    %do log10 transform
    %temp_transformed=log(temp_positive);
    
    harmscr_prediction_transformed(:,i)=temp_transformed;
    lamda_transformed(i)=temp_lamda;
    constant_transform(i)=-temp_min+positive_constant;
    
    %backtransform
    temp_backtransform=(temp_transformed*temp_lamda+1).^(1/temp_lamda)-constant_transform(i);
 
  
    %backtransform back of log10
    %temp_backtransform=10.^temp_transformed-constant_transform(i);
  
    
    figure;
    subplot(3,1,1);
    hist(temp);
    title(['scores in' blanks(1) num2str(i) 'th dimension before transform'] );
    
    subplot(3,1,2);
    hist(harmscr_prediction_transformed(:,i));
    title(['scores in' blanks(1) num2str(i) 'th dimension after transform']);
    
    subplot(3,1,3);
    hist(temp_backtransform);
    title(['scores in' blanks(1) num2str(i) 'th dimension after back transform'] );
end

%plot the histogram of harmonic scores in each dimension 
figure;
for i=1:size(harmscr_prediction_transformed,2)
    subplot(3,2,i)
    hist(harmscr_prediction_transformed(:,i));
    title(['transformed harmonic scores histogram in' blanks(1) num2str(i) 'th dimension']);
end






end

