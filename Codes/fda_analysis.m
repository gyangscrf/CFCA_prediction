function [ harmscr,pcas,b_Object ] = fda_analysis( concentration_curve, breaks, NX )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%run FDA analysis
% test of breaking in
%concentration_curve=log_conc_profile_t_choice;
% concentration_curve=log_conc_profile_t_choice_bt;
%% A. Create functional basis object:
    % Basis controls:
    norder=3; 
    %breaks=[0:10:20 28:4:160 170:10:200] ;
    nbasis=length(breaks)+norder-2;
    %Why this?
    %nbasis=nknots+norder-2;
    
    % Create basis object:
    a_basis=create_bspline_basis([0 NX],nbasis,norder,breaks);
    %clear a_basis;
    %other types of basis object??
    %a_basis=create_polygon_basis((0:5:NX));
%     
%     figure(2);
%     %Plot basis to see what it looks like:
%     plot(a_basis);
%     
%% B. Basis expansion:
    [b_Object]=smooth_basis(1:NX,concentration_curve,a_basis);
    
%     figure(3);
%     %Check one fit:
%     %Or we can construct all the curves
%     for i=1:size(concentration_curve,2)
%         %plotfit_fd(concentration_curve(:,i),1:NX,b_Object(i));
%         plotfit_fd(concentration_curve,1:NX,b_Object); 
%         pause()
%     end


%% C. Functional Principal Component Analysis
    ncomp = 6;
    pcas = pca_fd(b_Object, ncomp);
    
    %plot the eigenfunctions
%     figure;
%     subplot(1,1,1);
%     plot_pca(pcas);
%     
%     figure;
%     plot(pcas.harmfd)
    
    figure;
    % Plot scree plot:
    % get the cumulative value
    varprop_cumulative=cumsum(pcas.varprop);
    
    %varprop_cumulative_percent=varprop_cumulative/varprop_cumulative(end);
    plot(varprop_cumulative,'-b','LineWidth',3); xlabel('Eigen Component'); ylabel('Percent Variance Explained');

%     figure(5);
%     % fPCA Score plot (this is where we do model selection/interpretation, clustering etc.):
%     plot(pcas.harmscr(:,1),pcas.harmscr(:,2),'ob');
%     xlabel('Score on PC1');
%     ylabel('Score on PC2');
%     title('fPCA score plot');

    harmscr=pcas.harmscr;
    

end

