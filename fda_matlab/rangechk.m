function OK = rangechk(rangeval) 
%  check a range vector argument

%  last modified 19 November 2002

OK = 1;
if size(rangeval,1) ~= 1 & size(rangeval,2) ~= 1
    OK = 0;
end
if length(rangeval) ~= 2      
    OK = 0;
end
if rangeval(1) >= rangeval(2) 
    OK = 0;
end
