function exts = spring_exts(state,angs,locs,lengths,theta0)
%Calculates spring extensions
%Input args:
%   state------- state for which to calculate extensions
%   angs======== initial actuator angles from horizontal
%   locs-------- actuator attachment points along bar
%   lengths===== rest lengths of actuators
%   theta0------ rest orientation of the bar
    n=@(theta) [cos(theta);sin(theta)];
    rcm=state(1:2);
    theta=state(3);
    
    A=locs.*n(theta0)-lengths.*n(angs);
    P=rcm+locs.*n(theta);
    a=P-A; %actuation vectors
    L=sqrt(sum(a.^2));
    exts=L-lengths;
end

