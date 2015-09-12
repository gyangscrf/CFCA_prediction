function [ classes ] = SOM_process( Y, NumNodes )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here


input_vector=Y';
%rank in the first dimension
net1 = selforgmap([NumNodes 1]);
net1= train(net1,input_vector);
plotsompos(net1,input_vector);
%for classification
y1=net1(input_vector);
%thus we can get the parameter 1
classes=vec2ind(y1);

end

