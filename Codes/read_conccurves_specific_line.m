function [ arrival_time,conc_profile] =read_conccurves_specific_line( processidx,specific_line )
%This function reads concentration profile along specific line for 2D
%simulations
%   Detailed explanation goes here
    %for showcase purposes (grey out later)
    processidx=264;
    %or another one is 264
    specific_line=100;
    Prediction_Line=120;
    
    NX=200;
    NY=200;
    NZ=1;
    numyr=20;
    file_name=['Result/CASE' num2str(processidx) '.FUNRST' ];
    
    %misslist=[70 71 321 335 542 993];
    %parfor i=misslist
    %for i=misslist
    %there are some issues about variable classification if we store the output of sgas into a matrix by slicing
    %so to get around this problem, I write out all the processed files and later read back in (Comment:G.Y)
    %initialize the arrival time for the realization
    arrival_time=zeros(NX,1);
    conc_profile=zeros(NX,numyr);
    
    
    
    %loop through time steps
    for j=1:numyr
    soil=read_w_saturation_fmt(file_name, NX, NY, NZ, j);
    %visulization check (for 2d cases)
    soil_2d=reshape(soil,NX,NY);
    
    %plot the 2d saturation
    hFig1=figure(1);clf;
    axes('Layer','top','FontSize',18,'FontWeight','b'); box on; hold on;
    %axis square;
    %image(soil_2d');
    imagesc(flipdim(soil_2d',1));
    
    title(['NAPL concentration' blanks(1) 'at yr' num2str(j)], 'FontSize', 20);
    xlim([0 NX]);
    ylim([0 NY]);
%     xlabel('I index');
%     ylabel('J index');
    %set the color bar limit
    hc=colorbar;
    set(hc,'fontsize',18,'FontWeight','b');
    caxis([0, 1]);
    set(hFig1, 'Position', [100 500 600 400]);
    hold on;
    monitor_location=20:20:180;
    line_monitor=100;
    scatter(monitor_location,ones(length(monitor_location),1)*line_monitor,50,'wo','filled');
    hold on;
    plot(1:NX, ones(NX,1)*120,'w-','LineWidth',3);
    
    out_fig_name1=['2D_Case_' num2str(processidx) '_yr' num2str(j)];
    print(hFig1, '-djpeg', out_fig_name1); 
    

    %store the soil at J=100
    conc_temp=soil_2d(:,NY-specific_line+1);
    %store each time step into different rows
    % this is not going to work for parallel environment
    conc_profile(:,j)= conc_temp;
    
    conc_pred_temp=soil_2d(:,NY-Prediction_Line+1);
    
    %plot the concrentation curve
    hFig2=figure(2);clf;
    %subplot(2,1,1);
    axes('FontSize',18,'FontWeight','b'); hold on;box on;
    plot(1:NX,conc_temp,'b-','LineWidth',3);
    title(['Concentration profile along J=' num2str(specific_line) blanks(1) 'at yr' num2str(j)],'FontSize', 16);
    xlabel('I index');
    ylabel('Concentration');
    ylim([0 1]);
    set(hFig2, 'Position', [600 500 600 400]);
    out_fig_name2=['Conc_Case_' num2str(processidx) '_yr' num2str(j)];
    print(hFig2, '-djpeg', out_fig_name2);
    
    
    %subplot(2,1,2);
    hFig3=figure(3);clf;
    axes('FontSize',18,'FontWeight','b');hold on; box on;
    plot(1:NX,conc_pred_temp,'r-','LineWidth',3);
    title(['Concentration profile along J=' num2str(Prediction_Line) blanks(1) 'at yr' num2str(j)], 'FontSize', 16);
    xlabel('I index');
    ylabel('Concentration');
    ylim([0 1]);
    set(hFig3, 'Position', [300 100 600 400]);
    out_fig_name3=['Time_Case_' num2str(processidx) '_yr' num2str(j)];
    print(hFig3, '-djpeg', out_fig_name3);


    %store the arrival time for J=100
    idx=find(conc_temp>0);
    bool_idx=isempty(idx);
    %if there are places over 10%
    if (~bool_idx)
        %inner loop 
        for p=1:length(idx)
        if(arrival_time(idx(p))==0)
        arrival_time(idx(p))=j;
        end
        end
    end
    
    
    %plot the arrival time
%     hFig3=figure(3);
%     axes('FontSize',12,'FontWeight','b');hold on;box on;
%     subplot(2,1,1);
%     plot(1:NX,arrival_time,'-');
%     title(['Pollution Arrival time along J=' num2str(SampleJ) blanks(1) 'at yr' num2str(j)]);
%     xlabel('I index');
%     ylabel('Arrival time');
%     subplot(2,1,2);
%     plot(1:NX,arrival_time_pred,'-');
%     title(['Pollution Arrival time along J=' num2str(Prediction_Line) blanks(1) 'at yr' num2str(j)]);
%     xlabel('I index');
%     ylabel('Arrival time');
%     set(hFig3, 'Position', [300 100 600 400]);
%     out_fig_name3=['Time_Case_' num2str(processidx) '_yr' num2str(j)];
%     print(hFig3, '-djpeg', out_fig_name3);
    pause(0.1);
    end %end of timesteps
    
    %reshape the conc_profile here
    conc_profile=reshape(conc_profile,NX*numyr,1);
    
 
  
end

