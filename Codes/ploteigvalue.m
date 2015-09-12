function ploteigvalue( eigValue )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here


ncomponent=length(eigValue);
percentage=cumsum(eigValue);
percentage=percentage/sum(eigValue);
figure;
%axis handle
axes('FontSize',12,'FontWeight','b');hold on;box on;
plot(1:ncomponent,percentage,'b-');

end

