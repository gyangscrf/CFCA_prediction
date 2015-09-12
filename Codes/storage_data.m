function bool = storage_data( order,conc_profile_sum,arrival_time_sum,SampleLine )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%storage the processing order
output_order='Result/order';
storage(output_order,order);

	
%storage the data
output_soil_sum=['Result/concsum_Line' num2str(SampleLine)];
storage(output_soil_sum,conc_profile_sum);


%store the arrival time
output_time_sum=['Result/timesum_Line' num2str(SampleLine) ];
storage(output_time_sum,arrival_time_sum);

bool=1;
end

