%read through the successful simulations
function [SuccessNum,Success_Sample]=TestSuccess()
%success=dir('Result/Attempt1_Success/*.PRT' );
success=dir('Result/*.FUNRST' );


for i=1:length(success)
temp=success(i,1).name;
%this is for FUNRST files
SuccessNumString=temp(5:end-7);
SuccessNum(i)=str2num(SuccessNumString);
end



%load the Sample Num

MC_Sample=load('MC_Sample.dat');


Success_Sample=MC_Sample(SuccessNum,:);


%plot the cdfs of the successful ones
%11 variables to plot the 11 pdf

% for i=1:size(Success_Sample,2)
%     figure(i)
%     hist(Success_Sample(:,i));
% end
end
