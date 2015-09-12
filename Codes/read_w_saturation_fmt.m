function So=read_w_saturation_fmt(file_name, nx, ny, nz, yr)

% We are only reading 2 yrs data specified in the Eclipse schedule section (rptsched)
% The SkipLines are case by case and not general, you need to find the smallest number of skiplines in order to 
% make this function to work, usually this number relates to the smallest file of the output simulation PRT file
% Commented by Guang Yang, 2014
%% at year 2001

fid_in = fopen(file_name,'r');
temp_outfile=strrep(file_name, 'FUNRST', 'dat');
fid_out = fopen(temp_outfile,'w');
%Here the skiplines based on the output file
SkipLines=13150+23260*(yr-1);

%find line number with specific characters

%skiplines makes the program much faster
for n=1:SkipLines
 s = fgetl(fid_in);
end

%starting from the first line after skiplines
while true;
    line = fgets(fid_in);
    %find the line with SWAT
    if strfind(line,'SWAT')>0
    
    %line = fgets(fid_in);
    break;
    end
end



%for FUNRST,each line has 4 cells
lines=ceil(nx*ny*nz/4);
count = 0;


%writeout the saturation values
%write out lines of strings
for i=1:lines
    line = fgets(fid_in);
    %print out this line
    fprintf(fid_out,'%s',line);
end
 
fclose(fid_out);
fclose(fid_in);


pp=importdata(temp_outfile);

sw_1=[];
lines_full=floor(nx*ny*nz/4);
left_out=nx*ny*nz-lines_full*4;
if(left_out==0)
    
    for i=1:lines_full
        sw_1=[sw_1 pp(i,:)];
    end
else
    for i=1:lines_full
        sw_1=[sw_1 pp(i,:)];
    end
    for j=1:left_out
    sw_1=[sw_1 pp(i+1,j)];
    end
end


%get the oil saturation
So=1-sw_1;



